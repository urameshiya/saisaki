//
//  Resources.swift
//  saisaki
//
//  Created by Chinh Vu on 3/7/20.
//  Copyright © 2020 urameshiyaa. All rights reserved.
//

import UIKit

class Resources {
	static let bundle: Bundle? = {
		let bundle = Bundle(path: "/Library/Application Support/saisaki-resources.bundle")
		if (bundle == nil) {
			log("Cannot load resources")
		}
		return bundle
	}()
	
	static func image(named name: String) -> UIImage? {
		return UIImage(named: name, in: bundle, compatibleWith: nil)
	}
}
