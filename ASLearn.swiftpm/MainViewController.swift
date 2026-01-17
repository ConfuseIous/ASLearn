//
//  MainViewController.swift
//  ASLearn
//
//  Created by Karandeep Singh on 12/4/22.
//

import ARKit
import UIKit
import CoreML
import Vision

final class MainViewController: UIViewController, AVCapturePhotoCaptureDelegate {
	
	var sharedViewModel: SharedViewModel
	
	init(sharedViewModel: SharedViewModel) {
		self.sharedViewModel = sharedViewModel
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	var panGesture = UIPanGestureRecognizer()

	let alphabetImageView: UIImageView = {
		let view = UIImageView()
		view.contentMode = .scaleAspectFit
		view.image = UIImage(named: "black")
		view.layer.cornerRadius = 20
		view.clipsToBounds = true
		view.layer.shadowColor = UIColor.black.cgColor
		view.layer.shadowOpacity = 0.1
		view.layer.shadowOffset = CGSize(width: 0, height: 4)
		view.layer.shadowRadius = 12
		view.backgroundColor = .systemBackground
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()

	let gestureImageView: UIImageView = {
		let view = UIImageView()
		view.contentMode = .scaleAspectFit
		view.image = UIImage(named: "black")
		view.layer.cornerRadius = 20
		view.clipsToBounds = true
		view.layer.shadowColor = UIColor.black.cgColor
		view.layer.shadowOpacity = 0.1
		view.layer.shadowOffset = CGSize(width: 0, height: 4)
		view.layer.shadowRadius = 12
		view.backgroundColor = .systemBackground
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()

	let instructionsLabel: UILabel = {
		let label = UILabel()
		label.textAlignment = .center
		label.numberOfLines = 0
		label.font = .systemFont(ofSize: 16, weight: .medium)
		label.textColor = .label
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()

	let infoLabel: UILabel = {
		let label = UILabel()
		label.textAlignment = .center
		label.numberOfLines = 0
		label.text = "You can drag the camera feed around to a more comfortable position if you wish."
		label.font = .systemFont(ofSize: 14, weight: .regular)
		label.textColor = .secondaryLabel
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()

	let countdownView: UIView = {
		let view = UIView()
		view.backgroundColor = UIColor.black.withAlphaComponent(0.85)
		view.layer.cornerRadius = 16
		view.alpha = 0
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()

	let countdownLabel: UILabel = {
		let label = UILabel()
		label.textAlignment = .center
		label.numberOfLines = 1
		label.text = "3"
		label.font = .systemFont(ofSize: 48, weight: .semibold)
		label.textColor = .white
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()

	let loadingSpinner: UIActivityIndicatorView = {
		let spinner = UIActivityIndicatorView(style: .large)
		spinner.color = .white
		spinner.hidesWhenStopped = true
		spinner.translatesAutoresizingMaskIntoConstraints = false
		return spinner
	}()

	let cameraView: UIView = {
		let view = UIView()
		view.backgroundColor = .systemGray6
		view.layer.cornerRadius = 20
		view.clipsToBounds = true
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()

	let tryitYourselfButton: UIButton = {
		let button = UIButton(type: .system)
		button.backgroundColor = .systemBlue
		button.setTitle("Try it yourself!", for: .normal)
		button.setTitleColor(.white, for: .normal)
		button.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
		button.layer.cornerRadius = 14
		button.layer.shadowColor = UIColor.systemBlue.cgColor
		button.layer.shadowOpacity = 0.3
		button.layer.shadowOffset = CGSize(width: 0, height: 4)
		button.layer.shadowRadius = 8
		button.translatesAutoresizingMaskIntoConstraints = false
		return button
	}()

	let switchCameraButton: UIButton = {
		let button = UIButton(type: .system)
		button.backgroundColor = .systemBlue
		button.tintColor = .white
		button.setImage(UIImage(systemName: "arrow.triangle.2.circlepath.camera.fill"), for: .normal)
		button.imageView?.contentMode = .scaleAspectFit
		button.layer.cornerRadius = 25
		button.layer.shadowColor = UIColor.systemBlue.cgColor
		button.layer.shadowOpacity = 0.3
		button.layer.shadowOffset = CGSize(width: 0, height: 4)
		button.layer.shadowRadius = 8
		button.translatesAutoresizingMaskIntoConstraints = false
		return button
	}()

	// MARK: - View Lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()
		
		view.backgroundColor = .systemBackground
		
		tryitYourselfButton.addTarget(self, action: #selector(tryitYourselfButtonPressed), for: .touchUpInside)
		switchCameraButton.addTarget(self, action: #selector(switchCameraButtonPressed), for: .touchUpInside)
		
		setupViews()
		setupConstraints()
		setupGestures()
	}

	// MARK: - Setup

	private func setupViews() {
		view.addSubview(alphabetImageView)
		view.addSubview(gestureImageView)
		view.addSubview(instructionsLabel)
		view.addSubview(infoLabel)
		view.addSubview(cameraView)
		view.addSubview(tryitYourselfButton)
		view.addSubview(switchCameraButton)
		
		countdownView.addSubview(countdownLabel)
		countdownView.addSubview(loadingSpinner)
		view.addSubview(countdownView)
	}

	private func setupConstraints() {
		let imageSize = (UIScreen.main.bounds.width / 2) - 30
		
		NSLayoutConstraint.activate([
			// Alphabet Image
			alphabetImageView.widthAnchor.constraint(equalToConstant: imageSize),
			alphabetImageView.heightAnchor.constraint(equalToConstant: imageSize),
			alphabetImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
			alphabetImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
			
			// Gesture Image
			gestureImageView.widthAnchor.constraint(equalToConstant: imageSize),
			gestureImageView.heightAnchor.constraint(equalToConstant: imageSize),
			gestureImageView.leadingAnchor.constraint(equalTo: alphabetImageView.trailingAnchor, constant: 10),
			gestureImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
			gestureImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
			
			// Instructions Label
			instructionsLabel.topAnchor.constraint(equalTo: alphabetImageView.bottomAnchor, constant: 24),
			instructionsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
			instructionsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
			
			// Info Label
			infoLabel.topAnchor.constraint(equalTo: instructionsLabel.bottomAnchor, constant: 12),
			infoLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
			infoLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
			
			// Try It Button
			tryitYourselfButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			tryitYourselfButton.widthAnchor.constraint(equalToConstant: 220),
			tryitYourselfButton.heightAnchor.constraint(equalToConstant: 50),
			tryitYourselfButton.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: 32),
			
			// Camera View
			cameraView.widthAnchor.constraint(equalToConstant: 280),
			cameraView.heightAnchor.constraint(equalTo: cameraView.widthAnchor, multiplier: 1.0),
			cameraView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			cameraView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
			
			// Switch Camera Button
			switchCameraButton.widthAnchor.constraint(equalToConstant: 50),
			switchCameraButton.heightAnchor.constraint(equalTo: switchCameraButton.widthAnchor),
			switchCameraButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
			switchCameraButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
			
			// Countdown View
			countdownView.widthAnchor.constraint(equalToConstant: 80),
			countdownView.heightAnchor.constraint(equalToConstant: 80),
			countdownView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
			countdownView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			
			// Countdown Label
			countdownLabel.centerYAnchor.constraint(equalTo: countdownView.centerYAnchor),
			countdownLabel.centerXAnchor.constraint(equalTo: countdownView.centerXAnchor),
			
			// Loading Spinner
			loadingSpinner.centerYAnchor.constraint(equalTo: countdownView.centerYAnchor),
			loadingSpinner.centerXAnchor.constraint(equalTo: countdownView.centerXAnchor)
		])
	}

	private func setupGestures() {
		panGesture = UIPanGestureRecognizer(target: self, action: #selector(draggedView(_:)))
		cameraView.isUserInteractionEnabled = true
		cameraView.addGestureRecognizer(panGesture)
	}
	
	var cameraOutput: AVCapturePhotoOutput!
	var captureSession = AVCaptureSession()
	var previewLayer : AVCaptureVideoPreviewLayer!
	
	var selectedPosition = AVCaptureDevice.Position.front
	
	// This optional is force unwrapped because a failure to initialise the model is critical and termination is a suitable response.
	let deepLabV3 = try! DeepLabV3(configuration: .init()).model
	
	var aslClassifier: VNCoreMLModel = {
		let config = MLModelConfiguration()
		
		let aslClassifier = try! VNCoreMLModel(for: ASL(configuration: config).model)
		
		return aslClassifier
	}()
	
	override func viewDidAppear(_ animated: Bool) {
		startCameraAndSession()
		
		updateInfoText()
		updateGestureAndAlphabet()
	}
	
	override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
		super.viewWillTransition(to: size, with: coordinator)
		
		updateInfoText()
	}
	
	func updateGestureAndAlphabet() {
		instructionsLabel.text = "The image on the top right represents the American Sign Language gesture for the letter \(sharedViewModel.alphabets[sharedViewModel.currentAlphabetIndex]). Make sure only your hand is visible in frame."
		gestureImageView.image = UIImage(named: sharedViewModel.alphabets[sharedViewModel.currentAlphabetIndex] + "-GESTURE")
		alphabetImageView.image = UIImage(named: sharedViewModel.alphabets[sharedViewModel.currentAlphabetIndex])
	}
	
	func updateInfoText(error: String? = nil) {
		/* This function conditionally either
		 Warns the user to use portrait mode
		 or
		 Updates the instruction label
		 */
		
		UIView.animate(withDuration: 0.5, delay: 2.0, options: .curveEaseOut, animations: {
			self.infoLabel.alpha = 0.0
		}, completion: {_ in
			if let error = error {
				self.infoLabel.text = error
			} else {
				self.infoLabel.text = self.view.window?.windowScene?.interfaceOrientation != .portrait ? "For an ideal experience, please use ASLearn in portrait mode." : "Please press the \"Try it yourself!\" button and try to imitate the gesture indicated in the image above."
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
		
		if let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: selectedPosition),
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
		var image = UIImage(cgImage: cgImageRef, scale: 1.0, orientation: .leftMirrored)
		
		let x = removeBackgroundForImage(image: image)
		
		if let imageData = x.jpegData(compressionQuality: 1.0) {
			image = UIImage(data: imageData)!
		}
		
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
		
		let finalImage = UIImage(ciImage: compositedImage!).resized(to: originalSize)
		
		return finalImage
	}
	
	func handleClassification(request: VNRequest, error: Error?) {
		guard let observations = request.results as? [VNClassificationObservation] else { return }
		
		var predictedLetters: [[String : Float]] = []
		
		DispatchQueue.main.async { [self] in
			for observation in observations {
				print("Prediction: \(observation.identifier), Confidence: \(observation.confidence * 100)")
				predictedLetters.append([observation.identifier : observation.confidence])
			}
			print("\n")
			sharedViewModel.mostConfidentLetter = observations.first?.identifier ?? ""
			
			sharedViewModel.isLetterCorrect = ((predictedLetters.first(where: {$0.keys.first == sharedViewModel.alphabets[sharedViewModel.currentAlphabetIndex]})?.values.first ?? 0) * 100) >= 30
			
			sharedViewModel.shouldShowMainView.toggle()
		}
	}
	
	// MARK: - Button Actions
	@objc func switchCameraButtonPressed(_ sender: Any) {
		selectedPosition = (selectedPosition == .front ? .back : .front)
		startCameraAndSession()
	}
	
	@objc func tryitYourselfButtonPressed(_ sender: Any) {
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
	@objc func draggedView(_ sender:UIPanGestureRecognizer) {
		self.view.bringSubviewToFront(cameraView)
		let translation = sender.translation(in: self.view)
		cameraView.center = CGPoint(x: cameraView.center.x + translation.x, y: cameraView.center.y + translation.y)
		sender.setTranslation(CGPoint.zero, in: self.view)
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
