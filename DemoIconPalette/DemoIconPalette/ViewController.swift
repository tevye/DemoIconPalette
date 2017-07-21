//
//  ViewController.swift
//  DemoIconPalette
//
//  Created by Steve Lu on 7/20/17.
//  Copyright © 2017 justme. All rightntrol;s reserved.
//

import UIKit

class ViewController: UIViewController {

    var palette:  ScreenPalette?
    var pControl: ButtonPaletteController?
    var recogn:   UITapGestureRecognizer?

    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        myinit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        myinit()
    }

    func myinit() {
        recogn = UITapGestureRecognizer(target: self, action: Selector(("handler:")))
        palette = ScreenPalette(controller: self, e: exchange, h: home)
        pControl = ButtonPaletteController(controller: self, paletteProvider: palette)
        palette!.setCloser(pControl)
        pControl!.setExchangeAction(f: exchange)
    }

    @IBOutlet weak var outputLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        pControl!.viewDidLoadAdjunct()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func exchange() {
        if outputLabel != nil {
            outputLabel.text = "Exchange tapped, tap again"
        }
    }
    func home() {
        if outputLabel != nil {
            outputLabel.text = "Home tapped, tap again"
        }
    }
    
    func handler(tap: UITapGestureRecognizer) {
        pControl!.buttonPaletteAction(tap)
    }
}

