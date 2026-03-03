//
//  PassKeyService.swift
//  Calculator
//
//  Created by AI on 3.03.26.
//

import Foundation
import LocalAuthentication
import Security

enum PassKeyError: Error {
    case notSet
    case invalid
    case biometricUnavailable
}

final class PassKeyService {
    static let shared = PassKeyService()
    
    private let service = "CalculatorPassKeyService"
    private let account = "userPassKey"
    private let biometricsKey = "useBiometrics"
    
    private init() {}
    
    // MARK: - Keychain helpers
    
    private func keychainQuery() -> [String: Any] {
        [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account
        ]
    }
    
    func isPassKeySet() -> Bool {
        var query = keychainQuery()
        query[kSecReturnData as String] = true
        query[kSecMatchLimit as String] = kSecMatchLimitOne
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        return status == errSecSuccess
    }
    
    func setPassKey(_ passKey: String) throws {
        guard let data = passKey.data(using: .utf8) else { return }
        
        if isPassKeySet() {
            var attributes: [String: Any] = [:]
            attributes[kSecValueData as String] = data
            SecItemUpdate(keychainQuery() as CFDictionary, attributes as CFDictionary)
        } else {
            var query = keychainQuery()
            query[kSecValueData as String] = data
            SecItemAdd(query as CFDictionary, nil)
        }
    }
    
    func validatePassKey(_ passKey: String) -> Bool {
        var query = keychainQuery()
        query[kSecReturnData as String] = true
        query[kSecMatchLimit as String] = kSecMatchLimitOne
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        guard status == errSecSuccess,
              let data = item as? Data,
              let stored = String(data: data, encoding: .utf8) else {
            return false
        }
        return stored == passKey
    }
    
    func resetPassKey() {
        SecItemDelete(keychainQuery() as CFDictionary)
    }
    
    // MARK: - Biometric
    
    var biometricsEnabled: Bool {
        get { UserDefaults.standard.bool(forKey: biometricsKey) }
        set { UserDefaults.standard.set(newValue, forKey: biometricsKey) }
    }
    
    var biometricsAvailable: Bool {
        let context = LAContext()
        var error: NSError?
        let can = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
        return can
    }
    
    func authenticateWithBiometrics(completion: @escaping (Bool, Error?) -> Void) {
        let context = LAContext()
        var error: NSError?
        
        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            completion(false, error)
            return
        }
        
        let reason = "Unlock calculator with biometrics"
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, evalError in
            DispatchQueue.main.async {
                completion(success, evalError)
            }
        }
    }
}

