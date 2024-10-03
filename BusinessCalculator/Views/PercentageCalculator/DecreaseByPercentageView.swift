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
    
    var body: some View {
        ZStack {
            Color(hex: "#EBEBEB")
                .onTapGesture {
                    hideKeyboard()
                }
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {

                Text("Уменьшение на процент")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color(hex: "#538296"))
                    .padding(.top, 40)

                Text(result)
                    .font(.title2)
                    .fontWeight(.medium)
                    .padding()
                    .foregroundColor(result == "Error" || result.contains("Invalid") ? .red : Color(hex: "#538296"))
                    .onTapGesture {
                        UIPasteboard.general.string = result
                    }
                
                VStack(spacing: 20) {
                    TextField("Основное значение", text: $baseValue)
                        .keyboardType(.decimalPad)
                        .padding()
                        .background(Color.white)
                        .foregroundStyle(Color(hex: "#538296"))
                        .cornerRadius(10)
                        .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5)
                        .tint(Color(hex: "#538296"))
                    
                    TextField("Процент", text: $percentage)
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
                        decreaseByPercentage()
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
        result = String(base - (base * perc) / 100)
        saveValues()
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
        
        saveValues()
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
