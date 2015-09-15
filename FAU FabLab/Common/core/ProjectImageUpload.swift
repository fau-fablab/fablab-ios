
import Foundation
import ObjectMapper

class ProjectImageUpload: Mappable {

    private(set) var filename: String?
    private(set) var data: [UInt8]?
    private(set) var repoId: String?
    
    class func newInstance() -> Mappable {
        return ProjectFile()
    }
    
    func mapping(map: Map) {
        filename <- map["filename"]
        data <- map["data"]
        repoId <- map["repoId"]
    }
    
    func setFilename(filename: String) {
        self.filename = filename
    }
    
    func setData(data: [UInt8]) {
        self.data = data
    }
    
    func setRepoId(repoId: String) {
        self.repoId = repoId
    }
}