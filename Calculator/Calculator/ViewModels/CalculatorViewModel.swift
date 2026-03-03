//
//  CalculatorViewModel.swift
//  Calculator
//
//  Created by Арина Петрожицкая on 8.02.26.
//

import Foundation
import Combine

class CalculatorViewModel: ObservableObject {
    @Published var theme: Theme = .default
    private var model = CalculatorModel()
    @Published var displayText: String = "0"
    @Published var expressionText: String = ""
    @Published var showError: Bool = false
    @Published var errorMessage: String = ""
    @Published var history: [Calculation] = []
    private let historyService = HistoryService()
    
    private var cancellables = Set<AnyCancellable>()
    private var remoteConfigService = RemoteConfigService.shared
    private var justCalculated = false
    
    init() {
        model.$displayValue
            .assign(to: \.displayText, on: self)
            .store(in: &cancellables)
    }
    
    func saveCurrentCalculation(expression: String, result: String) {
        historyService.saveCalculation(expression: expression, result: result)
    }
        
    func loadHistory() {
        historyService.fetchHistory { [weak self] calculations in
            DispatchQueue.main.async {
                self?.history = calculations
            }
        }
    }
    
    func loadTheme() {
        remoteConfigService.fetchTheme { [weak self] theme in
            DispatchQueue.main.async {
                self?.theme = theme
            }
        }
    }
    
    func inputDigit(_ digit: String) {
        if justCalculated {
            expressionText = ""
            justCalculated = false
        }
        
        do {
            try model.inputDigits(digit)
        } catch CalculatorError.overflow{
            showError(message: "Number is too large")
        } catch {
            showError(message: "Invalid input")
        }
        
        expressionText.append(digit)
    }
    
    func performOperation(_ operation: Operation){
        justCalculated = false
        model.performOperation(operation)
        
        let symbol: String
        switch operation {
        case .add: symbol = " + "
        case .subtract: symbol = " - "
        case .multiply: symbol = " × "
        case .divide: symbol = " ÷ "
        case .none: symbol = ""
        }
        
        if !symbol.isEmpty {
            expressionText.append(symbol)
        }
    }
    
    func calculate() {
        do{
            try model.calculate()
            let expression = expressionText.isEmpty ? model.displayValue : expressionText
            let result = model.displayValue
            saveCurrentCalculation(expression: expression, result: result)
            justCalculated = true
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
        expressionText = ""
        justCalculated = false
    }
    
    func clearEntry() {
        model.clearEntry()
        expressionText = ""
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
