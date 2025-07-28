import Foundation
import NitroModules

public class NitroBackgroundTimer: HybridNitroBackgroundTimerSpec {
  private var timeoutTimers: [Int: Timer] = [:]
  private var intervalTimers: [Int: Timer] = [:]
  private var callbackQueue = DispatchQueue.main
  private var nextTimerId = 0


  public func setTimeout(id: Double, duration: Double, callback: @escaping (Double) -> Void) throws -> Double {
    let intId = Int(id)
    let timer = Timer.scheduledTimer(withTimeInterval: duration / 1000.0, repeats: false) { _ in
      self.callbackQueue.async {
        callback(id)
        self.timeoutTimers.removeValue(forKey: intId)
      }
    }
    RunLoop.main.add(timer, forMode: .common)
    timeoutTimers[intId] = timer
    return id
  }


  public func clearTimeout(id: Double) throws {
    let intId = Int(id)
    if let timer = timeoutTimers[intId] {
      timer.invalidate()
      timeoutTimers.removeValue(forKey: intId)
    }
  }


  public func setInterval(id: Double, interval: Double, callback: @escaping (Double) -> Void) throws -> Double {
    let intId = Int(id)
    let timer = Timer.scheduledTimer(withTimeInterval: interval / 1000.0, repeats: true) { _ in
      self.callbackQueue.async {
        callback(id)
      }
    }
    RunLoop.main.add(timer, forMode: .common)
    intervalTimers[intId] = timer
    return id
  }

  public func clearInterval(id: Double) throws {
    let intId = Int(id)
    if let timer = intervalTimers[intId] {
      timer.invalidate()
      intervalTimers.removeValue(forKey: intId)
    }
  }

}
