//
//  UINavigationController+Ext.swift
//  HCTHP
//
//  Created by Mahmudul Hasan on 2024-07-16.
//

import SwiftUI

/// This extension keeps our back navigation by swipe when we hide back button
extension UINavigationController: UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}
