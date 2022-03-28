//
//  See LICENSE folder for this template’s licensing information.
//
//  Abstract:
//  Provides supporting functions for setting up a live view.
//

import UIKit 
import PlaygroundSupport

/// Instantiates a new instance of a live view.
///
/// By default, this loads an instance of `LiveViewController` from `LiveView.storyboard`.
public func instantiateIntroView() -> PlaygroundLiveViewable {
	let storyboard = UIStoryboard(name: "Intro", bundle: nil)
	
	if let viewController = storyboard.instantiateViewController(withIdentifier: "IntroViewController") as? IntroViewController {
		return viewController
	}
	
	fatalError("Failed to instantiateIntroView")
}
