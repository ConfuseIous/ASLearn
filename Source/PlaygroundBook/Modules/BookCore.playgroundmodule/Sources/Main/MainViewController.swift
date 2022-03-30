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
	
	var captureSession = AVCaptureSession()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setupCaptureSession()
		
		do {
			let model = try ASL(configuration: .init()).model
		} catch {
			print(error)
		}
	}
	
	func setupCaptureSession() {
		DispatchQueue.global(qos: .userInitiated).async {
			self.captureSession = AVCaptureSession()
			self.captureSession.beginConfiguration()
			self.captureSession.commitConfiguration()
			self.captureSession.startRunning()
		}
	}
	
	public func receive(_ message: PlaygroundValue) {
		// Implement this method to receive messages sent from the process running Contents.swift.
		// This method is *required* by the PlaygroundLiveViewMessageHandler protocol.
		// Use this method to decode any messages sent as PlaygroundValue values and respond accordingly.
	}
}
