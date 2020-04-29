//
//  SettingsStorageController.swift
//  ComputerGamesList
//
//  Created by maxnevans on 3/14/20.
//  Copyright © 2020 maxnevans. All rights reserved.
//

import Foundation
import UIKit

class SettingsStorageController {
    var list: Settings
    
    init() {
        list = Settings(language: .en, font:  UIFont.systemFont(ofSize: 17, weight: .regular), fontSizeFactor: 1)
    }
}
