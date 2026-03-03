//
//  CalculatorView.swift
//  Calculator
//
//  Created by Арина Петрожицкая on 7.02.26.
//

import SwiftUI

struct CalculatorView: View {
    @StateObject private var viewModel = CalculatorViewModel()
    @State private var showHistorySheet = false
    
    private struct ButtonInfo {
        let id: String
        let isWide: Bool
    }
        
        private let buttons: [[ButtonInfo]] = [
            [
                ButtonInfo(id: "C", isWide: false),
                ButtonInfo(id: "AC", isWide: false),
                ButtonInfo(id: "%", isWide: false),
                ButtonInfo(id: "÷", isWide: false)
            ],
            [
                ButtonInfo(id: "7", isWide: false),
                ButtonInfo(id: "8", isWide: false),
                ButtonInfo(id: "9", isWide: false),
                ButtonInfo(id: "×", isWide: false)
            ],
            [
                ButtonInfo(id: "4", isWide: false),
                ButtonInfo(id: "5", isWide: false),
                ButtonInfo(id: "6", isWide: false),
                ButtonInfo(id: "-", isWide: false)
            ],
            [
                ButtonInfo(id: "1", isWide: false),
                ButtonInfo(id: "2", isWide: false),
                ButtonInfo(id: "3", isWide: false),
                ButtonInfo(id: "+", isWide: false)
            ],
            [
                ButtonInfo(id: "±", isWide: false),
                ButtonInfo(id: "0", isWide: true),
                ButtonInfo(id: ".", isWide: false),
                ButtonInfo(id: "=", isWide: false)
            ]
        ]
    
    @State private var showShakeMessage = false
    @State private var shakeMessage = ""
    
    private func showTemporaryMessage(_ message: String){
        shakeMessage = message
        withAnimation {
            showShakeMessage = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5){
            withAnimation{
                showShakeMessage = false
            }
        }
    }
    
    var body: some View {
        GeometryReader{ geometry in
            let isLandscape = geometry.size.width > geometry.size.height
            let buttonSpacing: CGFloat = isLandscape ? 8 : 8
            let buttonHeight: CGFloat = isLandscape ?
            (geometry.size.height - 200) / 5 :
            (geometry.size.height - 250) / 6
            VStack(spacing: 0){
                HStack {
                    Spacer()
                    Button {
                        showHistorySheet = true
                    } label: {
                        Image(systemName: "clock")
                            .foregroundStyle(.white)
                            .padding(8)
                    }
                    .padding(.trailing)
                }
                
                DisplayView(expression: viewModel.expressionText,
                            result: viewModel.displayText,
                            isLandscape: isLandscape)
                Spacer()
                VStack(spacing: buttonSpacing) {
                    ForEach(buttons.indices, id: \.self) { rowIndex in
                        HStack(spacing: buttonSpacing) {
                            ForEach(buttons[rowIndex].indices, id: \.self) { colIndex in
                                let button = buttons[rowIndex][colIndex]
                                
                                CalculatorButtonView(
                                    title: button.id,
                                    color: getColor(for: button.id),
                                    textColor: .white,
                                    isWide: button.isWide,
                                    action: { buttonTap(button.id)}
                                )
                                .frame(height: buttonHeight)
                            }
                        }
                    }
                }
                .padding(buttonSpacing)
                .background(Color.black)
            }
            .background(Color.black.edgesIgnoringSafeArea(.all))
            .alert("Error", isPresented: $viewModel.showError){
                Button("Ok", role: .cancel) {}
            } message: {
                Text(viewModel.errorMessage)
            }
        }
        .background(ShakeDetector())
        .onAppear {
            viewModel.loadTheme()
        }
        .background(
            StatusBarStyle(statusBarStyle: viewModel.theme.statusBarStyle)
                .edgesIgnoringSafeArea(.all)
        )
        .onReceive(NotificationCenter.default.publisher(for: .deviceDidShakeNotification)) { _ in
            viewModel.clear()
            showTemporaryMessage("Cleared by shake")
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
        }
        .overlay{
            Text(shakeMessage)
                .padding()
                .background(Color.black.opacity(0.7))
                .foregroundStyle(.white)
                .cornerRadius(10)
                .opacity(showShakeMessage ? 1 : 0)
                .padding(.top, 50)
        }
        .sheet(isPresented: $showHistorySheet) {
            HistoryView(viewModel: viewModel)
        }
    }
    
    private func getColor(for button: String) -> Color {
        let operations = ["÷", "×", "-", "+", "="]
        return operations.contains(button) ? viewModel.theme.primaryColor : .gray
    }
    
    private func buttonTap(_ button: String){
        switch button{
        case "AC":
            viewModel.clear()
        case "+":
            viewModel.performOperation(.add)
        case "=":
            viewModel.calculate()
        case "-":
            viewModel.performOperation(.subtract)
        case "%":
            viewModel.percentage()
        case ".":
            viewModel.inputDigit(".")
        case "×":
            viewModel.performOperation(.multiply)
        case "±":
            viewModel.toggleSign()
        case "C":
            viewModel.clearEntry()
        case "÷":
            viewModel.performOperation(.divide)
        default:
            if let _ = Int(button){
                viewModel.inputDigit(button)
            }
        }
    }
}

struct DisplayView: View{
    let expression: String
    let result: String
    let isLandscape: Bool
    
    var body: some View{
        HStack{
            Spacer()
            VStack(alignment: .trailing, spacing: 4) {
                if !expression.isEmpty {
                    Text(expression)
                        .font(.system(size: isLandscape ? 24 : 28, weight: .regular))
                        .foregroundStyle(.gray)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                }
                
                Text(result)
                    .font(.system(size: isLandscape ? 50 : 80, weight: .light))
                    .foregroundStyle(.white)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
            }
            .padding(.trailing)
        }
    }
}

#Preview {
    CalculatorView()
}
