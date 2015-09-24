
import Foundation
import ObjectMapper

class ProjectImageUpload: Mappable {

    private(set) var filename:  String?
    private(set) var data:      String?
    private(set) var repoId:    String?
    
    required init?(_ map: Map){}
    
    init(){}
    
    func mapping(map: Map) {
        filename    <- map["filename"]
        data        <- map["data"]
        repoId      <- map["repoId"]
    }
    
    func setFilename(filename: String) {
        self.filename = filename
    }
    
    func setData(data: String) {
        self.data = data
    }
    
    func setRepoId(repoId: String) {
        self.repoId = repoId
    }
}