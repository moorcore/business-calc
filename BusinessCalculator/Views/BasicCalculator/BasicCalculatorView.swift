//
//  BasicCalculatorView.swift
//  BusinessCalculator
//
//  Created by Maxim Boykin on 25.9.24..
//

import SwiftUI
import UIKit

struct BasicCalculatorView: View {
    
    @State private var displayText = "0"
    @State private var calculationChain = ""
    @State private var selectedOperation: String? = nil
    @State private var currentOperation: String? = nil
    
    @State private var firstValue: Double? = nil
    @State private var maxValue: Double = Double.greatestFiniteMagnitude

    @State private var isPressed = false
    @State private var operatorPressed = false
    @State private var isOperationCompleted = false

    @AppStorage("customLogic") private var customLogic: Bool = false
    
    var body: some View {
        VStack {
            if customLogic {
                Text(calculationChain)
                    .font(.title2)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .foregroundColor(Color(hex: "#538296"))
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
            }
            
            Text(displayText)
                .font(.system(size: 70))
                .padding()
                .frame(maxWidth: .infinity, alignment: .trailing)
                .cornerRadius(10)
                .foregroundColor(Color(hex: "#538296"))
                .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
                .onTapGesture {
                    UIPasteboard.general.string = displayText
                }
                .gesture(
                    DragGesture(minimumDistance: 20)
                        .onEnded { value in
                            if value.translation.width < -50 {
                                removeLastCharacter()
                            }
                        }
                )
            
            Spacer()
            
            VStack(spacing: 10) {
                ForEach(buttonsArray, id: \.self) { row in
                    HStack(spacing: 15) {
                        ForEach(row, id: \.self) { button in
                            Button(action: {
                                self.buttonTapped(button: button)
                            }) {
                                Text(button)
                                    .font(.largeTitle)
                                    .frame(width: 80, height: 80)
                                    .background(selectedOperation == button ? Color(hex: "#E1E5F2") : Color(hex: "#C5DCE4"))
                                    .foregroundColor(Color(hex: "#538296"))
                                    .cornerRadius(10)
                                    .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5)
                                    .scaleEffect(isPressed ? 1.1 : 1.0)
                                    .animation(.easeInOut(duration: 0.1), value: isPressed)
                            }
                            .gesture(
                                DragGesture(minimumDistance: 0)
                                    .onChanged { _ in
                                        isPressed = true
                                    }
                                    .onEnded { _ in
                                        isPressed = false
                                    }
                            )
                        }
                    }
                }
            }
            .padding()
            .onAppear {
                loadSavedState()
            }
        }
    }
    
    let buttonsArray = [
        ["C", "+/-", "%", "÷"],
        ["7", "8", "9", "x"],
        ["4", "5", "6", "-"],
        ["1", "2", "3", "+"],
        ["⌫", "0", ".", "="]
    ]
    
    func buttonTapped(button: String) {
        generateHapticFeedback()
        switch button {
        case "C":
            clear()
        case "+/-":
            toggleSign()
        case "%":
            handlePercentage()
        case "÷", "x", "+", "-":
            handleOperation(button)
        case "=":
            performCalculation()
        case "⌫":
            removeLastCharacter()
        default:
            handleNumberInput(button)
        }
    }
    
    func handleNumberInput(_ input: String) {
        selectedOperation = nil
        
        operatorPressed = false
        
        if isOperationCompleted {
            return
        }

        if let currentValue = Double(displayText), currentValue > maxValue {
            displayText = "Ошибка"
            return
        }

        if input == "." {
            if !displayText.contains(".") {
                displayText += input
            }
        } else {
            if displayText == "0" && input != "." {
                displayText = input
            } else {
                displayText += input
            }
        }

        if customLogic {
            calculationChain += input
        }

        saveCurrentState()
    }


    func handleOperation(_ operation: String) {
        if isOperationCompleted {
            isOperationCompleted = false
        }

        if operatorPressed {
            return
        }

        if let firstValue = firstValue, let currentValue = Double(displayText), let currentOperation = currentOperation {
            var result: Double = 0
            
            switch currentOperation {
            case "+":
                result = firstValue + currentValue
            case "-":
                result = firstValue - currentValue
            case "x":
                result = firstValue * currentValue
            case "÷":
                if currentValue != 0 {
                    result = firstValue / currentValue
                } else {
                    displayText = "Ошибка"
                    isOperationCompleted = true
                    return
                }
            default:
                return
            }

            displayText = formatResult(result)
            self.firstValue = result
        } else {
            firstValue = Double(displayText)
        }

        selectedOperation = operation
        currentOperation = operation
        displayText = "0"

        if customLogic {
            let lastChar = calculationChain.last
            if lastChar != "+" && lastChar != "-" && lastChar != "x" && lastChar != "÷" && lastChar != " " {
                calculationChain += " \(operation) "
            }
        }

        operatorPressed = true
        saveCurrentState()
    }

    func performCalculation() {
        guard let firstValue = firstValue, let secondValue = Double(displayText), let operation = currentOperation else {
            return
        }
        var result: Double = 0
        
        switch operation {
        case "+":
            result = firstValue + secondValue
        case "-":
            result = firstValue - secondValue
        case "x":
            result = firstValue * secondValue
        case "÷":
            if secondValue != 0 {
                result = firstValue / secondValue
            } else {
                displayText = "Ошибка"
                isOperationCompleted = true
                return
            }
        default:
            return
        }

        if result > maxValue {
            displayText = "Ошибка"
            isOperationCompleted = true
            return
        }

        displayText = formatResult(result)

        if customLogic {
            calculationChain += " = \(formatResult(result))"
        }

        selectedOperation = nil
        self.firstValue = nil
        currentOperation = nil
        saveCurrentState()
    }
    
    func handlePercentage() {
        guard let currentValue = Double(displayText) else { return }

        if let operation = currentOperation, let firstValue = firstValue {
            let percentageValue = firstValue * currentValue / 100
            displayText = String(percentageValue)
        } else {
            displayText = String(currentValue / 100)
        }

        isOperationCompleted = true
    }
    
    func formatResult(_ result: Double) -> String {
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

    
    func clear() {
        displayText = "0"
        calculationChain = ""
        currentOperation = nil
        firstValue = nil
        isOperationCompleted = false
        saveCurrentState()
    }
    
    func toggleSign() {
        if let value = Double(displayText) {
            displayText = formatResult(value * -1)
        }
        saveCurrentState()
    }
    
    func removeLastCharacter() {
        if isOperationCompleted {
            return
        }

        if !displayText.isEmpty && displayText != "0" {
            displayText.removeLast()
            if displayText.isEmpty {
                displayText = "0"
            }
        }

        if customLogic && !calculationChain.isEmpty {
            let lastChar = calculationChain.last
            if let lastChar = lastChar, lastChar.isNumber {
                calculationChain.removeLast()
            }
        }
        
        saveCurrentState()
    }

    
    func saveCurrentState() {
        UserDefaults.standard.set(displayText, forKey: "displayText")
        UserDefaults.standard.set(calculationChain, forKey: "calculationChain")
    }
    
    func loadSavedState() {
        displayText = UserDefaults.standard.string(forKey: "displayText") ?? "0"
        calculationChain = UserDefaults.standard.string(forKey: "calculationChain") ?? ""
    }
    
    func generateHapticFeedback() {
        let impactFeedbackgenerator = UIImpactFeedbackGenerator(style: .light)
        impactFeedbackgenerator.impactOccurred()
    }
}

struct BasicCalculatorView_Previews: PreviewProvider {
    static var previews: some View {
        BasicCalculatorView()
    }
}
