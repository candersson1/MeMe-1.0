//
//  TextFieldExtension.swift
//  image_picker_module
//
//  Created by Chris Andersson on 2018-11-27.
//  Copyright © 2018 klarsolutions. All rights reserved.
//

import Foundation
import UIKit

extension MemeEditorViewController: UITextFieldDelegate {
    
    func setTextField(_ textField: UITextField, text: String) {
        
        let memeTextAttributes: [NSAttributedString.Key: Any] = [
            .strokeColor: UIColor.black,
            .foregroundColor: UIColor.white,
            .font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            .strokeWidth: -4.0
        ]
        
        textField.text = text
        textField.delegate = self
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .center
        
    }
}
