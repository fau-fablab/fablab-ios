
import Foundation
import CoreActionSheetPicker

class ChangeAmountPickerHelper {
    
    class func getUIAlertController(#productName: String, productRounding: Double, productUnit: String, cancelAction: UIAlertAction, doneAction: UIAlertAction) -> UIAlertController {
        let formatString : String = getFormatStringForRounding(productRounding)
        let lowestUnit : String = String(format: formatString, productRounding)
        let message = productName + "\n" + "Kleinste Einheit".localized + ": " + lowestUnit + " " + productUnit
        
        let alertController: UIAlertController = UIAlertController(title: "Menge eingeben".localized, message: message, preferredStyle: .Alert)
        alertController.addAction(cancelAction)
        alertController.addAction(doneAction)
        
        return alertController
    }
    
    class func getFormatStringForRounding(productRounding: Double) -> String {
        return "%." + String(productRounding.digitsAfterComma) + "f"
    }
    
    class func correctWrongRounding(#amount: Double, rounding: Double) -> Double {
        let divRes = amount / rounding
        if divRes.digitsAfterComma != 0 {
            // round the user input down to match rounding.digitsAfterComma
            return amount.roundUpToRounding(rounding)
        }
        return -1
    }
    
    class func invalidInput(#amount: Double, rounding: Double) -> Bool {
        if amount < rounding || amount > Double(Int.max) {
            return true
        }
        return false
    }    
}