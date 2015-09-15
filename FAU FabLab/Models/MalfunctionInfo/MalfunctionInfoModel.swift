import Foundation

class MalfunctionInfoModel : NSObject{
    
    static let sharedInstance = MalfunctionInfoModel()
    
    private let drupalApi   = DrupalApi()
    private let dataApi     = DataApi()
    
    private var tools = [FabTool]()
    
    private var isFetching = false
    private var fetchingMailDone = false
    private var fetchingToolsDone = false
    private(set) var fablabMail: String?

    override init() {
        super.init()
    }
    
    func getCount() -> Int{
        return tools.count
    }
    
    func get(position: Int) -> FabTool{
        return tools[position]
    }
    
    func getAllNames() -> [String]{
        var names = [String]()
        for tool in tools{
            names.append(tool.title!)
        }
        return names
    }
    
    func fetchFablabMailAddress(onCompletion: () -> Void){
        if(fetchingMailDone){
            onCompletion()
            return
        }
        dataApi.getFablabMailAddress({ mail, err in
            if (err != nil) {
                AlertView.showErrorView("Fehler beim Abrufen der FabLab Email".localized)
                onCompletion()
                return
            }
            self.fablabMail = mail
            self.fetchingMailDone = true
            Debug.instance.log(mail)
            onCompletion()
        })
    }
    
    func fetchAllTools(onCompletion: () -> Void){
        if(fetchingToolsDone || isFetching){
            onCompletion()
            return
        }

        isFetching = true
        drupalApi.findAllTools({ tools, err in
            if (err != nil) {
                AlertView.showErrorView("Fehler beim Abrufen der FabLab Tools".localized)
                onCompletion()
            }
            else if let tools = tools{
                for tool in tools{
                    Debug.instance.log(tool.title)
                    self.tools.append(tool)
                }
                self.isFetching = false
                self.fetchingToolsDone = true
                onCompletion()
            }
        })
    }
}
