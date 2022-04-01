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
class MainViewController: UIViewController, PlaygroundLiveViewMessageHandler, PlaygroundLiveViewSafeAreaContainer, AVCapturePhotoCaptureDelegate {
	
	@IBOutlet weak var cameraView: UIView!
	@IBOutlet weak var orientationButton: UIButton!
	@IBOutlet weak var analyseButton: UIButton!
	
//	var frontCamera : AVCaptureDevice?
//	var frontCameraInput : AVCaptureInput!
	var cameraOutput: AVCapturePhotoOutput!
	var captureSession = AVCaptureSession()
	var previewLayer : AVCaptureVideoPreviewLayer!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		orientationButton.layer.cornerRadius = 10
		analyseButton.layer.cornerRadius = 10
	}
	
	override func viewDidAppear(_ animated: Bool) {
		startCamera()
		
		//		setupCamera()
		//		startCaptureSession()
		
		//		do {
		//			let model = try ASL(configuration: .init()).model
		//		} catch {
		//			print(error)
		//		}
	}
	
	func startCamera() {
		captureSession = AVCaptureSession()
		captureSession.sessionPreset = AVCaptureSession.Preset.photo
		cameraOutput = AVCapturePhotoOutput()
		
		if let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front),
		   let input = try? AVCaptureDeviceInput(device: device) {
			if (captureSession.canAddInput(input)) {
				captureSession.addInput(input)
				if (captureSession.canAddOutput(cameraOutput)) {
					captureSession.addOutput(cameraOutput)
					previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
					previewLayer.frame = cameraView.bounds
					cameraView.layer.addSublayer(previewLayer)
					captureSession.startRunning()
				}
			} else {
				fatalError("Problem with captureSesssion.canAddInput")
			}
		} else {
			fatalError("Problem with getting front cam")
		}
	}
	
	func captureImage() {
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
	
	func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
		
		if let error = error {
			print("error occured : \(error.localizedDescription)")
		}
		
		if let dataImage = photo.fileDataRepresentation() {
			print(UIImage(data: dataImage)?.size as Any)
			
			let dataProvider = CGDataProvider(data: dataImage as CFData)
			let cgImageRef: CGImage! = CGImage(jpegDataProviderSource: dataProvider!, decode: nil, shouldInterpolate: true, intent: .defaultIntent)
			let image = UIImage(cgImage: cgImageRef, scale: 1.0, orientation: UIImage.Orientation.right)
			
		} else {
			print("some error here")
		}
	}
	
	//	func setupCamera() {
	//
	//		guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) else {
	//			showCameraError()
	//			return
	//		}
	//
	//		frontCamera = device
	//
	//		guard let fcInput = try? AVCaptureDeviceInput(device: frontCamera!) else {
	//			showCameraError()
	//			return
	//		}
	//
	//		let cameraAuthStatus =  AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
	//		switch cameraAuthStatus {
	//		case .authorized:
	//			return
	//		case .denied:
	//			showCameraError()
	//			return
	//		case .notDetermined:
	//			AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (authorized) in
	//				if (!authorized) {
	//					self.showCameraError()
	//				}
	//			})
	//		case .restricted:
	//			showCameraError()
	//			return
	//		@unknown default:
	//			showCameraError()
	//			return
	//		}
	//
	//		frontCameraInput = fcInput
	//	}
	
	//	func startCaptureSession() {
	//		DispatchQueue.global(qos: .userInitiated).async { [self] in
	//			self.captureSession = AVCaptureSession()
	//
	//			self.captureSession.beginConfiguration()
	//
	//			DispatchQueue.main.async {
	//				self.previewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
	//
	//				self.previewLayer.frame = self.cameraView.bounds
	//
	//				self.cameraView.layer.addSublayer(previewLayer)
	//
	//				self.captureSession.addInput(frontCameraInput as AVCaptureInput)
	//				self.captureSession.connections.first?.videoOrientation = .landscapeRight
	//				self.captureSession.commitConfiguration()
	//				self.captureSession.startRunning()
	//			}
	//		}
	//	}
	
	//
	//	func capturePhoto() {
	//		let settings = AVCapturePhotoSettings()
	//		let previewPixelType = settings.availablePreviewPhotoPixelFormatTypes.first!
	//		let previewFormat = [kCVPixelBufferPixelFormatTypeKey as String: previewPixelType,
	//							 kCVPixelBufferWidthKey as String: 160,
	//							 kCVPixelBufferHeightKey as String: 160]
	//		settings.previewPhotoFormat = previewFormat
	//		self.cameraOutput.capturePhoto(with: settings, delegate: self)
	//	}
	//
	//	func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?, previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
	//		if let error = error {
	//			print(error.localizedDescription)
	//		}
	//
	//		func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
	//			let imageData = photo.fileDataRepresentation()
	//			if let data = imageData, let img = UIImage(data: data) {
	//				print(img)
	//			}
	//		}
	//	}
	
	func showCameraError() {
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		let vc = storyboard.instantiateViewController(withIdentifier: "noCameraVC")
		vc.isModalInPresentation = true
		self.present(vc, animated: true)
	}
	
	
	@IBAction func orientationButtonPressed(_ sender: Any) {
		captureSession.connections.first?.videoOrientation =  captureSession.connections.first?.videoOrientation == .landscapeLeft ? .landscapeRight : .landscapeLeft
	}
	
	@IBAction func analyseButtonPressed(_ sender: Any) {
		captureImage()
		//		self.cameraOutput.isLivePhotoCaptureEnabled = false
		//
		//		let settings = AVCapturePhotoSettings()
		//
		//		let previewPixelType = settings.availablePreviewPhotoPixelFormatTypes.first!
		//		let previewFormat = [
		//			kCVPixelBufferPixelFormatTypeKey as String: previewPixelType,
		//			kCVPixelBufferWidthKey as String: 200,
		//			kCVPixelBufferHeightKey as String: 200
		//		]
		//
		//		settings.previewPhotoFormat = previewFormat
		//		cameraOutput.capturePhoto(with: settings, delegate: self)
	}
	
	//	func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
	//		if let error = error {
	//			fatalError(error.localizedDescription)
	//		}
	//
	//		if let dataImage = photo.fileDataRepresentation() {
	//			print(UIImage(data: dataImage)?.size as Any)
	//
	//			let dataProvider = CGDataProvider(data: dataImage as CFData)
	//			let cgImageRef: CGImage! = CGImage(jpegDataProviderSource: dataProvider!, decode: nil, shouldInterpolate: true, intent: .defaultIntent)
	//
	//			let image = UIImage(cgImage: cgImageRef, scale: 1.0, orientation: UIImage.Orientation.right)
	//
	//		} else {
	//			fatalError("Something went wrong")
	//		}
	//	}
	
	public func receive(_ message: PlaygroundValue) {
		// Implement this method to receive messages sent from the process running Contents.swift.
		// This method is *required* by the PlaygroundLiveViewMessageHandler protocol.
		// Use this method to decode any messages sent as PlaygroundValue values and respond accordingly.
	}
}
