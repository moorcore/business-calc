//
//  UIView+Extensions.swift
//  BusinessCalculator
//
//  Created by Maxim Boykin on 3.10.24..
//

import SwiftUI
import UIKit

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
