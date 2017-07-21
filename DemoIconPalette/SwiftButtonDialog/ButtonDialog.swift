//
//  ButtonDialog.swift - This is painfully complicated for little value and much obsession. Instead of forcing
//                       all subview to have exactly the same dimensions and keeping it simple, this allows difference
//                       sizes and automatically fits them to a dialog box. Very dumb of me, but fun to work
//                       through
//  TestUIView
//
//  Created by Steve Lu on 10/8/16.
//  Copyright © 2016 justme. All rights reserved.
//

import Foundation
import UIKit



@objc public class DialogCheck : NSObject {
    var good: Bool = false
    var iconsPerRow: Int = 0
    var rowHeights: [CGFloat] = [CGFloat]()
    var columnWidths: [CGFloat] = [CGFloat]()
    var width: CGFloat = 0
    var height: CGFloat = 0
    var maxIconWidth: CGFloat = 0
    
    override init() {}
}

let refinedMargin: CGFloat = 0.03
let ridiculousNumberIconsInARow: Int = 1000

@objc public class ButtonDialog : UIView {
    
    let maxAllowedColumns: Int
    
    
    public init(bounds: CGRect, point: CGPoint, icons:[IconData], maxColumns: Int) {
        maxAllowedColumns = maxColumns
        let check: DialogCheck = checkFit(winBounds: bounds, icons: icons, maxColumns: maxAllowedColumns)
        let frame: CGRect = getFrame(bounds: bounds, point: point, icons: icons, check: check)
        super.init(frame: frame)
        var row: Int = 0
        var ix: CGFloat = 0
        var jy: CGFloat = 0
        var i: Int = 0
        var f: CGRect
        for icon in icons {
            f = CGRect(x: adjustX(i, ix, icon: icon, check: check), y: adjustY(row, jy, icon: icon, check: check), width: CGFloat(icon.width), height: CGFloat(icon.height))
            i += 1
            icon.view!.frame = f
            self.addSubview(icon.view!)
            if (i == check.iconsPerRow) {
                jy += check.rowHeights[row]
                row += 1
                i = 0
                ix = 0;
                
            } else {
                ix += check.columnWidths[i - 1]
            }
        }
    }
    
    
    func adjustX(_ i: Int, _ x: CGFloat, icon: IconData, check: DialogCheck) -> CGFloat {
        let diff: CGFloat = check.columnWidths[i % check.iconsPerRow] - CGFloat(icon.width)
        return x + diff / 2
    }
    
    func adjustY(_ row : Int, _ y: CGFloat, icon: IconData, check: DialogCheck) -> CGFloat {
        let diff: CGFloat = check.rowHeights[row] - CGFloat(icon.height)
        return y + diff / 2
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


func checkFit(winBounds: CGRect, icons:[IconData], maxColumns: Int) -> DialogCheck {
    let rv: DialogCheck = DialogCheck()
    rv.rowHeights = Array(repeating: CGFloat(0.0), count: icons.count)
    let hbnd: CGFloat = winBounds.height
    let wbnd: CGFloat = winBounds.width
    var wval: CGFloat = 0
    var hcumm: CGFloat = 0
    var hmax: CGFloat = 0
    var wcnt: Int = 0
    var wmax: Int = Int.max
    var max1w: Float = 0
    var currRow: Int = 0
    var reset: Bool = false
    for i in icons {
        max1w = max(max1w, i.width)
        rv.rowHeights[currRow] = max(rv.rowHeights[currRow], CGFloat(i.height))
        if (wval + CGFloat(i.width) < wbnd) {
            wval += CGFloat(i.width)
            wcnt += 1
        } else {
            wmax = min(wmax, wcnt)
            wcnt = 1
            currRow += 1
            wval = CGFloat(i.width)
            reset = true
        }
        if reset {
            hcumm += hmax
            reset = false
        } else {
            hmax = max(hmax, CGFloat(i.height))
        }
    }
    wcnt = min(wcnt, maxColumns)
    // 2016.10.16 lusp Loop over second time to set column widths
    rv.columnWidths = Array(repeating: 0, count: wcnt)
    var c: Int = 0
    for i in icons {
        rv.columnWidths[c] = max(rv.columnWidths[c], CGFloat(i.width))
        c = (c + 1) % wcnt
    }
    wval = 0
    for cw in rv.columnWidths {
        wval += cw
    }
    rv.good = hcumm < hbnd && wval < wbnd
    rv.iconsPerRow = wcnt
    rv.width = wval
    hcumm = 0
    for hrow in rv.rowHeights {
        if hrow > 0 {
            hcumm += hrow
        }
    }
    rv.height = hcumm
    rv.maxIconWidth = CGFloat(max1w)
    return rv
    
}

func getFrame(bounds: CGRect, point: CGPoint, icons:[IconData], check: DialogCheck) -> CGRect {
    var rv: CGRect
    var left: CGPoint = point
    let winDims = bounds
    let leftLimit = winDims.width * refinedMargin + check.width / 2
    let slideLeft = (winDims.width * (1.0 - refinedMargin)) - check.width
    let lx = ((left.x > (winDims.width - check.width))
        ? slideLeft
        : ((left.x < leftLimit)
            ? left.x
            : left.x - check.width / 2))
    left.x = CGFloat(lx)

    if check.good {
        let topLimit = check.width + refinedMargin * winDims.height
        let topOffset: CGFloat = refinedMargin * winDims.height
        left.y = CGFloat((left.y < topLimit)
            ? left.y + topOffset
            : left.y - check.height)
        rv = CGRect(x:left.x, y: left.y, width: CGFloat(check.width), height: CGFloat(check.height))
    } else {
        left.y = ((left.y <= winDims.height / 2)
            ? left.y
            : winDims.height * CGFloat(refinedMargin))
        let h: CGFloat = bounds.height * (1.0 - CGFloat(refinedMargin)) - point.y
        rv = CGRect(x: point.x, y: point.y, width: CGFloat(check.maxIconWidth), height: h)
    }
    return rv
}


