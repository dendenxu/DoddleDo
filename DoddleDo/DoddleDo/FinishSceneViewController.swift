//
//  FinishSceneViewController.swift
//  DoddleDo
//
//  Created by Xuzh on 2019/8/3.
//  Copyright © 2019 Xuzh. All rights reserved.
//

import UIKit
import SwiftyGif

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

    // MARK: Navigation
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

    
    // MARK: Initialization
    @IBOutlet weak var loading: UIImageView!
    @IBOutlet weak var mainImageView: ScrollingView!
    var tempImage: UIImage?

    override func viewDidLoad() {

        mainImageView.image = tempImage
        mainImageView.image = tintImage(mainImageView.image, with: UIColor.white.cgColor, with: 0.8)
        do {
            let gif = try UIImage(gifName: "Gif/loading.gif")
            loading.setGifImage(gif)
        } catch let error {
            print(error)
        }
        aiPainting(image: tempImage, to: mainImageView)

    }

    private func tintImage(_ image: UIImage?, with color: CGColor, with alpha: CGFloat) -> UIImage? {
        if let image = image {
            let bounds = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
            var tinted: UIImage?
            UIGraphicsBeginImageContext(image.size)
            guard let context = UIGraphicsGetCurrentContext() else { return nil }
            image.draw(in: bounds)
            context.setAlpha(alpha)
            context.setFillColor(color)
            context.fill(bounds)
            tinted = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return tinted
        }
        else {
            return nil
        }
    }

    private func aiPainting(image original: UIImage?, to aiPainted: ScrollingView?) {
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
                            aiPainted?.image = image.resize(to: CGSize(width: 1792, height: 828))
                            aiPainted?.setNeedsDisplay()
                            self.loading.isHidden = true

                        }
                    }
                }
            }
            task.resume()
        }
    }

}
