import Foundation

class ToolModel: NSObject {
    
    static let sharedInstance = ToolModel()
    
    private let api = ToolUsageApi()
    
    private var tools = [FabTool]()
    private var isLoading = false
    private var toolsLoaded = false
    
    override init() {
        super.init()
    }
    
    func fetchTools(onCompletion: ApiResponse) {
        if isLoading || toolsLoaded {
            onCompletion(nil)
            return
        }
        
        isLoading = true
        
        api.getEnabledTools({ (result, error) -> Void in
            if error != nil {
                AlertView.showErrorView("Fehler beim Laden der Maschinen".localized)
            } else if let result = result {
                self.tools = result
                self.toolsLoaded = true
                Debug.instance.log(result)
                Debug.instance.log(self.tools)
            }
            
            self.isLoading = false
            onCompletion(error)
        })
    }
    
    func getCount() -> Int {
        return tools.count
    }
    
    func getTool(index: Int) -> FabTool {
        return tools[index]
    }
    
    func getToolName(index: Int) -> String {
        if tools.isEmpty || tools.count <= index {
            return ""
        }
        return tools[index].title!
    }
    
    func getToolNames() -> [String] {
        var names = [String]()
        for tool in tools {
            names.append(tool.title!)
        }
        return names
    }
    
}
