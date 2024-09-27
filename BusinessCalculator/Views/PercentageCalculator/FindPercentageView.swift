//
//  FindPercentageView.swift
//  BusinessCalculator
//
//  Created by Maxim Boykin on 25.9.24..
//

import SwiftUI

struct FindPercentageView: View {
    @State private var baseValue: String = ""
    @State private var percentage: String = ""
    @State private var result: String = ""
    
    var body: some View {
        VStack(spacing: 20) {
            
            Text("Найти процент")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(Color(hex: "#538296"))
                .padding(.top, 40)
            
            Text("Результат: \(result)")
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
                    .tint(Color(hex: "#538296"))
                    .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5)
                
                TextField("Процент", text: $percentage)
                    .keyboardType(.decimalPad)
                    .padding()
                    .background(Color.white)
                    .foregroundStyle(Color(hex: "#538296"))
                    .cornerRadius(10)
                    .tint(Color(hex: "#538296"))
                    .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5)
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
            
            Spacer()
        }
        .padding()
        .background(Color(hex: "#EBEBEB"))
        .edgesIgnoringSafeArea(.all)
        .onAppear {
            loadValues()
        }
    }
    
    private func validateInput() -> Bool {
        guard let _ = Double(baseValue), let _ = Double(percentage) else {
            result = "Invalid input. Please enter valid numbers."
            return false
        }
        return true
    }
    
    private func calculatePercentage() {
        guard let base = Double(baseValue), let perc = Double(percentage) else {
            result = "Error"
            return
        }
        result = String((base * perc) / 100)
        saveValues()
    }
    
    private func saveValues() {
        UserDefaults.standard.set(baseValue, forKey: "FindPercentageBaseValue")
        UserDefaults.standard.set(percentage, forKey: "FindPercentagePercentage")
        UserDefaults.standard.set(result, forKey: "FindPercentageResult")
    }
    
    private func loadValues() {
        baseValue = UserDefaults.standard.string(forKey: "FindPercentageBaseValue") ?? ""
        percentage = UserDefaults.standard.string(forKey: "FindPercentagePercentage") ?? ""
        result = UserDefaults.standard.string(forKey: "FindPercentageResult") ?? ""
    }
    
    init() {
        loadValues() // Загружаем сохранённые данные при инициализации
    }
}

struct FindPercentageView_Previews: PreviewProvider {
    static var previews: some View {
        FindPercentageView()
    }
}
