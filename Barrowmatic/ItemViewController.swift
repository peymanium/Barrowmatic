//
//  ItemViewController.swift
//  Barrowmatic
//
//  Created by Peyman Attarzadeh on 6/10/16.
//  Copyright © 2016 PeymaniuM. All rights reserved.
//

import UIKit

class ItemViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var TXT_Title: UITextField!
    @IBOutlet weak var IMG_Item: UIImageView!
    @IBOutlet weak var LBL_BarrowAt: UILabel!
    @IBOutlet weak var LBL_ReturnAt: UILabel!
    @IBOutlet weak var BTN_Timeframe: UIButton!
    @IBOutlet weak var IMG_Person: UIImageView!
    @IBOutlet weak var TXT_Person: UITextField!
    
    var detailItem: BarrowItem?
    var managedObjectContext = CoreDataHelper.ManagedObjectContext()
    
    var itemImageSelected : Bool = false
    var personImageSelected:Bool = false
    enum ImageType : String {
        case item
        case person
    }
    var pictureTypeSelector : ImageType = .item
    
    
    
    
    func configureView()
    {
        if let detail = detailItem
        {
            if let title = detail.title
            {
                self.TXT_Title.text = title
            }
        }
    }

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        
        //Inside a table view we have to create the TapGesture from the code-behind
        let itemTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.AddImageForItem))
        let personTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.AddImageForPerson))
        self.IMG_Item.addGestureRecognizer(itemTapGesture)
        self.IMG_Person.addGestureRecognizer(personTapGesture)
        
        self.configureView()
    }


    @IBAction func BTN_Save_Tapped (sender: UIBarButtonItem)
    {
        if detailItem == nil
        {
            //INSERT
            let newItem = CoreDataHelper.InsertManagedObject(NSStringFromClass(BarrowItem), managedObjectContext: self.managedObjectContext) as! BarrowItem
            
            newItem.title = self.TXT_Title.text
            
        }
        else
        {
            //UPDATE
        }
        
        CoreDataHelper.SaveManagedObjectContext(self.managedObjectContext)
        
    }
    
    func AddImageForItem ()
    {
        self.pictureTypeSelector = .item
        self.AddImage()
        
    }
    func AddImageForPerson ()
    {
        self.pictureTypeSelector = .person
        self.AddImage()
    }
    func AddImage()
    {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .PhotoLibrary
        
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    func ScaleImageToSize(image:UIImage, toSize:CGSize) -> UIImage
    {
        UIGraphicsBeginImageContextWithOptions(toSize, false, UIScreen.mainScreen().scale)
        
        image.drawInRect(CGRectMake(0, 0, toSize.width, toSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return newImage
        
    }
    func ScaleImage(image : UIImage, width:CGFloat, height: CGFloat) -> UIImage
    {
        let oldWidth = image.size.width
        let oldHeight = image.size.height
        
        let scaleFactor = (oldWidth > oldHeight) ? width / oldWidth : height / oldHeight
        
        let newWidth = oldWidth * scaleFactor
        let newHeight = oldHeight * scaleFactor
        
        let scaledImage = self.ScaleImageToSize(image, toSize: CGSizeMake(newWidth, newHeight))
        
        return scaledImage
    }
    
    
    //ImagePickerDelegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
            let scaledImage = self.ScaleImage(selectedImage, width: 120, height: 120)
            
            if self.pictureTypeSelector == .item
            {
                self.IMG_Item.image = scaledImage
                self.itemImageSelected = true
                self.personImageSelected = false
            }
            else
            {
                self.IMG_Person.image = scaledImage
                self.itemImageSelected = false
                self.personImageSelected = true
            }
         
            picker.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }

    
}

