//
//  CalclatorButtonView.swift
//  Calculator
//
//  Created by Арина Петрожицкая on 7.02.26.
//

import SwiftUI

struct CalculatorButtonView: View {
    let title: String
    let color: Color
    let textColor: Color
    let isWide: Bool
    let action: () -> Void
    
    init(title: String, color: Color = .gray, textColor: Color = .white, isWide: Bool = false, action: @escaping () -> Void) {
        self.title = title
        self.color = color
        self.textColor = textColor
        self.isWide = isWide
        self.action = action
    }
    
    var body: some View {
        Button(action: action){
            Text(title)
                .font(.system(size: 32, weight: .medium))
                .foregroundStyle(textColor)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(color)
                .cornerRadius(40)
                .padding(isWide ? 4 : 8)
        }
    }
}

#Preview {
    CalculatorButtonView(title: "+", action: {})
}
