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
    private var scannedBarcode = ""
    
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
        
        ChangeAmountPickerHelper.showChangeAmountPicker(cell, initialValue: initialValue, delegateSucceedAction: { (currentAmount: Double) -> Void in
                CartModel.sharedInstance.addProductToCart(self.selectedProduct!, amount: Double(currentAmount));
                self.cartButtonController.updateBadge()
            }, delegateCancelAction: { (Void) -> Void in
            }, alertChangeAmountAction: { (currentAmount: Double) -> Void in
                ChangeAmountPickerHelper.alertChangeAmount(viewController: self, cell: cell, currentAmount: currentAmount, pickerCancelActionHandler: { (Void) -> Void in
                        self.showAddToCartPicker(self.tableView.cellForRowAtIndexPath(self.selectedIndexPath!) as! ProductCustomCell, initialValue: currentAmount)
                    }, pickerDoneActionHandlerFinished: { (amount: Double) -> Void in
                        CartModel.sharedInstance.addProductToCart(self.selectedProduct!, amount: Double(amount))
                        self.cartButtonController.updateBadge()
                })
        })
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
        
        //activity indicator
        actInd = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        actInd.center = self.view.center
        actInd.hidesWhenStopped = true
        actInd.autoresizingMask = UIViewAutoresizing.FlexibleLeftMargin | UIViewAutoresizing.FlexibleWidth |
            UIViewAutoresizing.FlexibleRightMargin | UIViewAutoresizing.FlexibleTopMargin |
            UIViewAutoresizing.FlexibleHeight | UIViewAutoresizing.FlexibleBottomMargin
        view.addSubview(actInd)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewWillAppear(animated: Bool) {
        if(scannedBarcode != ""){
            self.barCodeWasScanned()
        }
        super.viewWillAppear(animated)
        doorButtonController.setViewController(self)
        cartButtonController.setViewController(self)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardDidShow:", name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "categorySelected:", name: "CategorySelectedNotification", object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
        //NSNotificationCenter.defaultCenter().removeObserver(self, name: "CategorySelectedNotification", object: nil)
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
    
    func categorySelected(notification: NSNotification) {
        self.searchBar.text.removeAll(keepCapacity: false)
        self.resetTableViewBackground()
        self.searchHelpTableView.hidden = true
        self.searchBar.resignFirstResponder()
        self.searchBar.userInteractionEnabled = false;
        model.removeAllProducts()
        tableView.reloadData()
        self.actInd.startAnimating()
        let category = notification.object as! CategoryEntity
        model.searchProductByCategory(category.name, onCompletion: { err in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.searchActive = false
                self.searchBar.userInteractionEnabled = true;
                self.actInd.stopAnimating();
                self.setTableViewBackground()
                if self.searchBar.selectedScopeButtonIndex == 0 {
                    self.sortProductsByName()
                } else {
                    self.sortProductsByPrice()
                }
            })
        })
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
    
    func setScannedBarcode(scannedBarcode: String){
        self.scannedBarcode = scannedBarcode
    }
    func barCodeWasScanned() {
        self.resetTableViewBackground()
        self.searchBar.resignFirstResponder()
        self.searchBar.userInteractionEnabled = false;
        model.removeAllProducts()
        tableView.reloadData()
        self.actInd.startAnimating()
        model.searchProductById(scannedBarcode, onCompletion: { err in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.searchActive = false
                self.searchBar.userInteractionEnabled = true;
                self.actInd.stopAnimating();
                self.setTableViewBackground()
                if(self.searchBar.selectedScopeButtonIndex == 0) {
                    self.sortProductsByName()
                    self.tableView.reloadData()
                } else {
                    self.sortProductsByPrice()
                    self.tableView.reloadData()
                }
            })
        })
        scannedBarcode = ""
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch tableView {
        case searchHelpTableView:
            let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "searchHelpCell")
            cell.textLabel?.text = searchHelpModel.getEntry(indexPath.section, row: indexPath.row)
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            if indexPath.section == 0 {
                cell.imageView?.image = UIImage(named: "icon_categories", inBundle: nil, compatibleWithTraitCollection: nil)
            }
            return cell
        default:
            let cell = tableView.dequeueReusableCellWithIdentifier(productCellIdentifier) as? ProductCustomCell
            let product = model.getProduct(indexPath.section, row: indexPath.row)
            cell!.configure(product)
            return cell!
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        switch tableView {
        case searchHelpTableView:
            return searchHelpModel.getNumberOfSections()
        default:
            return model.getNumberOfSections()
        }
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case searchHelpTableView:
            return searchHelpModel.getNumberOfRowsInSection(section)
        default:
            return model.getNumberOfRowsInSection(section)
        }
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch tableView {
        case searchHelpTableView:
            return searchHelpModel.getTitleOfSection(section)
        default:
            return model.getTitleOfSection(section)
        }
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
        switch tableView {
        case searchHelpTableView:
            searchBar.setShowsCancelButton(false, animated: true)
            
            if indexPath.section == 0 {
                CategoryModel.sharedInstance.reset()
                let productCategoryViewController = storyboard!.instantiateViewControllerWithIdentifier("ProductCategoryViewController") as! ProductCategoryViewController
                navigationController?.pushViewController(productCategoryViewController, animated: true)
                self.searchHelpTableView.hidden = true
                self.searchBar.resignFirstResponder()
                return
            }
            
            searchBar.text = searchHelpTableView.cellForRowAtIndexPath(indexPath)?.textLabel?.text
            searchBarSearchButtonClicked(searchBar)
            return
        default:
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
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch tableView {
        case searchHelpTableView:
            return UITableViewAutomaticDimension
        default:
            if indexPath == selectedIndexPath {
                return ProductCustomCell.expandedHeight
            }
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