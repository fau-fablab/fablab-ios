import Foundation
import UIKit

class ProjectsViewController: UITableViewController {
    
    let cartHistoryModel = CartHistoryModel.sharedInstance
    let projectsModel = ProjectsModel.sharedInstance
    
    let cartCustomCellIdentifier = "CartCustomCell"
    let projectCustomCellIdentifier = "ProjectCustomCell"
    
    private var createFromCart : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Projekte/Warenkörbe".localized
    }
    
    override func viewWillAppear(animated: Bool) {
        self.tableView.reloadData()
        super.viewWillAppear(animated)
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
        if createFromCart {
            return 1
        } else {
            return 2
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0) {
            return cartHistoryModel.countNonEmptyCarts()
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
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            if (indexPath.section == 0) {
                cartHistoryModel.removeCart(indexPath.row)
            } else if (indexPath.section == 1) {
                showDeleteProjectAlertController(indexPath.row)
            }
            tableView.reloadData()
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (indexPath.section == 0) {
            if !createFromCart {
                let cartViewController = self.storyboard!.instantiateViewControllerWithIdentifier("CartView") as! CartViewController
                cartViewController.setCart(indexPath.row)
                self.navigationController?.pushViewController(cartViewController, animated: true)
            } else {
                createFromCart = false
                self.title = "Projekte/Warenkörbe".localized
                self.showCreateProjectViewController(projectId: -1, cart: cartHistoryModel.getCart(indexPath.row))
            }
        } else if (indexPath.section == 1) {
            self.showCreateProjectViewController(projectId: indexPath.row, cart: nil)
        }
    }
    
    func showCreateProjectViewController(projectId projectId: Int, cart: Cart?) {
        let projViewController = self.storyboard!.instantiateViewControllerWithIdentifier("CreateProjectViewController") as! CreateProjectsViewController
        if cart == nil {
            projViewController.configure(projectId: projectId)
        } else {
            projViewController.configure(projectId: projectId, cart: cart!)
        }
        self.navigationController?.pushViewController(projViewController, animated: true)
    }
    
    func showDeleteProjectAlertController(projectId: Int) {
        let cancelAction: UIAlertAction = UIAlertAction(title: "Abbrechen".localized, style: .Cancel, handler: { (Void) -> Void in })
        
        let deleteLocalAction: UIAlertAction = UIAlertAction(title: "Lokal".localized, style: .Default, handler: { (Void) -> Void in
                self.projectsModel.removeProject(projectId)
                self.tableView.reloadData()
        })
        
        let deleteBothAction: UIAlertAction = UIAlertAction(title: "Lokal und auf GitHub".localized, style: .Default, handler: { (Void) -> Void in
                self.deleteFromGitHub(projectId)
                self.projectsModel.removeProject(projectId)
                self.tableView.reloadData()
        })
        
        let deleteGitHubAction: UIAlertAction = UIAlertAction(title: "Auf GitHub".localized, style: .Default, handler: { (Void) -> Void in
                self.deleteFromGitHub(projectId)
                self.projectsModel.updateGistId(id: projectId, gistId: "")
        })
        
        let alertController: UIAlertController = UIAlertController(title: "Projekt löschen".localized, message: "Wo wollen Sie das Projekt löschen?".localized, preferredStyle: .Alert)
        alertController.addAction(cancelAction)
        alertController.addAction(deleteLocalAction)
        if (self.projectsModel.getGistId(projectId) != "") {
            alertController.addAction(deleteGitHubAction)
            alertController.addAction(deleteBothAction)
        }
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func deleteFromGitHub(projectId: Int) {
        let api = ProjectsApi()
        let gistId = self.projectsModel.getGistId(projectId)
        api.delete(gistId, onCompletion: {
            gistId, err in
            self.showDeleteAlertController(gistId!, err: err)
        })
    }
    
    func showDeleteAlertController(gistId: String, err: NSError?) {
        if (err != nil) {
            AlertView.showErrorView("Projekt konnte nicht gelöscht werden".localized)
        } else {
            AlertView.showInfoView("Projekt löschen".localized, message: "Projekt wurde erfolgreich gelöscht".localized)
        }
    }
    
    @IBAction func showActionSheet(sender: AnyObject) {
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        
        let projectAction = UIAlertAction(title: "Leeres Projekt-Snippet erstellen".localized, style: .Default, handler: {
            (alert: UIAlertAction) -> Void in
            
            self.showCreateProjectViewController(projectId: -1, cart: nil)
        })
        
        let fromCartAction = UIAlertAction(title: "Projekt aus Warenkorb erstellen".localized, style: .Default, handler: {
            (alert: UIAlertAction) -> Void in
            
            self.createFromCart = true
            self.title = "Warenkorb auswählen...".localized
            self.tableView.reloadData()
        })
        
        let cancelAction = UIAlertAction(title: "Abbrechen".localized, style: .Cancel, handler: {
            (alert: UIAlertAction) -> Void in
        })
        
        optionMenu.addAction(projectAction)
        optionMenu.addAction(fromCartAction)
        optionMenu.addAction(cancelAction)
        
        self.presentViewController(optionMenu, animated: true, completion: nil)
    }
    
}
