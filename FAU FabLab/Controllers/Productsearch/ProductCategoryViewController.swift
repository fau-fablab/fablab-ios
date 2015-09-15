import Foundation
import UIKit

class ProductCategoryViewController: UITableViewController {
    
    private let model = CategoryModel.sharedInstance
    private let reuseIdentifier = "CategoryCell"
    
    private var backBarButtonItem: UIBarButtonItem!
    private var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        model.fetchCategories {
            (error) -> Void in
            dispatch_async(dispatch_get_main_queue(), {
                () -> Void in
                if error != nil {
                    Debug.instance.log(error)
                    return
                }
                self.tableView.reloadData()
            })
        }
        
        title = model.getNameOfCategory(model.getCategory())
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        if (self.isMovingFromParentViewController() || self.isBeingDismissed()) {
            model.setCategory(model.getSupercategory(model.getCategory()))
        }
    }
    
    func reset() {
        model.reset()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        CartNavigationButtonController.sharedInstance.setViewController(self)
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return model.getNumberOfSections()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.getNumberOfRowsInSection(section)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        Debug.instance.log(indexPath)
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: reuseIdentifier)
        cell.textLabel?.text = model.getNameOfCategory(indexPath.section, row: indexPath.row)
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        Debug.instance.log(indexPath.section)
        Debug.instance.log(indexPath.row)
        model.setCategory(indexPath.section, row: indexPath.row)
        if model.hasSubcategories() {
            let productCategoryViewController = storyboard!.instantiateViewControllerWithIdentifier("ProductCategoryViewController") as! ProductCategoryViewController
            navigationController?.pushViewController(productCategoryViewController, animated: true)
        } else {
            navigationController?.popToRootViewControllerAnimated(true)
            NSNotificationCenter.defaultCenter().postNotificationName("CategorySelectedNotification", object: model.getCategory())
        }
    }
    
}