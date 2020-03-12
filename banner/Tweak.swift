//
//  Tweak.swift
//  saisaki
//
//  Created by Chinh Vu on 3/5/20.
//  Copyright © 2020 urameshiyaa. All rights reserved.
//

import UIKit

@objc public protocol WallpaperProviding: class {
	func wallpaperView() -> UIView?
	
	func updateWallpaper()
}

@objc public protocol WallpaperViewWrapper: class {
	func overridenWallpaperColor() -> UIColor?
	
	func snapshotImage() -> UIImage?
	
	@objc(initializeWithFrame:)
	func initialize(frame: CGRect)
}

@objc public protocol LockScreenWrapper: class {
	@objc(unlockSuccessful:)
	func unlock(successful: Bool)
	
	func lockScreenWillAppear()
	
}

public class LockScreenManager: NSObject, LockScreenWrapper, WallpaperViewWrapper {
	public func initialize(frame: CGRect) {
		overrideWallpaper.frame = frame
	}
	
	private var cachedSnapshot: UIImage?
	private var shouldUpdateCachedSnapshot: Bool = false
	
	public func snapshotImage() -> UIImage? {
		if (cachedSnapshot == nil || shouldUpdateCachedSnapshot) {
			let canvasSize = overrideWallpaper.bounds.size
			UIGraphicsBeginImageContextWithOptions(canvasSize, true, 0.0)
//			let ctx = UIGraphicsGetCurrentContext()!
			overrideWallpaper.drawHierarchy(in: overrideWallpaper.bounds, afterScreenUpdates: true)
			let snapshot = UIGraphicsGetImageFromCurrentImageContext()
			UIGraphicsEndImageContext()
			cachedSnapshot = snapshot
			shouldUpdateCachedSnapshot = false
		}
		return cachedSnapshot
	}
	
	func updateCachedSnapshot() {
		UIGraphicsBeginImageContext(overrideWallpaper.bounds.size)
		overrideWallpaper.drawHierarchy(in: overrideWallpaper.bounds, afterScreenUpdates: true)
		let snapshot = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		cachedSnapshot = snapshot
	}
	
	weak var wallpaperProvider: WallpaperProviding?
	var banners: SSKBannerOpening?
	var overrideWallpaper: SSKColoredWallpaperView
	@objc public init(wallpaperProvider: WallpaperProviding) {
		self.wallpaperProvider = wallpaperProvider
		let image = Resources.image(named: "saisaki-word")
		let wpEmblem = ImageEmblemView(image: image)
		wpEmblem.frame = CGRect(origin: .zero, size: image!.size.scaled(toWidth: 100))
		overrideWallpaper = SSKColoredWallpaperView(color: #colorLiteral(red: 0.9030858278, green: 0.2467186451, blue: 0.6991283298, alpha: 1), emblem: wpEmblem)
	}
	
	public func unlock(successful: Bool) {
		guard let banners = banners else {
			return
		}
		if (successful) {
			banners.open(animated: true) { _ in
				banners.removeFromSuperview()
				self.banners = nil
			}
			shouldUpdateCachedSnapshot = true
			self.wallpaperProvider?.updateWallpaper()
		}
	}
	
	public func lockScreenWillAppear() {
		guard let wallpaperView = wallpaperProvider?.wallpaperView() else { return }
		let overrideWallpaper = self.overrideWallpaper
		
		wallpaperView.addSubview(overrideWallpaper)
		overrideWallpaper.frame = wallpaperView.bounds

	
		if (banners == nil) {
			let emblem = ImageEmblemView(copy: overrideWallpaper.emblem as! ImageEmblemView)
			banners = SSKBannerOpening(numberOfBanners: 7)
			banners!.delegate = overrideWallpaper
			banners?.saisakiWord = emblem
			overrideWallpaper.addSubview(banners!)
			banners?.frame = overrideWallpaper.bounds
		}
		banners?.close(animated: false)
		shouldUpdateCachedSnapshot = true
	}
	
	public func overridenWallpaperColor() -> UIColor? {
		return overrideWallpaper.backgroundColor
	}
}
