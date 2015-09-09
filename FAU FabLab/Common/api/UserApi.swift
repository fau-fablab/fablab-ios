import ObjectMapper

struct UserApi {
    
    private let api = RestManager.sharedInstance
    private let mapper = Mapper<User>()
    private let resource = "/user"

    func getUserInfo(user: User, onCompletion: (User?, NSError?) -> Void){
        api.makeJSONRequestWithBasicAuth(.GET, encoding: .URL, resource: resource, username: user.username!, password: user.password!, params: nil,
            onCompletion: {
                JSON, err in
                
                if(err != nil){
                    onCompletion(nil, err)
                }
                else{
                    onCompletion(self.mapper.map(JSON), nil)
                }
        })
    }
}
