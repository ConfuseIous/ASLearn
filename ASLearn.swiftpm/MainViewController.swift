//
//  MainViewController.swift
//  ASLearn
//
//  Created by Karandeep Singh on 12/4/22.
//

import UIKit
import ARKit
import CoreML
import Vision
import SwiftUI

final class MainViewController: UIViewController, AVCapturePhotoCaptureDelegate {
	
	var panGesture = UIPanGestureRecognizer()
	
	let tutorialImageView: UIImageView = {
		let tutorialImageView = UIImageView()
		tutorialImageView.contentMode = .scaleAspectFit
		tutorialImageView.image = UIImage(named: "black")
		tutorialImageView.translatesAutoresizingMaskIntoConstraints = false
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
	
	let countdownView: UIView = {
		let countdownView = UIView()
		countdownView.backgroundColor = .gray.withAlphaComponent(0.7)
		countdownView.layer.cornerRadius = 10
		countdownView.alpha = 0
		countdownView.translatesAutoresizingMaskIntoConstraints = false
		return countdownView
	}()
	
	let countdownLabel: UILabel = {
		let countdownLabel = UILabel()
		countdownLabel.textAlignment = .center
		countdownLabel.numberOfLines = 1
		countdownLabel.text = "3"
		countdownLabel.font = .systemFont(ofSize: 25)
		countdownLabel.translatesAutoresizingMaskIntoConstraints = false
		return countdownLabel
	}()
	
	let cameraView: UIView = {
		let cameraView = UIView()
		cameraView.backgroundColor = .clear
		//		cameraView.layer.borderColor = UIColor.label.cgColor
		//		cameraView.layer.borderWidth = 5
		//		cameraView.layer.cornerRadius = 10
		cameraView.translatesAutoresizingMaskIntoConstraints = false
		return cameraView
	}()
	
	let analyseButton: UIButton = {
		let analyseButton = UIButton()
		analyseButton.backgroundColor = .systemBlue
		analyseButton.setTitle("Analyse Gesture", for: .normal)
		analyseButton.layer.cornerRadius = 10
		analyseButton.translatesAutoresizingMaskIntoConstraints = false
		return analyseButton
	}()
	
	var cameraOutput: AVCapturePhotoOutput!
	var captureSession = AVCaptureSession()
	var previewLayer : AVCaptureVideoPreviewLayer!
	
	// These optionals are force unwrapped because a failure to initialise a model is critical and termination is a suitable response.
	let deepLabV3 = try! DeepLabV3(configuration: .init()).model
	//	var aslClassifier: MLModel = try! ASL_Classifier(configuration: .init()).model

	var aslClassifier: VNCoreMLModel = {
		let config = MLModelConfiguration()
		config.computeUnits = .cpuOnly
		
		let aslClassifier = try! VNCoreMLModel(for: ASL(configuration: config).model)
		
		return aslClassifier
	}()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		analyseButton.addTarget(self, action: #selector(analyseButtonPressed), for: .touchUpInside)
		
		// Set up Views
		view.addSubview(tutorialImageView)
		view.addSubview(infoLabel)
		view.addSubview(cameraView)
		view.addSubview(analyseButton)
		view.addSubview(cameraView)
		
		countdownView.addSubview(countdownLabel)
		view.addSubview(countdownView)
		
		// Set up Constraints
		NSLayoutConstraint.activate([
			tutorialImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			tutorialImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			tutorialImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
			tutorialImageView.heightAnchor.constraint(equalToConstant: 400),
			
			infoLabel.topAnchor.constraint(equalTo: tutorialImageView.bottomAnchor, constant: 20),
			infoLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
			infoLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
			
			countdownView.widthAnchor.constraint(equalToConstant: 100),
			countdownView.heightAnchor.constraint(equalToConstant: 100),
			countdownView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
			countdownView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			
			countdownLabel.centerYAnchor.constraint(equalTo: countdownView.centerYAnchor),
			countdownLabel.centerXAnchor.constraint(equalTo: countdownView.centerXAnchor),
			
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
	
	func updateInfoText(error: String? = nil) {
		/* This function conditionally either
		 Warns the user to use portrait mode
		 or
		 Provides instructions
		 */
		
		UIView.animate(withDuration: 0.5, delay: 2.0, options: .curveEaseOut, animations: {
			self.infoLabel.alpha = 0.0
		}, completion: {_ in
			if let error = error {
				self.infoLabel.text = error
			} else {
				self.infoLabel.text = self.view.window?.windowScene?.interfaceOrientation != .portrait ? "For an ideal experience, please rotate your device to portrait mode." : "Please try to imitate the gesture indicated in the image above with your right hand and press the \"Analyse Gesture\" button with your left."
			}
			
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
		let image = UIImage(cgImage: cgImageRef, scale: 1.0, orientation: UserDefaults.standard.integer(forKey: "selectedHandIndex") == 0 ? .leftMirrored : .left)
		
		print("DEBUG: IMAGE SIZE = \(image.size)")
		
		let x = removeBackgroundForImage(image: image)
		tutorialImageView.image = x
		
		#warning("handle potential crash")
		tutorialImageView.image = UIImage(data: x.jpegData(compressionQuality: 1.0)!)
		
		let request = VNCoreMLRequest(model: aslClassifier, completionHandler: handleClassification)
		let handler = VNImageRequestHandler(cgImage: image.cgImage!)
		do {
			try handler.perform([request])
		} catch {
			print(error)
		}
	}
	
	func removeBackgroundForImage(image: UIImage) -> UIImage {
		let originalSize = image.size
		
		let resizedImage = image.resized(to: CGSize(width: 513, height: 513), scale: 1)
		let pixelBuffer = resizedImage.pixelBuffer(width: Int(513), height: Int(513))
		let outputPredictionImage = try? deepLabV3.prediction(from: DeepLabV3Input(image: pixelBuffer!))
		let outputImage = DeepLabV3Output(features: outputPredictionImage!).semanticPredictions.image(min: 0, max: 1, axes: (0, 0, 1))
		let outputCIImage = CIImage(image: outputImage!)!
		let maskImage = outputCIImage.removeWhitePixels()
		
		let resizedCIImage = CIImage(image: resizedImage)
		let compositedImage = resizedCIImage!.composite(with: maskImage!)
		let finalImage = UIImage(ciImage: compositedImage!)
			.resized(to: originalSize)
		
		return finalImage
	}
	
	func handleClassification(request: VNRequest, error: Error?) {
		guard let observations = request.results as? [VNClassificationObservation] else { return }
		guard let best = observations.first else { return}
		
		DispatchQueue.main.async {
			print("DEBUG: Classified as \(best.identifier) with a confidence of \(best.confidence)")
		}
	}
	
	// MARK: - Button Actions
	@objc func analyseButtonPressed(_ sender: Any) {
		var remainingSecondsForTimer = 3
		
		self.countdownLabel.text = String(3)
		
		UIView.animate(withDuration: 0.5, animations: { [weak self] in
			self?.countdownView.alpha = 1.0
		})
		
		Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
			remainingSecondsForTimer -= 1
			self.countdownLabel.text = String(remainingSecondsForTimer)
			
			if remainingSecondsForTimer == 0 {
				timer.invalidate()
				
				// Process in separate queue to avoid blocking UI
				DispatchQueue.global().async {
					// Capture Image
					let settings = AVCapturePhotoSettings()
					let previewPixelType = settings.availablePreviewPhotoPixelFormatTypes.first!
					let previewFormat = [
						kCVPixelBufferPixelFormatTypeKey as String: previewPixelType,
						kCVPixelBufferWidthKey as String: 200,
						kCVPixelBufferHeightKey as String: 200
					]
					
					settings.previewPhotoFormat = previewFormat
					self.cameraOutput.capturePhoto(with: settings, delegate: self)
				}
				
				UIView.animate(withDuration: 0.5, animations: { [weak self] in
					self?.countdownView.alpha = 0.0
				})
			}
		}
	}
	
	func showCameraError(error: CameraError) {
		var message = ""
		
		switch error {
		case .couldNotAddCamera:
			message = "ASLearn was unable to access your front camera. \nPlease ensure that you've granted camera access and that your front camera is functioning."
		case .cameraNotFunctional:
			message = "ASLearn couldn't find a front camera. \nPlease ensure that you've granted camera access and that your front camera is functioning."
		case .processingError, .noImageFound:
			message = "An error occurred while processing your hand gesture. \nPlease try another gesture. If this persists, please adjust your lighting conditions and only position your hand in the frame."
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

// SOURCE - https://gist.github.com/vlondon/491c2e7829d60e835d53a1f6810a34ed
extension CIImage {
	
	func removeWhitePixels() -> CIImage? {
		let chromaCIFilter = chromaKeyFilter()
		chromaCIFilter?.setValue(self, forKey: kCIInputImageKey)
		return chromaCIFilter?.outputImage
	}
	
	func composite(with mask: CIImage) -> CIImage? {
		return CIFilter(
			name: "CISourceOutCompositing",
			parameters: [
				kCIInputImageKey: self,
				kCIInputBackgroundImageKey: mask
			]
		)?.outputImage
	}
	
	// modified from https://developer.apple.com/documentation/coreimage/applying_a_chroma_key_effect
	private func chromaKeyFilter() -> CIFilter? {
		let size = 64
		var cubeRGB = [Float]()
		
		for z in 0 ..< size {
			let blue = CGFloat(z) / CGFloat(size - 1)
			for y in 0 ..< size {
				let green = CGFloat(y) / CGFloat(size - 1)
				for x in 0 ..< size {
					let red = CGFloat(x) / CGFloat(size - 1)
					let brightness = getBrightness(red: red, green: green, blue: blue)
					let alpha: CGFloat = brightness == 1 ? 0 : 1
					cubeRGB.append(Float(red * alpha))
					cubeRGB.append(Float(green * alpha))
					cubeRGB.append(Float(blue * alpha))
					cubeRGB.append(Float(alpha))
				}
			}
		}
		
		let data = cubeRGB.withUnsafeBufferPointer { bufPtr in
			Data(buffer: bufPtr)
		}
		
		let colorCubeFilter = CIFilter(
			name: "CIColorCube",
			parameters: [
				"inputCubeDimension": size,
				"inputCubeData": data
			]
		)
		return colorCubeFilter
	}
	
	// modified from https://developer.apple.com/documentation/coreimage/applying_a_chroma_key_effect
	private func getBrightness(red: CGFloat, green: CGFloat, blue: CGFloat) -> CGFloat {
		let color = UIColor(red: red, green: green, blue: blue, alpha: 1)
		var brightness: CGFloat = 0
		color.getHue(nil, saturation: nil, brightness: &brightness, alpha: nil)
		return brightness
	}
	
}
