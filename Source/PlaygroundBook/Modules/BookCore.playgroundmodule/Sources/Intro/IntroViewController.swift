//
//  IntroViewController.swift
//  BookCore
//
//  Created by Karandeep Singh on 29/3/22.
//

import UIKit
import PlaygroundSupport

@objc(BookCore_IntroViewController)
class IntroViewController: UIViewController, PlaygroundLiveViewMessageHandler, PlaygroundLiveViewSafeAreaContainer {
	
	@IBOutlet weak var icon: UIImageView!
	
	@IBOutlet weak var firstParagraph: UILabel!
	@IBOutlet weak var secondParagraph: UILabel!
	@IBOutlet weak var thirdParagraph: UILabel!
	
	override public func viewDidLoad() {
		super.viewDidLoad()
		
		animateView(view: firstParagraph, duration: 0.3)
		animateView(view: secondParagraph, duration: 1.6)
		animateView(view: thirdParagraph, duration: 2.9)
	}
	
	
	public func receive(_ message: PlaygroundValue) {
		// Implement this method to receive messages sent from the process running Contents.swift.
		// This method is *required* by the PlaygroundLiveViewMessageHandler protocol.
		// Use this method to decode any messages sent as PlaygroundValue values and respond accordingly.
	}
}

