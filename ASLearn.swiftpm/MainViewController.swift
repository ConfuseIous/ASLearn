//
//  MainViewController.swift
//  ASLearn
//
//  Created by Karandeep Singh on 12/4/22.
//

import UIKit
import ARKit
import CoreML
import SwiftUI

//final class MainViewController: UIViewController, AVCapturePhotoCaptureDelegate {
final class MainViewController: UIViewController {
	
	var panGesture = UIPanGestureRecognizer()
	
	let tutorialView: UIView = {
		let tutorialView = UIView()
		tutorialView.translatesAutoresizingMaskIntoConstraints = false
		return tutorialView
	}()
	
	let cameraView: UIView = {
		let cameraView = UIView()
		cameraView.translatesAutoresizingMaskIntoConstraints = false
		return cameraView
	}()
	
//	let orientationButton: UIButton = {
//		let orientationButton = UIButton()
//		orientationButton.translatesAutoresizingMaskIntoConstraints = false
//		return orientationButton
//	}()
	
	let analyseButton: UIButton = {
		let analyseButton = UIButton()
		analyseButton.translatesAutoresizingMaskIntoConstraints = false
		return analyseButton
	}()
	
	//	var cameraOutput: AVCapturePhotoOutput!
	//	var captureSession = AVCaptureSession()
	//	var previewLayer : AVCaptureVideoPreviewLayer!
	
	//	var model: MLModel = try! ASL(configuration: .init()).model
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Set up UIPanGestureRecognizer
		panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.draggedView(_:)))
		cameraView.isUserInteractionEnabled = true
		cameraView.addGestureRecognizer(panGesture)
		
		#warning("change colour")
		cameraView.backgroundColor = .red
		
		// Set up constraints
		view.addSubview(cameraView)
		view.addSubview(analyseButton)
		
		NSLayoutConstraint.activate([
			cameraView.widthAnchor.constraint(equalToConstant: 200),
			cameraView.heightAnchor.constraint(equalTo: cameraView.widthAnchor, multiplier: 1.0)
		])
	}
	
//		override func viewDidAppear(_ animated: Bool) {
//			startCameraAndSession()
//		}
	
	// MARK: - Camera
	//	func startCameraAndSession() {
	//		captureSession = AVCaptureSession()
	//		captureSession.sessionPreset = AVCaptureSession.Preset.photo
	//		cameraOutput = AVCapturePhotoOutput()
	//
	//		if let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front),
	//		   let input = try? AVCaptureDeviceInput(device: device) {
	//			if (captureSession.canAddInput(input)) {
	//				captureSession.addInput(input)
	//
	//				if (captureSession.canAddOutput(cameraOutput)) {
	//					// Setup previewLayer
	//					previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
	//					previewLayer.frame = cameraView.bounds
	//					cameraView.layer.addSublayer(previewLayer)
	//
	//					captureSession.addOutput(cameraOutput)
	//					captureSession.startRunning()
	//					captureSession.connections.first?.videoOrientation = .landscapeRight
	//				}
	//			} else {
	//				fatalError("captureSesssion.canAddInput is false")
	//			}
	//		} else {
	//			fatalError("Problem with front camera")
	//		}
	//	}
	
	//	func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
	//
	//		if let error = error {
	//			fatalError("Error with didFinishProcessingPhoto: \(error)")
	//		}
	//
	//		guard let dataImage = photo.fileDataRepresentation() else {
	//			fatalError("No image found in didFinishProcessingPhoto")
	//		}
	//
	//		let dataProvider = CGDataProvider(data: dataImage as CFData)
	//		let cgImageRef: CGImage! = CGImage(jpegDataProviderSource: dataProvider!, decode: nil, shouldInterpolate: true, intent: .defaultIntent)
	//		let image = UIImage(cgImage: cgImageRef, scale: 1.0, orientation: UIImage.Orientation.right)
	//
	//		//		let alert = UIAlertController(title: "DEBUG: IMAGE SIZE", message: "\(image.size)", preferredStyle: .alert)
	//		//		alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
	//		//		self.present(alert, animated: true, completion: nil)
	//
	//	}
	
	//	func showCameraError() {
	//		let storyboard = UIStoryboard(name: "Main", bundle: nil)
	//		let vc = storyboard.instantiateViewController(withIdentifier: "noCameraVC")
	//		vc.isModalInPresentation = true
	//		self.present(vc, animated: true)
	//	}
	
	// MARK: - Button Actions
	//	@IBAction func orientationButtonPressed(_ sender: Any) {
	//		captureSession.connections.first!.videoOrientation =  captureSession.connections.first!.videoOrientation == .landscapeLeft ? .landscapeRight : .landscapeLeft
	//	}
	//
	//	@IBAction func analyseButtonPressed(_ sender: Any) {
	//		// Capture Image
	//		let settings = AVCapturePhotoSettings()
	//		let previewPixelType = settings.availablePreviewPhotoPixelFormatTypes.first!
	//		let previewFormat = [
	//			kCVPixelBufferPixelFormatTypeKey as String: previewPixelType,
	//			kCVPixelBufferWidthKey as String: 200,
	//			kCVPixelBufferHeightKey as String: 200
	//		]
	//		settings.previewPhotoFormat = previewFormat
	//		cameraOutput.capturePhoto(with: settings, delegate: self)
	//	}
	
	// Handle PanGesture
	@objc func draggedView(_ sender:UIPanGestureRecognizer){
		self.view.bringSubviewToFront(cameraView)
		let translation = sender.translation(in: self.view)
		cameraView.center = CGPoint(x: cameraView.center.x + translation.x, y: cameraView.center.y + translation.y)
		sender.setTranslation(CGPoint.zero, in: self.view)
	}
}

extension MainViewController: UIViewControllerRepresentable {
	
	public typealias UIViewControllerType = MainViewController
	
	func makeUIViewController(context: UIViewControllerRepresentableContext<MainViewController>) -> MainViewController {
		
		return MainViewController()
	}
	
	func updateUIViewController(_ uiViewController: MainViewController, context: UIViewControllerRepresentableContext<MainViewController>) {
		
	}
}
