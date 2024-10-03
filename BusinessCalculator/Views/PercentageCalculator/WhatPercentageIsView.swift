//
//  WhatPercentageIsView.swift
//  BusinessCalculator
//
//  Created by Maxim Boykin on 25.9.24..
//

import SwiftUI

struct WhatPercentageIsView: View {
    @State private var firstValue: String = ""
    @State private var secondValue: String = ""
    @State private var result: String = "0"
    
    var body: some View {
        ZStack {
            Color(hex: "#EBEBEB")
                .onTapGesture {
                    hideKeyboard()
                }
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {

                Text("Какой процент")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color(hex: "#538296"))
                    .padding(.top, 40)
                
                Text(result)
                    .font(.title2)
                    .fontWeight(.medium)
                    .padding()
                    .foregroundColor(result == "Error" || result.contains("Invalid") ? .red : Color(hex: "#538296"))
                    .cornerRadius(10)
                    .onTapGesture {
                        UIPasteboard.general.string = result
                    }
                
                VStack(spacing: 20) {
                    TextField("Первое значение", text: $firstValue)
                        .keyboardType(.decimalPad)
                        .padding()
                        .background(Color.white)
                        .foregroundStyle(Color(hex: "#538296"))
                        .cornerRadius(10)
                        .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5)
                        .tint(Color(hex: "#538296"))
                    
                    TextField("Второе значение", text: $secondValue)
                        .keyboardType(.decimalPad)
                        .padding()
                        .background(Color.white)
                        .foregroundStyle(Color(hex: "#538296"))
                        .cornerRadius(10)
                        .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5)
                        .tint(Color(hex: "#538296"))
                }
                .padding(.horizontal)
                
                Button(action: {
                    if validateInput() {
                        calculatePercentage()
                    }
                }) {
                    Text("Рассчитать")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(hex: "#C5DCE4"))
                        .foregroundColor(Color(hex: "#538296"))
                        .cornerRadius(10)
                        .shadow(radius: 5)
                }
                .padding(.horizontal)
                
                Button(action: {
                    clearFields()
                }) {
                    Text("Очистить")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red.opacity(0.7))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .onAppear {
                loadValues()
        }
        }
    }
    
    private func validateInput() -> Bool {
        guard let _ = Double(firstValue), let _ = Double(secondValue), Double(secondValue) != 0 else {
            result = "Invalid input. Make sure values are numbers and second value is not zero."
            return false
        }
        return true
    }
    
    private func calculatePercentage() {
        guard let first = Double(firstValue), let second = Double(secondValue) else {
            result = "Error"
            return
        }
        result = String((first / second) * 100)
        saveValues()
    }
    
    private func saveValues() {
        UserDefaults.standard.set(firstValue, forKey: "WhatPercentageFirstValue")
        UserDefaults.standard.set(secondValue, forKey: "WhatPercentageSecondValue")
        UserDefaults.standard.set(result, forKey: "WhatPercentageResult")
    }
    
    private func loadValues() {
        firstValue = UserDefaults.standard.string(forKey: "WhatPercentageFirstValue") ?? ""
        secondValue = UserDefaults.standard.string(forKey: "WhatPercentageSecondValue") ?? ""
        result = UserDefaults.standard.string(forKey: "WhatPercentageResult") ?? ""
    }
    
    private func clearFields() {
        firstValue = ""
        secondValue = ""
        result = "0"
        
        saveValues()
    }
    
    init() {
        loadValues()
    }
}

struct WhatPercentageIsView_Previews: PreviewProvider {
    static var previews: some View {
        WhatPercentageIsView()
    }
}
