//
//  ScrollView.swift
//  SpreadsheetView
//
//  Created by Kishikawa Katsumi on 3/16/17.
//  Copyright © 2017 Kishikawa Katsumi. All rights reserved.
//

import UIKit

public final class ScrollView: UIScrollView, UIGestureRecognizerDelegate {
    var columnRecords = [CGFloat]()
    var rowRecords = [CGFloat]()

    var visibleCells = ReusableCollection<Cell>()
    var visibleVerticalGridlines = ReusableCollection<Gridline>()
    var visibleHorizontalGridlines = ReusableCollection<Gridline>()
    var visibleBorders = ReusableCollection<Border>()

    typealias TouchHandler = (_ touches: Set<UITouch>, _ event: UIEvent?) -> Void
    var touchesBegan: TouchHandler?
    var touchesEnded: TouchHandler?
    var touchesCancelled: TouchHandler?

    var layoutAttributes = LayoutAttributes(startColumn: 0, startRow: 0, numberOfColumns: 0, numberOfRows: 0, columnCount: 0, rowCount: 0, insets: .zero)
    var state = State()
    struct State {
        var frame = CGRect.zero
        var contentSize = CGSize.zero
        var contentOffset = CGPoint.zero
    }

    var hasDisplayedContent: Bool {
        return columnRecords.count > 0 || rowRecords.count > 0
    }

    func resetReusableObjects() {
        for cell in visibleCells {
            cell.removeFromSuperview()
        }
        for gridline in visibleVerticalGridlines {
            gridline.removeFromSuperlayer()
        }
        for gridline in visibleHorizontalGridlines {
            gridline.removeFromSuperlayer()
        }
        for border in visibleBorders {
            border.removeFromSuperview()
        }
        visibleCells = ReusableCollection<Cell>()
        visibleVerticalGridlines = ReusableCollection<Gridline>()
        visibleHorizontalGridlines = ReusableCollection<Gridline>()
        visibleBorders = ReusableCollection<Border>()
    }
    
    public var hitTestHandler: ((_ view: UIView, _ point: CGPoint, _ event: UIEvent?)-> UIView?)?
        
    public override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        if view == nil{
            if let hitTestHandler = hitTestHandler {
                return hitTestHandler(self, point, event)
            }
        }
        return view
    }

    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return gestureRecognizer is UIPanGestureRecognizer
    }

    public override func touchesShouldBegin(_ touches: Set<UITouch>, with event: UIEvent?, in view: UIView) -> Bool {
        return hasDisplayedContent
    }

    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard hasDisplayedContent else {
            return
        }
        touchesBegan?(touches, event)
    }

    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard hasDisplayedContent else {
            return
        }
        touchesEnded?(touches, event)
    }

    public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard hasDisplayedContent else {
            return
        }
        touchesCancelled?(touches, event)
    }
}
