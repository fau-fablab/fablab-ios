import Foundation
import AVFoundation
import RSBarcodes

class InventoryLoginViewController: UIViewController {
    
    
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    let inventoryLogin = InventoryLoginModel()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "inventoryUserScanned:", name: "InventoryUserScanned", object: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if inventoryLogin.notLoggedIn(){
            login(inventoryLogin.getUser())
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        spinner.stopAnimating()
    }

    
    @IBAction func loginButtonTouched(sender: AnyObject) {
        let user = User()
        user.setUsername(username.text!)
        user.setPassword(password.text!)
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
            let popoverContent = self.storyboard?.instantiateViewControllerWithIdentifier("InventoryLoginViaScanView")
            let nav = UINavigationController(rootViewController: popoverContent!)
            nav.modalPresentationStyle = UIModalPresentationStyle.Popover
            
            self.presentViewController(nav, animated: true, completion: nil)
            
        case AVAuthorizationStatus.Denied: alertToEncourageCameraAccessInitially()
        case AVAuthorizationStatus.NotDetermined: alertPromptToAllowCameraAccessViaSetting()
        default: alertToEncourageCameraAccessInitially()
        }
    }
    
    func alertToEncourageCameraAccessInitially(){
        let alert = UIAlertController(title: "Achtung".localized, message: "Es wird ein Zugriff auf die Kamera benötigt".localized, preferredStyle: UIAlertControllerStyle.Alert)
        
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
        let alert = UIAlertController(title: "Achtung".localized, message: "Es wird ein Zugriff auf die Kamera benötigt".localized, preferredStyle: UIAlertControllerStyle.Alert)
        
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
        let api = UserApi()
        api.getUserInfo(user, onCompletion: {
            user, err in
            self.spinner.stopAnimating()
            
            if(err != nil){
               print(err)
                dispatch_async(dispatch_get_main_queue()) {
                    let alert = UIAlertController(title: "Fehler".localized, message: "Name oder Passwort falsch".localized, preferredStyle: UIAlertControllerStyle.Alert)
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
        self.resignFirstResponder()
        self.view.endEditing(true)
        let parentView = self.parentViewController as! InventoryViewController
        parentView.loginWasSuccessful(user)
    }
    
}
