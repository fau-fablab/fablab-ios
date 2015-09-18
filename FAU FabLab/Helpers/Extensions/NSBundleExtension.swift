extension NSBundle {
    
    var releaseVersionString: String? {
        return self.infoDictionary?["CFBundleShortVersionString"] as? String
    }
}