//
//  ViewController.swift
//  Shutter 3
//
//  Created by Mario Kardum on 04/05/2018.
//  Copyright © 2018 dumar022. All rights reserved.
//

import UIKit
import  AVFoundation

class ViewController: UIViewController {
    
    // Outlets
    
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var shutterButton: UIButton!
    @IBOutlet weak var flashButtonOff: UIButton!
    @IBOutlet weak var signatureCreatorButton: UIButton!
    @IBOutlet weak var toggleCameraButton: UIButton!
    
    // Gestures
    
    var zoomInGesture = UISwipeGestureRecognizer()
    var zoomOutGesture = UISwipeGestureRecognizer()    
    @IBOutlet var focusTapGesture: UITapGestureRecognizer!
    
    // Functions
    
    var captureSession = AVCaptureSession()
    var photoOutput: AVCapturePhotoOutput?
    var cameraPreview: AVCaptureVideoPreviewLayer?
    
    
    // Device
    
    var backCamera: AVCaptureDevice?
    var frontCamera: AVCaptureDevice?
    var currentCamera: AVCaptureDevice?
    var flashMode = AVCaptureDevice.FlashMode.off
    
    //
    @IBOutlet weak var names: UILabel!
    
    var image: UIImage?
    
    var textStr: String?
    var theFont: UIFont?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCaptureSession()
        setupDevice()
        setupInputOutput()
        setupPreviewLayer()
        captureSession.startRunning()
        
        zoomInGesture.direction = .right
        zoomInGesture.addTarget(self, action: #selector(zoomIn))
        view.addGestureRecognizer(zoomInGesture)
        
        zoomOutGesture.direction = .left
        zoomOutGesture.addTarget(self, action: #selector(zoomOut))
        view.addGestureRecognizer(zoomOutGesture)
        
       
        
        
        
    }
        override func viewDidLayoutSubviews() {
          cameraPreview?.frame = cameraView.bounds
        if let photoImage = cameraPreview ,(photoImage.connection?.isVideoOrientationSupported)! {
          photoImage.connection?.videoOrientation = UIApplication.shared.statusBarOrientation.videoOrientation!
     }
     }
    
    override func viewDidAppear(_ animated: Bool) {
        if let x = UserDefaults.standard.object(forKey: "myName") as? String {
            names.text = x
        }
        
        if let y = UserDefaults.standard.object(forKey: "supak") {
            names.font = UIFont(name: y as! String, size: 16)
        }
        
    }
    
    
    func setupCaptureSession()  {
        captureSession.sessionPreset = AVCaptureSession.Preset .photo
    }
    func setupDevice() {
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera], mediaType: AVMediaType.video, position: AVCaptureDevice.Position.unspecified)
        let devices = deviceDiscoverySession.devices
        
        for device in devices {
            if device.position == AVCaptureDevice.Position.back {
                backCamera = device
            } else if device.position == AVCaptureDevice.Position.front {
                frontCamera = device
            }
        }
        currentCamera = backCamera
    }
    
    
    func setupInputOutput() {
        do {
            
            let captureDeviceInput = try AVCaptureDeviceInput(device: currentCamera!)
            captureSession.addInput(captureDeviceInput)
            photoOutput = AVCapturePhotoOutput()
            photoOutput!.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey : AVVideoCodecType.jpeg])], completionHandler: nil)
            captureSession.addOutput(photoOutput!)
        } catch {
            print(error)
        }
    }
    
    func setupPreviewLayer() {
        cameraPreview = AVCaptureVideoPreviewLayer(session: captureSession)
        cameraPreview?.frame = cameraView.bounds
        self.cameraPreview?.connection?.videoOrientation = AVCaptureVideoOrientation.portrait

        cameraPreview?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        self.cameraView.layer.insertSublayer(self.cameraPreview!, at: 0)
        
        
    }
    
    @objc func zoomIn() {
        if let zoomFactor = currentCamera?.videoZoomFactor {
            if zoomFactor < 5.0 {
                let newZoomFactor = min(zoomFactor + 1.0, 5.0)
                do {
                    try currentCamera?.lockForConfiguration()
                    currentCamera?.ramp(toVideoZoomFactor: newZoomFactor, withRate: 1.0)
                    currentCamera?.unlockForConfiguration()
                } catch {
                    print(error)
                }
            }
        }
    }
    
    @objc func zoomOut() {
        if let zoomFactor = currentCamera?.videoZoomFactor {
            if zoomFactor > 1.0 {
                let newZoomFactor = max(zoomFactor - 1.0, 1.0)
                do {
                    try currentCamera?.lockForConfiguration()
                    currentCamera?.ramp(toVideoZoomFactor: newZoomFactor, withRate: 1.0)
                    currentCamera?.unlockForConfiguration()
                } catch {
                    print(error)
                }
            }
        }
    }
    
    @IBAction func focusTapGestureAction(_ sender: UITapGestureRecognizer) {
        if (sender.state == .ended) {
            let thisFocusPoint = sender.location(in: cameraView)
            
            print("touch to focus ", thisFocusPoint)
            
            let focus_x = thisFocusPoint.x / cameraView.frame.size.width
            let focus_y = thisFocusPoint.y / cameraView.frame.size.height
            
            if (currentCamera!.isFocusModeSupported(.autoFocus) && currentCamera!.isFocusPointOfInterestSupported) {
                do {
                    try currentCamera?.lockForConfiguration()
                    currentCamera?.focusMode = .autoFocus
                    currentCamera?.focusPointOfInterest = CGPoint(x: focus_x, y: focus_y)
                    
                    if (currentCamera!.isExposureModeSupported(.autoExpose) && currentCamera!.isExposurePointOfInterestSupported) {
                        currentCamera?.exposureMode = .autoExpose;
                        currentCamera?.exposurePointOfInterest = CGPoint(x: focus_x, y: focus_y);
                    }
                    
                    currentCamera?.unlockForConfiguration()
                } catch {
                    print(error)
                }
            }
        }
        
    }
    
    @IBAction func flashButtonAction(_ sender: Any) {
        if flashMode == .on {
            flashMode = .off
            flashButtonOff.setImage(#imageLiteral(resourceName: "unnamed-4"), for: .normal)
        }
        else {
            flashMode = .on
            flashButtonOff.setImage(#imageLiteral(resourceName: "superlood"), for: .normal)
        }
        
    }
    
    @IBAction func toggleCameraButtonAction(_ sender: Any) {
        captureSession.beginConfiguration()
        let awesomeDevice = (currentCamera?.position == AVCaptureDevice.Position.back) ? frontCamera : backCamera
        for input in captureSession.inputs {
            captureSession.removeInput(input as! AVCaptureDeviceInput)
            let cameraInput:AVCaptureDeviceInput
            do {
                cameraInput = try AVCaptureDeviceInput(device: awesomeDevice!)
            } catch {
                print(error)
                return
            }
            
            if captureSession.canAddInput(cameraInput) {
                captureSession.addInput(cameraInput)
            }
            
            currentCamera = awesomeDevice
            captureSession.commitConfiguration()
        }
    }
    
    @IBAction func shutterButtonAction(_ sender: Any) {
        let settings = AVCapturePhotoSettings()
        settings.flashMode = self.flashMode
        self.photoOutput?.capturePhoto(with: settings, delegate: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "noviseg2" {
            let previewViewController = segue.destination as! PreviewAndEdit
            previewViewController.image = self.image
            var neki = segue.destination as! PreviewAndEdit
            neki.finalText = names.text!
            neki.finalFont = names.font
    
        }
        
    }
    
    @IBAction func signatureCreatorAction(_ sender: Any) {
        performSegue(withIdentifier: "sig_seg", sender: nil)
    }
    
    
    @IBAction func memeMakerAction(_ sender: Any) {
        performSegue(withIdentifier: "Meme1seg", sender: nil)
    }
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
      
    }


}

extension ViewController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let imageData = photo.fileDataRepresentation()
            
        {
            self.image = UIImage(data: imageData)
            image = image?.fixOrientation()
            performSegue(withIdentifier: "noviseg2", sender: nil)
        }
    }
}


extension UIImage {
    
    func fixOrientation() -> UIImage {
        
        // No-op if the orientation is already correct
        if ( self.imageOrientation == UIImageOrientation.up ) {
            return self;
        }
        
        // We need to calculate the proper transformation to make the image upright.
        // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
        var transform: CGAffineTransform = CGAffineTransform.identity
        
        if ( self.imageOrientation == UIImageOrientation.down || self.imageOrientation == UIImageOrientation.downMirrored ) {
            transform = transform.translatedBy(x: self.size.width, y: self.size.height)
            transform = transform.rotated(by: CGFloat(Double.pi))
        }
        
        if ( self.imageOrientation == UIImageOrientation.left || self.imageOrientation == UIImageOrientation.leftMirrored ) {
            transform = transform.translatedBy(x: self.size.width, y: 0)
            transform = transform.rotated(by: CGFloat(Double.pi / 2.0))
        }
        
        if ( self.imageOrientation == UIImageOrientation.right || self.imageOrientation == UIImageOrientation.rightMirrored ) {
            transform = transform.translatedBy(x: 0, y: self.size.height);
            transform = transform.rotated(by: CGFloat(-Double.pi / 2.0));
        }
        
        if ( self.imageOrientation == UIImageOrientation.upMirrored || self.imageOrientation == UIImageOrientation.downMirrored ) {
            transform = transform.translatedBy(x: self.size.width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        }
        
        if ( self.imageOrientation == UIImageOrientation.leftMirrored || self.imageOrientation == UIImageOrientation.rightMirrored ) {
            transform = transform.translatedBy(x: self.size.height, y: 0);
            transform = transform.scaledBy(x: -1, y: 1);
        }
        
        // Now we draw the underlying CGImage into a new context, applying the transform
        // calculated above.
        let ctx: CGContext = CGContext(data: nil, width: Int(self.size.width), height: Int(self.size.height),
                                       bitsPerComponent: self.cgImage!.bitsPerComponent, bytesPerRow: 0,
                                       space: self.cgImage!.colorSpace!,
                                       bitmapInfo: self.cgImage!.bitmapInfo.rawValue)!;
        
        ctx.concatenate(transform)
        
        if ( self.imageOrientation == UIImageOrientation.left ||
            self.imageOrientation == UIImageOrientation.leftMirrored ||
            self.imageOrientation == UIImageOrientation.right ||
            self.imageOrientation == UIImageOrientation.rightMirrored ) {
            ctx.draw(self.cgImage!, in: CGRect(x: 0,y: 0,width: self.size.height,height: self.size.width))
        } else {
            ctx.draw(self.cgImage!, in: CGRect(x: 0,y: 0,width: self.size.width,height: self.size.height))
        }
        
        // And now we just create a new UIImage from the drawing context and return it
        return UIImage(cgImage: ctx.makeImage()!)
    }
}

extension UIInterfaceOrientation {
   var videoOrientation: AVCaptureVideoOrientation? {
    switch self {
  case .portraitUpsideDown: return .portraitUpsideDown
     case .landscapeRight: return .landscapeRight
   case .landscapeLeft: return .landscapeLeft
 case .portrait: return .portrait
 default: return nil
}
}
}

