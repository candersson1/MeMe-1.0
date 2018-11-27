//
//  ViewController.swift
//  image_picker_module
//
//  Created by Chris Andersson on 2018-11-17.
//  Copyright © 2018 klarsolutions. All rights reserved.
//

import UIKit

    // Mark: Dismisses keyboard when user clicks outside text field.
    class MemeEditorViewController: UIViewController, UINavigationControllerDelegate {
 
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
    @IBOutlet weak var shareButton :UIBarButtonItem!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
    //Mark: Set some defaults and delegates.
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        shareButton.isEnabled = false
        setTextField( topTextField, text: "Top")
        setTextField( bottomTextField, text: "Bottom")
       
    }
   
    //Mark: Picking the image.
    @IBAction func pickImageFromAlbum(_ sender: Any) {
        presentPickerViewController(source: .photoLibrary)
    }
    
    @IBAction func pickImageFromCamera(_ sender: Any) {
        presentPickerViewController(source: .camera)
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
    
    
  
    //Mark: Moving view up.
    @objc func keyboardWillShow(_ notification:Notification) {
        if bottomTextField.isEditing {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    //Mark: Moving view back down.
    @objc func keyboardWillHide(_ notification:Notification) {
        view.frame.origin.y = 0
    }
        
        func hideToolbars(_ hide: Bool) {
            menuBar.isHidden = hide
            navBar.isHidden = hide
        }
        
        func save() {
            let memedImage = generateMemedImage()
            
            UIImageWriteToSavedPhotosAlbum(memedImage, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
            print("saving")
            
        }
        
        func generateMemedImage() -> UIImage {
            hideToolbars(true)
            // Render view to an image
            UIGraphicsBeginImageContext(self.view.frame.size)
            view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
            let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            
            hideToolbars(false)
            
            return memedImage
            
        }

        func showAlert(title: String, message: String){
            let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
        
        @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
            if let error = error {
                // we got back an error!
                showAlert(title: "Save Error", message: error.localizedDescription )
            } else {
                showAlert(title: "Saved!", message: "Your meme has been saved to your photos." )
            }
        }
        
}


