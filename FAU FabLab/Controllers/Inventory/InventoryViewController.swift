
import Foundation
import AVFoundation
import RSBarcodes

class InventoryViewController : UIViewController {
    
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var loggedInLabel: UILabel!
    @IBOutlet weak var productAmountTF: UITextField!
    
    var username = String()
    var password = String()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func hideLogin(){
        loginView.hidden = true
    }
    
//BUTTONS
    @IBAction func addProductButtonTouched(sender: AnyObject) {
    }
    
    @IBAction func clearProductButtonTouched(sender: AnyObject) {
    }
   
    
    @IBAction func logoutButtonTouched(sender: AnyObject) {
        var refreshAlert = UIAlertController(title: "Abmelden", message: "Möchtest du dich abmelden?", preferredStyle: UIAlertControllerStyle.Alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Ja", style: .Default, handler: { (action: UIAlertAction!) in
            var inventoryLogin = InventoryLogin()
            inventoryLogin.deleteUser()
            self.loginView.hidden = false
            
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Doch nicht", style: .Default, handler: { (action: UIAlertAction!) in
        }))
        
        presentViewController(refreshAlert, animated: true, completion: nil)
    }
    
    
    @IBAction func scanProductCode(sender: AnyObject) {
        self.cameraAction()
    }
    
    func cameraAction() {
        let authStatus = AVCaptureDevice.authorizationStatusForMediaType(AVMediaTypeVideo)
        switch authStatus {
        case AVAuthorizationStatus.Authorized:
            var popoverContent = self.storyboard?.instantiateViewControllerWithIdentifier("InventoryItemScanView") as! UIViewController
            var nav = UINavigationController(rootViewController: popoverContent)
            nav.modalPresentationStyle = UIModalPresentationStyle.Popover
            var popover = nav.popoverPresentationController
            
            self.presentViewController(nav, animated: true, completion: nil)
            
        case AVAuthorizationStatus.Denied: alertToEncourageCameraAccessInitially()
        case AVAuthorizationStatus.NotDetermined: alertPromptToAllowCameraAccessViaSetting()
        default: alertToEncourageCameraAccessInitially()
        }
    }
    
    func alertToEncourageCameraAccessInitially(){
        var alert = UIAlertController(title: "Achtung".localized, message: "Es wird ein Zugriff auf die Kamera benötigt".localized, preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "Abbrechen".localized, style: .Default, handler: { (alert) -> Void in
            dispatch_async(dispatch_get_main_queue()) {
                self.dismissViewControllerAnimated(true, completion:nil)
            }
        }))
        
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
            })
    }
    
    
//    private func getProductIdFromBarcode(barcode: AVMetadataMachineReadableCodeObject) -> String{
//        let productId = barcode.stringValue as NSString
//        if (barcode.type == AVMetadataObjectTypeEAN13Code) {
//            return productId.substringWithRange(NSRange(location: 8, length: 4))
//        } else {
//            return productId.substringWithRange(NSRange(location: 3, length: 4))
//        }
//    }
}