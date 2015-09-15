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
        let color:UIColor = UIColor.whiteColor()
        self.imageView.layer.borderColor = color.CGColor
        self.nameTxt.text = myUserName
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let fileManager = NSFileManager.defaultManager()
        if fileManager.fileExistsAtPath(userAvatar){
            print("FILE AVAILABLE AT viewWillAppear")
            let image = loadImageFromPath(imagePath)
            imageView.image = image
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func imageTapped(sender: AnyObject) {
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary){
            print("Choosing IMAGE")
            
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            imagePicker.allowsEditing = false
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
    }
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            
        })
        
        saveImage(image, path: imagePath)
        try! KeyChain.updateData(["userImage": "\(imagePath)"], forUserAccount: "profileIMG")
        
        
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

func saveImage (image: UIImage, path: String ) -> Bool{
    //let pngImageData = UIImagePNGRepresentation(image)       // if you want to save as PNG
    let jpgImageData = UIImageJPEGRepresentation(image, 1.0)   // if you want to save as JPEG
    let result = jpgImageData!.writeToFile(path, atomically: true)
    return result
}

func documentsDirectory() -> String {
    let documentsFolderPath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0] 
    return documentsFolderPath
}
// Get path for a file in the directory

func fileInDocumentsDirectory(filename: String) -> String {
    let documentsURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
    let fileURL = documentsURL.URLByAppendingPathComponent("\(filename)")
    let path = fileURL.path!
    print(path)
    return path
}

// Define the specific path, image name

let imagePath = fileInDocumentsDirectory("Save.png")

func loadImageFromPath(path: String) -> UIImage? {
    
    let image = UIImage(contentsOfFile: path)
    
    if image == nil {
        
        print("missing image at: \(path)")
    }
    //println("\(path)") // this is just for you to see the path in case you want to go to the directory, using Finder.
    return image
}