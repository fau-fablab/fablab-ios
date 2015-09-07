import UIKit
import AVFoundation
import RSBarcodes

class ProductsearchCodeScannerViewController: RSCodeReaderViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        self.cameraAction()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        self.navigationController?.navigationBarHidden = false
    }
    
    private func getProductIdFromBarcode(barcode: AVMetadataMachineReadableCodeObject) -> String{
        let productId = barcode.stringValue as NSString
        if (barcode.type == AVMetadataObjectTypeEAN13Code) {
            return productId.substringWithRange(NSRange(location: 8, length: 4))
        } else {
            return productId.substringWithRange(NSRange(location: 3, length: 4))
        }
    }
    
    private func scan(){
        self.focusMarkLayer.strokeColor = UIColor.greenColor().CGColor
        self.cornersLayer.strokeColor = UIColor.greenColor().CGColor
        
        self.barcodesHandler = { barcodes in
            self.session.stopRunning()
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                let productId = self.getProductIdFromBarcode(barcodes[0])
                Debug.instance.log("code:  \(barcodes[0]) id: \(productId)")
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
        #if (arch(i386) || arch(x86_64)) && os(iOS)
            //App runs inside a simulator, so no camera functionality
            showTextInputForSimulator()
        #else
            //App runs on a real device
            let authStatus = AVCaptureDevice.authorizationStatusForMediaType(AVMediaTypeVideo)
            switch authStatus {
                case AVAuthorizationStatus.Authorized:
                    self.scan()
                case AVAuthorizationStatus.Denied:
                    alertToEncourageCameraAccessInitially()
                case AVAuthorizationStatus.NotDetermined:
                    alertPromptToAllowCameraAccessViaSetting()
                default:
                    alertToEncourageCameraAccessInitially()
            }
        #endif
    }
    
    func alertToEncourageCameraAccessInitially(){
        var alert = UIAlertController(title: "Achtung".localized, message: "Es wird ein Zugriff auf die Kamera benötigt".localized, preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "Abbrechen".localized, style: .Default){
            UIAlertAction in
            dispatch_async(dispatch_get_main_queue()) {
                self.dismissViewControllerAnimated(true, completion:nil)
            }
        })

        
        alert.addAction(UIAlertAction(title: "Erlauben".localized, style: .Cancel, handler: { (alert) -> Void in
            UIApplication.sharedApplication().openURL(NSURL(string: UIApplicationOpenSettingsURLString)!)
        }))
        self.presentViewController(alert, animated: true, completion: nil)
        
        
    }
    
    func alertPromptToAllowCameraAccessViaSetting() {
        var alert = UIAlertController(title: "Achtung".localized, message: "Es wird ein Zugriff auf die Kamera benötigt".localized, preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "Abbrechen".localized, style: .Cancel) { alert in
           
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

// MARK: Simulator Debug View
extension ProductsearchCodeScannerViewController {
    
    func showTextInputForSimulator(){
        self.tabBarController?.view
        
        var inputTextField : UITextField?
        
        let doneAction: UIAlertAction = UIAlertAction(title: "Okay", style: .Default,
            handler: { (Void) -> Void in
                self.tabBarController?.selectedIndex = 2
                NSNotificationCenter.defaultCenter().postNotificationName("ProductScannerNotification", object: inputTextField?.text)
        })
        
        let alertController: UIAlertController = UIAlertController(title: "Produkt ID eingeben".localized, message: "Simulator", preferredStyle: .Alert)
        alertController.addTextFieldWithConfigurationHandler({ textField -> Void in
            inputTextField = textField
        })
        alertController.addAction(doneAction)
        presentViewController(alertController, animated: true, completion: nil)
    }
}