#include <jni.h>
#include "NitroBackgroundTimerOnLoad.hpp"

JNIEXPORT jint JNICALL JNI_OnLoad(JavaVM* vm, void*) {
  return margelo::nitro::nitrobackgroundtimer::initialize(vm);
}
