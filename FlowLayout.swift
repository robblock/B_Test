//
//  FlowLayout.swift
//  beacons_test
//
//  Created by Rob Block on 12/11/15.
//  Copyright © 2015 robblock. All rights reserved.
//
import UIKit

class FlowLayout: UICollectionViewFlowLayout {
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var attributesForElementsInRect = super.layoutAttributesForElementsInRect(rect)
        var newAttributesForElementsInRect = [UICollectionViewLayoutAttributes]()
        
        var leftMargin: CGFloat = 0.0
        
        for attributes in attributesForElementsInRect! {
            var refAttributes = attributes 
            if (refAttributes.frame.origin.x == self.sectionInset.left) {
                leftMargin = self.sectionInset.left
            } else {
                var newLeftAlignedFrame = refAttributes.frame
                newLeftAlignedFrame.origin.x = leftMargin
                refAttributes.frame = newLeftAlignedFrame
            }
            
            leftMargin += refAttributes.frame.size.width + 8
            newAttributesForElementsInRect.append(refAttributes)
        }
        
        return newAttributesForElementsInRect
    }
    
    
}