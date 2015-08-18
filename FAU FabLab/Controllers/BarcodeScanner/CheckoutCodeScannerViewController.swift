import UIKit
import AVFoundation
import RSBarcodes

class CheckoutCodeScannerViewController: RSCodeReaderViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.cameraAction()
    }
    
    private func scan(){
        self.focusMarkLayer.strokeColor = UIColor.greenColor().CGColor
        self.cornersLayer.strokeColor = UIColor.greenColor().CGColor
        
        self.barcodesHandler = { barcodes in
            self.session.stopRunning()
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                let checkoutCode = barcodes[0].stringValue
                
                
                self.dismissViewControllerAnimated(true, completion:nil )
                
                NSNotificationCenter.defaultCenter().postNotificationName("CheckoutScannerNotification", object: checkoutCode)
                
            })
            
        }
        
        self.output.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
        
        
        for subview in self.view.subviews {
            self.view.bringSubviewToFront(subview as! UIView)
        }

    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        self.navigationController?.navigationBarHidden = false
    }
    
    @IBAction func backButtonTouched(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion:nil )
    }
    func cameraAction() {
        let authStatus = AVCaptureDevice.authorizationStatusForMediaType(AVMediaTypeVideo)
        switch authStatus {
        case AVAuthorizationStatus.Authorized:
            self.scan()
            
        case AVAuthorizationStatus.Denied: alertToEncourageCameraAccessInitially()
        case AVAuthorizationStatus.NotDetermined: alertPromptToAllowCameraAccessViaSetting()
        default: alertToEncourageCameraAccessInitially()
        }
        
    }
    
    func alertToEncourageCameraAccessInitially(){
        var alert = UIAlertController(title: "Achtung", message: "Es wird ein Zugriff auf die Kamera benötigt", preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "Abbrechen", style: .Default, handler: { (alert) -> Void in
            dispatch_async(dispatch_get_main_queue()) {
                self.tabBarController?.selectedIndex = 0
            }
        }))

        alert.addAction(UIAlertAction(title: "Erlauben", style: .Cancel, handler: { (alert) -> Void in
            UIApplication.sharedApplication().openURL(NSURL(string: UIApplicationOpenSettingsURLString)!)
        }))
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func alertPromptToAllowCameraAccessViaSetting() {
        var alert = UIAlertController(title: "Achtung", message: "Es wird ein Zugriff auf die Kamera benötigt", preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "Abbrechen", style: .Cancel) { alert in
            if AVCaptureDevice.devicesWithMediaType(AVMediaTypeVideo).count > 0 {
                AVCaptureDevice.requestAccessForMediaType(AVMediaTypeVideo) { granted in
                    dispatch_async(dispatch_get_main_queue()) {
                        self.cameraAction()
                    }
                }
            }
        })
        dispatch_async(dispatch_get_main_queue()) {
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    
    
}