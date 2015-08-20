//
//  ImagePicker.swift
//  UatsApp
//
//  Created by Paul Paul on 20/08/15.
//  Copyright (c) 2015 Paul Paul. All rights reserved.
//

import UIKit

class ImagePicker: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameTxt: UITextField!

    
    var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageView.layer.cornerRadius = self.imageView.frame.size.height/2
        self.imageView.clipsToBounds = true
        self.imageView.layer.borderWidth = 3.0
        var color:UIColor = UIColor.whiteColor()
        self.imageView.layer.borderColor = color.CGColor
        self.nameTxt.text = myUserName
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func imageTapped(sender: AnyObject) {

        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary){
            println("Choosing IMAGE")
            
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            imagePicker.allowsEditing = false
            
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
    }
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
    
        })
        imageView.image = image
    }
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
