import UIKit
import Foundation

class ProductsearchViewController : UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate{
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    
    private var searchActive = false;
    private var model = ProductsearchModel()

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
        searchBar.showsCancelButton = true
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
        model.searchProductByName(searchBar.text, onCompletion: { err in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.sectionProducts()
                self.tableView.reloadData()
            })
        })
    }
    
    func searchByBarcodeScanner(notification:NSNotification) {
        Debug.instance.log("Got Notification from Barcodescanner, productId: \(notification.object)")
            model.searchProductById(notification.object as! String, onCompletion: { err in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.tableView.reloadData()
                })
            })
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell! = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
        let product = sections[indexPath.section][indexPath.row]
        cell.textLabel?.text = product.name
        return cell;
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.sections.count
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sections[section].count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if !self.sections[section].isEmpty {
            return self.collation.sectionTitles[section] as? String
        }
        return ""
    }
    
    func sectionIndexTitlesForTableView(tableView: UITableView) -> [AnyObject] {
        return self.collation.sectionIndexTitles
    }
    
    func tableView(tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int {
        return self.collation.sectionForSectionIndexTitleAtIndex(index)
    }
    
    private func sectionProducts(){
        
        let selector: Selector = "name"
        self.sections = [[Product]](count: self.collation.sectionTitles.count, repeatedValue: []);
        
        //add products to sections
        for index in 0..<model.getCount() {
            var sectionIndex = self.collation.sectionForObject(model.getProduct(index), collationStringSelector: selector)
            self.sections[sectionIndex].append(model.getProduct(index))
        }
        
        //sort each section
        for index in 0..<sections.count {
            sections[index] = collation.sortedArrayFromArray(sections[index], collationStringSelector: selector) as! [Product]
        }
        
    }
    
    
}