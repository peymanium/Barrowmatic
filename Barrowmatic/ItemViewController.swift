//
//  ItemViewController.swift
//  Barrowmatic
//
//  Created by Peyman Attarzadeh on 6/10/16.
//  Copyright © 2016 PeymaniuM. All rights reserved.
//

import UIKit

class ItemViewController: UITableViewController {

    @IBOutlet weak var TXT_Title: UITextField!
    @IBOutlet weak var IMG_Item: UIImageView!
    @IBOutlet weak var LBL_BarrowAt: UILabel!
    @IBOutlet weak var LBL_ReturnAt: UILabel!
    @IBOutlet weak var BTN_Timeframe: UIButton!
    @IBOutlet weak var IMG_Person: UIImageView!
    @IBOutlet weak var TXT_Person: UITextField!
    
    var detailItem: BarrowItem?
    var managedObjectContext = CoreDataHelper.ManagedObjectContext()

    
    func configureView() {
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
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

    
}

