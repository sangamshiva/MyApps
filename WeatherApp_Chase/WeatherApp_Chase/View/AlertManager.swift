//
//  AlertManager.swift
//  WeatherApp_Chase
//
//  Created by Shiva Sangam on 18/08/24.
//

import UIKit

final class AlertManager {
    
    private init () {}
    
    static func showAlert(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        
        self.topMostViewController()?.present(alert, animated: true)
    }
    
    private static func topMostViewController() -> UIViewController? {
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let keyWindow = windowScene?.windows.first
        
        if var topController = keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            return topController
        }
        return nil
    }
}
