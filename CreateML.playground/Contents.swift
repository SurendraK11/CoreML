import CreateML
import Foundation

// Get the path of training images directory
let trainingImagesDirectoryPath = URL(fileURLWithPath: "/Users/surendra/Desktop/Buzzmove/RealTimeCameraObjectDetectionWithMachineLearning/CoreML2/Training")
print(trainingImagesDirectoryPath)

//Let's train the model with training images
let model = try MLImageClassifier(trainingData: .labeledDirectories(at: trainingImagesDirectoryPath))

// Get the path of test images directory
let testImagesDirectoryPath = URL(fileURLWithPath: "/Users/surendra/Desktop/Buzzmove/RealTimeCameraObjectDetectionWithMachineLearning/CoreML2/Test")
print(testImagesDirectoryPath)

// Let's evaluate the trained model :)
let evaluation = model.evaluation(on: .labeledDirectories(at: testImagesDirectoryPath))

//Save the model at spcific path
try model.write(to: URL(fileURLWithPath: "/Users/surendra/Desktop/Buzzmove/RealTimeCameraObjectDetectionWithMachineLearning/CoreML2/BuzzModel.mlmodel"))

