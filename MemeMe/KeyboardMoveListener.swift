//
//  KeyboardMoveListener.swift
//  MemeMe
//
//  Created by Zhehui Joe Zhou on 7/5/17.
//  Copyright © 2017 ZhehuiZhou. All rights reserved.
//

import Foundation
import UIKit

class KeyboardMoveListener: NSObject {
    
    // MARK: Fields
    
    var view: UIView?
    var elements: [UIResponder] = []
    let notificationCenter = NotificationCenter.default
    
    
    // MARK: Subscribe and Unsubscribe

    func subscribe(view: UIView, elements: [UIResponder]) {
        self.view = view
        self.elements = elements
        
        notificationCenter.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        notificationCenter.addObserver(self, selector: #selector(UIKeyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribe() {
        notificationCenter.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        notificationCenter.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    
    // MARK: Keyboard
    
    func keyboardWillShow(_ notification:Notification) {
        for element in elements {
            if element.isFirstResponder {
                view!.frame.origin.y -= getKeyboardHeight(notification)
                return
            }
        }
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    func UIKeyboardWillHide(_ notification: NSNotification) {
        view!.frame.origin.y = 0
    }
    
}
