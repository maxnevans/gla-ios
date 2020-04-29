//
//  SettingsScreen.swift
//  ComputerGamesList
//
//  Created by maxnevans on 3/12/20.
//  Copyright © 2020 maxnevans. All rights reserved.
//

import UIKit

class SettingsScreen: UIViewController {
    
    @IBOutlet weak var fontPeek: UIPickerView!
    @IBOutlet weak var fontSizeSlider: UISlider!
    @IBOutlet weak var languagePeek: UIPickerView!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var fontLabel: UILabel!
    @IBOutlet weak var fontSizeLabel: UILabel!
    @IBOutlet weak var applySettingsButton: UIButton!
    
    var model: ModelController!
    var settings: Settings!
    var delegate: SettingsScreenDelegate!
    
    private static var languagePickerDictionary: [SettingsLanguages:String] = [.en : "English", .ru : "Русский"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        fontPeek.delegate = self
        fontPeek.dataSource = self
        languagePeek.delegate = self
        languagePeek.dataSource = self
        
        fontSizeSlider.minimumValue = Settings.minFontSizeFactor
        fontSizeSlider.maximumValue = Settings.maxFontSizeFactor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        settings = model.settings.list.copy()
        
        setupElementsValues()
        setupElementsLocale()
        setupElementsAppearence()
    }
    
    private func setupElementsLocale() {
        languageLabel.text = "Language".localize(settings.language)
        fontLabel.text = "Font".localize(settings.language)
        fontSizeLabel.text = "Font size".localize(settings.language)
        applySettingsButton.setTitle("Apply Settings".localize(settings.language), for: .normal)
    }
    
    private func setupElementsAppearence() {
        languageLabel.font = model.createFont(size: 17)
        fontLabel.font = model.createFont(size: 17)
        fontSizeLabel.font = model.createFont(size: 17)
        applySettingsButton.titleLabel?.font = model.createFont(size: 17)
    }
    
    private func setupElementsValues() {
        fontPeek.selectRow(settings.fontsFromRawValueToIndex(fromRawValue: settings.font.familyName) ?? 0, inComponent: 0, animated: false)
        languagePeek.selectRow(settings.languagesFromValueToIndex(fromValue: settings.language) ?? 0, inComponent: 0, animated: false)
        fontSizeSlider.setValue(settings.fontSizeFactor, animated: false)
    }
    
    @IBAction func fontSizeChange(_ sender: Any) {
        settings.fontSizeFactor = fontSizeSlider.value
    }
    
    @IBAction func applySettingsPressed(_ sender: Any) {
        model.settings.list = settings
        navigationController?.popViewController(animated: true)
        delegate.didApplySettings(settings: settings)
    }
}

extension SettingsScreen: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (pickerView == fontPeek) {
            return settings.fonts().count
        }
        
        if (pickerView == languagePeek) {
            return settings.languages().count
        }
        
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if (pickerView == fontPeek) {
            return settings.fonts()[row]
        }
        
        if (pickerView == languagePeek) {
            let lang = settings.languagesFromIndexToValue(fromIndex: row) ?? settings.language
            return SettingsScreen.languagePickerDictionary[lang]
        }
        
        return nil
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if (pickerView == fontPeek) {
            let font = settings.fontsFromIndexToValue(fromIndex: row)
            
            settings.font = font ?? settings.font
        }
        
        if (pickerView == languagePeek) {
            let lang = settings.languagesFromIndexToValue(fromIndex: row)
            
            settings.language = lang ?? settings.language
        }
    }
}

protocol SettingsScreenDelegate {
    func didApplySettings(settings: Settings)
}
