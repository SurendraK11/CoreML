//
//  ViewController.swift
//  RealTimeCameraObjectDetectionWithMachineLearning
//
//  Created by Surendra on 21/01/2019.
//  Copyright © 2019 Buzzmove. All rights reserved.
//

import UIKit
import AVKit
import Vision

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        guard let captureDevice = AVCaptureDevice.default(for: .video) else {
            return
        }
        
        guard let deviceInput = try? AVCaptureDeviceInput(device: captureDevice) else {
            return
        }
        
        let captureSession = AVCaptureSession()
        captureSession.sessionPreset = .photo
        captureSession.addInput(deviceInput)
        captureSession.startRunning()
        
        let videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        
        self.view.layer.addSublayer(videoPreviewLayer)
        videoPreviewLayer.frame = self.view.frame
        
        let captureVideoDataOutput = AVCaptureVideoDataOutput()
        captureVideoDataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
        captureSession.addOutput(captureVideoDataOutput)
    }
    
}

extension ViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return
        }
        guard let coreMLModel = try? VNCoreMLModel(for: BuzzModel().model) else {
            return
        }
        let request = VNCoreMLRequest(model: coreMLModel) { (finishedRequest, err) in
            guard err == nil else {
                return
            }
            
            guard let results = finishedRequest.results as? [VNClassificationObservation] else {
                return
            }
            
            guard let firstObservation = results.first else {
                return
            }
            
            if firstObservation.confidence == 1 {
                print("firstObservation : \(firstObservation.identifier)   \(firstObservation.confidence)")
            }
        }
        let ciImage = CIImage(cvImageBuffer: pixelBuffer)
        let handler = VNImageRequestHandler(ciImage: ciImage)
        
        DispatchQueue.global(qos: .userInteractive).async {
            do {
                try handler.perform([request])
            } catch {
                print(error)
            }
        }
        
    }
    
}
