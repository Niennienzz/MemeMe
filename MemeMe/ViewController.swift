//
//  ViewController.swift
//  MemeMe
//
//  Created by Zhehui Zhou on 7/5/17.
//  Copyright © 2017 ZhehuiZhou. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: Fields
    
    let imagePicker = UIImagePickerController()
    let textFieldDelegate = TextFieldDelegate()
    let keyboardMoveListener = KeyboardMoveListener()

    
    // MARK: Outlets
    
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var galleryButton: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var buttomTextField: UITextField!
    @IBOutlet weak var shareMemeButton: UIBarButtonItem!
    
    
    // MARK: UIViewController Methods
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        keyboardMoveListener.subscribe(view: view, elements: [buttomTextField])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // image picker
        self.imagePicker.delegate = self
        
        // text fields
        self.initTextFields()
        
        // buttons
        self.initToolbars()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        keyboardMoveListener.unsubscribe()
    }
    
    func initTextFields() {
        let memeTextAttributes:[String:Any] = [
            NSStrokeColorAttributeName: UIColor.black,
            NSForegroundColorAttributeName: UIColor.white,
            NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName: -2.0,
        ]
        self.topTextField.delegate = self.textFieldDelegate
        self.topTextField.defaultTextAttributes = memeTextAttributes
        self.topTextField.text = "TOP"
        self.topTextField.textAlignment = .center
        
        self.buttomTextField.delegate = self.textFieldDelegate
        self.buttomTextField.defaultTextAttributes = memeTextAttributes
        self.buttomTextField.text = "BUTTOM"
        self.buttomTextField.textAlignment = .center
    }
    
    func initToolbars() {
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        galleryButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.photoLibrary)
        shareMemeButton.isEnabled = false
    }

    
    // MARK: Actions
    
    @IBAction func pickAnImageFromAlbum(_ sender: Any) {
        self.imagePicker.sourceType = .photoLibrary
        present(self.imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        self.imagePicker.sourceType = .camera
        present(self.imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func shareMeme(_ sender: Any) {
        let image = save()
        let controller = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        present(controller, animated: true, completion: nil)
    }
    
    
    // MARK: UIImagePickerControllerDelegate Methods
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.imagePickerView.contentMode = .scaleAspectFit
            self.imagePickerView.image = pickedImage
        }
        shareMemeButton.isEnabled = true
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        shareMemeButton.isEnabled = (imagePickerView.image != nil)
        dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: Meme Generating Helpers
    
    func generateMemedImage() -> UIImage {
        self.navigationController?.setToolbarHidden(true, animated: false)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        self.navigationController?.setToolbarHidden(false, animated: false)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        return memedImage
    }
    
    func save() -> UIImage {
        let meme = Meme(textTop: topTextField.text!, textBottom: buttomTextField.text!, imageOriginal: imagePickerView.image!, imageMemed: generateMemedImage())
        return meme.imageMemed
    }
    
}
