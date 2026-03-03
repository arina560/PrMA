//
//  ShakeDetector.swift
//  Calculator
//
//  Created by Арина Петрожицкая on 22.02.26.
//
import SwiftUI
import UIKit

// Custom notification name for shake gesture
extension Notification.Name {
    static let deviceDidShakeNotification = Notification.Name("deviceDidShakeNotification")
}

// A view controller that posts a notification when a shake is detected
class ShakeDetectingViewController: UIViewController {
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            NotificationCenter.default.post(name: .deviceDidShakeNotification, object: nil)
        }
    }
}

// A SwiftUI representable to embed the view controller
struct ShakeDetector: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> ShakeDetectingViewController {
        ShakeDetectingViewController()
    }
    
    func updateUIViewController(_ uiViewController: ShakeDetectingViewController, context: Context) {}
}
