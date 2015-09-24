class Debug {

    static var instance = Debug()

    func log<T>(message: T, file: String = __FILE__, function: String = __FUNCTION__, line: Int = __LINE__) {
        #if DEBUG
            print("[\(function) in line \(line)] : \(message)")
        #endif
    }
}