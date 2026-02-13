//
//  CalculatorView.swift
//  Calculator
//
//  Created by Арина Петрожицкая on 7.02.26.
//

import SwiftUI

struct CalculatorView: View {
    @StateObject private var viewModel = CalculatorViewModel()
    
    private struct ButtonInfo {
            let id: String
            let color: Color
            let isWide: Bool
        }
        
        private let buttons: [[ButtonInfo]] = [
            [
                ButtonInfo(id: "C", color: .gray, isWide: false),
                ButtonInfo(id: "AC", color: .gray, isWide: false),
                ButtonInfo(id: "%", color: .gray, isWide: false),
                ButtonInfo(id: "÷", color: .orange, isWide: false)
            ],
            [
                ButtonInfo(id: "7", color: .gray, isWide: false),
                ButtonInfo(id: "8", color: .gray, isWide: false),
                ButtonInfo(id: "9", color: .gray, isWide: false),
                ButtonInfo(id: "×", color: .orange, isWide: false)
            ],
            [
                ButtonInfo(id: "4", color: .gray, isWide: false),
                ButtonInfo(id: "5", color: .gray, isWide: false),
                ButtonInfo(id: "6", color: .gray, isWide: false),
                ButtonInfo(id: "-", color: .orange, isWide: false)
            ],
            [
                ButtonInfo(id: "1", color: .gray, isWide: false),
                ButtonInfo(id: "2", color: .gray, isWide: false),
                ButtonInfo(id: "3", color: .gray, isWide: false),
                ButtonInfo(id: "+", color: .orange, isWide: false)
            ],
            [
                ButtonInfo(id: "±", color: .gray, isWide: false),
                ButtonInfo(id: "0", color: .gray, isWide: true),
                ButtonInfo(id: ".", color: .gray, isWide: false),
                ButtonInfo(id: "=", color: .orange, isWide: false)
            ]
        ]
    
    var body: some View {
        GeometryReader{ geometry in
            let isLandscape = geometry.size.width > geometry.size.height
            let buttonSpacing: CGFloat = isLandscape ? 8 : 8
            let buttonHeight: CGFloat = isLandscape ?
            (geometry.size.height - 200) / 5 :
            (geometry.size.height - 250) / 6
            VStack(spacing: 0){
                DisplayView(text: viewModel.displayText, isLandscape: isLandscape)
                Spacer()
                VStack(spacing: buttonSpacing) {
                    ForEach(buttons.indices, id: \.self) { rowIndex in
                        HStack(spacing: buttonSpacing) {
                            ForEach(buttons[rowIndex].indices, id: \.self) { colIndex in
                                let button = buttons[rowIndex][colIndex]
                                
                                CalculatorButtonView(
                                    title: button.id,
                                    color: button.color,
                                    textColor: .white,
                                    isWide: button.isWide
                                ) {
                                    buttonTap(button.id)
                                }
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
                Button("Ok", role: .cancel)
            } message: {
                Text(viewModel.errorMessage)
            }
        }
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
    let text: String
    let isLandscape: Bool
    
    var body: some View{
        HStack{
            Spacer()
            Text(text)
                .font(.system(size: isLandscape ? 50 : 80, weight: .light))
                .foregroundStyle(.white)
                .lineLimit(1)
                .padding(.trailing)
        }
    }
}

#Preview {
    CalculatorView()
}
