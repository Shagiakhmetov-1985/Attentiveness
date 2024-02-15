//
//  StorageManager.swift
//  Attentiveness
//
//  Created by Marat Shagiakhmetov on 15.02.2024.
//

import Foundation

class StorageManager {
    static let shared = StorageManager()
    
    private let userDefaults = UserDefaults.standard
    private let themesKey = "themes"
    private let countKey = "count"
    
    private init() {}
    
    func saveData(theme: Themes, count: Count) {
        userDefaults.set(theme.rawValue, forKey: themesKey)
        userDefaults.set(count.rawValue, forKey: countKey)
    }
    
    func fetchData() -> (Themes, Count) {
        guard let themes = userDefaults.object(forKey: themesKey) as? String else { return (Themes.Devices, Count.twelve) }
        let theme = Themes(rawValue: themes) ?? Themes.Devices
        guard let count = userDefaults.object(forKey: countKey) as? Int else { return (Themes.Devices, Count.twelve) }
        let countOfImages = Count(rawValue: count) ?? Count.twelve
        return (theme, countOfImages)
    }
}
