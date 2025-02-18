# Doddle Do

人工智能辅助绘画生成应用

## 项目概况

Doodle Do是一款人工智能辅助绘画生成应用。在应用操作中，用户只需选择某一特定元素如天空、草地等，并在画布上进行涂抹，点击完成，即可生成一幅相同布局、特定风格的图画。Doodle Do旨在帮助用户以最简单的输入形式，获得最独特的绘画体验。

 

## 项目背景

绘画是一种通过图形及构图来表达画家的情感与想法的艺术行为，不仅能帮助作画者抒发情感，还能带来视觉上的美好感受。

随着近年来科技的发展，绘画早已不局限于纸笔方寸之间，而跃然于各种媒介之上，如计算机、手机等。同时，为了能以更好的效果完成画作，各界人士也做出了不少尝试。无论是实体而机械的绘画修正，还是已被广泛应用的线条抖动修正，或是近年来新兴的AI、AR辅助绘画，都为绘画者创造了便利。

绘画与科技的结合已逐渐成为一种趋势，如何让二者相得益彰是应该思考的关键问题。 

 

## **痛点分析** 

- **绘画APP种类单一化**

目前App Store中绘画应用主要有涂色减压与自由绘画两类，据粗略统计，iPhone端绘画应用总下载量已逾百万。然而，在享有众多用户的同时，现有绘画应用却面临着种类单一的问题，仍然基本遵循“所画即所得”的模式，无法为用户带来新奇的绘画体验。

- **用户使用门槛较高**

跳脱出移动应用的框架，不难发现许多出色的绘画辅助技术已经得以实现。如Paints Transfer线稿自动填色、Project Scribbler黑白图片自动上色等。不过，这些技术都依附于网页端，如果脱离性能优秀的计算机将无法运行。而这一限制使得用户无法随时随地使用这些技术，无形中增加了用户门槛。 

 

## 创意方案

- **GAN图像生成技术**

生成式对抗网络（GAN）是一个深度学习模型，利用它可以完成许多复杂的应用，在图像生成领域的表现尤为突出，利用GAN已经能够实现许多形式的pix2pix转换，如风格迁移、线稿上色等。基于此，我们可以通过GAN实现简单绘图到精美风格图像的转换，以应用到绘画创作之中。

利用这一技术，用户只需选择某一特定元素如天空、草地等，并在画布上进行涂抹，点击完成，即可生成一幅相同布局、特定风格的图画。既不破坏作画者的原始构图，又为其增添了细节与纹理，达到更好的视觉效果。 

- **轻量化的智能绘画体验**

介于目前绘画辅助技术门槛较高的现状，我们着眼于寻找将绘画辅助技术移植到移动端的方法，实现轻量化的智能绘画体验。我们将把大量的数据与算法存储于服务器上，用户在移动端完成绘画并实时传输至服务器，经服务器计算、生成之后返回生成之后的图画，减轻了用户移动设备的计算负担。

为了进一步减少计算量，我们将适度降低对生成图片质量的要求，并通过计算量较小的后期处理达到同等生成效果。 

- **单指随心交互** 

  用户只需单指即可完成各种步骤的操作。 	

  - 任意区域双击：召唤画笔工具栏，可选择多种景物，如山川、河流、树木、岩石等
  - 上下滑动：调整画笔大小 
  - 长按左滑：撤销
  - 长按右滑：重做
  - 长按上滑：完成画作 

- **多感官创作体验** 

Doodle Do融合了局部动画与背景音，让画作不再是静态的图画，成为各种表现形态的载体。在画作完成后，只需长按屏幕，景物就会随之运动起来，潺潺溪流、云卷云舒，尽收眼底。同时，系统还会根据画面中景物的占比，自动合成和谐的自然背景音，如鸟鸣声、溪流声等，让画作更加生动，用户可以将作品保存为live照片或视频并进行分享。

 

## 应用场景 

Doodle Do为用户提供了简单快捷的绘画方式，而具体怎么应用系统生成的图画，全凭用户自己决定与探索。

你可以：

- 创作独一无二的风景图作为社交网络的文字配图 
- 免去漫画创作中繁复的背景绘制过程
- 把心仪的图画设置为手机壁纸或社交软件的头像
- 当然，仍有更多的可能性等待着用户去发掘……

 

## 未来发展

- **内部功能多元化**

据已有的算法，系统能完成更多其他风格图像的生成，如浮世绘、版画等风格，因此我们将在后期实现更多风格图画的生成。同时，绘画作为情感与艺术的良好载体，可与更多其他艺术形式相结合，如音乐、视频等。 

- **全民绘画新风潮**

本次智能绘画轻量化的尝试，或将激发更多相关绘画辅助技术持有者将其核心技术封装至移动设备，丰富如今绘画应用的种类与功能，进一步降低绘画门槛，激发全民绘画新风潮。 

- **实体产品发售**

通过Doodle Do创作出来的每一幅画都是独一无二的，因此，待线上应用成熟后，可以考虑开通用户定制实体周边的服务，将用户的画作印刷装裱成为装饰