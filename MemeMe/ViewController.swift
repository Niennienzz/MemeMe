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
    
    @IBOutlet weak var topToolBar: UIToolbar!
    @IBOutlet weak var buttomToolBar: UIToolbar!
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
        imagePicker.delegate = self
        
        // text fields
        initTextFields()
        
        // buttons
        initToolbars()
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
        topTextField.delegate = textFieldDelegate
        topTextField.defaultTextAttributes = memeTextAttributes
        topTextField.text = "TOP"
        topTextField.textAlignment = .center
        
        buttomTextField.delegate = textFieldDelegate
        buttomTextField.defaultTextAttributes = memeTextAttributes
        buttomTextField.text = "BUTTOM"
        buttomTextField.textAlignment = .center
    }
    
    func initToolbars() {
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        galleryButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.photoLibrary)
        shareMemeButton.isEnabled = false
    }

    
    // MARK: Actions
    
    @IBAction func pickAnImageFromAlbum(_ sender: Any) {
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func shareMeme(_ sender: Any) {
        let image = save()
        let controller = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        present(controller, animated: true, completion: nil)
    }
    
    
    // MARK: UIImagePickerControllerDelegate Methods
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagePickerView.contentMode = .scaleAspectFit
            imagePickerView.image = pickedImage
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
        topToolBar.isHidden = true
        buttomToolBar.isHidden = true
        
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawHierarchy(in: view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        topToolBar.isHidden = false
        buttomToolBar.isHidden = false
        
        return memedImage
    }
    
    func save() -> UIImage {
        let meme = Meme(textTop: topTextField.text!, textBottom: buttomTextField.text!, imageOriginal: imagePickerView.image!, imageMemed: generateMemedImage())
        return meme.imageMemed
    }
    
}
