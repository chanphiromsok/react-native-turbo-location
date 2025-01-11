import { NativeEventEmitter, NativeModules, Platform } from 'react-native';
import type {
  ErrorCallback,
  SuccessCallBack,
} from './spec/NativeTurboLocation';
import type { LocationOptions } from './type';
import { getOptions } from './utils';

const LINKING_ERROR =
  "The package 'react-native-mock-location-detector' doesn't seem to be linked. Make sure: \n\n" +
  Platform.select({ ios: "- You have run pod install'\n", default: '' }) +
  '- You rebuilt the app after installing the package\n' +
  '- You are not using Expo managed workflow\n';

// @ts-expect-error
const isTurboModuleEnabled = global.__turboModuleProxy != null;

const TurboLocationModule = isTurboModuleEnabled
  ? require('./spec/NativeTurboLocation').default
  : NativeModules.TurboLocation;

const TurboLocation = TurboLocationModule
  ? TurboLocationModule
  : new Proxy(
      {},
      {
        get() {
          throw new Error(LINKING_ERROR);
        },
      }
    );
export const ModuleEventEmitter = new NativeEventEmitter(TurboLocation);
export async function requestPermission() {
  return TurboLocationModule.requestPermission();
}

export async function getCurrentLocation(
  options: LocationOptions,
  success: SuccessCallBack,
  error?: ErrorCallback
) {
  const locationOptions = getOptions(options);
  return TurboLocationModule.getCurrentLocation(
    locationOptions,
    success,
    error
  );
}

export async function startWatching(
  onLocation: SuccessCallBack,
  options?: LocationOptions
) {
  const locationOptions = getOptions(options);
  await TurboLocationModule.startWatching(locationOptions);
  const subscription = ModuleEventEmitter.addListener(
    'onLocationChange',
    onLocation
  );
  return {
    remove: () => {
      TurboLocationModule.stopUpdatingLocation();
      subscription.remove();
    },
  };
}

export const onAuthorizeChange = (
  listener: (params: { status: string }) => void
) => {
  return ModuleEventEmitter.addListener('didAuthorizedChange', listener);
};
export async function stopUpdating() {
  TurboLocationModule.stopUpdatingLocation();
}
