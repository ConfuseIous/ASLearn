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
	
	@IBOutlet weak var cameraView: UIView!
	@IBOutlet weak var orientationButton: UIButton!
	@IBOutlet weak var analyseButton: UIButton!
	
	var frontCamera : AVCaptureDevice?
	var frontCameraInput : AVCaptureInput!
	var captureSession = AVCaptureSession()
	var previewLayer : AVCaptureVideoPreviewLayer!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		orientationButton.layer.cornerRadius = 10
		analyseButton.layer.cornerRadius = 10
		
		orientationButton.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
		analyseButton.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
	}
	
	override func viewDidAppear(_ animated: Bool) {
		
		setupCamera()
		startCaptureSession()
		
//		do {
//			let model = try ASL(configuration: .init()).model
//		} catch {
//			print(error)
//		}
	}
	
	func setupCamera() {
		guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) else {
			showCameraError()
			return
		}
		
		frontCamera = device
		
		guard let fcInput = try? AVCaptureDeviceInput(device: frontCamera!) else {
			showCameraError()
			return
		}
		
		let cameraAuthStatus =  AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
		switch cameraAuthStatus {
		case .authorized:
			return
		case .denied:
			showCameraError()
			return
		case .notDetermined:
			AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (authorized) in
				if (!authorized) {
					self.showCameraError()
				}
			})
		case .restricted:
			showCameraError()
			return
		@unknown default:
			showCameraError()
			return
		}
		
		frontCameraInput = fcInput
	}
	
	func startCaptureSession() {
		DispatchQueue.global(qos: .userInitiated).async { [self] in
			self.captureSession = AVCaptureSession()
			
			self.captureSession.beginConfiguration()
			
			DispatchQueue.main.async {
				self.previewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
				
				self.previewLayer.frame = self.cameraView.bounds
				self.cameraView.layer.addSublayer(previewLayer)
				
				self.captureSession.addInput(frontCameraInput as AVCaptureInput)
//				self.captureSession.connections.first?.videoOrientation = .landscapeLeft
				self.captureSession.connections.first?.videoOrientation = .landscapeRight
//				self.captureSession.connections.first?.automaticallyAdjustsVideoMirroring = false
//				self.captureSession.connections.first?.isVideoMirrored = true
				self.captureSession.commitConfiguration()
				self.captureSession.startRunning()
			}
		}
	}
	
	func showCameraError() {
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		let vc = storyboard.instantiateViewController(withIdentifier: "noCameraVC")
		vc.isModalInPresentation = true
		self.present(vc, animated: true)
	}
	
	@IBAction func orientationButtonPressed(_ sender: Any) {
		captureSession.connections.first?.videoOrientation =  captureSession.connections.first?.videoOrientation == .landscapeLeft ? .landscapeRight : .landscapeLeft
	}
	
	public func receive(_ message: PlaygroundValue) {
		// Implement this method to receive messages sent from the process running Contents.swift.
		// This method is *required* by the PlaygroundLiveViewMessageHandler protocol.
		// Use this method to decode any messages sent as PlaygroundValue values and respond accordingly.
	}
}
