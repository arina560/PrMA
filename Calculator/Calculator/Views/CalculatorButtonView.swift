//
//  CalclatorButtonView.swift
//  Calculator
//
//  Created by Арина Петрожицкая on 7.02.26.
//

import SwiftUI
import UIKit

struct HapticManager {
    static func lightImpact() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }
}

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
        Button(action: {
            HapticManager.lightImpact()
            action()
        }){
            Text(title)
                .font(.system(size: 32, weight: .medium))
                .foregroundStyle(textColor)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(color)
                .cornerRadius(40)
                .padding(isWide ? 4 : 8)
        }
        .buttonStyle(CalculatorButtonStyle())
    }
}

struct CalculatorButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .opacity(configuration.isPressed ? 0.9 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

#Preview {
    CalculatorButtonView(title: "+", action: {})
}
