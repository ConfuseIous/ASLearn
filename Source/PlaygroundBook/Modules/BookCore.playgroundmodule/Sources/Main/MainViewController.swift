//
//  MainViewController.swift
//  BookCore
//
//  Created by Karandeep Singh on 30/3/22.
//

import UIKit
import ARKit
import CoreML
import PlaygroundSupport

@objc(BookCore_MainViewController)
class MainViewController: UIViewController, PlaygroundLiveViewMessageHandler, PlaygroundLiveViewSafeAreaContainer, AVCapturePhotoCaptureDelegate {
	
	@IBOutlet weak var cameraView: UIView!
	@IBOutlet weak var orientationButton: UIButton!
	@IBOutlet weak var analyseButton: UIButton!
	
	var cameraOutput: AVCapturePhotoOutput!
	var captureSession = AVCaptureSession()
	var previewLayer : AVCaptureVideoPreviewLayer!
	
//	var model: MLModel = try! ASL(configuration: .init()).modele
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		orientationButton.layer.cornerRadius = 10
		analyseButton.layer.cornerRadius = 10
	}
	
	override func viewDidAppear(_ animated: Bool) {
		startCameraAndSession()
	}
	
	// MARK: - Camera
	func startCameraAndSession() {
		captureSession = AVCaptureSession()
		captureSession.sessionPreset = AVCaptureSession.Preset.photo
		cameraOutput = AVCapturePhotoOutput()
		
		if let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front),
		   let input = try? AVCaptureDeviceInput(device: device) {
			if (captureSession.canAddInput(input)) {
				captureSession.addInput(input)
				
				if (captureSession.canAddOutput(cameraOutput)) {
					// Setup previewLayer
					previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
					previewLayer.frame = cameraView.bounds
					cameraView.layer.addSublayer(previewLayer)
					
					captureSession.addOutput(cameraOutput)
					captureSession.startRunning()
					captureSession.connections.first?.videoOrientation = .landscapeRight
				}
			} else {
				fatalError("captureSesssion.canAddInput is false")
			}
		} else {
			fatalError("Problem with front camera")
		}
	}
	
	func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
		
		if let error = error {
			fatalError("Error with didFinishProcessingPhoto: \(error)")
		}
		
		guard let dataImage = photo.fileDataRepresentation() else {
			fatalError("No image found in didFinishProcessingPhoto")
		}
		
		let dataProvider = CGDataProvider(data: dataImage as CFData)
		let cgImageRef: CGImage! = CGImage(jpegDataProviderSource: dataProvider!, decode: nil, shouldInterpolate: true, intent: .defaultIntent)
		let image = UIImage(cgImage: cgImageRef, scale: 1.0, orientation: UIImage.Orientation.right)
		
		
		
		//		let alert = UIAlertController(title: "DEBUG: IMAGE SIZE", message: "\(image.size)", preferredStyle: .alert)
		//		alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
		//		self.present(alert, animated: true, completion: nil)
		
	}
	
	func showCameraError() {
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		let vc = storyboard.instantiateViewController(withIdentifier: "noCameraVC")
		vc.isModalInPresentation = true
		self.present(vc, animated: true)
	}
	
	// MARK: - Button Actions
	@IBAction func orientationButtonPressed(_ sender: Any) {
		captureSession.connections.first!.videoOrientation =  captureSession.connections.first!.videoOrientation == .landscapeLeft ? .landscapeRight : .landscapeLeft
	}
	
	@IBAction func analyseButtonPressed(_ sender: Any) {
		// Capture Image
		let settings = AVCapturePhotoSettings()
		let previewPixelType = settings.availablePreviewPhotoPixelFormatTypes.first!
		let previewFormat = [
			kCVPixelBufferPixelFormatTypeKey as String: previewPixelType,
			kCVPixelBufferWidthKey as String: 200,
			kCVPixelBufferHeightKey as String: 200
		]
		settings.previewPhotoFormat = previewFormat
		cameraOutput.capturePhoto(with: settings, delegate: self)
	}
	
	public func receive(_ message: PlaygroundValue) {
		// Implement this method to receive messages sent from the process running Contents.swift.
		// This method is *required* by the PlaygroundLiveViewMessageHandler protocol.
		// Use this method to decode any messages sent as PlaygroundValue values and respond accordingly.
	}
}
