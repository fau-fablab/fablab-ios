import UIKit
import AVFoundation
import RSBarcodes

class ProductsearchCodeScannerViewController: RSCodeReaderViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.cameraAction()
    }
    
    override func viewDidAppear(animated: Bool) {
        self.cameraAction()
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        self.navigationController?.navigationBarHidden = false
    }
    
    private func getProductIdFromBarcode(barcode: AVMetadataMachineReadableCodeObject) -> String{
        if (barcode.type == AVMetadataObjectTypeEAN13Code) {
            let productId = barcode.stringValue as NSString
            return productId.substringWithRange(NSRange(location: 8, length: 4))
        } else {
            let productId = barcode.stringValue as NSString
            return productId.substringWithRange(NSRange(location: 3, length: 4))
        }
    }
    
    private func scan(){
        self.focusMarkLayer.strokeColor = UIColor.greenColor().CGColor
        self.cornersLayer.strokeColor = UIColor.greenColor().CGColor
        
        self.barcodesHandler = { barcodes in
            self.session.stopRunning()
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                
                //TODO: CHANGE FOR REAL BARCODES
                //let productId = self.getProductIdFromBarcode(barcodes[0])
                let productId = "0009"
                self.tabBarController?.selectedIndex = 2
                NSNotificationCenter.defaultCenter().postNotificationName("ProductScannerNotification", object: productId)
            })
        }
        self.output.metadataObjectTypes = [AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeEAN13Code]
        
        
        for subview in self.view.subviews {
            self.view.bringSubviewToFront(subview as! UIView)
        }
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
        
        alert.addAction(UIAlertAction(title: "Abbrechen", style: .Default){
            UIAlertAction in
            dispatch_async(dispatch_get_main_queue()) {
                self.dismissViewControllerAnimated(true, completion:nil)
            }
        })

        
        alert.addAction(UIAlertAction(title: "Erlauben", style: .Cancel, handler: { (alert) -> Void in
            UIApplication.sharedApplication().openURL(NSURL(string: UIApplicationOpenSettingsURLString)!)
        }))
        self.presentViewController(alert, animated: true, completion: nil)
        
        
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
            self.dismissViewControllerAnimated(true, completion:nil)

        })
        self.dismissViewControllerAnimated(true, completion:nil)

    }
}