//
//  See LICENSE folder for this template’s licensing information.
//
//  Abstract:
//  Provides supporting functions for setting up a live view.
//

import UIKit 
import PlaygroundSupport

/// Instantiates a new instance of a live view.

public func instantiateIntroView() -> PlaygroundLiveViewable {
	let storyboard = UIStoryboard(name: "Intro", bundle: nil)
	
	guard let viewController = storyboard.instantiateViewController(withIdentifier: "IntroViewController") as? IntroViewController else {
		fatalError("Failed to instantiateIntroView")
	}
	
	return viewController
}
