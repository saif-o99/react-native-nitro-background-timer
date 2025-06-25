import Foundation
import React

@objc(NitroBackgroundTimer)
class NitroBackgroundTimer: NSObject, HybridNitroBackgroundTimerSpec {
  private var timeoutTimers: [Int: Timer] = [:]
  private var intervalTimers: [Int: Timer] = [:]
  private var callbackQueue = DispatchQueue.main
  private var nextTimerId = 0

  @objc(setTimeout:duration:callback:)
  func setTimeout(id: NSNumber, duration: NSNumber, callback: @escaping RCTResponseSenderBlock) {
    let timer = Timer.scheduledTimer(withTimeInterval: duration.doubleValue / 1000.0, repeats: false) { _ in
      self.callbackQueue.async {
        callback([id])
        self.timeoutTimers.removeValue(forKey: id.intValue)
      }
    }
    RunLoop.main.add(timer, forMode: .common)
    timeoutTimers[id.intValue] = timer
  }

  @objc(clearTimeout:)
  func clearTimeout(id: NSNumber) {
    if let timer = timeoutTimers[id.intValue] {
      timer.invalidate()
      timeoutTimers.removeValue(forKey: id.intValue)
    }
  }

  @objc(setInterval:interval:callback:)
  func setInterval(id: NSNumber, interval: NSNumber, callback: @escaping RCTResponseSenderBlock) {
    let timer = Timer.scheduledTimer(withTimeInterval: interval.doubleValue / 1000.0, repeats: true) { _ in
      self.callbackQueue.async {
        callback([id])
      }
    }
    RunLoop.main.add(timer, forMode: .common)
    intervalTimers[id.intValue] = timer
  }

  @objc(clearInterval:)
  func clearInterval(id: NSNumber) {
    if let timer = intervalTimers[id.intValue] {
      timer.invalidate()
      intervalTimers.removeValue(forKey: id.intValue)
    }
  }

  @objc static func requiresMainQueueSetup() -> Bool {
    return true
  }
}
