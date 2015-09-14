
import Foundation
import AVFoundation
import RSBarcodes

class InventoryViewController : UIViewController {
    
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var loggedInLabel: UILabel!
    
    @IBOutlet weak var productNameTF: UITextField!
    @IBOutlet weak var productAmountTF: UITextField!
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    private var productSearchModel = ProductsearchModel()

    var currentItem = InventoryItem()
    var user = User()
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "inventoryItemScanned:", name: "InventoryItemScanned", object: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginView.hidden = false
        self.currentItem.setUUID(NSUUID().UUIDString)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        spinner.stopAnimating()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func loginWasSuccessful(user: User){
        self.loggedInLabel.text = "Angemeldet als:".localized + " \(user.username!)"
        self.user = user
        loginView.hidden = true
    }
    
//BUTTONS
    @IBAction func addProductButtonTouched(sender: AnyObject) {
        spinner.startAnimating()
       
        if ((currentItem.productId) != nil){
            if count(productAmountTF.text) > 0 {
                let value = productAmountTF.text.doubleValue as Double?
                if  nil != value {
                    self.currentItem.setAmount(value!)
                    let api = InventoryApi()
                    api.add(self.user, item: self.currentItem, onCompletion: {
                        items, err in
                        if(err != nil){
                            self.showErrorMessage("Fehler:".localized, message: "\(err)")
                        }else{
                            self.showErrorMessage("Produkt Hinzugefügt".localized, message: "Das Produkt wurde zur Liste hinzugefügt".localized)
                            self.currentItem = InventoryItem()
                            self.productAmountTF.text = ""
                            self.productNameTF.text = ""
                        }
                    })
                }else{
                    self.showErrorMessage("Ungültiger Wert".localized, message: "Bitte gültigen Betrag eingeben (Integer/Double)".localized)
                }
            }else{
                self.showErrorMessage("Betrag Eingeben".localized, message: "Bitte erst einen Betrag eingeben".localized)
            }
        }else{
            self.showErrorMessage("Produkt wählen".localized, message: "Bitte erst ein Produkt auswählen.".localized)
        }
        spinner.stopAnimating()
    }
    
    @IBAction func clearProductButtonTouched(sender: AnyObject) {
    }
   
    
    @IBAction func logoutButtonTouched(sender: AnyObject) {
        var alert = UIAlertController(title: "Abmelden".localized, message: "Möchtest du dich abmelden?".localized, preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "Ja".localized, style: .Default, handler: { (action: UIAlertAction!) in
            var inventoryLogin = InventoryLogin()
            inventoryLogin.deleteUser()
            self.loginView.hidden = false
            
        }))
        
        alert.addAction(UIAlertAction(title: "Doch nicht".localized, style: .Default, handler: { (action: UIAlertAction!) in
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
                    self.productForInventoryFound(self.productSearchModel.getFirstProduct())
                    
                }else{
                    var alert = UIAlertController(title: "Fehler".localized, message: "Kein Produkt gefunden!".localized, preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "Danke".localized, style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                }
                self.spinner.stopAnimating()
            })
        })

    }
    
//ProductSearched (triggert by productSearchView and by scanner if product could be found)
    func productForInventoryFound(product: Product) {
        self.productNameTF.text = product.name
        self.currentItem.setProductId(product.productId!)
        self.currentItem.setProductName(product.name!)
        self.currentItem.setUser(self.user.username!)
        self.productAmountTF.text = ""
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

    func showErrorMessage(title: String, message: String){
        var alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Oh".localized, style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
}

extension String {
    struct NumberFormatter {
        static let instance = NSNumberFormatter()
    }
    var doubleValue:Double? {
        return NumberFormatter.instance.numberFromString(self)?.doubleValue
    }
}