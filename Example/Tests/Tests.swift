// https://github.com/Quick/Quick

import Quick
import Nimble
import VioletSwiftAsyncAwait

class AsyncAwaitSpec: QuickSpec {
    override func spec() {
        describe("Task") {
            it("runs") {
                let createAThingTask = async {
                    return "a thing"
                }
                let createAThingResult = await(createAThingTask)
                
                expect(createAThingResult).to(equal("a thing"))
            }
            it("awaits background queues") {
                let queue = DispatchQueue.init(label: "a background queue", qos: .background, attributes: .concurrent, autoreleaseFrequency: .inherit, target: nil)
                let createAThingTask = async(.onSpecificQueue(queue)) {
                    return "a thing on " + currentQueueName()!
                }
                let createAThingResult = await(createAThingTask)
                
                expect(createAThingResult).to(equal("a thing on a background queue"))
            }
            it("propogates errors") {
                enum FancyError: Error {
                    case properFancy
                }
                let howFancy = async {
                    throw FancyError.properFancy
                }
                var errorThrown = false
                do {
                    try await(howFancy)
                }
                catch {
                    errorThrown = true
                }
                expect(errorThrown).to(beTrue())
            }
            it("is cancellable") {
                let cancellationSource = CancellationSource()
                let longTask = async { cancel in
                    return "Takes ages so \(cancel.cancelled ? "was" : "was not") cancelled"
                }
                cancellationSource.cancel()
                var errorThrown = false
                do {
                    _ = try await(cancellationSource) { longTask }
                }
                catch {
                    if case TaskError.cancelled = error {
                        errorThrown = true
                    }
                }
                expect(errorThrown).to(beTrue())
            }
        }
    }
}

func currentQueueName() -> String? {
    let name = __dispatch_queue_get_label(nil)
    return String(cString: name, encoding: .utf8)
}
