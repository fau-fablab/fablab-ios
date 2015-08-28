
import Foundation
import UIKit

class DoorNavigationButtonController: NSObject {
    
    static let sharedInstance = DoorNavigationButtonController()

    private let model = DoorStateModel()

    private var timer = NSTimer();
    private var viewController: UIViewController?

    private var buttonText: UIBarButtonItem{
        var title: String
        if(model.hasState){
            title = (model.isOpen ? "open".localized+" " : "closed".localized+" ") + model.lastChangeAsString
        }
        else{
            title = ""
        }
        let button = UIBarButtonItem(title: title, style: UIBarButtonItemStyle.Plain, target: self, action: nil)
        button.tintColor = model.isOpen ? UIColor.fabLabGreen() : UIColor.fabLabRed()
        
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