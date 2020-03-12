//
//  SSKPinkBanner.swift
//  saisaki
//
//  Created by Chinh Vu on 2/20/20.
//  Copyright © 2020 urameshiyaa. All rights reserved.
//

import UIKit

protocol Rotatable {
	var rotAngle: CGFloat { get set }
}

public class SSKPinkBannerView: UIView, Rotatable {
	static let image = Resources.image(named: "saisaki-banner")?.compositor()
		.overlaying(backgroundColor: #colorLiteral(red: 0.9030858278, green: 0.2467186451, blue: 0.6991283298, alpha: 1))
		.overlappedBy(topImage: Resources.image(named: "saisaki-banner-bars")!).composite()
	
	var rotAngle: CGFloat = 0 {
		didSet {
			transform = .init(rotationAngle: rotAngle)
		}
	}
	
	lazy var bannerImageView: UIImageView = {
		let imageView = UIImageView(image: Self.image)
		imageView.isOpaque = true
		imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		imageView.frame = self.bounds
		imageView.layer.contentsGravity = .resize
		imageView.backgroundColor = .black
		return imageView
	}()
	
	init() {
		super.init(frame: .zero)
		isOpaque = true
		addSubview(bannerImageView)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func getPositionBySliding(dx: CGFloat) -> CGPoint {
		var point = center
		point.x += dx
		point.y += tan(rotAngle) * dx
		return point
	}
	
	func getPositionBySliding(forward distance: CGFloat) -> CGPoint {
		var point = center
		point.x += distance * cos(rotAngle)
		point.y += distance * sin(rotAngle)
		return point
	}
	
	func slide(dx: CGFloat) {
		center = getPositionBySliding(dx: dx)
	}
	
	func slide(forward distance: CGFloat) {
		center = getPositionBySliding(forward: distance)
	}
	
	func rotate(to angle: CGFloat) {
		
	}
}

protocol CopiableView: class {
	init(copy: Self)
}

final class ImageEmblemView: UIImageView, CopiableView {
	override init(image: UIImage?) {
		super.init(image: image)
		if let size = image?.size {
			bounds = CGRect(origin: .zero, size:size)
		}
	}

	convenience init(copy: ImageEmblemView) {
		self.init(image: copy.image!)
		rotAngle = copy.rotAngle
		transform = copy.transform
		bounds = copy.bounds
	}
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
//	typealias TransitionContextType = BasicEmblemTransitionContext
	var rotAngle: CGFloat = 0 {
		didSet {
			transform = .init(rotationAngle: rotAngle)
		}
	}
}

class LabelEmblemView: UILabel {
	var rotAngle: CGFloat = 0 {
		didSet {
			transform = .init(rotationAngle: rotAngle)
		}
	}
}

