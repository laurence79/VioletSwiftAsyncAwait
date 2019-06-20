import Foundation

public enum DispatchPolicy {
    case onCurrentQueue
    case onMainQueue
    case onSpecificQueue(_ queue: DispatchQueue)
    
    public func dispatch(_ block: @escaping () -> ()) {
        return dispatch(execute: DispatchWorkItem(block: block))
    }
    
    public func dispatch(execute: DispatchWorkItem) {
        switch self {
        case .onCurrentQueue:
            execute.perform()
        case .onMainQueue:
            DispatchQueue.main.async(execute: execute)
        case .onSpecificQueue(let queue):
            queue.async(execute: execute)
        }
    }
}
