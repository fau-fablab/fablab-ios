import UIKit

extension UIColor {
    
    @objc class func fabLabBlue() -> UIColor {
        return UIColor(red: 0.05, green: 0.23, blue: 0.38, alpha: 1.0)
    }
    
    @objc class func fabLabBlueSeperator() -> UIColor {
        return fabLabBlue().colorWithAlphaComponent(0.5)
    }
    
    @objc class func fabLabGreen() -> UIColor {
        //return UIColor(red: 0.00, green: 0.59, blue: 0.42, alpha: 1.0) //original
        return fabLabGreenNavBar()
    }
    
    @objc class func fabLabGreenNavBar() -> UIColor {
        return UIColor(red: 0.00, green: 0.65, blue: 0.47, alpha: 1.0)
    }
    
    @objc class func fabLabRed() -> UIColor {
        return UIColor(red: 0.61, green: 0.09, blue: 0.12, alpha: 1.0)
    }
}