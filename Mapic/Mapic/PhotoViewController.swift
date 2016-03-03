//
//  PhotoViewController.swift
//  Mapic
//
//  Created by Suyeon Kang on 3/1/16.
//  Copyright © 2016 Suyeon Kang. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    var cameraUI:UIImagePickerController = UIImagePickerController()

    @IBOutlet weak var captionField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBAction func useCamera(sender: AnyObject) {
        self.presentCamera()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        captionField.delegate = self
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)

    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func presentCamera()
    {
        cameraUI = UIImagePickerController()
        cameraUI.delegate = self
        cameraUI.sourceType = UIImagePickerControllerSourceType.Camera
        cameraUI.allowsEditing = false
        
        self.presentViewController(cameraUI, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker:UIImagePickerController)
    {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [String : AnyObject]) {
            print("didFinishPickingMediaWithInfo")
            let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
     
            picker.dismissViewControllerAnimated(true, completion: nil)
            imageView.image = ResizeImage(originalImage, targetSize: CGSizeMake(200.0, 200.0))
            //let post:Post = Post()
         
    }
    
    func ResizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSizeMake(size.width * heightRatio, size.height * heightRatio)
        } else {
            newSize = CGSizeMake(size.width * widthRatio,  size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRectMake(0, 0, newSize.width, newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.drawInRect(rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }

    @IBAction func saveClicked(sender: AnyObject) {
        if let img = self.imageView.image {
        //let img = imageView.image
        let caption = captionField.text
        Post.postUserImage(img, withCaption: caption) { (success: Bool, error: NSError?) -> Void in
            if(success){
                print("photo saved")
                let alertController = UIAlertController(title: "Save Result", message: "Save Successful", preferredStyle: .Alert)
                // create an OK action
                let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
                    // handle response here.
                }
                // add the OK action to the alert controller
                alertController.addAction(OKAction)

            } else {
                print("photo not saved")
                print(error?.localizedDescription)
                let alertController =  UIAlertController(title: "Save Result", message: "Save Unsuccessful! Please Try Again!", preferredStyle: .Alert)
                // create an OK action
                let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
                    // handle response here.
                }
                // add the OK action to the alert controller
                alertController.addAction(OKAction)
            }
        }
        }
    }
    @IBAction func getPhotos(sender: AnyObject) {
        self.getPictures()
    }
    func getPictures(){
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
        vc.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
        self.presentViewController(vc, animated: true, completion: nil)
    }
}
