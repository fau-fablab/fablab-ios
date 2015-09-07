import Foundation
import ObjectMapper

public class VersionCheckModel: NSObject {

    private let resource = "/versionCheck";
    private var isLoading = false;
    private var versionCheckLoaded = false;
    private var mapper:Mapper<UpdateStatus>;
    
    override init() {
        mapper = Mapper<UpdateStatus>()
        super.init()
    }
}

//MARK: VersionCheckApi implementation
extension VersionCheckModel : VersionCheckApi{
    
    func checkVersion(platformType: PlatformType, version: Int, onCompletion: (UpdateStatus) -> Void){
        let params: [String : AnyObject] = ["platformType" : platformType.rawValue, "currentVersion" : version]
        println(params)
        RestManager.sharedInstance.makeJSONRequest(.GET, encoding: .JSON, resource: resource, params: params, onCompletion: {
            json, error in
            if(error != nil){
                Debug.instance.log(error)
            }
            else{
                if let updateStatus = self.mapper.map(json){
                    onCompletion(updateStatus)
                }
            }
        })
    }
}