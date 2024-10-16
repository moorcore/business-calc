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
    
    @State private var notificationTimer: Timer? = nil

    @State private var isPressed = false
    @State private var operatorPressed = false
    @State private var isOperationCompleted = false
    @State private var showCopyNotification = false

    @AppStorage("customLogic") private var customLogic: Bool = false
    @AppStorage("saveState") private var saveState: Bool = false
    
    var body: some View {
        ZStack {
            
            VStack(spacing: 15) {
                if customLogic {
                    Text(calculationChain)
                        .font(.title2)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .foregroundColor(Color.adaptiveText)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                        .background(Color.clear)
                } else {
                    Spacer().frame(height: 40)
                }
                
                Text(displayText)
                    .font(.system(size: 80))
                    .padding()
                    .frame(maxWidth: CGFloat.infinity, alignment: .trailing)
                    .cornerRadius(10)
                    .foregroundColor(Color.adaptiveText)
                    .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    .onTapGesture {
                        copyToClipboard()
                    }
                    // Not working for now
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
                                        .background(selectedOperation == button ? Color.adaptiveButtonHighlight : Color.adaptiveButtonBackground)
                                        .foregroundColor(Color.adaptiveText)
                                        .cornerRadius(10)
                                        .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5)
                                        .scaleEffect(isPressed ? 1.1 : 1.0)
                                        .animation(.easeInOut(duration: 0.1), value: isPressed)
                                        .animation(.spring(response: 0.3, dampingFraction: 0.5, blendDuration: 0), value: isPressed)
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
            
            if showCopyNotification {
                Text("Скопировано!")
                    .font(.headline)
                    .padding()
                    .background(Color.adaptiveButtonHighlight)
                    .foregroundColor(Color.adaptiveText)
                    .cornerRadius(10)
                    .shadow(radius: 10)
                    .transition(.opacity)
                    .animation(.easeInOut(duration: 0.5))
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            withAnimation {
                                showCopyNotification = false
                            }
                        }
                    }
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
        if isOperationCompleted {
            displayText = "0"
            isOperationCompleted = false
        }
        
        selectedOperation = nil
        operatorPressed = false
        
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
        if saveState {
            saveCurrentState()
        }
    }

    func handleOperation(_ operation: String) {
        if isOperationCompleted {
            isOperationCompleted = false
        }

        if operatorPressed {
            currentOperation = operation
            selectedOperation = operation
            if customLogic {
                if let lastChar = calculationChain.last, !lastChar.isNumber {
                    calculationChain.removeLast(2)
                    calculationChain += "\(operation) "
                }
            }
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
        if saveState {
            saveCurrentState()
        }
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
        selectedOperation = nil
        self.firstValue = nil
        currentOperation = nil
        isOperationCompleted = true
        if saveState {
            saveCurrentState()
        }
    }
    
    func handlePercentage() {
        guard let currentValue = Double(displayText) else { return }

        if let currentOperation, let firstValue = firstValue {
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
        selectedOperation = nil
        currentOperation = nil
        firstValue = nil
        isOperationCompleted = false
        if saveState {
            saveCurrentState()
        }
    }
    
    func toggleSign() {
        if let value = Double(displayText) {
            displayText = formatResult(value * -1)
        }
        if saveState {
            saveCurrentState()
        }
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
        
        if saveState {
            saveCurrentState()
        }
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
    
    func copyToClipboard() {
        UIPasteboard.general.string = displayText
        
        notificationTimer?.invalidate()
        showCopyNotification = true
        
        notificationTimer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { _ in
            withAnimation {
                showCopyNotification = false
            }
        }
    }
}

struct BasicCalculatorView_Previews: PreviewProvider {
    static var previews: some View {
        BasicCalculatorView()
    }
}
