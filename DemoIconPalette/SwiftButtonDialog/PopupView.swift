//
//  PopupView.swift
//  TestUIView
//
//  Created by Steve Lu on 9/18/16.
//  Copyright © 2016 justme. All rights reserved.
//

import Foundation
import UIKit

@objc public class PopupView : UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.blue
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
