//
//  SSKBannerOpening.swift
//  saisaki
//
//  Created by Chinh Vu on 2/28/20.
//  Copyright © 2020 urameshiyaa. All rights reserved.
//

import UIKit

public class SSKBannerOpening : UIView {
	let maxTilt = CGFloat.pi / 6
	var banners: [SSKPinkBannerView] = []
	var auxiliaryBannerSize: CGFloat = 30
	var saisakiBanner: SSKPinkBannerView!
	public var saisakiWord: UIView? {
		didSet {
			oldValue?.removeFromSuperview()
			guard let saisakiWord = saisakiWord else {
				return
			}
			saisakiWord.transform = saisakiBanner.transform // align rotation
			addSubview(saisakiWord)
		}
	}
	
	fileprivate var numBanners: Int
	weak var delegate: BannersDelegate?
	
	public init(numberOfBanners: Int) {
		numBanners = numberOfBanners
		super.init(frame: .zero)
		setupBanners()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func setupBanners() {
		for i in 0..<numBanners {
			let tiltAngle = CGFloat.random(in: 0..<maxTilt) * (i % 2 == 0 ? 1.0 : -1.0)
			let banner = SSKPinkBannerView()
			banner.rotAngle = tiltAngle
			banner.bounds = CGRect(x: 0, y: 0, width: 1000, height: 100)
			banners.append(banner)
			addSubview(banner)
		}
		banners.shuffle()
		
		saisakiBanner = SSKPinkBannerView()
		saisakiBanner.bounds = CGRect(x: 0, y: 0, width: 1500, height: 150)
		saisakiBanner.rotAngle = CGFloat.random(in: -maxTilt..<maxTilt)
		addSubview(saisakiBanner)
	}
	
	public func close(animated: Bool, completion: ((Bool) -> Void)? = nil) {
		let midX = center.x
		let midY = center.y
		let spacing: CGFloat = (frame.height + 200) / CGFloat(numBanners + 1)
		let duration: Double = animated ? 1.0 : 0.0
		let mainBanner = saisakiBanner!
		let emblem = saisakiWord
//		emblem?.alpha = 0

		UIView.animateKeyframes(withDuration: duration, delay: 0, options: [], animations: {
			for i in 0..<self.numBanners {
				let banner = self.banners[i]
				let startTime = Double(i) / Double(self.numBanners)
				UIView.addKeyframe(withRelativeStartTime: startTime, relativeDuration: 0.3) {
					banner.center = CGPoint(x: midX, y: -100 + spacing * CGFloat(i+1))
				}
			}
			UIView.addKeyframe(withRelativeStartTime: 0.9, relativeDuration: 0.2) {
				mainBanner.center = CGPoint(x: midX, y: midY)
			}
			UIView.addKeyframe(withRelativeStartTime: 1.0, relativeDuration: 0) {
				guard let emblem = emblem else {
					return
				}
				emblem.alpha = 1.0
				emblem.bounds.size = emblem.bounds.size.scaled(toWidth: self.bounds.width * 2.0 / 3.0)
				emblem.center = mainBanner.center
				self.delegate?.bannersEmblemDidUpdate(self)
			}
		}, completion: completion)
	}
	
	public func open(animated: Bool, completion: ((Bool) -> Void)? = nil) {
		let dxOut = bounds.width + 30
		let duration: Double = animated ? 1.0 : 0.0
		let mainBanner = saisakiBanner!
		
		UIView.animateKeyframes(withDuration: duration, delay: 0, options: [], animations: {
			for i in 0..<self.numBanners {
				let banner = self.banners[i]
				let direction: CGFloat = (i % 2 == 0 ? 1.0 : -1.0)
				let toPoint = banner.getPositionBySliding(dx: direction * (dxOut + banner.bounds.midX))
				let startTime = Double(i) / Double(self.numBanners)
				UIView.addKeyframe(withRelativeStartTime: startTime, relativeDuration: 0.3) {
					banner.center = toPoint
				}
			}
			UIView.addKeyframe(withRelativeStartTime: 0.9, relativeDuration: 0.2) {
				mainBanner.center = mainBanner.getPositionBySliding(dx: dxOut + mainBanner.bounds.midX)
			}
			UIView.addKeyframe(withRelativeStartTime: 0.9, relativeDuration: 0) {
//				self.saisakiWord?.alpha = 0
			}
		}, completion: completion)
	}
}

class SSKBannerOpeningController: UIViewController {
}

protocol BannersDelegate: class {
	func bannersEmblemDidUpdate(_ banners: SSKBannerOpening)
}

class SSKColoredWallpaperView: UIView, BannersDelegate {
	var emblem: UIView
	
	init(color: UIColor, emblem: UIView) {
		self.emblem = emblem
		super.init(frame: .zero)
		backgroundColor = color
		
		addSubview(emblem)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func bannersEmblemDidUpdate(_ banners: SSKBannerOpening) {
		guard let otherEmblem = banners.saisakiWord else {
			return
		}
		emblem.bounds = otherEmblem.bounds
		emblem.center = otherEmblem.superview?.convert(otherEmblem.center, to: self) ?? self.center
		emblem.transform = otherEmblem.transform
	}
}
