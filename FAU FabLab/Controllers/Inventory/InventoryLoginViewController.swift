import Foundation
import AVFoundation
import RSBarcodes

class InventoryLoginViewController: UIViewController {
    
     var inventoryLogin = InventoryLogin()
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "inventoryUserScanned:", name: "InventoryUserScanned", object: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        var user = inventoryLogin.getUser()
        println(user)
        login(user)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        spinner.stopAnimating()
    }

    
    @IBAction func loginButtonTouched(sender: AnyObject) {
        var user = User()
        user.setUsername(username.text)
        user.setPassword(password.text)
        self.login(user)
    }

    func inventoryUserScanned(notification:NSNotification) {
        self.login(notification.object as! User)
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
    
    private func login(user: User) -> Bool{
        spinner.startAnimating()
        var api = UserApi()
        api.getUserInfo(user, onCompletion: {
            user, err in
            self.spinner.stopAnimating()
            
            if(err != nil){
               println(err)
                dispatch_async(dispatch_get_main_queue()) {
                    var alert = UIAlertController(title: "Fehler".localized, message: "Name oder Passwort falsch".localized, preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "Oh".localized, style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            }
            else{
                self.inventoryLogin.saveUser(user!)
                self.loginWasSuccessful(user!)
            }
        })
        
        return true
    }
    
    private func loginWasSuccessful(user: User){
        var parentView = self.parentViewController as! InventoryViewController
        parentView.loginWasSuccessful(user)
    }
    
}
