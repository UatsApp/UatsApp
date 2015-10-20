//
//  TextInputTableViewCell.swift
//  UatsApp
//
//  Created by Student on 17/10/15.
//  Copyright © 2015 Paul Paul. All rights reserved.
//

import Foundation
import UIKit

public class TextInputTableViewCell: UITableViewCell, UITextFieldDelegate {

   
    
    @IBOutlet weak var emailTextField: UITextField!
    
    public func configure(text: String?, placeholder: String) {
        emailTextField.text = text
        emailTextField.placeholder = placeholder
        
        emailTextField.accessibilityValue = text
        emailTextField.accessibilityLabel = placeholder
    }
}