import ObjectMapper

struct ProjectsApi {
    
    private let api = RestManager.sharedInstance
    private let mapper = Mapper<ProjectFile>()
    private let resource = "/projects/create"
    
    func create(project: ProjectFile, onCompletion: (String?, NSError?) -> Void) {
        let params = mapper.toJSON(project)
        
        api.makeTextRequest(.POST, encoding: .JSON, resource: resource, params: params,
            onCompletion: { response, err in
                ApiResult.getSimpleType(response, error: err, completionHandler: onCompletion)
        })
    }
}
