
import Foundation
import ObjectMapper

class ProjectFile : Mappable {
    
    private(set) var description:   String?
    private(set) var filename:      String?
    private(set) var content:       String?
    
    required init?(_ map: Map){}
    
    init(){}
    
    func mapping(map: Map) {
        description <- map["description"]
        filename    <- map["filename"]
        content     <- map["content"]
    }
    
    func setDescription(description: String) {
        self.description = description
    }
    
    func setFilename(filename: String) {
        self.filename = filename
    }
    
    func setContent(content: String) {
        self.content = content
    }
}