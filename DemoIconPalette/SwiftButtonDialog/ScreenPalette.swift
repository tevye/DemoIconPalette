//
//  ScreenPalette.swift
//  Wibber
//
//  Created by Steve Lu on 2/18/17.
//  Copyright © 2017 Steve Lu. All rights reserved.
//

import Foundation
import UIKit

@objc open class ScreenPalette: NSObject, PaletteProviderProtocol {
    let wrapper:FontAwesomeWrapper = FontAwesomeWrapper()
    public var ctrlr: UIViewController?
    open var popCloser: PopupViewDismissalProtocol?
    var exchangeFunc: (() -> ())?
    var homeFunc: (() -> ())?
    
    init(controller: UIViewController, e: (() -> ())!, h: (() -> ())!) {
        super.init()
        ctrlr = controller
        exchangeFunc = e
        homeFunc = h
    }

    @objc func setCloser(_ closer: PopupViewDismissalProtocol!) {
        popCloser = closer
    }
    
    @objc func exchange() -> Int {
        if popCloser != nil {
            popCloser!.dismiss()
        }
        self.exchangeFunc!();
        return 0
    }
    
    @objc func home() -> Int {
        if popCloser != nil {
            popCloser!.dismiss()
        }
        self.homeFunc!();
        return 0
    }

    
    @objc public func getPalette() -> [IconData]! {
        NSLog("Providing screen palette...")
        var rv:[IconData] = [IconData]()
        let exchangeButton = UIButton()
        var buttonString: String = wrapper.symbolCode("fa-exchange")
        var buttonStringAttributed = NSMutableAttributedString(string: buttonString, attributes: [NSFontAttributeName:UIFont(name: "FontAwesome", size: 48)!])
        //		let buttonStringAttributed = NSMutableAttributedString(string: buttonString, attributes: [NSFontAttributeName:UIFont(name: "HelveticaNeue", size: 11.00)!])
        //		buttonStringAttributed.addAttribute(NSFontAttributeName, value: UIFont.iconFontOfSize("FontAwesome", fontSize: 50), range: NSRange(location: 0,length: 1))
        
        exchangeButton.titleLabel?.textAlignment = .center
        exchangeButton.titleLabel?.numberOfLines = 1
        exchangeButton.setAttributedTitle(buttonStringAttributed, for: UIControlState())
        exchangeButton.backgroundColor = UIColor.white
        exchangeButton.addTarget(self, action: #selector(self.exchange), for: .touchUpInside)
        let exb = IconData(h: 50, w: 50, view:  exchangeButton, action: exchange)
        
        rv.append(exb)
        buttonString = wrapper.symbolCode("fa-home")
        let homeButton = UIButton()
        buttonStringAttributed = NSMutableAttributedString(string: buttonString, attributes: [NSFontAttributeName:UIFont(name: "FontAwesome", size: 48)!])
        homeButton.titleLabel?.textAlignment = .center
        homeButton.titleLabel?.numberOfLines = 1
        homeButton.setAttributedTitle(buttonStringAttributed, for: UIControlState())
        homeButton.backgroundColor = UIColor.white
        homeButton.addTarget(self, action: #selector(self.home), for: .touchUpInside)
        let homeb = IconData(h: 50, w: 50, view:  homeButton, action: home)
        rv.append(homeb)
        
        return rv
        
    }
}
