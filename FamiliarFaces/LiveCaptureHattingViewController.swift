//
//  LiveCaptureHattingViewController.swift
//  Created by Adib Contractor on 6/9/17.
//

import UIKit
import Vision
import CoreMedia

class LiveCaptureHattingViewController: LiveCaptureViewController {
    private var hats = [UIImageView]()
    private var currentPixelBuffer : CMSampleBuffer? = nil
    
    override func processBufferCaptured(buffer: CMSampleBuffer!, faceDetectionRequest: VNDetectFaceRectanglesRequest) {
        currentPixelBuffer = buffer
        
        DispatchQueue.main.async { [unowned self] in
            self.hats.forEach { $0.removeFromSuperview() }
            self.hats.forEach { $0.isHidden = true }
            
            guard let results = faceDetectionRequest.results, results.count > 0 else {
                return
            }
            
            var faceNumber = 1
            for observation in faceDetectionRequest.results as! [VNFaceObservation] {
                let rect = observation.boundingBox.denormalized(newRect: self.view.frame)
                
                let hatWidth = rect.size.width
                let hatHeight = rect.size.height
                let hatX = rect.origin.x - hatWidth/4
                let hatY = rect.origin.y - hatHeight
                let hatRect = CGRect(x: hatX, y: hatY, width: hatWidth, height: hatHeight)
                
                var hat : UIImageView? = nil
                if faceNumber >= self.hats.count {
                    hat = UIImageView(frame: hatRect)
                    hat!.image = UIImage.init(named: "hat")
                    self.hats.append(hat!)
                }
                else {
                    hat = self.hats[faceNumber]
                    hat!.frame = hatRect
                }
                
                self.view.addSubview(hat!)
                hat!.isHidden = false
                
                faceNumber += 1
            }
        }
    }
}

extension LiveCaptureHattingViewController {
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        takeScreenShot()
    }
    
    func takeScreenShot()
    {
        guard let currentPixelBuffer = currentPixelBuffer else {
            return
        }
        
        let frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
        let photoView = UIView(frame: frame)
        let imageView = UIImageView(frame: frame)
        imageView.image = imageFromBuffer(buffer: currentPixelBuffer)
        imageView.contentMode = UIViewContentMode.scaleAspectFill
        photoView.addSubview(imageView)
        hats.forEach{ photoView.addSubview($0) }
        
        UIGraphicsBeginImageContext(photoView.frame.size)
        photoView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let imageRef = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        UIImageWriteToSavedPhotosAlbum(imageRef!, nil, nil, nil)
    }
    
    private func imageFromBuffer(buffer: CMSampleBuffer) -> UIImage?
    {
        guard let imageBuffer = CMSampleBufferGetImageBuffer(buffer) else { return nil }
        let ciImage = CIImage(cvPixelBuffer: imageBuffer)
        guard let cgImage = CIContext().createCGImage(ciImage, from: ciImage.extent) else { return nil }
        return UIImage(cgImage: cgImage)
    }
}
