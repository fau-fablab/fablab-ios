import Foundation
import UIKit

class ProductCategoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tableView: UITableView!
    
    private var activityIndicator: UIActivityIndicatorView!
    
    private let model = CategoryModel.sharedInstance
    private let reuseIdentifier = "CategoryCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.autoresizingMask = [UIViewAutoresizing.FlexibleLeftMargin, UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleRightMargin, UIViewAutoresizing.FlexibleTopMargin, UIViewAutoresizing.FlexibleHeight, UIViewAutoresizing.FlexibleBottomMargin]
        view.addSubview(activityIndicator)
        
        if let category = model.getCategory() {
            title = category.name
        } else {
            activityIndicator.startAnimating()
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        CartNavigationButtonController.sharedInstance.setViewController(self)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "categoriesLoaded", name: "CategoriesLoadedNotification", object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        if (self.isMovingFromParentViewController() || self.isBeingDismissed()) {
            if model.hasSupercategory() {
                model.setCategory(model.getSupercategory()!)   
            }
        }
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "CategoriesLoadedNotification", object: nil)
    }
    
    func categoriesLoaded() {
        if let category = model.getCategory() {
            title = category.name
        }
        activityIndicator.stopAnimating()
        tableView.reloadData()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 && model.getNumberOfSubcategories() > 0 {
            return 1
        } else {
            return model.getNumberOfSubcategories()
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: reuseIdentifier)
        if indexPath.section == 0 {
            cell.textLabel?.text = "Alles anzeigen".localized
        } else {
            cell.textLabel?.text = model.getSubcategory(indexPath.row)!.name
        }
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 1 {
            model.setCategory(model.getSubcategory(indexPath.row)!)
        }
        if indexPath.section == 1 && model.hasSubcategories() {
            let productCategoryViewController = storyboard!.instantiateViewControllerWithIdentifier("ProductCategoryViewController") as! ProductCategoryViewController
            navigationController?.pushViewController(productCategoryViewController, animated: true)
        } else {
            navigationController?.popToRootViewControllerAnimated(true)
            NSNotificationCenter.defaultCenter().postNotificationName("CategorySelectedNotification", object: model.getCategory())
        }
    }
    
}