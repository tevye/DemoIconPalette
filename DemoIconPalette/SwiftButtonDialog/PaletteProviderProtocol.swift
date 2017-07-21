//
//  PaletteProviderProtocol.swift
//  Wibber
//
//  Created by Steve Lu on 2/18/17.
//  Copyright © 2017 Steve Lu. All rights reserved.
//

import Foundation


@objc public protocol PaletteProviderProtocol {
    func getPalette() -> [IconData]!
    var popCloser: PopupViewDismissalProtocol? { get set }
    //var ctrlr: UIViewController? { get }
}

@objc public protocol PopupViewDismissalProtocol {
    func dismiss()
}
