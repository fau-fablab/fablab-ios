import UIKit
import Foundation
import CoreActionSheetPicker
import MessageUI

class ProductsearchViewController : UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UIGestureRecognizerDelegate {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    
    private var actInd : UIActivityIndicatorView!
    private var selectedIndexPath: NSIndexPath?
    private var model = ProductsearchModel()
    private let modelOutOfStock = MalfunctionInfoModel.sharedInstance
    private var selectedProduct: Product?
    private var searchActive = false;
    private var productCellIdentifier = "ProductCustomCell"
    private let doorButtonController = DoorNavigationButtonController.sharedInstance
    private let cartButtonController = CartNavigationButtonController.sharedInstance
    //search help
    private let searchHelpModel = SearchHelpModel.sharedInstance
    private var searchHelpTableView: UITableView!
    private var searchHelpTableViewHeight: NSLayoutConstraint!
    
    //table view background
    private var backgroundView: UILabel {
        var label = UILabel()
        label.center = view.center
        label.textAlignment = NSTextAlignment.Center
        label.text = "Keine Produkte gefunden".localized
        label.alpha = 0.5
        return label
    }
    
    @IBAction func buttonReportOutOfStockPressed(sender: AnyObject) {
        modelOutOfStock.fetchFablabMailAddress { () -> Void in
            self.presentViewController(MailComposeHelper.showOutOfStockMailComposeView(delegate: self, recipients: [self.modelOutOfStock.fablabMail!], productId: self.selectedProduct!.productId!, productName: self.selectedProduct!.name!), animated: true, completion: nil)
        }
    }

    @IBAction func buttonAddToCartPressed(sender: AnyObject) {
        let cell = tableView.cellForRowAtIndexPath(selectedIndexPath!) as! ProductCustomCell;
        showAddToCartPicker(cell, initialValue: cell.product.uom!.rounding!)
    }
    
    func showAddToCartPicker(cell: ProductCustomCell, initialValue: Double) {
        let rounding = cell.product.uom!.rounding!
        
        var addToCart = true
        var currentAmount : Double = initialValue
        
        var pickerDelegate = ActionSheetPickerDelegate(unit: cell.product.unit!, price: cell.product.price!, rounding: rounding, didSucceedAction: {
            //INFO Changed cell.product to self.selectedProduct -> Works now with locationString but dunno if this affects other things!
            (amount: Double) -> Void in
            
            if addToCart == false {
                currentAmount = amount
                addToCart = true
            } else {
                // if currentAmount has initial value, take the amount value
                if currentAmount == rounding {
                    currentAmount = amount
                }
                CartModel.sharedInstance.addProductToCart(self.selectedProduct!, amount: Double(currentAmount));
                self.cartButtonController.updateBadge()
            }
            }, didCancelAction: {(Void) -> Void in })
        
        var picker: ActionSheetCustomPicker = ActionSheetCustomPicker(title: "Menge auswählen".localized, delegate: pickerDelegate, showCancelButton: false, origin: self, initialSelections: [(currentAmount/rounding)-1])
        
        var doneButton: UIBarButtonItem = UIBarButtonItem()
        doneButton.title = "Hinzufügen".localized
        picker.setDoneButton(doneButton)
        
        picker.addCustomButtonWithTitle("Freitext".localized, actionBlock: {
            addToCart = false
            picker.delegate.actionSheetPickerDidSucceed!(picker, origin: self)
            self.alertChangeAmount(currentAmount) })
        picker.tapDismissAction = TapAction.Cancel
        
        picker.showActionSheetPicker()
    }
    
    func alertChangeAmount(currentAmount: Double) {
        
        var inputTextField: UITextField?
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "Abbrechen".localized, style: .Cancel, handler: { (Void) -> Void in self.showAddToCartPicker(self.tableView.cellForRowAtIndexPath(self.selectedIndexPath!) as! ProductCustomCell, initialValue: currentAmount)})
        
        let doneAction: UIAlertAction = UIAlertAction(title: "Hinzufügen".localized, style: .Default, handler: { (Void) -> Void in
            
            var amount: Double = NSString(string: inputTextField!.text.stringByReplacingOccurrencesOfString(",", withString: ".")).doubleValue
            
            var invalidInput = ChangeAmountPickerHelper.invalidInput(amount: amount, rounding: self.selectedProduct!.uom!.rounding!)
            if invalidInput == true {
                amount = currentAmount
            }
            
            var correctedRounding = ChangeAmountPickerHelper.correctWrongRounding(amount: amount, rounding: self.selectedProduct!.uom!.rounding!)
            if correctedRounding > 0 {
                amount = correctedRounding
            }
            
            if correctedRounding > 0 || invalidInput == true {
                let amountString = String(format: ChangeAmountPickerHelper.getFormatStringForRounding(self.selectedProduct!.uom!.rounding!), amount)
                
                var errorMsg : String = ""
                var errorTitle : String = ""
                if invalidInput == true {
                    errorTitle = "Fehlerhafte Eingabe".localized
                    errorMsg = "Wert ist ungültig".localized
                    errorMsg += "\n" + "Produkt wurde nicht dem Warenkorb hinzugefügt".localized
                } else if correctedRounding > 0 {
                    errorTitle = "Produkt wurde dem Warenkorb hinzugefügt".localized
                    errorMsg = "Wert wurde aufgerundet auf".localized + ": " + amountString + " " + self.selectedProduct!.unit!
                }
                
                AlertView.showInfoView(errorTitle, message: errorMsg)
            }
            
            if invalidInput == false {
                CartModel.sharedInstance.addProductToCart(self.selectedProduct!, amount: Double(amount))
                self.cartButtonController.updateBadge()
            }
        })
        
        let alertController = ChangeAmountPickerHelper.getUIAlertController(productName: self.selectedProduct!.name!, productRounding: self.selectedProduct!.uom!.rounding!, productUnit: self.selectedProduct!.unit!, cancelAction: cancelAction, doneAction: doneAction)
        
        alertController.addTextFieldWithConfigurationHandler({ textField -> Void in
            inputTextField = textField
            inputTextField!.text = String(format: ChangeAmountPickerHelper.getFormatStringForRounding(self.selectedProduct!.uom!.rounding!), currentAmount)
        })
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        Debug.instance.log(segue.identifier)
        if segue.identifier == "ProductLocationSegue" {
            let destination = segue.destinationViewController as? ProductLocationViewController
            
            let cell = tableView.cellForRowAtIndexPath(selectedIndexPath!) as! ProductCustomCell;
            
            let locationId = cell.product.locationStringForMap!
            let productName = cell.product.name
            
            destination!.configure(id: locationId, name: productName!)
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //search bar
        searchBar.delegate = self
        searchBar.enablesReturnKeyAutomatically = false
        searchBar.showsCancelButton = false
        
        //table view
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = UIColor.fabLabBlueSeperator()
        
        //activity indicator
        actInd = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        actInd.center = self.view.center
        actInd.hidesWhenStopped = true
        actInd.autoresizingMask = UIViewAutoresizing.FlexibleLeftMargin | UIViewAutoresizing.FlexibleWidth |
            UIViewAutoresizing.FlexibleRightMargin | UIViewAutoresizing.FlexibleTopMargin |
            UIViewAutoresizing.FlexibleHeight | UIViewAutoresizing.FlexibleBottomMargin
        view.addSubview(actInd)
        
        //search help
        searchHelpTableView = UITableView()
        searchHelpTableView.delegate = self
        searchHelpTableView.dataSource = self
        searchHelpTableView.scrollEnabled = true
        searchHelpTableView.hidden = true
        searchHelpTableView.setTranslatesAutoresizingMaskIntoConstraints(false)
        view.addSubview(searchHelpTableView)
        
        let c1 = NSLayoutConstraint(item: searchHelpTableView, attribute: NSLayoutAttribute.LeftMargin,
            relatedBy: NSLayoutRelation.Equal, toItem: self.tableView, attribute: NSLayoutAttribute.LeftMargin,
            multiplier: 1, constant: 0)
        let c2 = NSLayoutConstraint(item: searchHelpTableView, attribute: NSLayoutAttribute.RightMargin,
            relatedBy: NSLayoutRelation.Equal, toItem: self.tableView, attribute: NSLayoutAttribute.RightMargin,
            multiplier: 1, constant: 0)
        let c3 = NSLayoutConstraint(item: searchHelpTableView, attribute: NSLayoutAttribute.TopMargin,
            relatedBy: NSLayoutRelation.Equal, toItem: self.tableView, attribute: NSLayoutAttribute.TopMargin,
            multiplier: 1, constant: 0)
        searchHelpTableViewHeight = NSLayoutConstraint(item: searchHelpTableView, attribute: NSLayoutAttribute.Height,
            relatedBy: NSLayoutRelation.Equal, toItem: self.tableView, attribute: NSLayoutAttribute.Height,
            multiplier: 1, constant: 0)
        
        view.addConstraint(c1)
        view.addConstraint(c2)
        view.addConstraint(c3)
        view.addConstraint(searchHelpTableViewHeight)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        doorButtonController.setViewController(self)
        cartButtonController.setViewController(self)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "searchByBarcodeScanner:", name: "ProductScannerNotification", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardDidShow:", name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    func keyboardDidShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            if let tabBarSize = self.tabBarController?.tabBar.frame.size {
                searchHelpTableViewHeight.constant = tabBarSize.height - keyboardSize.height
                searchHelpTableView.setNeedsUpdateConstraints()
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        searchHelpTableViewHeight.constant = 0
        searchHelpTableView.setNeedsUpdateConstraints()
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
        searchActive = true;
        if (searchBar.text.isEmpty) {
            searchHelpModel.fetchEntries()
        } else {
            searchHelpModel.fetchEntriesWithSubstring(searchBar.text)
        }
        searchHelpTableView.reloadData()
        searchHelpTableView.hidden = false
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBar(searchBar: UISearchBar, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        var newString = (searchBar.text as NSString).stringByReplacingCharactersInRange(range, withString: text)
        searchHelpModel.fetchEntriesWithSubstring(newString)
        searchHelpTableView.reloadData()
        searchHelpTableView.hidden = false
        return true
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if (count(searchText) == 0) {
            searchHelpModel.fetchEntries()
            searchHelpTableView.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
        searchActive = false;
        searchBar.resignFirstResponder()
        searchHelpTableView.hidden = true
    }
    
    func searchBar(searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        if(selectedScope == 0) {
            sortProductsByName()
        } else {
            sortProductsByPrice()
        }
    }
    
    private func sortProductsByName() {
        selectedIndexPath = nil
        model.sortProductsByName()
        tableView.reloadData()
    }
    
    private func sortProductsByPrice() {
        selectedIndexPath = nil
        model.sortProductsByPrice()
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        self.searchHelpModel.addHistoryEntry(searchBar.text)
        self.resetTableViewBackground()
        self.searchHelpTableView.hidden = true
        self.searchBar.resignFirstResponder()
        self.searchBar.userInteractionEnabled = false;
        model.removeAllProducts()
        tableView.reloadData()
        self.actInd.startAnimating()
        model.searchProductByName(searchBar.text, onCompletion: { err in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.searchActive = false
                self.searchBar.userInteractionEnabled = true;
                self.actInd.stopAnimating();
                self.setTableViewBackground()
                if(self.searchBar.selectedScopeButtonIndex == 0) {
                    self.sortProductsByName()
                } else {
                    self.sortProductsByPrice()
                }
            })
        })
    }
    
    func searchByBarcodeScanner(notification:NSNotification) {
        Debug.instance.log("Got Notification from Barcodescanner, productId: \(notification.object)")
        self.resetTableViewBackground()
        self.searchBar.resignFirstResponder()
        self.searchBar.userInteractionEnabled = false;
        model.removeAllProducts()
        tableView.reloadData()
        self.actInd.startAnimating()
        model.searchProductById(notification.object as! String, onCompletion: { err in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.searchActive = false
                self.searchBar.userInteractionEnabled = true;
                self.actInd.stopAnimating();
                self.setTableViewBackground()
                if(self.searchBar.selectedScopeButtonIndex == 0) {
                    self.sortProductsByName()
                } else {
                    self.sortProductsByPrice()
                }
            })
        })
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if(tableView == searchHelpTableView) {
            let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "searchHelpCell")
            cell.textLabel?.text = searchHelpModel.getEntry(indexPath.section, row: indexPath.row)
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            return cell
        }
        let cell = tableView.dequeueReusableCellWithIdentifier(productCellIdentifier) as? ProductCustomCell
        let product = model.getProduct(indexPath.section, row: indexPath.row)
        cell!.configure(product)
        return cell!;
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if(tableView == searchHelpTableView) {
            return searchHelpModel.getNumberOfSections()
        }
        return model.getNumberOfSections()
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(tableView == searchHelpTableView) {
            return searchHelpModel.getNumberOfRowsInSection(section)
        }
        return model.getNumberOfRowsInSection(section)
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (tableView == searchHelpTableView) {
            return searchHelpModel.getTitleOfSection(section)
        }
        return model.getTitleOfSection(section)
    }
    
    func sectionIndexTitlesForTableView(tableView: UITableView) -> [AnyObject] {
        if(tableView == self.tableView) {
            return model.getSectionIndexTitles()
        }
        return []
    }
    
    func tableView(tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int {
        if(tableView == self.tableView) {
            return model.getSectionForSectionIndexTitleAtIndex(index)
        }
        return 0
    }
    

    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if (tableView == self.tableView) {
            (cell as! ProductCustomCell).watchFrameChanges()
        }
    }
    
    func tableView(tableView: UITableView, didEndDisplayingCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if (tableView == self.tableView) {
           (cell as! ProductCustomCell).ignoreFrameChanges()
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if(tableView == searchHelpTableView) {
            searchBar.text = searchHelpTableView.cellForRowAtIndexPath(indexPath)?.textLabel?.text
            searchBarSearchButtonClicked(searchBar)
            return
        }
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
        selectedProduct = model.getProduct(indexPath.section, row: indexPath.row)
        if let cell = tableView.cellForRowAtIndexPath(indexPath) as? ProductCustomCell{
            if(!selectedProduct!.hasLocation){
                cell.disableProductLocationButton()
            }else{
                cell.enableProductLocationButton()
            }
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if(tableView == searchHelpTableView) {
            return UITableViewAutomaticDimension
        } else if (indexPath == selectedIndexPath){
            return ProductCustomCell.expandedHeight
        } else{
            return ProductCustomCell.defaultHeight
        }
    }
    
    private func setTableViewBackground() {
        if (model.getNumberOfProducts() == 0) {
            tableView.separatorStyle = UITableViewCellSeparatorStyle.None
            tableView.backgroundView = backgroundView
        }
    }
    
    private func resetTableViewBackground() {
        tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
        tableView.backgroundView = nil
    }
}

extension ProductsearchViewController : MFMailComposeViewControllerDelegate{
    
    func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
        dismissViewControllerAnimated(true, completion: nil)
        switch result.value{
        case MFMailComposeResultCancelled.value:
            self.presentViewController(MailComposeHelper.getCancelAlertController(), animated: true, completion: nil)
            
        case MFMailComposeResultSent.value:
            self.presentViewController(MailComposeHelper.getSentAlertController(), animated: true, completion: nil)
            
        default:
            //TODO
            Debug.instance.log("Default")
        }
    }
}