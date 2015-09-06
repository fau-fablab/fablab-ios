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
        if(inventoryLogin.username != nil && isLoginValid(inventoryLogin.username!, password: inventoryLogin.password!)){
            loginWasSuccessful(inventoryLogin.username!, password: inventoryLogin.password!)
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        spinner.stopAnimating()
    }

    
    @IBAction func loginButtonTouched(sender: AnyObject) {
        var user = InventoryUser()
        user.setUsername(username.text)
        user.setPassword(password.text)
        self.tryToLogin(user)
    }

    func inventoryUserScanned(notification:NSNotification) {
        self.tryToLogin(notification.object as! InventoryUser)
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
    
    
    func tryToLogin(user: InventoryUser){
        if(isLoginValid(user.username!, password: user.password!)){
            inventoryLogin.saveUser(user.username!, password: user.password!)
            loginWasSuccessful(user.username!, password: user.password!)
        }else{
             dispatch_async(dispatch_get_main_queue()) {
                var alert = UIAlertController(title: "Fehler".localized, message: "Name oder Passwort falsch".localized, preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Oh".localized, style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
    }
    
    private func isLoginValid(username: String, password: String) -> Bool{
        spinner.startAnimating()
        //TODO send to server and check is login is correct
        spinner.stopAnimating()
        return true
    }
    
    private func loginWasSuccessful(username: String, password: String){
        var parentView = self.parentViewController as! InventoryViewController
        parentView.currentItem.setUser(username)
        parentView.loggedInLabel.text = "Angemeldet als: \(username)"
        parentView.hideLogin()
    }
    
}
