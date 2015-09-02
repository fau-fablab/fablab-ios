protocol VersionCheckApi {
    func checkVersion(platformType: PlatformType, version: Int) -> UpdateStatus
}
