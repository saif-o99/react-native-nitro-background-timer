import Foundation
import NitroModules

public class NitroBackgroundTimer: HybridNitroBackgroundTimerSpec {
    private var timeoutTimers: [Int: DispatchSourceTimer] = [:]
    private var intervalTimers: [Int: DispatchSourceTimer] = [:]
    private let timerQueue = DispatchQueue(label: "com.app.backgroundtimer", qos: .utility)
    private let callbackQueue = DispatchQueue.main

    public func setTimeout(id: Double, duration: Double, callback: @escaping (Double) -> Void) throws -> Double {
        let intId = Int(id)
        return try timerQueue.sync {
            // Cancel existing timer if any
            timeoutTimers[intId]?.cancel()
            let timer = DispatchSource.makeTimerSource(queue: timerQueue)
            timer.schedule(deadline: .now() + duration / 1000.0)
            timer.setEventHandler { [weak self] in
                self?.callbackQueue.async {
                    callback(id)
                }
                // Auto-cleanup after execution
                self?.timerQueue.async {
                    self?.timeoutTimers.removeValue(forKey: intId)
                }
            }
            timeoutTimers[intId] = timer
            timer.resume()
            return id
        }
    }

    public func clearTimeout(id: Double) throws {
        let intId = Int(id)
        timerQueue.sync {
            timeoutTimers[intId]?.cancel()
            timeoutTimers.removeValue(forKey: intId)
        }
    }

    public func setInterval(id: Double, interval: Double, callback: @escaping (Double) -> Void) throws -> Double {
        let intId = Int(id)
        return try timerQueue.sync {
            // Cancel existing timer if any
            intervalTimers[intId]?.cancel()
            let timer = DispatchSource.makeTimerSource(queue: timerQueue)
            timer.schedule(deadline: .now() + interval / 1000.0, repeating: interval / 1000.0)
            timer.setEventHandler { [weak self] in
                self?.callbackQueue.async {
                    callback(id)
                }
            }
            intervalTimers[intId] = timer
            timer.resume()
            return id
        }
    }

    public func clearInterval(id: Double) throws {
        let intId = Int(id)
        timerQueue.sync {
            intervalTimers[intId]?.cancel()
            intervalTimers.removeValue(forKey: intId)
        }
    }
    deinit {
        timerQueue.sync {
            timeoutTimers.values.forEach { $0.cancel() }
            intervalTimers.values.forEach { $0.cancel() }
            timeoutTimers.removeAll()
            intervalTimers.removeAll()
        }
    }
}
