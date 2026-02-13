//
//  CalculatorViewModel.swift
//  Calculator
//
//  Created by Арина Петрожицкая on 8.02.26.
//

import Foundation
import Combine

class CalculatorViewModel: ObservableObject {
    private var model = CalculatorModel()
    @Published var displayText: String = "0"
    @Published var showError: Bool = false
    @Published var errorMessage: String = ""
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        model.$displayValue
            .assign(to: \.displayText, on: self)
            .store(in: &cancellables)
    }
    
    func inputDigit(_ digit: String) {
        do {
            try model.inputDigits(digit)
        } catch CalculatorError.overflow{
            showError(message: "Number is too large")
        } catch {
            showError(message: "Invalid input")
        }
    }
    
    func performOperation(_ operation: Operation){
        model.performOperation(operation)
    }
    
    func calculate() {
        do{
            try model.calculate()
        } catch CalculatorError.divisionByZero {
            showError(message: "Cannot divide by zero")
        } catch CalculatorError.overflow {
            showError(message: "Calculation result is too large")
        } catch {
            showError(message: "Calculation error")
        }
    }
    
    func clear(){
        model.clear()
    }
    
    func clearEntry() {
        model.clearEntry()
    }
    
    func toggleSign() {
        model.toggleSign()
    }
    
    func percentage(){
        model.percentage()
    }
    
    private func showError(message: String){
        errorMessage = message
        showError = true
    }
}
