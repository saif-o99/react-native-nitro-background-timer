///
/// NitroBackgroundTimerAutolinking.swift
/// This file was generated by nitrogen. DO NOT MODIFY THIS FILE.
/// https://github.com/mrousavy/nitro
/// Copyright © 2025 Marc Rousavy @ Margelo
///

public final class NitroBackgroundTimerAutolinking {
  public typealias bridge = margelo.nitro.nitrobackgroundtimer.bridge.swift

  /**
   * Creates an instance of a Swift class that implements `HybridNitroBackgroundTimerSpec`,
   * and wraps it in a Swift class that can directly interop with C++ (`HybridNitroBackgroundTimerSpec_cxx`)
   *
   * This is generated by Nitrogen and will initialize the class specified
   * in the `"autolinking"` property of `nitro.json` (in this case, `NitroBackgroundTimer`).
   */
  public static func createNitroBackgroundTimer() -> bridge.std__shared_ptr_margelo__nitro__nitrobackgroundtimer__HybridNitroBackgroundTimerSpec_ {
    let hybridObject = NitroBackgroundTimer()
    return { () -> bridge.std__shared_ptr_margelo__nitro__nitrobackgroundtimer__HybridNitroBackgroundTimerSpec_ in
      let __cxxWrapped = hybridObject.getCxxWrapper()
      return __cxxWrapped.getCxxPart()
    }()
  }
}
