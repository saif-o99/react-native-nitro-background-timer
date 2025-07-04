///
/// NitroBackgroundTimer-Swift-Cxx-Bridge.hpp
/// This file was generated by nitrogen. DO NOT MODIFY THIS FILE.
/// https://github.com/mrousavy/nitro
/// Copyright © 2025 Marc Rousavy @ Margelo
///

#pragma once

// Forward declarations of C++ defined types
// Forward declaration of `HybridNitroBackgroundTimerSpec` to properly resolve imports.
namespace margelo::nitro::nitrobackgroundtimer { class HybridNitroBackgroundTimerSpec; }

// Forward declarations of Swift defined types
// Forward declaration of `HybridNitroBackgroundTimerSpec_cxx` to properly resolve imports.
namespace NitroBackgroundTimer { class HybridNitroBackgroundTimerSpec_cxx; }

// Include C++ defined types
#include "HybridNitroBackgroundTimerSpec.hpp"
#include <NitroModules/Result.hpp>
#include <exception>
#include <functional>
#include <memory>

/**
 * Contains specialized versions of C++ templated types so they can be accessed from Swift,
 * as well as helper functions to interact with those C++ types from Swift.
 */
namespace margelo::nitro::nitrobackgroundtimer::bridge::swift {

  // pragma MARK: std::function<void(double /* nativeId */)>
  /**
   * Specialized version of `std::function<void(double)>`.
   */
  using Func_void_double = std::function<void(double /* nativeId */)>;
  /**
   * Wrapper class for a `std::function<void(double / * nativeId * /)>`, this can be used from Swift.
   */
  class Func_void_double_Wrapper final {
  public:
    explicit Func_void_double_Wrapper(std::function<void(double /* nativeId */)>&& func): _function(std::make_shared<std::function<void(double /* nativeId */)>>(std::move(func))) {}
    inline void call(double nativeId) const {
      _function->operator()(nativeId);
    }
  private:
    std::shared_ptr<std::function<void(double /* nativeId */)>> _function;
  };
  Func_void_double create_Func_void_double(void* _Nonnull swiftClosureWrapper);
  inline Func_void_double_Wrapper wrap_Func_void_double(Func_void_double value) {
    return Func_void_double_Wrapper(std::move(value));
  }
  
  // pragma MARK: std::shared_ptr<margelo::nitro::nitrobackgroundtimer::HybridNitroBackgroundTimerSpec>
  /**
   * Specialized version of `std::shared_ptr<margelo::nitro::nitrobackgroundtimer::HybridNitroBackgroundTimerSpec>`.
   */
  using std__shared_ptr_margelo__nitro__nitrobackgroundtimer__HybridNitroBackgroundTimerSpec_ = std::shared_ptr<margelo::nitro::nitrobackgroundtimer::HybridNitroBackgroundTimerSpec>;
  std::shared_ptr<margelo::nitro::nitrobackgroundtimer::HybridNitroBackgroundTimerSpec> create_std__shared_ptr_margelo__nitro__nitrobackgroundtimer__HybridNitroBackgroundTimerSpec_(void* _Nonnull swiftUnsafePointer);
  void* _Nonnull get_std__shared_ptr_margelo__nitro__nitrobackgroundtimer__HybridNitroBackgroundTimerSpec_(std__shared_ptr_margelo__nitro__nitrobackgroundtimer__HybridNitroBackgroundTimerSpec_ cppType);
  
  // pragma MARK: std::weak_ptr<margelo::nitro::nitrobackgroundtimer::HybridNitroBackgroundTimerSpec>
  using std__weak_ptr_margelo__nitro__nitrobackgroundtimer__HybridNitroBackgroundTimerSpec_ = std::weak_ptr<margelo::nitro::nitrobackgroundtimer::HybridNitroBackgroundTimerSpec>;
  inline std__weak_ptr_margelo__nitro__nitrobackgroundtimer__HybridNitroBackgroundTimerSpec_ weakify_std__shared_ptr_margelo__nitro__nitrobackgroundtimer__HybridNitroBackgroundTimerSpec_(const std::shared_ptr<margelo::nitro::nitrobackgroundtimer::HybridNitroBackgroundTimerSpec>& strong) { return strong; }
  
  // pragma MARK: Result<double>
  using Result_double_ = Result<double>;
  inline Result_double_ create_Result_double_(double value) {
    return Result<double>::withValue(std::move(value));
  }
  inline Result_double_ create_Result_double_(const std::exception_ptr& error) {
    return Result<double>::withError(error);
  }
  
  // pragma MARK: Result<void>
  using Result_void_ = Result<void>;
  inline Result_void_ create_Result_void_() {
    return Result<void>::withValue();
  }
  inline Result_void_ create_Result_void_(const std::exception_ptr& error) {
    return Result<void>::withError(error);
  }

} // namespace margelo::nitro::nitrobackgroundtimer::bridge::swift
