//
//  LiveCaptureViewController.swift
//  Created by Adib Contractor on 6/14/17.
//

import Foundation
import UIKit
import AVFoundation
import Vision

class LiveCaptureViewController: UIViewController {
    public let cameraCapture = CameraCapture()
    private var videoPreviewLayer : AVCaptureVideoPreviewLayer?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        cameraCapture.delegate = self
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: cameraCapture.captureSession)
        videoPreviewLayer!.videoGravity = AVLayerVideoGravity.resize
        videoPreviewLayer!.connection?.videoOrientation = AVCaptureVideoOrientation.landscapeRight
        view.layer.addSublayer(videoPreviewLayer!)
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        videoPreviewLayer!.frame = view.layer.bounds
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return .landscapeRight
    }
    
    func processBufferCaptured(buffer: CMSampleBuffer!, faceDetectionRequest: VNDetectFaceRectanglesRequest)
    {
        // Override this
    }
}

extension LiveCaptureViewController : CameraCaptureDelegate {
    func bufferCaptured(buffer: CMSampleBuffer!)
    {
        guard let pixelBuffer : CVPixelBuffer = CMSampleBufferGetImageBuffer(buffer) else { return }
        
        let faceDetectionRequest = VNDetectFaceRectanglesRequest()
        let myRequestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:])
        try! myRequestHandler.perform([faceDetectionRequest])
        
        processBufferCaptured(buffer: buffer, faceDetectionRequest: faceDetectionRequest)
    }
}
