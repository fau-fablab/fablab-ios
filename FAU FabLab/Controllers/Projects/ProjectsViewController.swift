import Foundation
import UIKit

class ProjectsViewController: UITableViewController {
    
    let cartHistoryModel = CartHistoryModel.sharedInstance
    let projectsModel = ProjectsModel.sharedInstance
    
    let cartCustomCellIdentifier = "CartCustomCell"
    let projectCustomCellIdentifier = "ProjectCustomCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.tableView.reloadData()
        super.viewWillAppear(animated)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        Debug.instance.log(segue.identifier)
        if segue.identifier == "CreateProjectsSegue" {
            let destination = segue.destinationViewController as? CreateProjectsViewController
            destination!.configure(projectId: -1)
        }
        if segue.identifier == "EditProjectsSegue" {
            let destination = segue.destinationViewController as? CreateProjectsViewController
            destination!.configure(projectId: tableView.indexPathForSelectedRow()!.row)
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if (indexPath.section == 0) {
            let cell = tableView.dequeueReusableCellWithIdentifier(cartCustomCellIdentifier) as? CartCustomCell
            let cart = cartHistoryModel.getCart(indexPath.row)
            cell!.configure(cart.date, count: cart.getCount(), status: cart.cartStatus)
            return cell!
        } else if (indexPath.section == 1) {
            let cell = tableView.dequeueReusableCellWithIdentifier(projectCustomCellIdentifier) as? ProjectCustomCell
            let project = projectsModel.getProject(indexPath.row)
            cell!.configure(filename: project.filename, description: project.descr)
            return cell!
        }
        return UITableViewCell()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0) {
            return cartHistoryModel.getCount()
        } else if (section == 1) {
            return projectsModel.getCount()
        }
        return 0
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (section == 0) {
            return "Warenkörbe".localized
        } else if (section == 1) {
            return "Gespeicherte Projekte".localized
        }
        return nil
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if (indexPath.section == 0 && indexPath.row == 0) {
            return false
        } else if (indexPath.section == 1 && indexPath.row == 0) {
            return false
        }
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            if (indexPath.section == 0) {
                cartHistoryModel.removeCart(indexPath.row)
            } else if (indexPath.section == 1) {
                projectsModel.removeProject(indexPath.row)
            }
            tableView.reloadData()
        }
        
        /*
        if (indexPath.section == 0 && editingStyle == UITableViewCellEditingStyle.Delete) {
            cartHistoryModel.removeCart(indexPath.row)
            tableView.reloadData()
        } else if (indexPath.section == 1 && editingStyle == UITableViewCellEditingStyle.Delete) {
            projectsModel.removeProject(indexPath.row)
            tableView.reloadData()
        }*/
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (indexPath.section == 0) {
            let cartViewController = self.storyboard!.instantiateViewControllerWithIdentifier("CartViewController") as! CartViewController
            cartViewController.setCart(indexPath.row)
            self.navigationController?.pushViewController(cartViewController, animated: true)
        }
        //else if (indexPath.section == 1)
        // this case is handled in prepareForSegue()
    }
    
}
