//
//  PassKeyViewModel.swift
//  Calculator
//
//  Created by AI on 3.03.26.
//

import Foundation

final class PassKeyViewModel: ObservableObject {
    @Published var isUnlocked: Bool = false
    @Published var isPassKeySet: Bool = false
    @Published var errorMessage: String?
    @Published var useBiometrics: Bool = false
    
    @Published var newPassKey: String = ""
    @Published var confirmPassKey: String = ""
    @Published var enteredPassKey: String = ""
    
    private let service = PassKeyService.shared
    
    func loadState() {
        isPassKeySet = service.isPassKeySet()
        useBiometrics = service.biometricsEnabled && service.biometricsAvailable
    }
    
    func setupPassKey() {
        guard !newPassKey.isEmpty, !confirmPassKey.isEmpty else {
            errorMessage = "Pass Key cannot be empty"
            return
        }
        
        guard newPassKey == confirmPassKey else {
            errorMessage = "Pass Keys do not match"
            return
        }
        
        do {
            try service.setPassKey(newPassKey)
            service.biometricsEnabled = useBiometrics && service.biometricsAvailable
            isPassKeySet = true
            isUnlocked = true
            errorMessage = nil
        } catch {
            errorMessage = "Failed to save Pass Key"
        }
    }
    
    func validatePassKey() {
        guard service.isPassKeySet() else {
            errorMessage = "Pass Key is not set"
            return
        }
        
        if service.validatePassKey(enteredPassKey) {
            isUnlocked = true
            errorMessage = nil
        } else {
            errorMessage = "Incorrect Pass Key"
        }
    }
    
    func resetPassKey() {
        service.resetPassKey()
        isPassKeySet = false
        isUnlocked = false
        newPassKey = ""
        confirmPassKey = ""
        enteredPassKey = ""
        errorMessage = nil
    }
    
    func toggleBiometrics(_ enabled: Bool) {
        guard service.biometricsAvailable else {
            useBiometrics = false
            errorMessage = "Biometric authentication is not available"
            return
        }
        useBiometrics = enabled
        service.biometricsEnabled = enabled
    }
    
    func tryBiometricUnlock() {
        guard service.biometricsEnabled, service.biometricsAvailable else { return }
        
        service.authenticateWithBiometrics { [weak self] success, error in
            if success {
                self?.isUnlocked = true
                self?.errorMessage = nil
            } else if let error = error {
                self?.errorMessage = error.localizedDescription
            } else {
                self?.errorMessage = "Biometric authentication failed"
            }
        }
    }
}

