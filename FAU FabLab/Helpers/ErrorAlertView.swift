class ErrorAlertView {
    
    class func showErrorView(message: String?){
        let alertView = UIAlertView(title: "Fehler".localized,
            message: message,
            delegate: nil, cancelButtonTitle: "OK".localized)
        alertView.show()
    }
}