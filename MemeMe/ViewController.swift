//
//  ViewController.swift
//  MemeMe
//
//  Created by Zhehui Zhou on 7/5/17.
//  Copyright © 2017 ZhehuiZhou. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: Outlets

    @IBOutlet weak var imagePickerView: UIImageView!
    
    // MARK: UIViewController Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: Actions
    
    @IBAction func pickAnImage(_ sender: Any) {
        let pickerController = UIImagePickerController()
        self.present(pickerController, animated: true, completion: nil)
    }
    
}

