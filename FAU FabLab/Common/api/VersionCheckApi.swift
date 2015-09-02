protocol VersionCheckApi {
    func checkVersion(platformType: PlatformType, version: Int, onCompletion: (UpdateStatus) -> Void)
}
