import Foundation
import UIKit

class CartNavigationButtonController: NSObject {
    
    static let sharedInstance = CartNavigationButtonController()
    
    private let model = CartModel()
    
    private var viewController: UIViewController?
    
    private var barButtonItem: BBBadgeBarButtonItem!
    
    
    private override init() {
        super.init()
        
        //create custom bar buttom item with badge
        var button = UIButton(frame: CGRectMake(0, 0, 22.5, 22.5))
        var image = UIImage(named: "icon_cart", inBundle: nil, compatibleWithTraitCollection: nil)?
            .imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        button.setImage(image, forState: .Normal)
        button.tintColor = UIColor(red: 0.0, green: 122.0/255.0, blue: 1.0, alpha: 1.0)
        button.addTarget(self, action: "showCart", forControlEvents: UIControlEvents.TouchUpInside)
        barButtonItem = BBBadgeBarButtonItem(customUIButton: button)
        barButtonItem.badgeOriginX = 13
        barButtonItem.badgeOriginY = -9
        barButtonItem.shouldHideBadgeAtZero = true
        barButtonItem.shouldAnimateBadge = true
        barButtonItem.target = self
        barButtonItem.action = "showCart"
        updateBadge()

    }
    
    @objc func showCart() {
        let cartViewController = viewController?.storyboard!.instantiateViewControllerWithIdentifier("CartViewController") as! CartViewController
        viewController?.navigationController?.pushViewController(cartViewController, animated: true)
        
    }
    
    func updateBadge() {
        barButtonItem.badgeValue = String(model.getNumberOfProductsInCart())
    }
    
    func setViewController(viewController: UIViewController) {
        self.viewController = viewController
        updateBadge()
        viewController.navigationItem.rightBarButtonItem = barButtonItem
    }
    
    
}