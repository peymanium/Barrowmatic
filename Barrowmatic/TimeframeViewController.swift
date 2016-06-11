//
//  TimeframeViewController.swift
//  Barrowmatic
//
//  Created by Peyman Attarzadeh on 6/11/16.
//  Copyright © 2016 PeymaniuM. All rights reserved.
//

import UIKit

protocol TimeFrameViewControllerDelegate
{
    func didSelectTimeFrame(dateRange : GLCalendarDateRange)
}

class TimeframeViewController: UIViewController, GLCalendarViewDelegate {

    
    @IBOutlet weak var calendarView: GLCalendarView!
    
    var delegate : TimeFrameViewControllerDelegate? = nil //Delegate variable
    var dateRange : GLCalendarDateRange? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.calendarView.delegate = self

        GLCalendarView.appearance().rowHeight = 54
        GLCalendarView.appearance().padding = 6
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let today = NSDate()
        let beginDate = GLDateUtils.dateByAddingDays(0, toDate: today)
        let endDate = GLDateUtils.dateByAddingDays(7, toDate: today)
        
        let range = GLCalendarDateRange(beginDate: beginDate, endDate: endDate)
        range.backgroundColor = UIColor.lightGrayColor()
        range.editable = true
        
        self.calendarView.ranges = [range]
        
        self.calendarView.reload()
        
        dispatch_async(dispatch_get_main_queue()) { 
            self.calendarView.scrollToDate(self.calendarView.lastDate, animated: false)
        }
        
        
    }
    
    
    
    @IBAction func BTN_Done_Tapped (sender : UIButton)
    {
        
        if let dateRangeSelected = self.dateRange
        {
            if let delegate = self.delegate
            {
                delegate.didSelectTimeFrame(dateRangeSelected)
            }
        }
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    
    
    //GLCalendarView delegates
    func calenderView(calendarView: GLCalendarView!, canAddRangeWithBeginDate beginDate: NSDate!) -> Bool
    {
        return true
    }
    func calenderView(calendarView: GLCalendarView!, canUpdateRange range: GLCalendarDateRange!, toBeginDate beginDate: NSDate!, endDate: NSDate!) -> Bool
    {
        return true
    }
    func calenderView(calendarView: GLCalendarView!, rangeToAddWithBeginDate beginDate: NSDate!) -> GLCalendarDateRange! {
        
        let endDate = GLDateUtils.dateByAddingDays(0, toDate: beginDate)
        
        let range = GLCalendarDateRange(beginDate: beginDate, endDate: endDate)
        range.backgroundColor = UIColor.lightGrayColor()
        range.editable = true
        
        return range
        
    }
    func calenderView(calendarView: GLCalendarView!, beginToEditRange range: GLCalendarDateRange!) {
        
    }
    func calenderView(calendarView: GLCalendarView!, finishEditRange range: GLCalendarDateRange!, continueEditing: Bool) {
        
    }
    func calenderView(calendarView: GLCalendarView!, didUpdateRange range: GLCalendarDateRange!, toBeginDate beginDate: NSDate!, endDate: NSDate!) {
        
        self.dateRange = range
        
    }
    
}
