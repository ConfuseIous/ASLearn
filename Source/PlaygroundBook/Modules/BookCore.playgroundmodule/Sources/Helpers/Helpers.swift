//
//  Helpers.swift
//  BookCore
//
//  Created by Karandeep Singh on 29/3/22.
//

import UIKit
import Foundation


func animateView(view: UIView, duration: Double) -> Void {
	let transition: CATransition = CATransition()
	
	transition.duration = duration
	transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
	transition.type = CATransitionType.push
	transition.subtype = CATransitionSubtype.fromBottom
	view.layer.add(transition, forKey: kCATransition)
}
