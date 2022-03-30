//
//  MainViewController.swift
//  BookCore
//
//  Created by Karandeep Singh on 30/3/22.
//

import UIKit
import ARKit
import CoreML
import Vision
import PlaygroundSupport

@objc(BookCore_MainViewController)
class MainViewController: UIViewController, PlaygroundLiveViewMessageHandler, PlaygroundLiveViewSafeAreaContainer {
	
	@IBOutlet weak var sceneView: ARSCNView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		do {
			let model = try ASL(configuration: .init()).model
		} catch {
			print(error)
		}
		
		let configuration = ARWorldTrackingConfiguration()
		sceneView.session.run(configuration)
	}
	
	public func receive(_ message: PlaygroundValue) {
		// Implement this method to receive messages sent from the process running Contents.swift.
		// This method is *required* by the PlaygroundLiveViewMessageHandler protocol.
		// Use this method to decode any messages sent as PlaygroundValue values and respond accordingly.
	}
}
