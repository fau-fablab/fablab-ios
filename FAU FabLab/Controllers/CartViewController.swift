import UIKit
import Foundation


class CartViewController : UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate{

    @IBOutlet weak var tableView: UITableView!
    private var checkoutModel = CheckoutModel()
    private var cart = Cart()
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "checkoutCodeScanned:", name: "CheckoutScannerNotification", object: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    
    
   
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell! = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
        
        return cell;
    }
    
    //Checkout process
    private func checkoutCodeScanned(notification:NSNotification) {
        println("Got Notification from Scanner, code: \(notification.object)")
        self.checkout(notification.object as! String)
    }
    
    
    private func checkout(code: String){
        cart.setCode(code)
        checkoutModel.sendCartToServer(cart, onCompletion: { error in
            
        })
        
    }
    
    //DEV BUTTONS
    @IBAction func SCAN(sender: AnyObject) {
        RestManager.sharedInstance.makeJsonGetRequest("/checkout/createCode", params: ["password": "dummyPassword"], onCompletion: {
            json, err in
            
            let p1 = Product()
            p1.setId("123")
            let e1 = CartEntry(product: p1, amount: 1.0)
            
            let p2 = Product()
            p2.setId("123")
            let e2 = CartEntry(product: p2, amount: 5.0)
            
            self.cart.addEntry(e1)
            self.cart.addEntry(e2)
            self.cart.setStatus(Cart.CartStatus.PENDING)
            self.checkout(String(json as! Int))
        })

    }
    
    @IBAction func STATUS(sender: AnyObject) {
        let requ = "/\(cart.cartCode)"
        RestManager.sharedInstance.makeJsonGetRequest(requ, params: nil, onCompletion: {
            json, err in
            println("CART: \(json)")
        })
    }
    @IBAction func PAID(sender: AnyObject) {
        let requ = "/canelled/\(cart.cartCode)"
        RestManager.sharedInstance.makeJsonGetRequest(requ, params: nil, onCompletion: {
            json, err in
            println("PAID! \(json)")
        })
    }
    
    @IBAction func CANCELLED(sender: AnyObject) {
        let requ = "/paid/\(cart.cartCode)"
        RestManager.sharedInstance.makeJsonGetRequest(requ, params: nil, onCompletion: {
            json, err in
            println("CANCELLED! \(json)")
        })
    }

}