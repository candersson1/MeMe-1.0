//
//  imageHandlerExtension.swift
//  image_picker_module
//
//  Created by Chris Andersson on 2018-11-27.
//  Copyright © 2018 klarsolutions. All rights reserved.
//

import Foundation
import UIKit

extension MemeEditorViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // All `UIImagePickerControllerDelegate` methods here
    func pickImageFromAlbum(_ sender: Any) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
    }
    
}
