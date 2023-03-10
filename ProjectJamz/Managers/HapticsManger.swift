//
//  HapticsManger.swift
//  JamzApp
//
//  Created by Adrianna Parlato on 10/11/22.
//

import Foundation
import UIKit


//The HapticsManager class can be used to encapsulate the logic for generating haptic feedback and make it easier to use throughout an app.

final class HapticsManager {
    static let shared = HapticsManager()
    //The private init() method defines the initializer for the class, making it private so that instances of the class cannot be created from outside the class.
    private init() {
        
    }
    
    //The vibrateForSelection() method generates a haptic feedback pattern for a selection change. It creates an instance of UISelectionFeedbackGenerator, prepares it for use, and triggers a selection change. The method is executed on the main thread asynchronously.
    
    public func vibrateForSelection() {
        DispatchQueue.main.async {
            let generator = UISelectionFeedbackGenerator()
            generator.prepare()
            generator.selectionChanged()
        }
    }
    
    //The vibrate(for type: UINotificationFeedbackGenerator.FeedbackType) method generates a haptic feedback pattern of the specified type. It creates an instance of UINotificationFeedbackGenerator, prepares it for use, and triggers a notification of the specified type. The method is executed on the main thread asynchronously.
    
    public func vibrate(for type: UINotificationFeedbackGenerator.FeedbackType) {
        DispatchQueue.main.async {
            let generator = UINotificationFeedbackGenerator()
            generator.prepare()
            generator.notificationOccurred(type)
        }
    }
}



