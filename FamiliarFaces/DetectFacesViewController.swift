//
//  DetectFacesViewController.swift
//  Created by Adib Contractor on 6/13/17.
//

import UIKit
import Vision
import CoreMedia

class DetectFacesViewController: UIViewController {
    
    private var imageView : UIImageView? = nil
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let image = UIImage.init(named: "faces")
        imageView = UIImageView(frame: view.frame)
        imageView!.image = image
        imageView!.contentMode = .scaleToFill
        view.addSubview(imageView!)
        detectFaces(image: imageView!.image!)
    }
    
    func detectFaces(image: UIImage)
    {
        let faceDetectionRequest = VNDetectFaceRectanglesRequest()
        let myRequestHandler = VNImageRequestHandler(cgImage: image.cgImage!, options: [:])
        try! myRequestHandler.perform([faceDetectionRequest])
        
        DispatchQueue.main.async { [weak self] in
            guard let results = faceDetectionRequest.results,
                results.count > 0,
                let imageView = self?.imageView else {
                    return
            }
            
            for observation in faceDetectionRequest.results as! [VNFaceObservation] {
                let layer = CAShapeLayer()
                let rect = observation.boundingBox.denormalized(newRect: imageView.frame)
                let path = UIBezierPath(rect: rect)
                
                layer.path = path.cgPath
                layer.fillColor = UIColor.clear.cgColor
                layer.strokeColor = UIColor.yellow.cgColor
                layer.lineWidth = 4
                imageView.layer.addSublayer(layer)
            }
        }
    }
}

extension CGRect {
    func denormalized(newRect: CGRect) -> CGRect
    {
        let viewWidth = newRect.size.width
        let viewHeight = newRect.size.height
        let standardRect = self.standardized
        let width = standardRect.size.width * viewWidth
        let height = standardRect.size.height * viewHeight
        let x = standardRect.origin.x * viewWidth
        let y = viewHeight - (standardRect.origin.y * viewHeight) - height
        
        return CGRect(x: x, y: y, width: width, height: height)
    }
}
