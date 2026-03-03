//
//  HistoryView.swift
//  Calculator
//
//  Created by Арина Петрожицкая on 23.02.26.
//

import SwiftUI

struct HistoryView: View {
    @ObservedObject var viewModel: CalculatorViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            List(viewModel.history) { item in
                VStack(alignment: .leading) {
                    Text(item.expression)
                        .font(.headline)
                    Text("= \(item.result)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Text(item.timestamp, style: .date)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .padding(.vertical, 4)
            }
            .navigationTitle("История")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Готово") { dismiss() }
                }
            }
            .overlay {
                if viewModel.history.isEmpty {
                    ContentUnavailableView(
                        "Нет вычислений",
                        systemImage: "clock",
                        description: Text("Совершите расчёты, чтобы они появились здесь.")
                    )
                }
            }
        }
        .onAppear {
            viewModel.loadHistory()
        }
    }
}

#Preview {
    let viewModel = CalculatorViewModel()
    viewModel.history = [
        Calculation(id: "1", expression: "2 + 2", result: "4", timestamp: Date()),
        Calculation(id: "2", expression: "5 × 3", result: "15", timestamp: Date().addingTimeInterval(-3600))
    ]
    return HistoryView(viewModel: viewModel)
}
