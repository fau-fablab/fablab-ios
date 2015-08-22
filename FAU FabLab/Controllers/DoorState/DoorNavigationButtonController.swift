
import Foundation
import UIKit

class DoorNavigationButtonController: NSObject {
    
    static let sharedInstance = DoorNavigationButtonController()

    private let model = DoorStateModel()
    private var viewController: UIViewController?
    
    private let red = UIColor(red: 0.81, green: 0.12, blue: 0.18, alpha: 1.0)
    private let green = UIColor(red: 0.00, green: 0.59, blue: 0.42, alpha: 1.0)

    private var buttonIcon: UIBarButtonItem{
        let img = model.isOpen ? UIImage(named: "icon_door_open") : UIImage(named: "icon_door_closed")
        let button = UIBarButtonItem(image: img!, style: UIBarButtonItemStyle.Plain, target: self, action: "showText")
        button.tintColor = model.isOpen ? green : red

        return button
    }

    private var buttonText: UIBarButtonItem{

        let title = (model.isOpen ? "open " : "closed ") + model.lastChangeAsString
        let button = UIBarButtonItem(title: title, style: UIBarButtonItemStyle.Plain, target: self, action: "showButton")
        button.tintColor = model.isOpen ? green : red

        return button
    }

    private override init() {
        super.init()
    }
    
    func setViewController(vc: UIViewController) {
        self.viewController = vc
        showButton()
    }
    
    func showText() {
        model.getDoorState()

        viewController!.navigationItem.leftBarButtonItem = buttonText
    }
    
    func showButton() {
        model.getDoorState()
        viewController!.navigationItem.leftBarButtonItem = buttonIcon
    }
}