//
//  FinishSceneViewController.swift
//  DoddleDo
//
//  Created by Xuzh on 2019/8/3.
//  Copyright © 2019 Xuzh. All rights reserved.
//

import UIKit


extension Data {
    mutating func appendString(string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}

extension UIImage {
    func resize(to rect: CGSize) -> UIImage? {

        UIGraphicsBeginImageContext(rect)
        self.draw(in: CGRect(x: 0, y: 0, width: rect.width, height: rect.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage
    }
}

class FinishSceneViewController: UIViewController {

    var backPoint = CGPoint()

    @IBOutlet weak var finishBack: ShadowedImageView! {
        didSet {
            addButtonTappedOrPressedGestureRecognizer(to: finishBack)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let bouncyUnwindSegue = segue as? BouncyUnwindSegue {
            bouncyUnwindSegue.desinationZoomPoint = backPoint
        }
    }

    @IBOutlet weak var mainImageView: UIImageView!
    var image: UIImage?

    override func viewDidLoad() {
        mainImageView.image = image
        aiPainting(image: image, to: mainImageView)
    }

    private func aiPainting(image original: UIImage?, to aiPainted: UIImageView?) {
        if let url = URL(string: "http://painting.nhcilab.com/ajax_dict"), let imageString = original?.resize(to: CGSize(width: 1024, height: 512))?.pngData()?.base64EncodedString() {

            var request = URLRequest(url: url)
            request.httpMethod = "POST"

            let boundary = "Boundary-\(NSUUID().uuidString)"
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            request.setValue("keep-alive", forHTTPHeaderField: "Proxy-Connection")

            var body = Data()
            body.appendString(string: "--\(boundary)\r\n")
            body.appendString(string: "Content-Disposition: form-data; name=\"dg\"\r\n")
            body.appendString(string: "\r\n\r\n")
            body.appendString(string: imageString)
            body.appendString(string: "\r\n")
            body.appendString(string: "--\(boundary)\r\n")
            body.appendString(string: "Content-Disposition: form-data; name=\"steps\"\r\n")
            body.appendString(string: "\r\n\r\n")
            body.appendString(string: "0")
            body.appendString(string: "\r\n")
            body.appendString(string: "--\(boundary)\r\n")

            request.setValue("\(body.count)", forHTTPHeaderField: "Content-Length")

            let task = URLSession.shared.uploadTask(with: request, from: body) { data, response, error in
                if let error = error {
                    print ("error: \(error)")
                    return
                }
                guard let response = response as? HTTPURLResponse,
                    (200...299).contains(response.statusCode) else {
                        print ("server error")
                        return
                }
                if let mimeType = response.mimeType,
                    mimeType == "application/json", let data = data {
                    var temp = data.advanced(by: 10)
                    temp.count = temp.count - 3
                    if let str = String(data: temp, encoding: .utf8), let tempData = Data(base64Encoded: str), let image = UIImage(data: tempData) {
                        DispatchQueue.main.async {
                            aiPainted?.image = image
                        }
                    }
                }
            }
            task.resume()
        }
    }

}
