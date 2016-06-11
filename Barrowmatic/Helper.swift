//
//  Helper.swift
//  Barrowmatic
//
//  Created by Peyman Attarzadeh on 6/10/16.
//  Copyright © 2016 PeymaniuM. All rights reserved.
//

import Foundation
import UIKit

class Helper
{
    static let instance = Helper()
    
    func ScaleImage(image : UIImage, width:CGFloat, height: CGFloat) -> UIImage
    {
        let oldWidth = image.size.width
        let oldHeight = image.size.height
        
        let scaleFactor = (oldWidth > oldHeight) ? width / oldWidth : height / oldHeight
        
        let newWidth = oldWidth * scaleFactor
        let newHeight = oldHeight * scaleFactor
        
        let scaledImage = self.CreateScaledImage(image, toSize: CGSizeMake(newWidth, newHeight))
        
        return scaledImage
    }
    private func CreateScaledImage(image:UIImage, toSize:CGSize) -> UIImage
    {
        UIGraphicsBeginImageContextWithOptions(toSize, false, UIScreen.mainScreen().scale)
        
        image.drawInRect(CGRectMake(0, 0, toSize.width, toSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return newImage
        
    }
    
}