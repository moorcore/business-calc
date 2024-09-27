//
//  BasicCalculatorView.swift
//  BusinessCalculator
//
//  Created by Maxim Boykin on 25.9.24..
//

import SwiftUI

struct BasicCalculatorView: View {
    @State private var displayText = "0"
    @State private var currentOperation: String? = nil
    @State private var firstValue: Double? = nil
    @State private var isPressed = false
    @State private var selectedOperation: String? = nil
    @State private var isTypingNewNumber = true
    
    var body: some View {
        VStack {
            Text(displayText)
                .font(.system(size: 70))
                .padding()
                .frame(maxWidth: .infinity, alignment: .trailing)
                .cornerRadius(10)
                .foregroundColor(Color(hex: "#538296"))
                .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5)
                .onTapGesture {
                    UIPasteboard.general.string = displayText
                }
                .gesture(
                    DragGesture(minimumDistance: 20)
                        .onEnded { value in
                            if value.translation.width < 0 {
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
        ["", "0", ".", "="]
    ]
    
    func buttonTapped(button: String) {
        switch button {
        case "C":
            clear()
        case "+/-":
            toggleSign()
        case "%":
            // TODO: finish this
            break
        case "÷", "x", "+", "-":
            handleOperation(button)
        case "=":
            performCalculation()
        default:
            handleNumberInput(button)
        }
    }
    
    func handleNumberInput(_ input: String) {
        if isTypingNewNumber {
            displayText = input == "." ? "0." : input
            isTypingNewNumber = false
        } else {
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
        }
        saveCurrentState()
    }
    
    func handleOperation(_ operation: String) {
        if let firstValue = firstValue, !isTypingNewNumber {
            performCalculation()
        }
        currentOperation = operation
        selectedOperation = operation
        firstValue = Double(displayText)
        isTypingNewNumber = true
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
                displayText = "Error"
                return
            }
        default:
            return
        }
        
        displayText = formatResult(result)
        selectedOperation = nil
        isTypingNewNumber = true
        self.firstValue = nil
        currentOperation = nil
        saveCurrentState()
    }
    
    func formatResult(_ result: Double) -> String {
        if result.truncatingRemainder(dividingBy: 1) == 0 {
            return String(Int(result))
        } else {
            return String(result)
        }
    }
    
    func clear() {
        displayText = "0"
        currentOperation = nil
        selectedOperation = nil
        firstValue = nil
        isTypingNewNumber = true
        saveCurrentState()
    }
    
    func toggleSign() {
        if let value = Double(displayText) {
            displayText = String(value * -1)
        }
        saveCurrentState()
    }
    
    func removeLastCharacter() {
        if !displayText.isEmpty && displayText != "0" {
            displayText.removeLast()
            if displayText.isEmpty {
                displayText = "0"
            }
            saveCurrentState()
        }
    }
    
    func saveCurrentState() {
        UserDefaults.standard.set(displayText, forKey: "displayText")
    }
    
    func loadSavedState() {
        if let savedText = UserDefaults.standard.string(forKey: "displayText") {
            displayText = savedText
        }
    }
    
    func buttonIsOperator(_ button: String) -> Bool {
        return ["+", "-", "x", "÷"].contains(button)
    }
}

struct BasicCalculatorView_Previews: PreviewProvider {
    static var previews: some View {
        BasicCalculatorView()
    }
}




