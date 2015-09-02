class AlertView {
    
    class func showErrorView(message: String?){
        let alertView = UIAlertView(title: "Fehler".localized,
            message: message,
            delegate: nil, cancelButtonTitle: "OK".localized)
        alertView.show()
    }
    
    class func showInfoView(title: String?, message: String?){
        let alertView = UIAlertView(title: title,
            message: message,
            delegate: nil, cancelButtonTitle: "OK".localized)
        alertView.show()
    }
}