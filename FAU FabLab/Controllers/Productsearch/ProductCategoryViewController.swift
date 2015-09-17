import Foundation
import UIKit

class ProductCategoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tableView: UITableView!
    
    private let model = CategoryModel.sharedInstance
    private let reuseIdentifier = "CategoryCell"
    
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
                self.setTitle()
            })
        }
        
        setTitle()

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        CartNavigationButtonController.sharedInstance.setViewController(self)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        if (self.isMovingFromParentViewController() || self.isBeingDismissed()) {
            if model.hasSupercategory() {
                model.setCategory(model.getSupercategory()!)   
            }
        }
    }
    
    private func setTitle() {
        if let category = model.getCategory() {
            title = category.name!
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return model.getNumberOfSections()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.getNumberOfRowsInSection(section)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: reuseIdentifier)
        if indexPath.section == 0 {
            cell.textLabel?.text = "Alles anzeigen".localized
        } else {
            cell.textLabel?.text = model.getSubcategory(indexPath.section, row: indexPath.row)!.name
        }
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
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