//
//  ThemeManager.swift
//  BusinessCalculator
//
//  Created by Maxim Boykin on 11.10.24..
//

import SwiftUI

class ThemeManager: ObservableObject {
    @AppStorage("isDarkMode") var isDarkMode: Bool = false {
        didSet {
            updateTheme()
        }
    }
    
    @Published var currentColorScheme: ColorScheme? = nil
    
    init() {
        updateTheme()
    }
    
    private func updateTheme() {
        currentColorScheme = isDarkMode ? .dark : .light
    }
}
