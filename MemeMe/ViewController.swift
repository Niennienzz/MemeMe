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
    
    // MARK: UIViewController Helpers
    
    func initTextFields() {
        let memeTextAttributes:[String:Any] = [
            NSStrokeColorAttributeName: UIColor.black,
            NSForegroundColorAttributeName: UIColor.white,
            NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName: -2.0,
        ]

        configTextFiels(topTextField, "TOP", memeTextAttributes)
        configTextFiels(buttomTextField, "BUTTOM", memeTextAttributes)
    }
    
    func configTextFiels(_ textField: UITextField, _ text: String, _ defaultAttributes: [String:Any]) {
        textField.delegate = textFieldDelegate
        textField.defaultTextAttributes = defaultAttributes
        textField.text = text
        textField.textAlignment = .center
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
        let image = generateMemedImage()
        let controller = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        controller.completionWithItemsHandler = {
            (_, successful, _, _) in
            if successful {
                self.save()
                self.dismiss(animated: true, completion: nil)
            }
        }
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
        configBars(hidden: true)
        
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawHierarchy(in: view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        configBars(hidden: false)
        
        return memedImage
    }
    
    func configBars(hidden: Bool) {
        topToolBar.isHidden = hidden
        buttomToolBar.isHidden = hidden
    }
    
    func save() {
        let meme = Meme(
            textTop: topTextField.text!,
            textBottom: buttomTextField.text!,
            imageOriginal: imagePickerView.image!,
            imageMemed: generateMemedImage()
        )
        
        (UIApplication.shared.delegate as! AppDelegate).memes.append(meme)
    }
    
}
