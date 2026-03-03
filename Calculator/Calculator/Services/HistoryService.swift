//
//  HistoryService.swift
//  Calculator
//
//  Created by Арина Петрожицкая on 23.02.26.
//

import Foundation
import FirebaseFirestore

class HistoryService {
    private let db = Firestore.firestore()
    private let collection = "history"
    
    func saveCalculation(expression: String, result: String, userId: String? = nil) {
        var data: [String: Any] = [
            "expression": expression,
            "result": result,
            "timestamp": FieldValue.serverTimestamp()
        ]
        if let userId = userId {
            data["userId"] = userId
        }
        
        db.collection(collection).addDocument(data: data) { error in
            if let error = error {
                print("Ошибка сохранения: \(error)")
            } else {
                print("Сохранено успешно")
            }
        }
    }
    
    func fetchHistory(completion: @escaping ([Calculation]) -> Void) {
        db.collection(collection)
            .order(by: "timestamp", descending: true)
            .limit(to: 50)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Ошибка загрузки: \(error)")
                    completion([])
                    return
                }
                
                let calculations = snapshot?.documents.compactMap { doc -> Calculation? in
                    let data = doc.data()
                    guard let expr = data["expression"] as? String,
                          let res = data["result"] as? String else { return nil }
                    
                    let timestampValue = data["timestamp"]
                    let date: Date
                    if let ts = timestampValue as? Timestamp {
                        date = ts.dateValue()
                    } else {
                        date = Date()
                    }
                    
                    return Calculation(id: doc.documentID,
                                       expression: expr,
                                       result: res,
                                       timestamp: date)
                } ?? []
                completion(calculations)
            }
    }
}

struct Calculation: Identifiable {
    let id: String
    let expression: String
    let result: String
    let timestamp: Date
}
