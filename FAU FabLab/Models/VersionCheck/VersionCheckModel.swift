import Foundation
import ObjectMapper

public class VersionCheckModel: NSObject {

    private var isLoading = false;
    private var versionCheckLoaded = false;
    private let api = VersionCheckApi()
    
    override init() {
        super.init()
    }
    
    func checkVersion(){
        api.checkVersion(PlatformType.APPLE, version: NSBundle.mainBundle().buildNumberAsInt!,
            onCompletion: { updateStatus, error in
            
                if(error != nil){
                    Debug.instance.log(error)
                }
                else if let status = updateStatus{
                    let title = "Update verfügbar".localized
                    let message = "Neue Version".localized + ":" + "\(status.latestVersion!) \n" + "Hinweis".localized + ": \n \(status.updateMessage!)"
                    
                    switch (status.updateAvailable!){
                    case .Required :
                        AlertView.showInfoView(title, message: "Notwendiges Update".localized + "!\n\(message)")
                    case .Optional :
                        AlertView.showInfoView(title, message: "Optionales Update".localized + "!\n\(message)")
                    default:
                        return
                    }
                }
        })
    }
}