//
//  Log.swift
//  saisaki
//
//  Created by Chinh Vu on 3/7/20.
//  Copyright © 2020 urameshiyaa. All rights reserved.
//

import os.log

func log(_ message: String) {
	os_log("_saisaki_ %{public}@", message)
}
