//
//  PassKeyViews.swift
//  Calculator
//
//  Created by AI on 3.03.26.
//

import SwiftUI

struct PassKeyGateView: View {
    @StateObject private var passKeyViewModel = PassKeyViewModel()
    
    var body: some View {
        Group {
            if passKeyViewModel.isUnlocked {
                CalculatorView()
            } else if passKeyViewModel.isPassKeySet {
                PassKeyUnlockView(viewModel: passKeyViewModel)
            } else {
                PassKeySetupView(viewModel: passKeyViewModel)
            }
        }
        .onAppear {
            passKeyViewModel.loadState()
            if passKeyViewModel.isPassKeySet {
                passKeyViewModel.tryBiometricUnlock()
            }
        }
    }
}

struct PassKeySetupView: View {
    @ObservedObject var viewModel: PassKeyViewModel
    
    var body: some View {
        VStack(spacing: 24) {
            Text("Set Pass Key")
                .font(.largeTitle)
                .foregroundStyle(.white)
            
            SecureField("Enter new Pass Key", text: $viewModel.newPassKey)
                .keyboardType(.numberPad)
                .textContentType(.password)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(12)
            
            SecureField("Confirm Pass Key", text: $viewModel.confirmPassKey)
                .keyboardType(.numberPad)
                .textContentType(.password)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(12)
            
            if viewModel.useBiometrics || PassKeyService.shared.biometricsAvailable {
                Toggle("Use Face ID / Touch ID", isOn: $viewModel.useBiometrics)
                    .onChange(of: viewModel.useBiometrics) { newValue in
                        viewModel.toggleBiometrics(newValue)
                    }
                    .tint(.orange)
            }
            
            if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundStyle(.red)
                    .font(.footnote)
            }
            
            Button(action: {
                viewModel.setupPassKey()
            }) {
                Text("Save Pass Key")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.orange)
                    .foregroundStyle(.white)
                    .cornerRadius(12)
            }
        }
        .padding()
        .background(Color.black.ignoresSafeArea())
    }
}

struct PassKeyUnlockView: View {
    @ObservedObject var viewModel: PassKeyViewModel
    
    var body: some View {
        VStack(spacing: 24) {
            Text("Enter Pass Key")
                .font(.largeTitle)
                .foregroundStyle(.white)
            
            SecureField("Pass Key", text: $viewModel.enteredPassKey)
                .keyboardType(.numberPad)
                .textContentType(.password)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(12)
            
            if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundStyle(.red)
                    .font(.footnote)
            }
            
            Button(action: {
                viewModel.validatePassKey()
            }) {
                Text("Unlock")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.orange)
                    .foregroundStyle(.white)
                    .cornerRadius(12)
            }
            
            if PassKeyService.shared.biometricsEnabled && PassKeyService.shared.biometricsAvailable {
                Button(action: {
                    viewModel.tryBiometricUnlock()
                }) {
                    HStack {
                        Image(systemName: "faceid")
                        Text("Use Face ID / Touch ID")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.gray.opacity(0.3))
                    .foregroundStyle(.white)
                    .cornerRadius(12)
                }
            }
            
            Button(role: .destructive) {
                viewModel.resetPassKey()
            } label: {
                Text("Forgot Pass Key?")
                    .foregroundStyle(.red)
            }
        }
        .padding()
        .background(Color.black.ignoresSafeArea())
    }
}

#Preview {
    PassKeyGateView()
}

