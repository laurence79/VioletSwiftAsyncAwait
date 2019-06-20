import Foundation

public typealias FailableTask<T> = (
    _ completion: @escaping (T?, Error?) -> ()) -> ()
