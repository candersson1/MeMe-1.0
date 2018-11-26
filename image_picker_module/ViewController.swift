//
//  ViewController.swift
//  image_picker_module
//
//  Created by Chris Andersson on 2018-11-17.
//  Copyright © 2018 klarsolutions. All rights reserved.
//

import UIKit

    // Mark: Dismisses keyboard when user clicks outside text field.
    class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
 
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    
    //Mark: Connect to layout objects.
    @IBOutlet weak var menuBar: UIToolbar!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButton :UIButton!
    @IBOutlet weak var topTextField :UITextField!
    @IBOutlet weak var bottomTextField :UITextField!
    @IBOutlet weak var shareButton :UIButton!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
       shareButton.isEnabled = false
        
    //Mark: Set some defaults and delegates.
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        topTextField.text = "Top"
        bottomTextField.text = "Bottom"
        topTextField.delegate = self
        bottomTextField.delegate = self
        
        let memeTextAttributes:[NSAttributedString.Key: Any] = [
            NSAttributedString.Key(rawValue: NSAttributedString.Key.strokeColor.rawValue): UIColor.black,
            NSAttributedString.Key(rawValue: NSAttributedString.Key.foregroundColor.rawValue): UIColor.white,
            NSAttributedString.Key(rawValue: NSAttributedString.Key.font.rawValue): UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSAttributedString.Key(rawValue: NSAttributedString.Key.strokeWidth.rawValue): -4.0]
        
        bottomTextField.defaultTextAttributes = memeTextAttributes
        topTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.textAlignment = .center
        topTextField.textAlignment = .center
       
    }

    //Mark: Picking the image.
    @IBAction func pickImageFromAlbum(_ sender: Any) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @IBAction func pickImageFromCamera(_ sender: Any) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .camera
        present(imagePickerController, animated: true, completion: nil)
    }
      
    @IBAction func cancel( sender: Any) {
            topTextField.text = "Top"
            bottomTextField.text = "Bottom"
            imageView.image = nil
            shareButton.isEnabled = false
        }
        
    @IBAction func share(_ sender: Any){
        //generate a memed image
        let memedImage = generateMemedImage()
        let imageToShare = [ memedImage ]
        //define an instance of the ActivityViewController
        let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil )
        //pass the ActivityViewController a memed image as an activity item
        activityViewController.popoverPresentationController?.sourceView = self.view
        //present the ActivityViewController
        self.present(activityViewController, animated: true, completion:nil)
        //save the image if it was shared
        activityViewController.completionWithItemsHandler = {(activityType: UIActivity.ActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) in
            if !completed {
                // User canceled
                return
            }
            self.save()
        }
        
        }
 
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[.originalImage] as? UIImage
            else {
            return
        }
        imageView.image = image
        shareButton.isEnabled = true
        
    }
    func
        imagePickerControllerDidCancel(_ picker: UIImagePickerController){
     print("cancelled")
        dismiss(animated: true, completion: nil)
    }
 
    
    //Mark: Clearing the text fields when edit begins.
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
    
    //Mark: Moving the view up when the keyboard appears
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
        subscribeToKeyboardHideNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
        unsubscribeFromKeyboardHideNotifications()
    }
    
    
    //Mark: Keyboard will show subscriptions
    func subscribeToKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    //Mark: Keyboard will hide subscriptions
    func subscribeToKeyboardHideNotifications() {
        print("subscribing to keyboard hide")
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardHideNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    //Mark: Getting the keyboard height.
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
   
    //Mark: Moving view up.
    @objc func keyboardWillShow(_ notification:Notification) {
        if bottomTextField.isEditing {
        print("keyboard is showing")
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    //Mark: Moving view back down.
    @objc func keyboardWillHide(_ notification:Notification) {
        print("keyboard is hiding")
        view.frame.origin.y = 0
    }
   
   func generateMemedImage() -> UIImage {
            menuBar.isHidden = true
            navBar.isHidden = true
            // Render view to an image
            UIGraphicsBeginImageContext(self.view.frame.size)
            view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
            let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            menuBar.isHidden = false
            navBar.isHidden = false
            return memedImage
    }
       
    
        
    struct Meme {
        let topText: String
        let bottomText: String
        let originalImage: UIImage
        let memedImage: UIImage
        }
        
        func save() {
            let memedImage = generateMemedImage()
            
            UIImageWriteToSavedPhotosAlbum(memedImage, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
            print("saving")
            
            
           
        }
        
        @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
            if let error = error {
                // we got back an error!
                let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default))
                present(ac, animated: true)
            } else {
                let ac = UIAlertController(title: "Saved!", message: "Your meme has been saved to your photos.", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default))
                present(ac, animated: true)
            }
        }
        
}


