//
//  ButtonPaletteController.swift
//  Wibber
//
//  Created by Steve Lu on 2/12/17.
//  Copyright © 2017 Steve Lu. All rights reserved.
//

import Foundation
import UIKit

func noop() {
    return
}


@objc public class ButtonPaletteController : NSObject, PopupViewDismissalProtocol {
    var popView: UIView?
    var ctrlr: UIViewController?
    var provider: PaletteProviderProtocol?
    let popupHeight: Float  = 80
    let popupWidth: Float = 100
    let minWidthPercent: Float = 0.1
    let refinedMargin: Float = 0.03
    let wrapper:FontAwesomeWrapper = FontAwesomeWrapper()
    
    var exchangeAction: (() -> ())
    var homeAction: (() -> ())
    
    init(controller: UIViewController, paletteProvider: PaletteProviderProtocol!) {
        ctrlr = controller
        exchangeAction = noop
        homeAction = noop
        provider = paletteProvider
        super.init()
        provider!.popCloser = self
    }
    
    
    func viewDidLoadAdjunct() {
        let gesture = UITapGestureRecognizer(target: self, action:  #selector (self.buttonPaletteAction (_:)))
        ctrlr!.view.addGestureRecognizer(gesture)
    }

    func refinedAction(_ sender:UITapGestureRecognizer) {
        if popView != nil {
            //            popView!.backgroundColor = UIColor.whiteColor()
            ctrlr!.view.willRemoveSubview(popView!)
            popView!.removeFromSuperview()
        }
        var left = sender.location(ofTouch: 0, in: ctrlr!.view)
        if ctrlr!.view.window != nil {
            let winDims = ctrlr!.view.window!.screen.bounds
            let leftLimit = Float(winDims.width) * refinedMargin + popupWidth / 2
            let slideLeft = (Float(winDims.width) * (Float(1.0) - refinedMargin)) - popupWidth
            let lx = ((Float(left.x) > (Float(winDims.width) - popupWidth))
                ? slideLeft
                : ((Float(left.x) < leftLimit)
                    ? Float(left.x)
                    : Float(left.x) - popupWidth / 2))
            left.x = CGFloat(lx)
            let topLimit = popupHeight + refinedMargin * Float(winDims.height)
            let topOffset: Float = refinedMargin * Float(winDims.height)
            left.y = CGFloat((Float(left.y) < topLimit)
                ? Float(left.y) + topOffset
                : Float(left.y) - popupHeight)
            popView = PopupView(frame: CGRect(x:left.x, y: left.y, width: CGFloat(popupWidth), height: CGFloat(popupHeight)))
            ctrlr!.view.addSubview(popView!)
        }
    }
    
    @objc func setExchangeAction(f: @escaping (() -> ())) {
        exchangeAction = f
    }
    
    @objc func setHomeAction(f: @escaping (() -> ())) {
        homeAction = f
    }
    
    public func dismiss() {
        NSLog("Dismissing...")
        if popView != nil {
            ctrlr!.view.willRemoveSubview(popView!)
            popView!.removeFromSuperview()
        }
    }
    
    @objc func exchange() -> Int {
        dismiss()
        self.exchangeAction();
        return 0
    }
    
    @objc func home() -> Int {
        dismiss()
        self.homeAction();
        return 0
    }
    
    func buildIconList() -> [IconData] {
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
    
    @objc func buttonPaletteAction(_ sender:UITapGestureRecognizer) {
        NSLog("In buttonPaletteAction...")
        dismiss()
        let pt = sender.location(ofTouch: 0, in: ctrlr!.view)
        //let icons:[IconData] = buildIconList()
        if ctrlr!.view.window != nil {
            popView = ButtonDialog(bounds: ctrlr!.view.window!.screen.bounds, point: pt, icons: provider!.getPalette(), maxColumns: 4)
            ctrlr!.view.addSubview(popView!)
        }
    }
    
    
}

