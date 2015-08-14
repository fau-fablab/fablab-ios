import UIKit
import CoreActionSheetPicker

class ActionSheetPickerDelegate: NSObject, ActionSheetCustomPickerDelegate {
    
    private var unit: String!
    private var price: Double!
    private var successAction: (Int) -> Void
    
    private var amounts: [Int]!
    private var amount: Int!
    
    init(unit: String, price: Double, successAction: (Int) -> Void) {
        self.unit = unit
        self.price = price
        self.successAction = successAction
        self.amounts = [Int]();
        for number in 1...100 {
            self.amounts.append(number);
        }
        self.amount = amounts[0];
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(component == 0) {
            return amounts.count
        } else {
            return 1
        }
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(component == 0) {
            amount = amounts[row]
            pickerView.reloadComponent(1)
        }
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(component == 0) {
            return "\(amounts[row]) \(unit!)"
        } else {
            return "\(Double (amount) * price!) €"
        }
    }
    
    func actionSheetPickerDidSucceed(actionSheetPicker: AbstractActionSheetPicker!, origin: AnyObject!) {
        successAction(amount)
    }
    
}
