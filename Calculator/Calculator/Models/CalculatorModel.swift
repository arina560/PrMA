//
//  CalculatorModel.swift
//  Calculator
//
//  Created by Арина Петрожицкая on 8.02.26.
//

import Foundation

enum Operation {
    case add, subtract, multiply, divide, none
}

enum CalculatorError: Error {
    case divisionByZero
    case invalidInput
    case overflow
}

class CalculatorModel: ObservableObject {
    private var currentNumber: String = "0"
    private var storedNumber: Double = 0
    private var currentOperation: Operation = .none
    private var shouldResetScreen: Bool = false
    private var lastResult: Double = 0
    
    @Published var displayValue: String = "0"
    
    private func formatNumber(_ numberString: String) -> String{
        guard let number = Double(numberString) else {
            return numberString
        }
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 10
        formatter.minimumFractionDigits = 0
        formatter.groupingSeparator = " "
        
        if number.truncatingRemainder(dividingBy: 1) == 0 {
            formatter.maximumFractionDigits = 0
        }
        
        return formatter.string(from: NSNumber(value: number)) ?? numberString
    }
    
    func printCurrentState() {
            print("""
            Текущее состояние:
            displayValue: \(displayValue)
            currentNumber: \(currentNumber)
            storedNumber: \(storedNumber)
            currentOperation: \(currentOperation)
            shouldResetScreen: \(shouldResetScreen)
            """)
        }
    
    func inputDigits(_ digit: String) throws {
        if shouldResetScreen {
            currentNumber = "0"
            shouldResetScreen = false
        }
        
        if currentNumber == "0" && digit != "." {
            currentNumber = digit
        } else if digit == "." {
            if !currentNumber.contains(".") {
                currentNumber += digit
            }
        } else {
            currentNumber += digit
        }
        
        if let number = Double(currentNumber), number > 1e12 {
            throw CalculatorError.overflow
        }
        
        displayValue = formatNumber(currentNumber)
        printCurrentState()
    }
    
    func performOperation(_ operation: Operation){
        
        if let number = Double(currentNumber) {
            storedNumber = number
            print("Сохранили число: \(storedNumber)")
        }

//        if currentOperation != .none && !shouldResetScreen {
//            do{
//                try calculate()
//            } catch {
//                currentNumber = "Error"
//                shouldResetScreen = true
//                return
//            }
//        }
        
        currentOperation = operation
        shouldResetScreen = true
        printCurrentState()
    }
    
    func calculate() throws {
        guard let current = Double(currentNumber) else {
            throw CalculatorError.invalidInput
        }
        
        var result: Double = 0
        
        switch currentOperation {
        case .add:
            result = storedNumber + current
        case .subtract:
            result = storedNumber - current
        case .multiply:
            result = storedNumber * current
        case .divide:
            guard current != 0 else {
                throw CalculatorError.divisionByZero
            }
            result = storedNumber / current
        case .none:
            return
        }
        
        guard result.isFinite else {
            throw CalculatorError.overflow
        }
        
        lastResult = result
        currentNumber = "\(result)"
        currentOperation = .none
        shouldResetScreen = true
        
        displayValue = formatNumber(currentNumber)
        printCurrentState()
    }
    
    func clear(){
        currentNumber = "0"
        storedNumber = 0
        currentOperation = .none
        shouldResetScreen = false
        displayValue = "0"
    }
    
    func clearEntry(){
        currentNumber = "0"
        shouldResetScreen = false
        displayValue = "0"
    }
    
    func toggleSign(){
        if let number = Double(currentNumber){
            currentNumber = "\(-number)"
            displayValue = formatNumber(currentNumber)
        }
    }
    
    func percentage(){
        if let number = Double(currentNumber){
            currentNumber = "\(number / 100)"
            displayValue = formatNumber(currentNumber)
        }
    }
    
    func getLastResult() -> Double {
        return lastResult
    }
}
