import Foundation

public func spawn(_ a: @escaping Task<()>) {
    a{_ in }
}

public func spawn(_ cancel: Cancellation, _ a: @escaping () -> CancellableTask<()>) {
    a()({_, _ in }, cancel)
}
