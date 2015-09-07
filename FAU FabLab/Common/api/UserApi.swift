import ObjectMapper

struct UserApi {
    
    let api = RestManager.sharedInstance
    let mapper = Mapper<User>()
    let resource = "/user"

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
