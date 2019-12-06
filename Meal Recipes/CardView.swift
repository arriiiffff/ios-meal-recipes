//
//  CardView.swift
//  Meal Recipes
//
//  Created by Amin faruq on 03/12/19.
//  Copyright © 2019 Amin faruq. All rights reserved.
//

import Foundation
import UIKit

public class CardView: UIView {
    @IBInspectable public var cornerRadius: CGFloat = 1 //default
       @IBInspectable var shadow: CGFloat = 1 //default
       @IBInspectable var shadowRadius: CGFloat = 2.0
       @IBInspectable var borderWidth: CGFloat = 0.0
    
       
       override public func layoutSubviews() {
           self.layer.cornerRadius = cornerRadius
           let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
           layer.masksToBounds = false
           layer.shadowColor = UIColor.gray.cgColor
           layer.shadowOffset = CGSize(width: 0, height: shadow)
           layer.shadowOpacity = 0.4
           layer.shadowRadius = shadowRadius
           layer.shadowPath = shadowPath.cgPath
           layer.borderWidth = borderWidth
       }
       
       required public init(coder aDecoder: NSCoder) {
           super.init(coder: aDecoder)!
       }
       
       public func reload() {
           setNeedsDisplay()
           layer.displayIfNeeded()
       }
       
       public func setRadius(radius : CGFloat) {
           self.cornerRadius = radius
           self.layer.cornerRadius = radius
           self.layoutSubviews()
       }
       
       public func setRounded() {
           self.cornerRadius = self.frame.height/2
           self.layer.cornerRadius = cornerRadius
           self.layoutSubviews()
       }
}
