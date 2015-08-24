
import Foundation
import UIKit

class DoorNavigationButtonController: NSObject {
    
    static let sharedInstance = DoorNavigationButtonController()

    private let model = DoorStateModel()

    private let red     = UIColor(red: 0.81, green: 0.12, blue: 0.18, alpha: 1.0)
    private let green   = UIColor(red: 0.00, green: 0.59, blue: 0.42, alpha: 1.0)

    private var timer = NSTimer();
    private var viewController: UIViewController?

    private var buttonText: UIBarButtonItem{
        var title: String
        if(model.hasState){
            title = (model.isOpen ? "open " : "closed ") + model.lastChangeAsString
        }
        else{
            title = ""
        }
        let button = UIBarButtonItem(title: title, style: UIBarButtonItemStyle.Plain, target: self, action: nil)
        button.tintColor = model.isOpen ? green : red
        
        return button
    }

    private override init() {
        super.init()
        self.timer = NSTimer.scheduledTimerWithTimeInterval(30, target: self, selector: "fetchDoorStateTask:", userInfo: nil, repeats: true)
        self.timer.fire()
    }
    
    func setViewController(vc: UIViewController) {
        viewController = vc
        showText()
    }

    @objc func fetchDoorStateTask(timer: NSTimer) {
        model.getDoorState({
            self.showText()
        })
    }
    

    @objc private func showText() {
        viewController!.navigationItem.leftBarButtonItem = buttonText
    }
}