import Foundation
import ObjectMapper

class MalfunctionInfoModel : NSObject{
    
    private let resource = "/drupal";
    private var tools = [FabTool]()
    private var mapper: Mapper<FabTool>;
    
    private var isFetching = false
    private var fetchingDone = false
    private(set) var fablabMail: String?

    override init() {
        mapper = Mapper<FabTool>()
        super.init()
        fetchFablabMailAddress({})
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
    
    private func fetchFablabMailAddress(onCompletion: () -> Void){
        let endpoint = "/data" + "/fablab-mail"
        RestManager.sharedInstance.makeGetRequest(endpoint, params: nil, onCompletion: {
            json, err in
            
            if (err != nil) {
                //TODO error handling is not working here, endpoint seems to be corrupt
                Debug.instance.log("Error while fetching email!")
            }
            self.fablabMail = json
            Debug.instance.log(json)
            onCompletion()
        })
        return
    }
    
    func fetchAllTools(onCompletion: () -> Void){
        if(!isFetching){
            isFetching = true
            let endpoint = resource + "/tools"
            RestManager.sharedInstance.makeJsonGetRequest(endpoint, params: nil, onCompletion:{
                json, err in
                
                if (err != nil) {
                    //TODO error handling
                    Debug.instance.log("Error while fetching news!")
                }
                
                if let tools = self.mapper.mapArray(json){
                    for tmp in tools{
                        Debug.instance.log(tmp.title)
                        self.tools.append(tmp)
                    }
                    self.fetchingDone = true
                    onCompletion()
                }
            })
            return
        }
        onCompletion()
    }
}
