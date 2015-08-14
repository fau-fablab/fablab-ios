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
    private var productCellIdentifier = "ProductCustomCell"
    
    private let doorButtonController = DoorNavigationButtonController.sharedInstance
    
    
    @IBAction func buttonAddToCartPressed(sender: AnyObject) {
        let cell = tableView.cellForRowAtIndexPath(selectedIndexPath!) as! ProductCustomCell;
        var picker: ActionSheetCustomPicker = ActionSheetCustomPicker()
        var doneButton: UIBarButtonItem = UIBarButtonItem()
        doneButton.title = "Hinzufügen"
        picker.setDoneButton(doneButton)
        picker.title = "Menge auswählen"
        picker.tapDismissAction = TapAction.Cancel
        picker.hideCancel = true
        picker.delegate = ActionSheetPickerDelegate(product: cell.product, successAction: { (product: Product, amount: Int) -> Void in CartModel.sharedInstance.addProductToCart(product, amount: Double(amount)) })
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
    

    //collation for sectioning the table
    let collation = UILocalizedIndexedCollation.currentCollation() as! UILocalizedIndexedCollation
    
    //table sections
    var sections: [[Product]] = []
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "searchByBarcodeScanner:", name: "ProductScannerNotification", object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        
        searchBar.enablesReturnKeyAutomatically = false
        
        actInd = UIActivityIndicatorView(frame: CGRectMake(0,0, 50, 50)) as UIActivityIndicatorView
        actInd.center = self.view.center
        actInd.hidesWhenStopped = true
        actInd.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        view.addSubview(actInd)
        
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
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
        searchBar.resignFirstResponder();
    }
    
    func searchBar(searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        if(selectedScope == 0) {
            sortProductsByName()
        } else {
            sortProductsByPrice()
        }
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
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
        let cell = tableView.dequeueReusableCellWithIdentifier(productCellIdentifier) as? ProductCustomCell
        let product = sections[indexPath.section][indexPath.row]
        cell!.configure(product)
        return cell!;
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.sections.count
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sections[section].count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if sortedByName && !self.sections[section].isEmpty {
            return self.collation.sectionTitles[section] as? String
        }
        return ""
    }
    
    func sectionIndexTitlesForTableView(tableView: UITableView) -> [AnyObject] {
        if(sortedByName) {
            return self.collation.sectionIndexTitles
        }
        return []
    }
    
    func tableView(tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int {
        if(sortedByName) {
            return self.collation.sectionForSectionIndexTitleAtIndex(index)
        }
        return 0
    }
    

    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        (cell as! ProductCustomCell).watchFrameChanges()
    }
    
    func tableView(tableView: UITableView, didEndDisplayingCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        (cell as! ProductCustomCell).ignoreFrameChanges()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let previousIndexPath = selectedIndexPath
        if indexPath == selectedIndexPath {
            selectedIndexPath = nil
        } else {
            selectedIndexPath = indexPath
        }
        
        var indexPaths : Array<NSIndexPath> = []
        if let previous = previousIndexPath {
            indexPaths += [previous]
        }
        if let current = selectedIndexPath {
            indexPaths += [current]
        }
        if indexPaths.count > 0 {
            tableView.reloadRowsAtIndexPaths(indexPaths, withRowAnimation: UITableViewRowAnimation.Automatic)
        }
        tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Top, animated: true)

    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if(indexPath == selectedIndexPath){
            return ProductCustomCell.expandedHeight
        }else{
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