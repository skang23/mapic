//
//  CameraViewController.swift
//  Mapic
//
//  Created by Suyeon Kang on 3/1/16.
//  Copyright © 2016 Suyeon Kang. All rights reserved.
//

import UIKit
import Parse
import MBProgressHUD

class CameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var photos:[PFObject]?
    
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        collectionView.dataSource = self
        self.getPhotos()
        //print(photos?.debugDescription)
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let photos=photos {
            return photos.count;
        }else{
            return 0;
        }
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell=collectionView.dequeueReusableCellWithReuseIdentifier("CollectionCell", forIndexPath: indexPath) as! CollectionViewCell
      let photo=photos![indexPath.row]
        /*
        if let userPicture = image.valueForKey("media") as? PFFile {
            userPicture.getDataInBackgroundWithBlock({
                (imageData: NSData!, error: NSError!) -> Void in
                if (error == nil) {
                    let img = UIImage(data:imageData)
                    cell.posterView.image = img
                }
            })
        }
        */
        let userImageFile = photo["media"] as! PFFile
        userImageFile.getDataInBackgroundWithBlock { (imageData: NSData?, error: NSError?) -> Void in
            if error == nil {
                let image = UIImage(data:imageData!)
                cell.posterView.image = image
        
                cell.captionLabel.text = photo["caption"] as! String
                print("successful")
            } else {
                print(error.debugDescription)
            }
        }/*
        userImageFile.getDataInBackgroundWithBlock({
            (imageData: NSData!, error: NSError!) -> Void in
            if error != nil {
                let image = UIImage(data:imageData)
            }
        })
        */
        return cell
        
    }

    @IBAction func refreshClicked(sender: AnyObject) {
        getPhotos()
        collectionView.reloadData()
    }
    
    
    func getPhotos() {
         MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        let query = PFQuery(className: "Post")
        query.orderByDescending("_created_at")
       // query.includeKey("media")
        query.limit = 20
        query.whereKey("author", equalTo: PFUser.currentUser()!)
     
        // fetch data asynchronously
        query.findObjectsInBackgroundWithBlock { (media: [PFObject]?, error: NSError?) -> Void in
            if let media = media {
                self.photos = media
                print(media.debugDescription)
                self.collectionView.reloadData()
                // do something with the data fetched
            } else {
                // handle error
                 print(error?.localizedDescription)
                
            }
            MBProgressHUD.hideHUDForView(self.view, animated: true)

        }
    }
}
