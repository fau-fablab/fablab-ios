import Foundation
import ObjectMapper

class MalfunctionInfoModel : NSObject{
    
    private let resource = "/drupal";
    private var tools = [FabTool]()
    private var mapper:Mapper<FabTool>;

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
    
    func fetchAllTools(onCompletion: () -> Void){
        let endpoint = resource + "/tools"
        RestManager.sharedInstance.makeJsonGetRequest(endpoint, params: nil, onCompletion:{
            json, err in
            
            if (err != nil) {
                Debug.instance.log("Error while fetching news!")
            }
            
            if let tools = self.mapper.mapArray(json){
                for tmp in tools{
                    Debug.instance.log(tmp.title)
                    self.tools.append(tmp)
                }
                onCompletion()
            }

        })
    }

}
