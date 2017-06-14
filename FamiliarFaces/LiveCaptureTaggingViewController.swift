//
//  LiveCaptureTaggingViewController.swift
//  Created by Adib Contractor on 6/9/17.
//

import UIKit
import CoreMedia
import Vision

class LiveCaptureTaggingViewController: LiveCaptureViewController {
    private var faceLayers = [CAShapeLayer]()
    
    override func processBufferCaptured(buffer: CMSampleBuffer!, faceDetectionRequest: VNDetectFaceRectanglesRequest) {
        DispatchQueue.main.async { [unowned self] in
            self.faceLayers.forEach{ $0.removeFromSuperlayer() }
            self.faceLayers.removeAll()
            
            guard let results = faceDetectionRequest.results, results.count > 0 else {
                return
            }
            
            for observation in faceDetectionRequest.results as! [VNFaceObservation] {
                let layer = CAShapeLayer()
                let rect = observation.boundingBox.denormalized(newRect: self.view.frame)
                let path = UIBezierPath(rect: rect)
                
                layer.path = path.cgPath
                layer.fillColor = UIColor.clear.cgColor
                layer.strokeColor = UIColor.yellow.cgColor
                layer.lineWidth = 4
                self.view.layer.addSublayer(layer)
                self.faceLayers.append(layer)
            }
        }
    }
}
