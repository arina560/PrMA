//
//  Theme.swift
//  Calculator
//
//  Created by Арина Петрожицкая on 23.02.26.
//

import Foundation
import SwiftUI

struct Theme {
    let primaryColor: Color
    let statusBarStyle: UIStatusBarStyle
    
    static let `default` = Theme(
        primaryColor: .orange,
        statusBarStyle: .lightContent
    )
}
