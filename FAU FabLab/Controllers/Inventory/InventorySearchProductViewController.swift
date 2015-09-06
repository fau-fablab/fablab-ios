
import Foundation

class InventorySearchProductViewController : UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UIGestureRecognizerDelegate {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    
    private var actInd : UIActivityIndicatorView!
    private var selectedIndexPath: NSIndexPath?
    private var model = ProductsearchModel()
    private var selectedProduct: Product?
    private var searchActive = false;
    private var productCellIdentifier = "InventoryProductSearchCell"
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
    
    @IBAction func buttonAddToCartPressed(sender: AnyObject) {
        let cell = tableView.cellForRowAtIndexPath(selectedIndexPath!) as! InventoryProductSearchCell;
       
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
                self.selectedIndexPath = nil
                self.model.sortProductsByName()
                self.tableView.reloadData()
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
        let cell = tableView.dequeueReusableCellWithIdentifier(productCellIdentifier) as? InventoryProductSearchCell
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