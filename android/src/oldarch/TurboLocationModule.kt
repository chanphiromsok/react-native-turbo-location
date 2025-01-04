package com.turbolocation

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactMethod;

class TurboLocationModule(context: ReactApplicationContext) : ReactContextBaseJavaModule(context) {
    private val impl = TurboLocationModuleImpl()
    override fun getName(): String = TurboLocationModuleImpl.NAME

    @ReactMethod()
    fun multiply(a: Double, b: Double,promise: Promise){
        promise.resolve(impl.multiply(a,b))
    }
}
