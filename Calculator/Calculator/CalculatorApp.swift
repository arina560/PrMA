//
//  CalculatorApp.swift
//  Calculator
//
//  Created by Арина Петрожицкая on 7.02.26.
//

import SwiftUI

@main
struct CalculatorApp: App {
    var body: some Scene {
        WindowGroup {
            CalculatorView()
                .preferredColorScheme(.dark)
        }
    }
}
