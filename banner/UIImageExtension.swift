//
//  UIImageExtension.swift
//  saisaki
//
//  Created by Chinh Vu on 3/1/20.
//  Copyright © 2020 urameshiyaa. All rights reserved.
//

import UIKit

class ImageCompositor {
	let image: UIImage
	private var operations: [(CGContext, CGRect) -> Void] = []
	private var drawingRect: CGRect { return CGRect(origin: .zero, size: image.size)}
	
	init(image: UIImage) {
		self.image = image;
	}
	
	func overlaying(backgroundColor: UIColor) -> Self {
		operations.append { (ctx, rect) in
			backgroundColor.setFill()
			ctx.fill(rect)
			self.image.draw(in: rect, blendMode: .overlay, alpha: 1.0)
		}
		return self
	}
	
	func overlappedBy(topImage: UIImage) -> Self {
		operations.append { (ctx, rect) in
			topImage.draw(in: rect, blendMode: .normal, alpha: 1.0)
		}
		return self
	}
	
	func composite() -> UIImage {
		UIGraphicsBeginImageContext(image.size)
		defer {
			UIGraphicsEndImageContext()
		}
		let ctx = UIGraphicsGetCurrentContext()!
		for op in operations {
			op(ctx, drawingRect)
		}
		return UIGraphicsGetImageFromCurrentImageContext()!
	}
}

extension UIImage {
	func compositor() -> ImageCompositor {
		return ImageCompositor(image: self)
	}
}
