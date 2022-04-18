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

final class MainViewController: UIViewController, AVCapturePhotoCaptureDelegate {
	
	var panGesture = UIPanGestureRecognizer()
	
	let tutorialImageView: UIImageView = {
		let tutorialImageView = UIImageView()
		tutorialImageView.translatesAutoresizingMaskIntoConstraints = false
		tutorialImageView.image = UIImage(named: "black")
		return tutorialImageView
	}()
	
	let infoLabel: UILabel = {
		let infoLabel = UILabel()
		infoLabel.textAlignment = .center
		infoLabel.numberOfLines = 2
		infoLabel.text = "You can drag the camera feed around to a more comfortable position if you wish.\n"
		infoLabel.translatesAutoresizingMaskIntoConstraints = false
		return infoLabel
	}()
	
	let cameraView: UIView = {
		let cameraView = UIView()
		cameraView.translatesAutoresizingMaskIntoConstraints = false
		return cameraView
	}()
	
	let analyseButton: UIButton = {
		let analyseButton = UIButton()
		analyseButton.translatesAutoresizingMaskIntoConstraints = false
		return analyseButton
	}()
	
	var cameraOutput: AVCapturePhotoOutput!
	var captureSession = AVCaptureSession()
	var previewLayer : AVCaptureVideoPreviewLayer!
	
	// These optionals are force unwrapped because a failure to initialise a model is critical and termination is a suitable response.
	var deepLabV3: MLModel = try! DeepLabV3(configuration: .init()).model
	var aslClassifier: MLModel = try! ASL_Classifier(configuration: .init()).model
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		cameraView.backgroundColor = .clear
		
		analyseButton.backgroundColor = .systemBlue
		analyseButton.setTitle("Analyse Gesture", for: .normal)
		analyseButton.layer.cornerRadius = 10
		analyseButton.addTarget(self, action: #selector(analyseButtonPressed), for: .touchUpInside)
		
		// Set up Views
		view.addSubview(tutorialImageView)
		view.addSubview(infoLabel)
		view.addSubview(analyseButton)
		view.addSubview(cameraView)
		
		// Set up Constraints
		NSLayoutConstraint.activate([
			tutorialImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			tutorialImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			tutorialImageView.topAnchor.constraint(equalTo: view.topAnchor),
			tutorialImageView.heightAnchor.constraint(equalToConstant: 400),
			
			infoLabel.topAnchor.constraint(equalTo: tutorialImageView.bottomAnchor, constant: 20),
			infoLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
			infoLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
			
			analyseButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			analyseButton.widthAnchor.constraint(equalToConstant: 200),
			analyseButton.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: 40),
			
			cameraView.widthAnchor.constraint(equalToConstant: 300),
			cameraView.heightAnchor.constraint(equalTo: cameraView.widthAnchor, multiplier: 1.0),
			cameraView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			cameraView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 20)
		])
		
		// Set up UIPanGestureRecognizer
		panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.draggedView(_:)))
		cameraView.isUserInteractionEnabled = true
		cameraView.addGestureRecognizer(panGesture)
	}
	
	override func viewDidAppear(_ animated: Bool) {
		startCameraAndSession()
		
		updateInfoText()
	}
	
	override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
		super.viewWillTransition(to: size, with: coordinator)
		
		updateInfoText()
	}
	
	func updateInfoText() {
		UIView.animate(withDuration: 0.5, delay: 2.0, options: .curveEaseOut, animations: {
			self.infoLabel.alpha = 0.0
		}, completion: {_ in
			
			self.infoLabel.text = self.view.window?.windowScene?.interfaceOrientation != .portrait ? "For an ideal experience, please rotate your device to portrait mode." : "Please try to imitate the gesture indicated in the image above with your right hand and press the \"Analyse Gesture\" button with your left."
			
			UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseOut, animations: {
				self.infoLabel.alpha = 1.0
			}, completion: nil)
		})
	}
	
	//	 MARK: - Camera
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
					captureSession.connections.first?.videoOrientation = .portrait
				}
			} else {
				showCameraError(error: .couldNotAddCamera)
			}
		} else {
			showCameraError(error: .cameraNotFunctional)
		}
	}
	
	func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
		
		if error != nil {
			showCameraError(error: .processingError)
			return
		}
		
		guard let dataImage = photo.fileDataRepresentation() else {
			showCameraError(error: .processingError)
			return
		}
		
		let dataProvider = CGDataProvider(data: dataImage as CFData)
		let cgImageRef: CGImage! = CGImage(jpegDataProviderSource: dataProvider!, decode: nil, shouldInterpolate: true, intent: .defaultIntent)
		let image = UIImage(cgImage: cgImageRef, scale: 1.0, orientation: UIImage.Orientation.right)
		
		let alert = UIAlertController(title: "DEBUG: IMAGE SIZE", message: "\(image.size)", preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
		self.present(alert, animated: true, completion: nil)
	}
	
	// MARK: - Button Actions
	@objc func analyseButtonPressed(_ sender: Any) {
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
	
	func showCameraError(error: CameraError) {
		var message = ""
		
		switch error {
		case .couldNotAddCamera:
			message = "ASLearn was unable to access your front camera. \nPlease ensure that you've granted camera access and that your front camera is functioning."
		case .cameraNotFunctional:
			message = "ASLearn couldn't find a front camera. \nPlease ensure that you've granted camera access and that your front camera is functioning."
		case .processingError, .noImageFound:
			message = "An error occurred while processing your hand gesture. \nPlease try another gesture. If this persists, ensure that you've granted camera access and that your front camera is functioning."
		}
		
		let alert = UIAlertController(title: "Something seems to be wrong", message: message, preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
		self.present(alert, animated: true, completion: nil)
	}
	
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
