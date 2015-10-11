import ObjectMapper

struct ProjectsApi {
    
    private let api = RestManager.sharedInstance
    private let mapper = Mapper<ProjectFile>()
    private let imageMapper = Mapper<ProjectImageUpload>()
    
    private let resourceCreate = "/projects/create"
    private let resourceUpdate = "/projects/"
    private let resourceImage = "/projects/image/upload"
    
    func create(project: ProjectFile, onCompletion: (String?, NSError?) -> Void) {
        let params = mapper.toJSON(project)
        
        api.makeTextRequest(.POST, encoding: .JSON, resource: resourceCreate, params: params,
            onCompletion: { response, err in
                ApiResult.getSimpleType(response, error: err, completionHandler: onCompletion)
        })
    }
    
    func delete(repoId: String, onCompletion: (String?, NSError?) -> Void) {
        let url = resourceUpdate + repoId
        
        api.makeTextRequest(.DELETE, encoding: .JSON, resource: url, params: nil,
            onCompletion: { response, err in
                ApiResult.getSimpleType(response, error: err, completionHandler: onCompletion)
        })
    }
    
    func update(repoId: String, project: ProjectFile, onCompletion: (String?, NSError?) -> Void) {
        let params = mapper.toJSON(project)
        let url = resourceUpdate + repoId
        
        api.makeTextRequest(.PUT, encoding: .JSON, resource: url, params: params,
            onCompletion: { response, err in
                ApiResult.getSimpleType(response, error: err, completionHandler: onCompletion)
        })
    }
    
    func uploadImage(image: ProjectImageUpload, onCompletion: (String?, NSError?) -> Void) {
        let params = imageMapper.toJSON(image)
        
        api.makeTextRequest(.POST, encoding: .JSON, resource: resourceImage, params: params,
            onCompletion: { response, err in
                ApiResult.getSimpleType(response, error: err, completionHandler: onCompletion)
        })
    }
}
