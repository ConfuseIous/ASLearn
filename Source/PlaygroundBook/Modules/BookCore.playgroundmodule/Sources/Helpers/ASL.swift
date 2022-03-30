//
// ASL.swift
//
// This file was automatically generated and should not be edited.
//

import CoreML


/// Model Prediction Input Type
@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
class ASLInput : MLFeatureProvider {

	/// keras_layer_input as 1 × 224 × 224 × 3 4-dimensional array of floats
	var keras_layer_input: MLMultiArray

	var featureNames: Set<String> {
		get {
			return ["keras_layer_input"]
		}
	}
	
	func featureValue(for featureName: String) -> MLFeatureValue? {
		if (featureName == "keras_layer_input") {
			return MLFeatureValue(multiArray: keras_layer_input)
		}
		return nil
	}
	
	init(keras_layer_input: MLMultiArray) {
		self.keras_layer_input = keras_layer_input
	}

	@available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
	convenience init(keras_layer_input: MLShapedArray<Float>) {
		self.init(keras_layer_input: MLMultiArray(keras_layer_input))
	}

}


/// Model Prediction Output Type
@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
class ASLOutput : MLFeatureProvider {

	/// Source provided by CoreML
	private let provider : MLFeatureProvider

	/// Identity as multidimensional array of floats
	lazy var Identity: MLMultiArray = {
		[unowned self] in return self.provider.featureValue(for: "Identity")!.multiArrayValue
	}()!

	/// Identity as multidimensional array of floats
	@available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
	var IdentityShapedArray: MLShapedArray<Float> {
		return MLShapedArray<Float>(self.Identity)
	}

	var featureNames: Set<String> {
		return self.provider.featureNames
	}
	
	func featureValue(for featureName: String) -> MLFeatureValue? {
		return self.provider.featureValue(for: featureName)
	}

	init(Identity: MLMultiArray) {
		self.provider = try! MLDictionaryFeatureProvider(dictionary: ["Identity" : MLFeatureValue(multiArray: Identity)])
	}

	init(features: MLFeatureProvider) {
		self.provider = features
	}
}


/// Class for model loading and prediction
@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
class ASL {
	let model: MLModel

	/// URL of model assuming it was installed in the same bundle as this class
	class var urlOfModelInThisBundle : URL {
		let bundle = Bundle(for: self)
		return bundle.url(forResource: "ASL", withExtension:"mlmodelc")!
	}

	/**
		Construct ASL instance with an existing MLModel object.

		Usually the application does not use this initializer unless it makes a subclass of ASL.
		Such application may want to use `MLModel(contentsOfURL:configuration:)` and `ASL.urlOfModelInThisBundle` to create a MLModel object to pass-in.

		- parameters:
		  - model: MLModel object
	*/
	init(model: MLModel) {
		self.model = model
	}

	/**
		Construct ASL instance by automatically loading the model from the app's bundle.
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
		Construct ASL instance with explicit path to mlmodelc file
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
		Construct ASL instance asynchronously with optional configuration.

		Model loading may take time when the model content is not immediately available (e.g. encrypted model). Use this factory method especially when the caller is on the main thread.

		- parameters:
		  - configuration: the desired model configuration
		  - handler: the completion handler to be called when the model loading completes successfully or unsuccessfully
	*/
	@available(macOS 11.0, iOS 14.0, tvOS 14.0, watchOS 7.0, *)
	class func load(configuration: MLModelConfiguration = MLModelConfiguration(), completionHandler handler: @escaping (Swift.Result<ASL, Error>) -> Void) {
		return self.load(contentsOf: self.urlOfModelInThisBundle, configuration: configuration, completionHandler: handler)
	}

	/**
		Construct ASL instance asynchronously with optional configuration.

		Model loading may take time when the model content is not immediately available (e.g. encrypted model). Use this factory method especially when the caller is on the main thread.

		- parameters:
		  - configuration: the desired model configuration
	*/
	@available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
	class func load(configuration: MLModelConfiguration = MLModelConfiguration()) async throws -> ASL {
		return try await self.load(contentsOf: self.urlOfModelInThisBundle, configuration: configuration)
	}

	/**
		Construct ASL instance asynchronously with URL of the .mlmodelc directory with optional configuration.

		Model loading may take time when the model content is not immediately available (e.g. encrypted model). Use this factory method especially when the caller is on the main thread.

		- parameters:
		  - modelURL: the URL to the model
		  - configuration: the desired model configuration
		  - handler: the completion handler to be called when the model loading completes successfully or unsuccessfully
	*/
	@available(macOS 11.0, iOS 14.0, tvOS 14.0, watchOS 7.0, *)
	class func load(contentsOf modelURL: URL, configuration: MLModelConfiguration = MLModelConfiguration(), completionHandler handler: @escaping (Swift.Result<ASL, Error>) -> Void) {
		MLModel.load(contentsOf: modelURL, configuration: configuration) { result in
			switch result {
			case .failure(let error):
				handler(.failure(error))
			case .success(let model):
				handler(.success(ASL(model: model)))
			}
		}
	}

	/**
		Construct ASL instance asynchronously with URL of the .mlmodelc directory with optional configuration.

		Model loading may take time when the model content is not immediately available (e.g. encrypted model). Use this factory method especially when the caller is on the main thread.

		- parameters:
		  - modelURL: the URL to the model
		  - configuration: the desired model configuration
	*/
	@available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
	class func load(contentsOf modelURL: URL, configuration: MLModelConfiguration = MLModelConfiguration()) async throws -> ASL {
		let model = try await MLModel.load(contentsOf: modelURL, configuration: configuration)
		return ASL(model: model)
	}

	/**
		Make a prediction using the structured interface

		- parameters:
		   - input: the input to the prediction as ASLInput

		- throws: an NSError object that describes the problem

		- returns: the result of the prediction as ASLOutput
	*/
	func prediction(input: ASLInput) throws -> ASLOutput {
		return try self.prediction(input: input, options: MLPredictionOptions())
	}

	/**
		Make a prediction using the structured interface

		- parameters:
		   - input: the input to the prediction as ASLInput
		   - options: prediction options

		- throws: an NSError object that describes the problem

		- returns: the result of the prediction as ASLOutput
	*/
	func prediction(input: ASLInput, options: MLPredictionOptions) throws -> ASLOutput {
		let outFeatures = try model.prediction(from: input, options:options)
		return ASLOutput(features: outFeatures)
	}

	/**
		Make a prediction using the convenience interface

		- parameters:
			- keras_layer_input as 1 × 224 × 224 × 3 4-dimensional array of floats

		- throws: an NSError object that describes the problem

		- returns: the result of the prediction as ASLOutput
	*/
	func prediction(keras_layer_input: MLMultiArray) throws -> ASLOutput {
		let input_ = ASLInput(keras_layer_input: keras_layer_input)
		return try self.prediction(input: input_)
	}

	/**
		Make a prediction using the convenience interface

		- parameters:
			- keras_layer_input as 1 × 224 × 224 × 3 4-dimensional array of floats

		- throws: an NSError object that describes the problem

		- returns: the result of the prediction as ASLOutput
	*/

	@available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
	func prediction(keras_layer_input: MLShapedArray<Float>) throws -> ASLOutput {
		let input_ = ASLInput(keras_layer_input: keras_layer_input)
		return try self.prediction(input: input_)
	}

	/**
		Make a batch prediction using the structured interface

		- parameters:
		   - inputs: the inputs to the prediction as [ASLInput]
		   - options: prediction options

		- throws: an NSError object that describes the problem

		- returns: the result of the prediction as [ASLOutput]
	*/
	func predictions(inputs: [ASLInput], options: MLPredictionOptions = MLPredictionOptions()) throws -> [ASLOutput] {
		let batchIn = MLArrayBatchProvider(array: inputs)
		let batchOut = try model.predictions(from: batchIn, options: options)
		var results : [ASLOutput] = []
		results.reserveCapacity(inputs.count)
		for i in 0..<batchOut.count {
			let outProvider = batchOut.features(at: i)
			let result =  ASLOutput(features: outProvider)
			results.append(result)
		}
		return results
	}
}
