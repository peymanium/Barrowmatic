//
//  ItemViewController.swift
//  Barrowmatic
//
//  Created by Peyman Attarzadeh on 6/10/16.
//  Copyright © 2016 PeymaniuM. All rights reserved.
//

import UIKit

class ItemViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, TimeFrameViewControllerDelegate {

    @IBOutlet weak var TXT_Title: UITextField!
    @IBOutlet weak var IMG_Item: UIImageView!
    @IBOutlet weak var LBL_BarrowAt: UILabel!
    @IBOutlet weak var LBL_ReturnAt: UILabel!
    @IBOutlet weak var BTN_Timeframe: UIButton!
    @IBOutlet weak var IMG_Person: UIImageView!
    @IBOutlet weak var TXT_Person: UITextField!
    
    var detailItem: BarrowItem?
    var managedObjectContext = CoreDataHelper.instance.ManagedObjectContext()
    
    //Image
    var itemImageSelected : Bool = false
    var personImageSelected:Bool = false
    
    var imageTypeSelector : ImageType = .item
    enum ImageType : String {
        case item
        case person
    }
    
    //Date Range
    var startDate : NSDate?
    var endDate : NSDate?
    
    
    func configureView()
    {
        if let detail = detailItem
        {
            if let title = detail.title
            {
                self.TXT_Title.text = title
            }
            
            if let itemImageData = detail.image
            {
                self.IMG_Item.image = UIImage(data: itemImageData)
            }
            
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            if let startDate = detail.startDate
            {
                self.LBL_BarrowAt.text = "Barrowed at \(dateFormatter.stringFromDate(startDate))"
            }
            
            if let endDate = detail.endDate
            {
                self.LBL_ReturnAt.text = "Return at \(dateFormatter.stringFromDate(endDate))"
            }
            
            
            if let person = detail.person as? Person
            {
                self.TXT_Person.text = person.name
                
                if let personImageData = person.image
                {
                    self.IMG_Person.image = UIImage(data: personImageData)
                }
            }
        }
    }

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        
        //Inside a table view we have to create the TapGesture from the code-behind
        let itemTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.IMG_Item_Tapped))
        let personTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.IMG_Person_Tapped))
        self.IMG_Item.addGestureRecognizer(itemTapGesture)
        self.IMG_Person.addGestureRecognizer(personTapGesture)
        
        
        self.configureView()
    }


    @IBAction func BTN_Save_Tapped (sender: UIBarButtonItem)
    {
        if detailItem == nil //INSERT
        {
            let newItem = CoreDataHelper.instance.InsertManagedObject(NSStringFromClass(BarrowItem), managedObjectContext: self.managedObjectContext) as! BarrowItem
            
            newItem.title = self.TXT_Title.text
            
            //Image for Item
            if let itemImage = self.IMG_Item.image
            {
                newItem.image = UIImageJPEGRepresentation(itemImage, 0.3)
            }
            
            //Date Range
            newItem.startDate = self.startDate
            newItem.endDate = self.endDate
            
            
            //PERSON
            let fetchRequest = NSFetchRequest(entityName: NSStringFromClass(Person))
            fetchRequest.fetchLimit = 1
            if let name = self.TXT_Person.text
            {
                fetchRequest.predicate = NSPredicate(format: "name == %@", name)
            }
            var error : NSError? = nil
            let count = self.managedObjectContext.countForFetchRequest(fetchRequest, error: &error)
            if error == nil
            {
                if count == 0 //New Person
                {
                    let newPerson = CoreDataHelper.instance.InsertManagedObject(NSStringFromClass(Person), managedObjectContext: self.managedObjectContext) as! Person
                    
                    newPerson.name = self.TXT_Person.text
                    
                    if let personImage = self.IMG_Person.image
                    {
                        newPerson.image = UIImageJPEGRepresentation(personImage, 0.3)
                    }
                    
                    newPerson.addBarrowItemObject(newItem)
                }
                else //Update Person
                {
                    var persons = [Person]()
                    do
                    {
                        persons = try self.managedObjectContext.executeFetchRequest(fetchRequest) as![Person]
                    }
                    catch let error as NSError
                    {
                        print (error.debugDescription)
                    }
                    
                    //Fetch first person
                    if let personFound = persons.first
                    {
                        personFound.addBarrowItemObject(newItem)
                    }
                }
                
            }
            else
            {
                print (error.debugDescription)
            }
            
            
        }
        else //UPDATE
        {
            
        }
        
        
        CoreDataHelper.instance.SaveManagedObjectContext(self.managedObjectContext)
        
    }
    
    //IMAGE Functions
    func IMG_Item_Tapped ()
    {
        self.imageTypeSelector = .item
        self.AddImage()
        
    }
    func IMG_Person_Tapped ()
    {
        self.imageTypeSelector = .person
        self.AddImage()
    }
    func AddImage()
    {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .PhotoLibrary
        
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }

    
    
    //ImagePickerDelegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        if let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
            let scaledImage = Helper.instance.ScaleImage(selectedImage, width: 120, height: 120)
            
            if self.imageTypeSelector == .item
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
    func imagePickerControllerDidCancel(picker: UIImagePickerController)
    {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }

    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == "SEGUE_DATERANGE"
        {
            let timeFrameViewController = segue.destinationViewController as? TimeframeViewController
            timeFrameViewController?.delegate = self
            
        }
    }
    //TimeFrameViewController delegate function
    func didSelectTimeFrame(dateRange: GLCalendarDateRange)
    {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        self.LBL_BarrowAt.text = "Borrowed at \(dateFormatter.stringFromDate(dateRange.beginDate))"
        self.LBL_ReturnAt.text = "Return at \(dateFormatter.stringFromDate(dateRange.endDate))"
        
        self.startDate = dateRange.beginDate
        self.endDate = dateRange.endDate
    }
    
    
}

