import Foundation

public typealias Task<T> = (
    _ completion: @escaping (T) -> ()) -> ()
