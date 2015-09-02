extension NSBundle {
    
    var releaseVersionString: String? {
        return self.infoDictionary?["CFBundleShortVersionString"] as? String
    }
    
    var buildNumberAsInt: Int? {
        let buildNumber =  self.infoDictionary?["CFBundleVersion"] as? String
        return buildNumber?.toInt()
    }
    
}