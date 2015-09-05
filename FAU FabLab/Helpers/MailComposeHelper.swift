
import Foundation
import MessageUI

class MailComposeHelper : NSObject {
    
    class func getMailComposeViewController(#delegate: MFMailComposeViewControllerDelegate, recipients: [String], subject: String, messageBody: String, isHTML: Bool) -> MFMailComposeViewController {
        
        var mailVC = MFMailComposeViewController()
        mailVC.mailComposeDelegate = delegate
        mailVC.navigationBar.tintColor = UIColor.fabLabGreen()
        mailVC.setToRecipients(recipients)
        mailVC.setSubject(subject)
        mailVC.setMessageBody(messageBody, isHTML: isHTML)
        
        return mailVC
    }
    
    class func showOutOfStockMailComposeView(#delegate: MFMailComposeViewControllerDelegate, recipients: [String], productId: String, productName: String) -> MFMailComposeViewController {
        return getMailComposeViewController(delegate: delegate, recipients: recipients, subject: "Bestandsmeldung".localized, messageBody: getMessageBody(productId: productId, productName: productName), isHTML: true)
    }
    
    class func getMessageBody(#productId: String, productName: String) -> String {
        return "Produkt ist nicht mehr auf Lager.".localized + "</br></br><b>" + "Produkt ID".localized + ":</b> </br>"
            + "\(productId)</br> </br> <b>" + "Produkt Name".localized + ": </b> </br> \(productName)"
            + "</br></br>" + "Gesendet mit der FAU FabLab-App für iOS".localized
    }
    
    class func getCancelAlertController() -> UIAlertController {
        var alert = UIAlertController(title: "Abgebrochen".localized, message: "Meldung wurde nicht versendet!".localized, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK".localized, style: UIAlertActionStyle.Default, handler: nil))
        return alert
    }
    
    class func getSentAlertController() -> UIAlertController {
        var alert = UIAlertController(title: "Versendet".localized, message: "Ausgegangenes Produkt wurde gemeldet!".localized, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK".localized, style: UIAlertActionStyle.Default, handler: nil))
        return alert
    }
    
}