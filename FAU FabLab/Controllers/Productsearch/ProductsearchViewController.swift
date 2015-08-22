import UIKit
import Foundation
import CoreActionSheetPicker

class ProductsearchViewController : UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var actInd : UIActivityIndicatorView!
    
    private var selectedIndexPath: NSIndexPath?
    private var model = ProductsearchModel()
    private var searchActive = false;
    private var sortedByName = true;
    private var sortingDidChange = false
    private var productCellIdentifier = "ProductCustomCell"
    private let doorButtonController = DoorNavigationButtonController.sharedInstance
    private let collation = UILocalizedIndexedCollation.currentCollation() as! UILocalizedIndexedCollation
    private var sections: [[Product]] = []
    //autocomplete
    private var autocompleteSuggestions = [String]()
    private var autocompleteTableView: UITableView!

    
    
    @IBAction func buttonAddToCartPressed(sender: AnyObject) {
        let cell = tableView.cellForRowAtIndexPath(selectedIndexPath!) as! ProductCustomCell;
        var picker: ActionSheetCustomPicker = ActionSheetCustomPicker()
        var doneButton: UIBarButtonItem = UIBarButtonItem()
        doneButton.title = "Hinzufügen"
        picker.setDoneButton(doneButton)
        picker.title = "Menge auswählen"
        picker.tapDismissAction = TapAction.Cancel
        picker.hideCancel = true
        picker.delegate = ActionSheetPickerDelegate(unit: cell.product.unit!, price: cell.product.price!, didSucceedAction: { (amount: Int) -> Void in CartModel.sharedInstance.addProductToCart(cell.product, amount: Double(amount)) }, didCancelAction: {(Void) -> Void in })
        picker.showActionSheetPicker()
    }
    
    @IBAction func buttonShowLocationPressed(sender: AnyObject) {
        //TODO PASS locationId and productName
        let cell = tableView.cellForRowAtIndexPath(selectedIndexPath!) as! ProductCustomCell;
        
        let locationId = cell.product.locationId
        let productName = cell.product.name
        
        var locationView = self.storyboard?.instantiateViewControllerWithIdentifier("ProductLocationView") as! ProductLocationViewController
        locationView.locationId = "\(locationId)"
        locationView.productName = productName
        var nav = UINavigationController(rootViewController: locationView)
        nav.modalPresentationStyle = UIModalPresentationStyle.Popover
        var popover = nav.popoverPresentationController
        self.presentViewController(nav, animated: true, completion: nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "searchByBarcodeScanner:", name: "ProductScannerNotification", object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //search bar
        searchBar.delegate = self
        searchBar.enablesReturnKeyAutomatically = false
        
        //table view
        tableView.delegate = self
        tableView.dataSource = self
        
        //activity indicator
        actInd = UIActivityIndicatorView(frame: CGRectMake(0,0, 50, 50)) as UIActivityIndicatorView
        actInd.center = self.view.center
        actInd.hidesWhenStopped = true
        actInd.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        view.addSubview(actInd)
        
        //autocomplete
        autocompleteTableView = UITableView()
        autocompleteTableView.delegate = self
        autocompleteTableView.dataSource = self
        autocompleteTableView.scrollEnabled = true
        autocompleteTableView.hidden = true
        autocompleteTableView.setTranslatesAutoresizingMaskIntoConstraints(false)
        view.addSubview(autocompleteTableView)
        
        let c1 = NSLayoutConstraint(item: autocompleteTableView, attribute: NSLayoutAttribute.LeftMargin,
            relatedBy: NSLayoutRelation.Equal, toItem: self.tableView, attribute: NSLayoutAttribute.LeftMargin,
            multiplier: 1, constant: 0)
        let c2 = NSLayoutConstraint(item: autocompleteTableView, attribute: NSLayoutAttribute.RightMargin,
            relatedBy: NSLayoutRelation.Equal, toItem: self.tableView, attribute: NSLayoutAttribute.RightMargin,
            multiplier: 1, constant: 0)
        let c3 = NSLayoutConstraint(item: autocompleteTableView, attribute: NSLayoutAttribute.TopMargin,
            relatedBy: NSLayoutRelation.Equal, toItem: self.tableView, attribute: NSLayoutAttribute.TopMargin,
            multiplier: 1, constant: 0)
        let c4 = NSLayoutConstraint(item: autocompleteTableView, attribute: NSLayoutAttribute.BottomMargin,
            relatedBy: NSLayoutRelation.Equal, toItem: self.tableView, attribute: NSLayoutAttribute.BottomMargin,
            multiplier: 1, constant: 0)
        
        view.addConstraint(c1)
        view.addConstraint(c2)
        view.addConstraint(c3)
        view.addConstraint(c4)
        
        doorButtonController.updateButtons(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func showText() {
        doorButtonController.showText(self)
    }
    
    func showButton() {
        doorButtonController.showButton(self)
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchActive = true;
        autocompleteTableView.hidden = false
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBar(searchBar: UISearchBar, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        var newString = (searchBar.text as NSString).stringByReplacingCharactersInRange(range, withString: text)
        autocompleteTableView.hidden = false
        filterAutocompleteSuggestions(newString)
        return true
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if (count(searchText) == 0) {
            autocompleteSuggestions.removeAll(keepCapacity: false)
            autocompleteTableView.reloadData()
        }
    }
    
    func filterAutocompleteSuggestions(newString: String) {
        autocompleteSuggestions.removeAll(keepCapacity: false)
        if (count(newString) > 1) {
            for suggestion in AutocompleteModel.sharedInstance.getAutocompleteSuggestions() {
                var string: NSString! = suggestion as NSString
                var substringRange: NSRange! = string.rangeOfString(newString)
                if (substringRange.location != NSNotFound) {
                    autocompleteSuggestions.append(suggestion)
                }
            }
        }
        autocompleteTableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
        searchBar.resignFirstResponder();
        autocompleteTableView.hidden = true
    }
    
    func searchBar(searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        sortingDidChange = true
        if(selectedScope == 0) {
            sortProductsByName()
        } else {
            sortProductsByPrice()
        }
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        self.autocompleteTableView.hidden = true
        self.searchBar.resignFirstResponder()
        self.searchBar.userInteractionEnabled = false;
        self.sections.removeAll(keepCapacity: false);
        self.tableView.reloadData();
        self.actInd.startAnimating()
        model.searchProductByName(searchBar.text, onCompletion: { err in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.searchBar.userInteractionEnabled = true;
                self.actInd.stopAnimating();
                if(self.sortedByName) {
                    self.sortProductsByName()
                } else {
                    self.sortProductsByPrice()
                }
            })
        })
    }
    
    func searchByBarcodeScanner(notification:NSNotification) {
        Debug.instance.log("Got Notification from Barcodescanner, productId: \(notification.object)")
        
        
            model.searchProductById(notification.object as! String, onCompletion: { err in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                   
                    if(self.sortedByName) {
                        self.sortProductsByName()
                    } else {
                        self.sortProductsByPrice()
                    }
                })
            })
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if(tableView == autocompleteTableView) {
            let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "autocomplete")
            cell.textLabel?.text = autocompleteSuggestions[indexPath.row]
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            return cell
        }
        let cell = tableView.dequeueReusableCellWithIdentifier(productCellIdentifier) as? ProductCustomCell
        let product = sections[indexPath.section][indexPath.row]
        cell!.configure(product)
        return cell!;
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if(tableView == autocompleteTableView) {
            return 1
        }
        return self.sections.count
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(tableView == autocompleteTableView) {
            return autocompleteSuggestions.count
        }
        return self.sections[section].count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (tableView == self.tableView && sortedByName && !self.sections[section].isEmpty) {
            return self.collation.sectionTitles[section] as? String
        }
        return ""
    }
    
    func sectionIndexTitlesForTableView(tableView: UITableView) -> [AnyObject] {
        if(tableView == self.tableView && sortedByName) {
            return self.collation.sectionIndexTitles
        }
        return []
    }
    
    func tableView(tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int {
        if(tableView == self.tableView && sortedByName) {
            return self.collation.sectionForSectionIndexTitleAtIndex(index)
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
        if(tableView == autocompleteTableView) {
            searchBar.text = autocompleteTableView.cellForRowAtIndexPath(indexPath)?.textLabel?.text
            filterAutocompleteSuggestions(searchBar.text)
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
        if !sortingDidChange {
            if let previous = previousIndexPath{
                indexPaths += [previous]
            }
        }
        sortingDidChange = false
        if let current = selectedIndexPath {
            indexPaths += [current]
        }
        if indexPaths.count > 0 {
            tableView.reloadRowsAtIndexPaths(indexPaths, withRowAnimation: UITableViewRowAnimation.Automatic)
        }
        tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Top, animated: true)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if(tableView == autocompleteTableView) {
            return UITableViewAutomaticDimension
        } else if (indexPath == selectedIndexPath){
            return ProductCustomCell.expandedHeight
        } else{
            return ProductCustomCell.defaultHeight
        }
    }
    

    private func sortProductsByName(){
        
        sortedByName = true
        
        let selector: Selector = "name"
        
        //add products to sections
        self.sections.removeAll(keepCapacity: false)
        self.sections = [[Product]](count: self.collation.sectionTitles.count, repeatedValue: []);
        for index in 0..<model.getCount() {
            var sectionIndex = self.collation.sectionForObject(model.getProduct(index), collationStringSelector: selector)
            self.sections[sectionIndex].append(model.getProduct(index))
        }
        
        //sort sections by name
        for index in 0..<sections.count {
            sections[index] = collation.sortedArrayFromArray(sections[index], collationStringSelector: selector) as! [Product]
        }
        
        self.tableView.reloadData();
        
    }
    
    private func sortProductsByPrice() {
        
        sortedByName = false;
        
        sections.removeAll(keepCapacity: false);
        var products = model.getAllProducts();
        products.sort({$0.price < $1.price});
        sections.append(products)
        
        self.tableView.reloadData();
    }
    
}