import UIKit
import CoreActionSheetPicker

class ActionSheetPickerDelegate: NSObject, ActionSheetCustomPickerDelegate {
    
    private var unit: String!
    private var price: Double!
    private var rounding: Double!
    
    private var didSucceedAction: (Double) -> Void
    private var didCancelAction: (Void) -> Void
    
    private var amounts: [Double]!
    private var amount: Double!
    
    init(unit: String, price: Double, rounding: Double, didSucceedAction: (Double) -> Void, didCancelAction: (Void) -> Void) {
        self.unit = unit
        self.price = price
        self.rounding = rounding
        self.didSucceedAction = didSucceedAction
        self.didCancelAction = didCancelAction
        self.amounts = [Double]();
        for number in 1...100 {
            self.amounts.append(Double(number));
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
            if (unit.hasPrefix("Platte")) {
                unit = "Platten".localized
            }
            return "\(amounts[row]) \(unit!)"
        } else {
            return String(format: "%.2f€".localized, Double (amount) * price!)
        }
    }
    
    func actionSheetPickerDidSucceed(actionSheetPicker: AbstractActionSheetPicker!, origin: AnyObject!) {
        didSucceedAction(amount)
    }
    
    func actionSheetPickerDidCancel(actionSheetPicker: AbstractActionSheetPicker!, origin: AnyObject!) {
        didCancelAction()
    }
    
}
