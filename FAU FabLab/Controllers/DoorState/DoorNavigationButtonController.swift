
import Foundation
import UIKit

class DoorNavigationButtonController: NSObject {

    private enum ButtonState {
        case Icon
        case Text
    }
    
    static let sharedInstance = DoorNavigationButtonController()

    private let model = DoorStateModel()

    private let red     = UIColor(red: 0.81, green: 0.12, blue: 0.18, alpha: 1.0)
    private let green   = UIColor(red: 0.00, green: 0.59, blue: 0.42, alpha: 1.0)

    private var timer = NSTimer();
    private var state = ButtonState.Icon
    private var viewController: UIViewController?

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
        self.timer = NSTimer.scheduledTimerWithTimeInterval(30, target: self, selector: "fetchDoorStateTask:", userInfo: nil, repeats: true)
        self.timer.fire()
    }
    
    func setViewController(vc: UIViewController) {
        self.viewController = vc
        restoreButtonState()
    }

    private func restoreButtonState(){
        state == ButtonState.Icon ? showButton() : showText()
    }

    @objc func fetchDoorStateTask(timer: NSTimer) {
        model.getDoorState()
    }

    @objc private func showText() {
        viewController!.navigationItem.leftBarButtonItem = buttonText
        state = ButtonState.Text
    }

    @objc private func showButton() {
        viewController!.navigationItem.leftBarButtonItem = buttonIcon
        state = ButtonState.Icon
    }
}