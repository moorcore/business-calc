//
//  DecreaseByPercentageView.swift
//  BusinessCalculator
//
//  Created by Maxim Boykin on 25.9.24..
//

import SwiftUI

struct DecreaseByPercentageView: View {
    @State private var baseValue: String = ""
    @State private var percentage: String = ""
    @State private var result: String = "0"
    
    @AppStorage("saveState") private var saveState: Bool = false
    
    var body: some View {
        ZStack {
            Color.adaptiveBackground
                .onTapGesture {
                    hideKeyboard()
                }
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {

                Text("Уменьшение на процент")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color.adaptiveText)
                    .padding(.top, 40)

                Text(result)
                    .font(.title2)
                    .fontWeight(.medium)
                    .padding()
                    .foregroundColor(result == "Error" || result.contains("Invalid") ? .red : Color.adaptiveText)
                    .onTapGesture {
                        UIPasteboard.general.string = result
                    }
                
                VStack(spacing: 20) {
                    TextField("Основное значение", text: $baseValue)
                        .keyboardType(.decimalPad)
                        .padding()
                        .background(Color.adaptiveButtonHighlight.opacity(0.2))
                        .foregroundStyle(Color.adaptiveText)
                        .cornerRadius(10)
                        .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5)
                        .tint(Color.adaptiveText)
                    
                    TextField("Процент", text: $percentage)
                        .keyboardType(.decimalPad)
                        .padding()
                        .background(Color.adaptiveButtonHighlight.opacity(0.2))
                        .foregroundStyle(Color.adaptiveText)
                        .cornerRadius(10)
                        .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5)
                        .tint(Color.adaptiveText)
                }
                .padding(.horizontal)
                
                Button(action: {
                    if validateInput() {
                        decreaseByPercentage()
                    }
                }) {
                    Text("Рассчитать")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.adaptiveButtonBackground)
                        .foregroundColor(Color.adaptiveText)
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
        guard let _ = Double(baseValue), let _ = Double(percentage) else {
            result = "Invalid input. Please enter valid numbers."
            return false
        }
        return true
    }
    
    private func decreaseByPercentage() {
        guard let base = Double(baseValue), let perc = Double(percentage) else {
            result = "Error"
            return
        }
        result = formatResult(base - (base * perc) / 100)
        if saveState {
            saveValues()
        }
    }
    
    private func saveValues() {
        UserDefaults.standard.set(baseValue, forKey: "DecreaseBaseValue")
        UserDefaults.standard.set(percentage, forKey: "DecreasePercentage")
        UserDefaults.standard.set(result, forKey: "DecreaseResult")
    }
    
    private func loadValues() {
        baseValue = UserDefaults.standard.string(forKey: "DecreaseBaseValue") ?? ""
        percentage = UserDefaults.standard.string(forKey: "DecreasePercentage") ?? ""
        result = UserDefaults.standard.string(forKey: "DecreaseResult") ?? ""
    }
    
    private func clearFields() {
        baseValue = ""
        percentage = ""
        result = "0"
        
        if saveState {
            saveValues()
        }
    }
    
    private func formatResult(_ result: Double) -> String {
        if result.truncatingRemainder(dividingBy: 1) == 0 {
            if result > Double(Int.max) {
                return String(result)
            } else {
                return String(Int(result))
            }
        } else {
            return String(result)
        }
    }
    
    init() {
        loadValues()
    }
}

struct DecreaseByPercentageView_Previews: PreviewProvider {
    static var previews: some View {
        DecreaseByPercentageView()
    }
}
