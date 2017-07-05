//
//  TextFieldDelegate.swift
//  MemeMe
//
//  Created by Zhehui Zhou on 7/5/17.
//  Copyright © 2017 ZhehuiZhou. All rights reserved.
//

import Foundation
import UIKit

class TextFieldDelegate: NSObject, UITextFieldDelegate {
        
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if !(textField.text!.isEmpty) {
            textField.text = ""
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
}
