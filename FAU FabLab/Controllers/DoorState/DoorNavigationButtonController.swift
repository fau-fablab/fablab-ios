
import Foundation
import UIKit

class DoorNavigationButtonController: NSObject {
    
    static let sharedInstance = DoorNavigationButtonController()

    private let dsm = DoorStateModel()
    private var viewController: UIViewController?
    
    private let red = UIColor(red: 0.81, green: 0.12, blue: 0.18, alpha: 1.0)
    private let green = UIColor(red: 0.00, green: 0.59, blue: 0.42, alpha: 1.0)

    private override init() {
        super.init()
    }
    
    func updateButtons(vc: UIViewController) {
        self.viewController = vc
        showButton()
    }
    
    func showText() {
        dsm.getDoorState()
        
        let lastChange = NSDate(timeIntervalSince1970: dsm.lastChange)
        let components = NSCalendar.currentCalendar().components(NSCalendarUnit.CalendarUnitHour, fromDate: lastChange, toDate: NSDate(), options: nil)
        
        let buttonClosed = getClosedText(viewController!)
        let buttonOpen = getOpenText(viewController!)
        
        if dsm.isOpen {
            buttonOpen.title = buttonOpen.title! + " \(components.hour) h"
            viewController!.navigationItem.leftBarButtonItem = buttonOpen
        } else {
            buttonClosed.title = buttonClosed.title! + " \(components.hour) h"
            viewController!.navigationItem.leftBarButtonItem = buttonClosed
        }
    }
    
    func showButton() {
        dsm.getDoorState()
        
        let buttonClosed = getClosedButton(viewController!)
        let buttonOpen = getOpenButton(viewController!)
        
        if dsm.isOpen {
            viewController!.navigationItem.leftBarButtonItem = buttonOpen
        } else {
            viewController!.navigationItem.leftBarButtonItem = buttonClosed
        }
    }
    
    func getOpenButton(vc: UIViewController) -> UIBarButtonItem {
        let buttonOpen = UIBarButtonItem(image: UIImage(named: "icon_door_open"), style: UIBarButtonItemStyle.Plain, target: self, action: "showText")
        buttonOpen.tintColor = green
        return buttonOpen
    }
    
    func getClosedButton(vc: UIViewController) -> UIBarButtonItem {
        let buttonClosed = UIBarButtonItem(image: UIImage(named: "icon_door_closed"), style: UIBarButtonItemStyle.Plain, target: self, action: "showText")
        buttonClosed.tintColor = red
        return buttonClosed
    }
    
    func getOpenText(vc: UIViewController) -> UIBarButtonItem {
        let textOpen = UIBarButtonItem(title: "open", style: UIBarButtonItemStyle.Plain, target: self, action: "showButton")
        textOpen.tintColor = green
        return textOpen
    }
    
    func getClosedText(vc: UIViewController) -> UIBarButtonItem {
        let textClosed = UIBarButtonItem(title: "closed", style: UIBarButtonItemStyle.Plain, target: self, action: "showButton")
        textClosed.tintColor = red
        return textClosed
    }
    
}