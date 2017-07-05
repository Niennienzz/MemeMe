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
        
        notificationCenter.addObserver(self, selector: #selector(keyboardWillAppear(_:)), name: .UIKeyboardWillShow, object: nil)
        notificationCenter.addObserver(self, selector: #selector(keyboardWillDisappear(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribe() {
        notificationCenter.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        notificationCenter.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    
    // MARK: Keyboard
    
    func keyboardWillAppear(_ notification: NSNotification) {
        for element in elements {
            if element.isFirstResponder {
                view!.frame.origin.y = 0 - (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.height
                return
            }
        }
    }
    
    func keyboardWillDisappear(_ notification: NSNotification) {
        view!.frame.origin.y = 0
    }
    
}
