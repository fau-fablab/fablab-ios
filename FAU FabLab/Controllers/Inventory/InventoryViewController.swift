
import Foundation
import AVFoundation
import RSBarcodes

class InventoryViewController : UIViewController {
    
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var loggedInLabel: UILabel!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    @IBOutlet weak var productNameTF: UITextField!
    @IBOutlet weak var productAmountTF: UITextField!
    
    
    private var productSearchModel = ProductsearchModel()

    var currentItem = InventoryItem()
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "inventoryItemScanned:", name: "InventoryItemScanned", object: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginView.hidden = false
        spinner.stopAnimating()
        self.currentItem.setUUID(NSUUID().UUIDString)
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
        var alert = UIAlertController(title: "Abmelden", message: "Möchtest du dich abmelden?", preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "Ja", style: .Default, handler: { (action: UIAlertAction!) in
            var inventoryLogin = InventoryLogin()
            inventoryLogin.deleteUser()
            self.loginView.hidden = false
            
        }))
        
        alert.addAction(UIAlertAction(title: "Doch nicht", style: .Default, handler: { (action: UIAlertAction!) in
        }))
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
    
//OBSERVER (triggert by scanner)
    
    func inventoryItemScanned(notification:NSNotification) {
        spinner.startAnimating()
        println(notification.object)
        productSearchModel.searchProductById(notification.object as! String, onCompletion: { err in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                println(self.productSearchModel.getFirstProduct())
                if(self.productSearchModel.getNumberOfProducts() > 0){
                    var product = self.productSearchModel.getFirstProduct()
                    self.productNameTF.text = product.name
                    self.currentItem.setProductId(product.productId!)
                    self.currentItem.setProductName(product.name!)
                    self.currentItem.setAmount(0)
                    
                    self.productAmountTF.text = ""
                    
                }else{
                    var alert = UIAlertController(title: "Fehler".localized, message: "Kein Produkt gefunden!".localized, preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "Danke".localized, style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                }
                self.spinner.stopAnimating()
            })
        })

    }
    
    
    
//CAMERA
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
}