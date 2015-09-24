import Foundation
import UIKit

class CartNavigationButtonController: NSObject {
    
    static let sharedInstance = CartNavigationButtonController()
    
    private let model = CartModel.sharedInstance
    
    private var viewController: UIViewController?
    
    private var barButtonItem: BBBadgeBarButtonItem!
    
    
    private override init() {
        super.init()
        
        //create custom bar buttom item with badge
        let button = UIButton(frame: CGRectMake(0, 0, 22.5, 22.5))
        let image = UIImage(named: "icon_cart", inBundle: nil, compatibleWithTraitCollection: nil)?
            .imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        button.setImage(image, forState: .Normal)
        button.tintColor = UIColor.fabLabGreenNavBar()
        button.addTarget(self, action: "showCart", forControlEvents: UIControlEvents.TouchUpInside)
        barButtonItem = BBBadgeBarButtonItem(customUIButton: button)
        barButtonItem.badgeOriginX = 13
        barButtonItem.badgeOriginY = -9
        barButtonItem.shouldHideBadgeAtZero = true
        barButtonItem.shouldAnimateBadge = true
        barButtonItem.target = self
        barButtonItem.action = "showCart"
        updateBadge()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "orientationDidChange", name: UIDeviceOrientationDidChangeNotification, object: nil)

    }
    
    func orientationDidChange() {
        if(UIDeviceOrientationIsLandscape(UIDevice.currentDevice().orientation)) {
            barButtonItem.badgeOriginY = -2
        } else if (UIDeviceOrientationIsPortrait(UIDevice.currentDevice().orientation)) {
            barButtonItem.badgeOriginY = -9
        }
    }

    
    @objc func showCart() {
        let cartViewController = viewController?.storyboard!.instantiateViewControllerWithIdentifier("CartView") as! CartViewController
        viewController?.navigationController?.pushViewController(cartViewController, animated: true)
        
    }
    
    func updateBadge() {
        barButtonItem.badgeValue = String(model.getNumberOfProductsInCart())
    }
    
    func refreshBadge() {
        barButtonItem.refreshBadge()
    }
    
    func setViewController(viewController: UIViewController) {
        self.viewController = viewController
        viewController.navigationItem.rightBarButtonItem = barButtonItem
        refreshBadge()
    }
    
    
}