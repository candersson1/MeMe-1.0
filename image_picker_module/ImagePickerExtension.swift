//
//  imagePickerExtension.swift
//  image_picker_module
//
//  Created by Chris Andersson on 2018-11-27.
//  Copyright © 2018 klarsolutions. All rights reserved.
//

import Foundation
import Foundation
import UIKit

extension MemeEditorViewController: UIImagePickerControllerDelegate  {

    func presentPickerViewController(source: UIImagePickerController.SourceType) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = source
        present(imagePickerController, animated: true, completion: nil)
    }
    
    
}
