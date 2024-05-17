//
//  UIView_Ex.swift
//  HappyBirthdayApp
//
//  Created by Yehonatan Yehudai on 17/05/2024.
//

import UIKit

extension UIView {
    var frameRadius: CGFloat {
        min(frame.width, frame.height) / 2
    }

    var boundsRadius: CGFloat {
        min(bounds.width, bounds.height) / 2
    }

    static func animateOnTap(gesture: UIGestureRecognizer, completion: ((Bool) -> Void)? = nil) {
        guard let sender = gesture.view else { return }
        animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
            sender.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        }, completion: { _ in
            animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
                sender.transform = .identity
            }, completion: completion)
        })
    }
}
