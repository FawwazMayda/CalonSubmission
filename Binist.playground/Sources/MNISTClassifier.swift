import Foundation

//
// MNISTClassifier.swift
//
// This file was automatically generated and should not be edited.
//

import CoreML


/// Model Prediction Input Type
@available(macOS 10.13, iOS 11.0, tvOS 11.0, watchOS 4.0, *)
public class MNISTClassifierInput : MLFeatureProvider {

    /// Image of the digit drawing to be classified as grayscale (kCVPixelFormatType_OneComponent8) image buffer, 28 pixels wide by 28 pixels high
    var image: CVPixelBuffer
    
    public var featureNames: Set<String> {
        get {
            return ["image"]
        }
    }
    
    public func featureValue(for featureName: String) -> MLFeatureValue? {
        if (featureName == "image") {
            return MLFeatureValue(pixelBuffer: image)
        }
        return nil
    }
    
    init(image: CVPixelBuffer) {
        self.image = image
    }
}

/// Model Prediction Output Type
@available(macOS 10.13, iOS 11.0, tvOS 11.0, watchOS 4.0, *)
public class MNISTClassifierOutput : MLFeatureProvider {

    /// Source provided by CoreML

    private let provider : MLFeatureProvider


    /// Probability of each digit as dictionary of 64-bit integers to doubles
    lazy var labelProbabilities: [Int64 : Double] = {
        [unowned self] in return self.provider.featureValue(for: "labelProbabilities")!.dictionaryValue as! [Int64 : Double]
    }()

    /// Most likely digit as integer value
    lazy var classLabel: Int64 = {
        [unowned self] in return self.provider.featureValue(for: "classLabel")!.int64Value
    }()

    public var featureNames: Set<String> {
        return self.provider.featureNames
    }
    
    public func featureValue(for featureName: String) -> MLFeatureValue? {
        return self.provider.featureValue(for: featureName)
    }

    init(labelProbabilities: [Int64 : Double], classLabel: Int64) {
        self.provider = try! MLDictionaryFeatureProvider(dictionary: ["labelProbabilities" : MLFeatureValue(dictionary: labelProbabilities as [AnyHashable : NSNumber]), "classLabel" : MLFeatureValue(int64: classLabel)])
    }

    init(features: MLFeatureProvider) {
        self.provider = features
    }
}


/// Class for model loading and prediction
@available(macOS 10.13, iOS 11.0, tvOS 11.0, watchOS 4.0, *)
public class MNISTClassifier {
    public var model: MLModel

/// URL of model assuming it was installed in the same bundle as this class
    public class var urlOfModelInThisBundle : URL {
        let bundle = Bundle(for: MNISTClassifier.self)
        return bundle.url(forResource: "MNISTClassifier", withExtension:"mlmodelc")!
    }

    /**
        Construct a model with explicit path to mlmodelc file
        - parameters:
           - url: the file url of the model
           - throws: an NSError object that describes the problem
    */
    public init(contentsOf url: URL) throws {
        self.model = try MLModel(contentsOf: url)
    }

    /// Construct a model that automatically loads the model from the app's bundle
    public convenience init() {
        try! self.init(contentsOf: type(of:self).urlOfModelInThisBundle)
    }

    /**
        Construct a model with configuration
        - parameters:
           - configuration: the desired model configuration
           - throws: an NSError object that describes the problem
    */
    @available(macOS 10.14, iOS 12.0, tvOS 12.0, watchOS 5.0, *)
    public convenience init(configuration: MLModelConfiguration) throws {
        try self.init(contentsOf: type(of:self).urlOfModelInThisBundle, configuration: configuration)
    }

    /**
        Construct a model with explicit path to mlmodelc file and configuration
        - parameters:
           - url: the file url of the model
           - configuration: the desired model configuration
           - throws: an NSError object that describes the problem
    */
    @available(macOS 10.14, iOS 12.0, tvOS 12.0, watchOS 5.0, *)
    public init(contentsOf url: URL, configuration: MLModelConfiguration) throws {
        self.model = try MLModel(contentsOf: url, configuration: configuration)
    }

    /**
        Make a prediction using the structured interface
        - parameters:
           - input: the input to the prediction as MNISTClassifierInput
        - throws: an NSError object that describes the problem
        - returns: the result of the prediction as MNISTClassifierOutput
    */
    func prediction(input: MNISTClassifierInput) throws -> MNISTClassifierOutput {
        return try self.prediction(input: input, options: MLPredictionOptions())
    }

    /**
        Make a prediction using the structured interface
        - parameters:
           - input: the input to the prediction as MNISTClassifierInput
           - options: prediction options
        - throws: an NSError object that describes the problem
        - returns: the result of the prediction as MNISTClassifierOutput
    */
    func prediction(input: MNISTClassifierInput, options: MLPredictionOptions) throws -> MNISTClassifierOutput {
        let outFeatures = try model.prediction(from: input, options:options)
        return MNISTClassifierOutput(features: outFeatures)
    }

    /**
        Make a prediction using the convenience interface
        - parameters:
            - image: Image of the digit drawing to be classified as grayscale (kCVPixelFormatType_OneComponent8) image buffer, 28 pixels wide by 28 pixels high
        - throws: an NSError object that describes the problem
        - returns: the result of the prediction as MNISTClassifierOutput
    */
    func prediction(image: CVPixelBuffer) throws -> MNISTClassifierOutput {
        let input_ = MNISTClassifierInput(image: image)
        return try self.prediction(input: input_)
    }

    /**
        Make a batch prediction using the structured interface
        - parameters:
           - inputs: the inputs to the prediction as [MNISTClassifierInput]
           - options: prediction options
        - throws: an NSError object that describes the problem
        - returns: the result of the prediction as [MNISTClassifierOutput]
    */
    @available(macOS 10.14, iOS 12.0, tvOS 12.0, watchOS 5.0, *)
    func predictions(inputs: [MNISTClassifierInput], options: MLPredictionOptions = MLPredictionOptions()) throws -> [MNISTClassifierOutput] {
        let batchIn = MLArrayBatchProvider(array: inputs)
        let batchOut = try model.predictions(from: batchIn, options: options)
        var results : [MNISTClassifierOutput] = []
        results.reserveCapacity(inputs.count)
        for i in 0..<batchOut.count {
            let outProvider = batchOut.features(at: i)
            let result =  MNISTClassifierOutput(features: outProvider)
            results.append(result)
        }
        return results
    }
}
