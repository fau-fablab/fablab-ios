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
    
    
    private func scan(){
        self.focusMarkLayer.strokeColor = UIColor.greenColor().CGColor
        self.cornersLayer.strokeColor = UIColor.greenColor().CGColor
        
        self.barcodesHandler = { barcodes in
            self.session.stopRunning()
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                if barcodes[0].type == AVMetadataObjectTypeQRCode{
                    let checkoutCode = barcodes[0].stringValue
                    let prefix = (checkoutCode as NSString).substringToIndex(3)
                    if prefix == "FAU" {
                        let alert = UIAlertController(title: "Achtung".localized, message: "Bezahlprozess einleiten?".localized,    preferredStyle: UIAlertControllerStyle.Alert)
                        
                        alert.addAction(UIAlertAction(title: "Gerne".localized, style: .Default, handler: {
                            (alert) -> Void in
                            
                            let cartViewController = self.storyboard!.instantiateViewControllerWithIdentifier("CartView") as! CartViewController
                            self.navigationController?.pushViewController(cartViewController, animated: true)
                            NSNotificationCenter.defaultCenter().postNotificationName("CheckoutScannerNotification", object: checkoutCode)
                        }))
                        
                        alert.addAction(UIAlertAction(title: "Doch nicht".localized, style: .Cancel, handler: { (alert) -> Void in
                            self.session.startRunning()
                        }))
                        self.presentViewController(alert, animated: true, completion: nil)
                        
                    }else{
                        let alert = UIAlertController(title: "Fehler".localized, message: "Kein gültiger Code!".localized, preferredStyle: UIAlertControllerStyle.Alert)
                        alert.addAction(UIAlertAction(title: "OK".localized, style: UIAlertActionStyle.Default, handler: nil))
                        self.presentViewController(alert, animated: true, completion: nil)
                        self.session.startRunning()
                    }
                }else{
                    let productId = BarcodeScannerHelper.getProductIdFromBarcode(barcodes[0])
                    Debug.instance.log("code:  \(barcodes[0]) id: \(productId)")
                    self.displayProductSearchForCode(productId)
                }
            })
        }
        self.output.metadataObjectTypes = [AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeQRCode]
        
        for subview in self.view.subviews {
            self.view.bringSubviewToFront(subview)
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
        let alert = UIAlertController(title: "Achtung".localized, message: "Es wird ein Zugriff auf die Kamera benötigt".localized, preferredStyle: UIAlertControllerStyle.Alert)
        
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
        let alert = UIAlertController(title: "Achtung".localized, message: "Es wird ein Zugriff auf die Kamera benötigt".localized, preferredStyle: UIAlertControllerStyle.Alert)
        
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
    
    func displayProductSearchForCode(code: String){
        
        var tabBarControllers = self.tabBarController?.viewControllers
        let controllers  = tabBarControllers!.filter { $0 is ProductsearchTabViewController }
        let productSearchController = controllers.first as! ProductsearchTabViewController
        let productsearchViewController = productSearchController.viewControllers.first as! ProductsearchViewController
        productsearchViewController.setScannedBarcode(code)
        for(var i = 0; i < tabBarControllers!.count; i++){
            if tabBarControllers![i] == controllers.first{
                self.tabBarController?.selectedIndex = i
            }
        }
        
        
    }
}

// MARK: Simulator Debug View
extension ProductsearchCodeScannerViewController {
    
    func showTextInputForSimulator(){
        self.tabBarController?.view
        
        var inputTextField : UITextField?
        
        let doneAction: UIAlertAction = UIAlertAction(title: "Okay", style: .Default,
            handler: { (Void) -> Void in
             self.displayProductSearchForCode(inputTextField!.text!)
             
        })
        
        let alertController: UIAlertController = UIAlertController(title: "Produkt ID eingeben".localized, message: "Simulator", preferredStyle: .Alert)
        alertController.addTextFieldWithConfigurationHandler({ textField -> Void in
            inputTextField = textField
        })
        alertController.addAction(doneAction)
        presentViewController(alertController, animated: true, completion: nil)
    }
}