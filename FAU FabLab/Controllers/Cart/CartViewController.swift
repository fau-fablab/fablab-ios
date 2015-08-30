import UIKit
import AVFoundation
import RSBarcodes
import CoreActionSheetPicker
import MessageUI

class CartViewController : UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var labelTotalPrice: UILabel!
    
    private var checkoutButton : UIBarButtonItem {
        return self.navigationItem.rightBarButtonItem!
    }
    private var cartModel = CartModel.sharedInstance
    private var cartEntryCellIdentifier = "CartEntryCustomCell"
    private let noLocationSetIdentifier = "unknown location"
    private let modelOutOfStock = MalfunctionInfoModel()
    private var productSearchModel = ProductsearchModel()
    
    private var selectedIndexPath: NSIndexPath?
    private var selectedProduct: CartProduct?
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "checkoutCodeScanned:", name: "CheckoutScannerNotification", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "checkoutStatusChanged:", name: "CheckoutStatusChangedNotification", object: nil)
    }
    
    @IBAction func buttonChangeAmountPressed(sender: AnyObject) {
        var picker: ActionSheetCustomPicker = ActionSheetCustomPicker()
        var doneButton: UIBarButtonItem = UIBarButtonItem()
        doneButton.title = "Übernehmen".localized
        doneButton.tintColor = UIColor.fabLabGreen()
        
        var cancelButton: UIBarButtonItem = UIBarButtonItem()
        cancelButton.title = "Abbrechen".localized
        cancelButton.tintColor = UIColor.fabLabGreen()
        
        picker.setDoneButton(doneButton)
        picker.setCancelButton(cancelButton)
        picker.title = "Menge auswählen".localized
        picker.tapDismissAction = TapAction.Cancel
        let cartEntry = self.cartModel.cart.getEntry(selectedIndexPath!.row)
        picker.delegate = ActionSheetPickerDelegate(unit: cartEntry.product.unit, price: cartEntry.product.price, didSucceedAction: { (amount: Int) -> Void in
            CartModel.sharedInstance.updateProductInCart(self.selectedIndexPath!.row, amount: Double(amount))
            self.tableView.reloadData();
            self.tableView.setEditing(false, animated: true)
            self.showTotalPrice()
            }, didCancelAction:{ (Void) -> Void in self.tableView.setEditing(false, animated: true)} )
        picker.showActionSheetPicker()
    }
    
    private var emailBody: String{
        return "Produkt ist nicht mehr auf Lager.</br></br><b>Produkt ID :</b> </br>"
            + "\(selectedProduct!.id)</br> </br> <b>Produkt Name :</b> </br> \(selectedProduct!.name)"
            + "</br></br> Gesendet mit der Fablab-iOS App"
    }
    
    @IBAction func buttonReportOutOfStockPressed(sender: AnyObject) {
        var picker = MFMailComposeViewController()
        picker.mailComposeDelegate = self
        picker.navigationBar.tintColor = UIColor.fabLabGreen()
        picker.setToRecipients([modelOutOfStock.fablabMail!])
        picker.setSubject("Bestandsmeldung".localized)
        picker.setMessageBody(emailBody, isHTML: true)
        
        presentViewController(picker, animated: true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        Debug.instance.log(segue.identifier)
        if segue.identifier == "ProductLocationSegueCart" {
            let destination = segue.destinationViewController as? ProductLocationViewController
            
            let cell = tableView.cellForRowAtIndexPath(selectedIndexPath!) as! CartEntryCustomCell;
            
            let locationId = selectedProduct!.id // TODO
            let productName = selectedProduct!.name
            
            destination!.configure(id: locationId, name: productName)
        }
    }
    
    private func showTotalPrice(){
        labelTotalPrice.text = String(format: "%.2f€".localized, cartModel.cart.getPrice());
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        showTotalPrice()
    }
    
    override func viewWillAppear(animated: Bool) {
        tableView.reloadData()
        refreshCheckoutButton()
        showTotalPrice()
    }
   
    // we have to unregister all observers!
    override func viewWillDisappear(animated: Bool) {
        for cell in tableView.visibleCells() {
            (cell as! CartEntryCustomCell).ignoreFrameChanges()
        }
    }
    
    func refreshCheckoutButton() {
        if (cartModel.getNumberOfProductsInCart() > 0) {
            checkoutButton.enabled = true
        } else {
            checkoutButton.enabled = false
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartModel.cart.getCount()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cartEntryCellIdentifier) as? CartEntryCustomCell
        let cartEntry = cartModel.cart.getEntry(indexPath.row)
        cell!.configure(cartEntry.product.name, unit: "\(Int(cartEntry.amount)) \(cartEntry.product.unit)", price: cartEntry.product.price * cartEntry.amount)
        cell!.selectionStyle = UITableViewCellSelectionStyle.None
       
        println(cartEntry.product.locationStringForMap)
        println(cartEntry.product.locationStringForMap )
        println(cartEntry.product.locationStringForMap )
        
        if(cartEntry.product.locationStringForMap == noLocationSetIdentifier){
            cell?.disableProdctLocationButton()
        }else{
            cell?.enableProdctLocationButton()
        }
        
        return cell!;
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        /*
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            CartModel.sharedInstance.removeProductFromCart(indexPath.row)
            tableView.reloadData()
            showTotalPrice()
        }
        */
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if (tableView == self.tableView) {
            (cell as! CartEntryCustomCell).watchFrameChanges()
        }
    }
    
    func tableView(tableView: UITableView, didEndDisplayingCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if (tableView == self.tableView) {
            (cell as! CartEntryCustomCell).ignoreFrameChanges()
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let previousIndexPath = selectedIndexPath
        if indexPath == selectedIndexPath {
            selectedIndexPath = nil
        } else {
            selectedIndexPath = indexPath
        }
        var indexPaths : Array<NSIndexPath> = []
        if let previous = previousIndexPath{
            indexPaths += [previous]
        }
        if let current = selectedIndexPath {
            indexPaths += [current]
        }
        if indexPaths.count > 0 {
            tableView.reloadRowsAtIndexPaths(indexPaths, withRowAnimation: UITableViewRowAnimation.Automatic)
        }
        tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Top, animated: true)
        selectedProduct = cartModel.cart.getEntry(indexPath.row).product
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if (indexPath == selectedIndexPath){
            return CartEntryCustomCell.expandedHeight
        } else{
            return CartEntryCustomCell.defaultHeight
        }
    }
    
    /*                      Checkout process            */
    //Observer -> Scanner
    func checkoutCodeScanned(notification:NSNotification) {
        cartModel.sendCartToServer(notification.object as! String)
    }
    
    //Observer -> Status changed
    func checkoutStatusChanged(notification:NSNotification) {
        if let newStatus = CartStatus(rawValue: notification.object as! String) {
            switch(newStatus){
                case CartStatus.SHOPPING:
                    //cart is still @shopping -> error happend -> Code was wrong
                    let alertView = UIAlertView(title: "Fehler".localized, message: "Der gescannte Code wurde nicht akzeptiert. Bitte den Code vom Kassenterminal scannen.".localized, delegate: nil, cancelButtonTitle: "OK".localized)
                    alertView.show()
                
                case CartStatus.PENDING:
                    var popoverContent = self.storyboard?.instantiateViewControllerWithIdentifier("PayOrCancelView") as! PayOrCancelViewController
                    var nav = UINavigationController(rootViewController: popoverContent)
                    nav.modalPresentationStyle = UIModalPresentationStyle.Popover
                    var popover = nav.popoverPresentationController
                    self.presentViewController(nav, animated: true, completion: nil)
              
                case CartStatus.PAID:
                    let alertView = UIAlertView(title: "Bezahlt".localized, message: "Ihr Warenkorb wurde erfolgreich bezahlt".localized, delegate: nil, cancelButtonTitle: "OK".localized)
                    alertView.show()
                
                case CartStatus.CANCELLED:
                    let alertView = UIAlertView(title: "Abgebrochen".localized, message: "Bezahlvorgang wurde abgebrochen".localized, delegate: nil, cancelButtonTitle: "OK".localized)
                    alertView.show()
                
                case CartStatus.FAILED:
                    let alertView = UIAlertView(title: "Fehlgeschlagen".localized, message: "Bezahlvorgang ist Fehlgeschlagen".localized, delegate: nil, cancelButtonTitle: "OK".localized)
                    alertView.show()
                
            }
        }
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]? {
        var deleteAction = UITableViewRowAction(style: .Default, title: "Löschen".localized) { (action: UITableViewRowAction!, indexPath: NSIndexPath!) -> Void in
            CartModel.sharedInstance.removeProductFromCart(indexPath.row)
            CartNavigationButtonController.sharedInstance.updateBadge()
            tableView.reloadData()
            self.refreshCheckoutButton()
            self.showTotalPrice()
        }
        return [deleteAction]
    }
    

    //Gets sure that app has permissions to access the camera.
    
    @IBAction func startCheckout(sender: AnyObject) {
        self.cameraAction()
    }
    
    func cameraAction() {
        let authStatus = AVCaptureDevice.authorizationStatusForMediaType(AVMediaTypeVideo)
        switch authStatus {
            case AVAuthorizationStatus.Authorized:
                var popoverContent = self.storyboard?.instantiateViewControllerWithIdentifier("CheckoutCodeScanner") as! UIViewController
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

extension CartViewController : MFMailComposeViewControllerDelegate{
    
    func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
        dismissViewControllerAnimated(true, completion: nil)
        switch result.value{
        case MFMailComposeResultCancelled.value:
            var alert = UIAlertController(title: "Abgebrochen".localized, message: "Meldung wurde nicht versendet!".localized, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK".localized, style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            
        case MFMailComposeResultSent.value:
            var alert = UIAlertController(title: "Versendet".localized, message: "Ausgegangenes Produkt wurde gemeldet!".localized, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK".localized, style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            
        default:
            //TODO
            Debug.instance.log("Default")
        }
    }
    
}