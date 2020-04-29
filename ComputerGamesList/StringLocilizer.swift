//
//  StringLocilizer.swift
//  ComputerGamesList
//
//  Created by maxnevans on 3/14/20.
//  Copyright © 2020 maxnevans. All rights reserved.
//

import Foundation
import UIKit

enum StringLocales: String {
    case en = "en"
    case ru = "ru"
}

extension String {
    func localize(_ loc: SettingsLanguages) -> String {
        guard let locale = StringLocales(rawValue: loc.rawValue) else {
            return self
        }
        
        let localized = self.localize(loc: locale)
        
        return localized
    }
    
    func localize(loc: StringLocales = .en) -> String {
        let path = Bundle.main.path(forResource: loc.rawValue, ofType: "lproj")
        let bundle = Bundle(path: path!)
        
        return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
    }
}
