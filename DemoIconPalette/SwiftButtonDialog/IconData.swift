//
//  IconData.swift
//  TestUIView
//
//  Created by Steve Lu on 10/8/16.
//  Copyright © 2016 justme. All rights reserved.
//

import Foundation
import UIKit


@objc public class IconData : NSObject {
    let height, width: Float
    var view: UIView?
    let callBack:() -> Int
    
    
    init(h: Float, w: Float, view: UIView?, action:@escaping () -> Int) {
        height = h
        width = w
        if view != nil {
            self.view = view!
        }
        callBack = action
    }
}
