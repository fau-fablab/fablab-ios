import Foundation
import ObjectMapper

class MalfunctionInfoModel : NSObject{
    
    static let sharedInstance = MalfunctionInfoModel()
    
    private let resource = "/drupal";
    private var tools = [FabTool]()
    private var mapper: Mapper<FabTool>;
    
    private var isFetching = false
    private var fetchingMailDone = false
    private var fetchingToolsDone = false
    private(set) var fablabMail: String?

    override init() {
        mapper = Mapper<FabTool>()
        super.init()
    }
    
    func getCount() -> Int{
        return tools.count
    }
    
    func get(position: Int) -> FabTool{
        return tools[position]
    }
    
    func getAllNames() -> [String]{
        var names = [String]()
        for tool in tools{
            names.append(tool.title!)
        }
        return names
    }
    
    func fetchFablabMailAddress(onCompletion: () -> Void){
        if(fetchingMailDone){
            onCompletion()
            return
        }
        let endpoint = "/data" + "/fablab-mail"
        RestManager.sharedInstance.makeGetRequest(endpoint, params: nil, onCompletion: {
            json, err in
                
            if (err != nil) {
                AlertView.showErrorView("Fehler beim Abrufen der Fablab Email".localized)
                onCompletion()
                return
            }
            self.fablabMail = json
            self.fetchingMailDone = true
            Debug.instance.log(json)
            onCompletion()
        })
    }
    
    func fetchAllTools(onCompletion: () -> Void){
        if(fetchingToolsDone){
            onCompletion()
            return
        }
        if(!isFetching){
            isFetching = true
            let endpoint = resource + "/tools"
            RestManager.sharedInstance.makeJsonGetRequest(endpoint, params: nil, onCompletion:{
                json, err in
                
                if (err != nil) {
                    AlertView.showErrorView("Fehler beim Abrufen der Fablab Tools".localized)
                    onCompletion()
                }
                
                if let tools = self.mapper.mapArray(json){
                    for tmp in tools{
                        Debug.instance.log(tmp.title)
                        self.tools.append(tmp)
                    }
                    self.fetchingToolsDone = true
                    onCompletion()
                }
            })
            isFetching = false
            return
        }
    }
}
