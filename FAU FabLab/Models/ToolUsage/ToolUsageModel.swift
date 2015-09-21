import Foundation

class ToolUsageModel: NSObject {
    
    static let sharedInstance = ToolUsageModel()
    
    private let api = ToolUsageApi()
    
    private var toolUsages = [ToolUsage]()
    private var isLoading = false
    
    override init() {
        super.init()
    }
    
    func fetchToolUsagesForTool(toolId: Int64, onCompletion: ApiResponse) {
        if isLoading {
            onCompletion(nil)
            return
        }
        
        isLoading = true
        
        api.getUsageForTool(toolId, onCompletion: {
            (result, error) -> Void in
            if error != nil {
                AlertView.showErrorView("Fehler beim Laden der Reservierungen".localized)
            } else if let result = result {
                self.toolUsages = result
                Debug.instance.log(result)
                Debug.instance.log(self.toolUsages)
            }
            
            self.isLoading = false
            onCompletion(error)
        })
        
    }
    
    func getCount() -> Int {
        Debug.instance.log(toolUsages.count)
        return toolUsages.count
    }
    
    func getToolUsage(index: Int) -> ToolUsage {
        return toolUsages[index]
    }
    
    //in seconds
    func getStartingTimeOfToolUsage(index: Int) -> Int64 {
        if index == 0 {
            return (toolUsages[0].creationTime!)/1000
        } else if index == 1 {
            return ((toolUsages[0].creationTime!)+(toolUsages[0].duration!*60*1000))/1000
        }
        var time = toolUsages[0].creationTime!
        for i in 0...index-1 {
            time = time + (toolUsages[i].duration!*60*1000)
        }
        return time/1000
    }
    
    
    
    
    
}