import { NativeEventEmitter, NativeModules, Platform } from 'react-native';

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
export async function getCurrentLocation() {
  return TurboLocationModule.getCurrentLocation();
}

// type OnLocationChange = (location: any) => void;
export async function startWatching() {
  // const listener = ModuleEventEmitter.addListener(
  //   'onLocationChange',
  //   onLocationChange
  // );
  await TurboLocationModule.startWatching();

  // return listener;
}

console.log(TurboLocationModule);
