import ObjectMapper

struct ProjectsApi {
    
    private let api = RestManager.sharedInstance
    private let projectsMapper = Mapper<ProjectFile>()
    private let resource = "/projects/create"
    
    func create(project: ProjectFile, onCompletion: (String?, NSError?) -> Void) {
        let params = projectsMapper.toJSON(project)
        
        api.makeTextRequest(.POST, encoding: .JSON, resource: resource, params: params, onCompletion: {
            response, err in
        
            if (err != nil) {
                onCompletion(nil, err)
            } else {
                onCompletion(response, nil)
            }
        })
    }
}
