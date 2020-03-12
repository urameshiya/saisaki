//
//  CGExtension.swift
//  saisaki
//
//  Created by Chinh Vu on 3/3/20.
//  Copyright © 2020 urameshiyaa. All rights reserved.
//

import CoreGraphics

extension CGSize {
	func scaled(toHeight height: CGFloat) -> CGSize {
		let scale = self.width / self.height
		return CGSize(width: height * scale, height: height)
	}
	
	func scaled(toWidth width: CGFloat) -> CGSize {
		let scale = self.height / self.width
		return CGSize(width: width, height: width * scale)
	}
}
