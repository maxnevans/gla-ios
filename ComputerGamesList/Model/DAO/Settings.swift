//
//  File.swift
//  ComputerGamesList
//
//  Created by maxnevans on 3/12/20.
//  Copyright © 2020 maxnevans. All rights reserved.
//

import Foundation
import UIKit

enum SettingsLanguages: String, CaseIterable {
    case ru = "ru"
    case en = "en"
}

struct Settings {
    static let maxFontSizeFactor: Float = 1.2
    static let minFontSizeFactor: Float = 0.7
    
    var language: SettingsLanguages
    var font: UIFont
    var fontSizeFactor: Float
    
    func copy() -> Settings {
        return self
    }
    
    func languages() -> [String] {
        return SettingsLanguages.allCases.map { $0.rawValue }
    }
    
    func fonts() -> [String] {
        return UIFont.familyNames
    }
    
    func languagesFromValueToIndex(fromValue: SettingsLanguages) -> Int? {
        return SettingsLanguages.allCases.firstIndex(of: fromValue)
    }
    
    func languagesFromIndexToValue(fromIndex: Int) -> SettingsLanguages? {
        return SettingsLanguages.allCases[fromIndex]
    }
    
    func languagesFromRawValueToValue(fromValue: String) -> SettingsLanguages? {
        return SettingsLanguages(rawValue: fromValue)
    }
    
    func fontsFromRawValueToIndex(fromRawValue: String) -> Int? {
        return UIFont.familyNames.firstIndex(of: fromRawValue)
    }
    
    func fontsFromRawValueToValue(fromValue: String) -> UIFont? {
        let fontSize = font.pointSize
        return UIFont(name: fromValue, size: fontSize)
    }
    
    func fontsFromIndexToValue(fromIndex: Int) -> UIFont? {
        let fontSize = font.pointSize
        return UIFont(name: UIFont.familyNames[fromIndex], size: fontSize)
    }
}
