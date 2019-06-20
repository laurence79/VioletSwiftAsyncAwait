import Foundation

public typealias CancellationReceipt = Int

public protocol Cancellation {
    var cancelled: Bool { get }
    
    @discardableResult
    func onCancel(_ closure: @escaping () -> ()) -> CancellationReceipt
    
    func remove(_ receipt: CancellationReceipt)
}

public final class CancellationSource: Cancellation {
    private let semaphore = DispatchSemaphore(value: 1)
    private var closures = [CancellationReceipt: () -> ()]()
    private let closureSequence = Atomic<Int>(0)
    public private(set) var cancelled = false
    public init() { }
    
    @discardableResult
    public func onCancel(_ closure: @escaping () -> ()) -> CancellationReceipt {
        semaphore.wait()
        let seq = closureSequence.increment()
        if !cancelled {
            closures[seq] = closure
        } else {
            closure()
        }
        semaphore.signal()
        return seq
    }
    public func remove(_ receipt: CancellationReceipt) {
        semaphore.wait()
        closures.removeValue(forKey: receipt)
        semaphore.signal()
    }
    public func cancel() {
        semaphore.wait()
        if !cancelled {
            cancelled = true
            closures.values.forEach { $0() }
            closures.removeAll()
        }
        semaphore.signal()
    }
}

extension CancellationSource {
    static var never: Cancellation {
        get {
            return Never()
        }
    }
    private class Never: Cancellation {
        var cancelled = false
        
        func onCancel(_ closure: @escaping () -> ()) -> Int {
            return -1
        }
        public func remove(_ receipt: CancellationReceipt) {}
    }
}


