import Foundation
import AVFoundation
import RSBarcodes

class InventoryLoginViewController: UIViewController {
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "loginScanned:", name: "InventoryLoginNotification", object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        spinner.startAnimating()
        
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


    func loginScanned(notification:NSNotification) {
        println(notification.object)
        //notification.object as! String ?!
    }
    
    @IBAction func loginViaScannerButtonTouched(sender: AnyObject) {
       self.cameraAction()
    }
    
    func cameraAction() {
        let authStatus = AVCaptureDevice.authorizationStatusForMediaType(AVMediaTypeVideo)
        switch authStatus {
        case AVAuthorizationStatus.Authorized:
            var popoverContent = self.storyboard?.instantiateViewControllerWithIdentifier("InventoryLoginViaScanView") as! UIViewController
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
    
}
