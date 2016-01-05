//
//  TagCell.swift
//  beacons_test
//
//  Created by Rob Block on 12/10/15.
//  Copyright © 2015 robblock. All rights reserved.
//

import Foundation
import UIKit

struct Tags {
    var isSelected: Bool
    var isLocked: Bool
    var textContent: String
}

let colorUnselectedTag = UIColor.whiteColor()
let colorSelectedTag = UIColor(red:0.22, green:0.7, blue:0.99, alpha:1)

let colorTextUnSelectedTag = UIColor(red:0.33, green:0.33, blue:0.35, alpha:1)
let colorTextSelectedTag = UIColor.whiteColor()


@IBDesignable
class TagCell: UICollectionViewCell {
    
    @IBOutlet weak var tagName: UILabel!
    @IBOutlet weak var tagNameMaxWidthConstraint: NSLayoutConstraint!

    var setSelected: Bool = false
    
    lazy var textContent: UILabel! = {
        let textContent = UILabel(frame: CGRectZero)
        textContent.layer.masksToBounds = true
        textContent.layer.cornerRadius = 20
        textContent.layer.borderWidth = 2
        textContent.layer.borderColor = UIColor(red:0.88, green:0.88, blue:0.88, alpha:1).CGColor
        textContent.font = UIFont.boldSystemFontOfSize(17)
        textContent.textAlignment = NSTextAlignment.Center
        return textContent
    }()
    
    func initContent(tag: Tags) {
        self.contentView.addSubview(textContent)
        textContent.text = tag.textContent
        textContent.sizeToFit()
        textContent.frame.size.width = textContent.frame.size.width + 30
        textContent.frame.size.height = textContent.frame.size.height + 20
        selected = tag.isSelected
        textContent.backgroundColor = UIColor.clearColor()
        self.textContent.layer.backgroundColor = (self.selected == true) ? colorSelectedTag.CGColor : colorUnselectedTag.CGColor
        self.textContent.textColor = (self.selected == true) ? colorTextSelectedTag : colorTextUnSelectedTag
    }
    
    func initAddButtonContent() {
        self.contentView.addSubview(textContent)
        textContent.text = "+"
        textContent.sizeToFit()
        textContent.frame.size = CGSizeMake(40, 40)
        textContent.backgroundColor = UIColor.clearColor()
        self.textContent.layer.backgroundColor = UIColor.grayColor().CGColor
        self.textContent.textColor = UIColor.whiteColor()
    }
    
    func animateSelection(selection: Bool) {
        selected = selection
        
        self.textContent.frame.size = CGSizeMake(self.textContent.frame.size.width - 20, self.textContent.frame.size.height - 20)
        self.textContent.frame.origin = CGPointMake(self.textContent.frame.origin.x + 10, self.textContent.frame.origin.y + 10)
        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.4, options: UIViewAnimationOptions(), animations: { () -> Void in
            self.textContent.layer.backgroundColor = (self.selected == true) ? colorSelectedTag.CGColor : colorUnselectedTag.CGColor
            self.textContent.textColor = (self.selected == true) ? colorTextSelectedTag : colorTextUnSelectedTag
            self.textContent.frame.size = CGSizeMake(self.textContent.frame.size.width + 20, self.textContent.frame.size.height + 20)
            self.textContent.center = CGPointMake(self.contentView.frame.size.width / 2, self.contentView.frame.size.height / 2)
            }, completion: nil)
    }
    
    class func contentHeight(content: String) -> CGSize {
        let styleText = NSMutableParagraphStyle()
        styleText.alignment = NSTextAlignment.Center
        let attributs = [NSParagraphStyleAttributeName:styleText, NSFontAttributeName:UIFont.boldSystemFontOfSize(17)]
        let sizeBoundsContent = (content as NSString).boundingRectWithSize(CGSizeMake(UIScreen.mainScreen().bounds.size.width,
            UIScreen.mainScreen().bounds.size.height), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: attributs, context: nil)
        return CGSizeMake(sizeBoundsContent.width + 30, sizeBoundsContent.height + 20)
    }
}

