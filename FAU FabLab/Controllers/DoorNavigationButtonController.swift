
import Foundation
import UIKit

class DoorNavigationButtonController: NSObject {

    private let dsm = DoorStateModel()
    
    private let red = UIColor(red: 0.81, green: 0.12, blue: 0.18, alpha: 1.0)
    private let green = UIColor(red: 0.00, green: 0.59, blue: 0.42, alpha: 1.0)
    
    func updateButtons(vc: UIViewController) {
        showButton(vc)
    }
    
    func showText(vc: UIViewController) {
        dsm.getDoorState()
        
        let buttonClosed = getClosedText(vc)
        let buttonOpen = getOpenText(vc)
        
        if dsm.isOpen {
            buttonClosed.title = buttonClosed.title! /*+ doorState.lastchange*/ + " h"
            vc.navigationItem.leftBarButtonItem = buttonOpen
        } else {
            buttonClosed.title = buttonClosed.title! /*+ doorState.lastchange*/ + " h"
            vc.navigationItem.leftBarButtonItem = buttonClosed
        }
    }
    
    func showButton(vc: UIViewController) {
        dsm.getDoorState()
        
        let buttonClosed = getClosedButton(vc)
        let buttonOpen = getOpenButton(vc)
        
        if dsm.isOpen {
            vc.navigationItem.leftBarButtonItem = buttonOpen
        } else {
            vc.navigationItem.leftBarButtonItem = buttonClosed
        }
    }
    
    func getOpenButton(vc: UIViewController) -> UIBarButtonItem {
        let buttonOpen = UIBarButtonItem(image: UIImage(named: "icon_door_open"), style: UIBarButtonItemStyle.Plain, target: vc, action: "showText")
        buttonOpen.tintColor = green
        return buttonOpen
    }
    
    func getClosedButton(vc: UIViewController) -> UIBarButtonItem {
        let buttonClosed = UIBarButtonItem(image: UIImage(named: "icon_door_closed"), style: UIBarButtonItemStyle.Plain, target: vc, action: "showText")
        buttonClosed.tintColor = red
        return buttonClosed
    }
    
    func getOpenText(vc: UIViewController) -> UIBarButtonItem {
        let textOpen = UIBarButtonItem(title: "open ", style: UIBarButtonItemStyle.Plain, target: vc, action: "showButton")
        textOpen.tintColor = green
        return textOpen
    }
    
    func getClosedText(vc: UIViewController) -> UIBarButtonItem {
        let textClosed = UIBarButtonItem(title: "closed ", style: UIBarButtonItemStyle.Plain, target: vc, action: "showButton")
        textClosed.tintColor = red
        return textClosed
    }
    
}