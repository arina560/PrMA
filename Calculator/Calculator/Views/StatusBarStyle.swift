//
//  StatusBarStyle.swift
//  Calculator
//
//  Created by Арина Петрожицкая on 23.02.26.
//

import SwiftUI
import UIKit

struct StatusBarStyle: UIViewControllerRepresentable {
    var statusBarStyle: UIStatusBarStyle
    
    final class HostingController: UIViewController {
        var currentStyle: UIStatusBarStyle = .default {
            didSet {
                setNeedsStatusBarAppearanceUpdate()
            }
        }
        
        override var preferredStatusBarStyle: UIStatusBarStyle {
            currentStyle
        }
    }
    
    func makeUIViewController(context: Context) -> HostingController {
        let controller = HostingController()
        controller.view.backgroundColor = .clear
        controller.currentStyle = statusBarStyle
        return controller
    }
    
    func updateUIViewController(_ uiViewController: HostingController, context: Context) {
        uiViewController.currentStyle = statusBarStyle
    }
}

#Preview {
    StatusBarStyle(statusBarStyle: .lightContent)
}
