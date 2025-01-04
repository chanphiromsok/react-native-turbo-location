package com.turbolocation

import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.module.annotations.ReactModule


@ReactModule(name = TurboLocationModuleImpl.NAME)
class TurboLocationModule(reactContext: ReactApplicationContext) :
  NativeTurboLocationSpec(reactContext) {

  private val impl = TurboLocationModuleImpl()

  override fun getName(): String {
    return TurboLocationModuleImpl.NAME
  }

  // Example method
  // See https://reactnative.dev/docs/native-modules-android
  override fun multiply(a: Double, b: Double): Double {
    return impl.multiply(a , b)
  }

}
