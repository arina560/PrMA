//
//  RemoteConfigService.swift
//  Calculator
//
//  Created by Арина Петрожицкая on 23.02.26.
//

import FirebaseRemoteConfig
import SwiftUI

class RemoteConfigService {
    static let shared = RemoteConfigService()
    private let remoteConfig = RemoteConfig.remoteConfig()
    
    private init() {
        // Настройки по умолчанию (можно также задать в консоли Firebase)
        let defaults: [String: NSObject] = [
            "primaryColor": "#FF9500" as NSString,
            "statusBarStyle": "light" as NSString
        ]
        remoteConfig.setDefaults(defaults)
    }
    
    func fetchTheme(completion: @escaping (Theme) -> Void) {
        remoteConfig.fetch { [weak self] status, error in
            guard let self = self else { return }
            
            if status == .success {
                self.remoteConfig.activate { changed, error in
                    let primaryColorHex = self.remoteConfig.configValue(forKey: "primaryColor").stringValue ?? "#FF9500"
                    let statusBarStyleString = self.remoteConfig.configValue(forKey: "statusBarStyle").stringValue ?? "light"
                    
                    let theme = Theme(
                        primaryColor: Color(hex: primaryColorHex),
                        statusBarStyle: statusBarStyleString == "light" ? .lightContent : .darkContent
                    )
                    completion(theme)
                }
            } else {
                print("Ошибка загрузки Remote Config: \(error?.localizedDescription ?? "")")
                // Возвращаем тему по умолчанию
                completion(.default)
            }
        }
    }
}
