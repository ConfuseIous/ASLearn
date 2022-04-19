//
// DeepLabV3.swift
//
// This file was automatically generated and should not be edited.
//

import CoreML


/// Model Prediction Input Type
@available(macOS 10.14, iOS 12.0, tvOS 12.0, watchOS 5.0, *)
class DeepLabV3Input : MLFeatureProvider {

	/// Input image to be segmented as color (kCVPixelFormatType_32BGRA) image buffer, 513 pixels wide by 513 pixels high
	var image: CVPixelBuffer

	var featureNames: Set<String> {
		get {
			return ["image"]
		}
	}
	
	func featureValue(for featureName: String) -> MLFeatureValue? {
		if (featureName == "image") {
			return MLFeatureValue(pixelBuffer: image)
		}
		return nil
	}
	
	init(image: CVPixelBuffer) {
		self.image = image
	}

	@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
	convenience init(imageWith image: CGImage) throws {
		self.init(image: try MLFeatureValue(cgImage: image, pixelsWide: 513, pixelsHigh: 513, pixelFormatType: kCVPixelFormatType_32ARGB, options: nil).imageBufferValue!)
	}

	@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
	convenience init(imageAt image: URL) throws {
		self.init(image: try MLFeatureValue(imageAt: image, pixelsWide: 513, pixelsHigh: 513, pixelFormatType: kCVPixelFormatType_32ARGB, options: nil).imageBufferValue!)
	}

	@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
	func setImage(with image: CGImage) throws  {
		self.image = try MLFeatureValue(cgImage: image, pixelsWide: 513, pixelsHigh: 513, pixelFormatType: kCVPixelFormatType_32ARGB, options: nil).imageBufferValue!
	}

	@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
	func setImage(with image: URL) throws  {
		self.image = try MLFeatureValue(imageAt: image, pixelsWide: 513, pixelsHigh: 513, pixelFormatType: kCVPixelFormatType_32ARGB, options: nil).imageBufferValue!
	}

}


/// Model Prediction Output Type
@available(macOS 10.14, iOS 12.0, tvOS 12.0, watchOS 5.0, *)
class DeepLabV3Output : MLFeatureProvider {

	/// Source provided by CoreML
	private let provider : MLFeatureProvider

	/// Array of integers of the same size as the input image, where each value represents the class of the corresponding pixel. as 513 by 513 matrix of 32-bit integers
	lazy var semanticPredictions: MLMultiArray = {
		[unowned self] in return self.provider.featureValue(for: "semanticPredictions")!.multiArrayValue
	}()!

	/// Array of integers of the same size as the input image, where each value represents the class of the corresponding pixel. as 513 by 513 matrix of 32-bit integers
	@available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
	var semanticPredictionsShapedArray: MLShapedArray<Int32> {
		return MLShapedArray<Int32>(self.semanticPredictions)
	}

	var featureNames: Set<String> {
		return self.provider.featureNames
	}
	
	func featureValue(for featureName: String) -> MLFeatureValue? {
		return self.provider.featureValue(for: featureName)
	}

	init(semanticPredictions: MLMultiArray) {
		self.provider = try! MLDictionaryFeatureProvider(dictionary: ["semanticPredictions" : MLFeatureValue(multiArray: semanticPredictions)])
	}

	init(features: MLFeatureProvider) {
		self.provider = features
	}
}


/// Class for model loading and prediction
@available(macOS 10.14, iOS 12.0, tvOS 12.0, watchOS 5.0, *)
class DeepLabV3 {
	let model: MLModel

	/// URL of model assuming it was installed in the same bundle as this class
	class var urlOfModelInThisBundle : URL {
		let bundle = Bundle(for: self)
		return bundle.url(forResource: "DeepLabV3", withExtension:"mlmodelc")!
	}

	/**
		Construct DeepLabV3 instance with an existing MLModel object.

		Usually the application does not use this initializer unless it makes a subclass of DeepLabV3.
		Such application may want to use `MLModel(contentsOfURL:configuration:)` and `DeepLabV3.urlOfModelInThisBundle` to create a MLModel object to pass-in.

		- parameters:
		  - model: MLModel object
	*/
	init(model: MLModel) {
		self.model = model
	}

	/**
		Construct DeepLabV3 instance by automatically loading the model from the app's bundle.
	*/
	@available(*, deprecated, message: "Use init(configuration:) instead and handle errors appropriately.")
	convenience init() {
		try! self.init(contentsOf: type(of:self).urlOfModelInThisBundle)
	}

	/**
		Construct a model with configuration

		- parameters:
		   - configuration: the desired model configuration

		- throws: an NSError object that describes the problem
	*/
	convenience init(configuration: MLModelConfiguration) throws {
		try self.init(contentsOf: type(of:self).urlOfModelInThisBundle, configuration: configuration)
	}

	/**
		Construct DeepLabV3 instance with explicit path to mlmodelc file
		- parameters:
		   - modelURL: the file url of the model

		- throws: an NSError object that describes the problem
	*/
	convenience init(contentsOf modelURL: URL) throws {
		try self.init(model: MLModel(contentsOf: modelURL))
	}

	/**
		Construct a model with URL of the .mlmodelc directory and configuration

		- parameters:
		   - modelURL: the file url of the model
		   - configuration: the desired model configuration

		- throws: an NSError object that describes the problem
	*/
	convenience init(contentsOf modelURL: URL, configuration: MLModelConfiguration) throws {
		try self.init(model: MLModel(contentsOf: modelURL, configuration: configuration))
	}

	/**
		Construct DeepLabV3 instance asynchronously with optional configuration.

		Model loading may take time when the model content is not immediately available (e.g. encrypted model). Use this factory method especially when the caller is on the main thread.

		- parameters:
		  - configuration: the desired model configuration
		  - handler: the completion handler to be called when the model loading completes successfully or unsuccessfully
	*/
	@available(macOS 11.0, iOS 14.0, tvOS 14.0, watchOS 7.0, *)
	class func load(configuration: MLModelConfiguration = MLModelConfiguration(), completionHandler handler: @escaping (Swift.Result<DeepLabV3, Error>) -> Void) {
		return self.load(contentsOf: self.urlOfModelInThisBundle, configuration: configuration, completionHandler: handler)
	}

	/**
		Construct DeepLabV3 instance asynchronously with optional configuration.

		Model loading may take time when the model content is not immediately available (e.g. encrypted model). Use this factory method especially when the caller is on the main thread.

		- parameters:
		  - configuration: the desired model configuration
	*/
	@available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
	class func load(configuration: MLModelConfiguration = MLModelConfiguration()) async throws -> DeepLabV3 {
		return try await self.load(contentsOf: self.urlOfModelInThisBundle, configuration: configuration)
	}

	/**
		Construct DeepLabV3 instance asynchronously with URL of the .mlmodelc directory with optional configuration.

		Model loading may take time when the model content is not immediately available (e.g. encrypted model). Use this factory method especially when the caller is on the main thread.

		- parameters:
		  - modelURL: the URL to the model
		  - configuration: the desired model configuration
		  - handler: the completion handler to be called when the model loading completes successfully or unsuccessfully
	*/
	@available(macOS 11.0, iOS 14.0, tvOS 14.0, watchOS 7.0, *)
	class func load(contentsOf modelURL: URL, configuration: MLModelConfiguration = MLModelConfiguration(), completionHandler handler: @escaping (Swift.Result<DeepLabV3, Error>) -> Void) {
		MLModel.load(contentsOf: modelURL, configuration: configuration) { result in
			switch result {
			case .failure(let error):
				handler(.failure(error))
			case .success(let model):
				handler(.success(DeepLabV3(model: model)))
			}
		}
	}

	/**
		Construct DeepLabV3 instance asynchronously with URL of the .mlmodelc directory with optional configuration.

		Model loading may take time when the model content is not immediately available (e.g. encrypted model). Use this factory method especially when the caller is on the main thread.

		- parameters:
		  - modelURL: the URL to the model
		  - configuration: the desired model configuration
	*/
	@available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
	class func load(contentsOf modelURL: URL, configuration: MLModelConfiguration = MLModelConfiguration()) async throws -> DeepLabV3 {
		let model = try await MLModel.load(contentsOf: modelURL, configuration: configuration)
		return DeepLabV3(model: model)
	}

	/**
		Make a prediction using the structured interface

		- parameters:
		   - input: the input to the prediction as DeepLabV3Input

		- throws: an NSError object that describes the problem

		- returns: the result of the prediction as DeepLabV3Output
	*/
	func prediction(input: DeepLabV3Input) throws -> DeepLabV3Output {
		return try self.prediction(input: input, options: MLPredictionOptions())
	}

	/**
		Make a prediction using the structured interface

		- parameters:
		   - input: the input to the prediction as DeepLabV3Input
		   - options: prediction options

		- throws: an NSError object that describes the problem

		- returns: the result of the prediction as DeepLabV3Output
	*/
	func prediction(input: DeepLabV3Input, options: MLPredictionOptions) throws -> DeepLabV3Output {
		let outFeatures = try model.prediction(from: input, options:options)
		return DeepLabV3Output(features: outFeatures)
	}

	/**
		Make a prediction using the convenience interface

		- parameters:
			- image: Input image to be segmented as color (kCVPixelFormatType_32BGRA) image buffer, 513 pixels wide by 513 pixels high

		- throws: an NSError object that describes the problem

		- returns: the result of the prediction as DeepLabV3Output
	*/
	func prediction(image: CVPixelBuffer) throws -> DeepLabV3Output {
		let input_ = DeepLabV3Input(image: image)
		return try self.prediction(input: input_)
	}

	/**
		Make a batch prediction using the structured interface

		- parameters:
		   - inputs: the inputs to the prediction as [DeepLabV3Input]
		   - options: prediction options

		- throws: an NSError object that describes the problem

		- returns: the result of the prediction as [DeepLabV3Output]
	*/
	func predictions(inputs: [DeepLabV3Input], options: MLPredictionOptions = MLPredictionOptions()) throws -> [DeepLabV3Output] {
		let batchIn = MLArrayBatchProvider(array: inputs)
		let batchOut = try model.predictions(from: batchIn, options: options)
		var results : [DeepLabV3Output] = []
		results.reserveCapacity(inputs.count)
		for i in 0..<batchOut.count {
			let outProvider = batchOut.features(at: i)
			let result =  DeepLabV3Output(features: outProvider)
			results.append(result)
		}
		return results
	}
}
