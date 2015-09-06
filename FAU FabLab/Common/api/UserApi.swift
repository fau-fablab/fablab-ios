import ObjectMapper

struct UserApi {
    
    let api = RestManager.sharedInstance
    let mapper = Mapper<User>()
    
    func getUserInfo(user: User, onCompletion: (User?, NSError?) -> Void){
    
        let resource = api.apiUrl + "/user"
        let params = mapper.toJSON(user)
        
        api.makeJsonGetRequestWithBasicAuth(resource, username: user.username!, password: user.password!, params: params,
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
