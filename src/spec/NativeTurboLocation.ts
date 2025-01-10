import type { TurboModule } from 'react-native';
import { TurboModuleRegistry } from 'react-native';

type Location = {
  coords: {
    altitudeAccuracy: number;
    latitude: number;
    heading: number;
    altitude: number;
    mocked: boolean;
    longitude: number;
    speed: number;
    accuracy: number;
  };
  timestamp: number;
};

type SuccessParams = Location;
type ErrorParams = {
  error: string;
  code: string;
};
export type SuccessCallBack = (params: SuccessParams) => void;
export type ErrorCallback = (params: ErrorParams) => void;

export interface Spec extends TurboModule {
  requestPermission(): Promise<void>;
  getCurrentLocation(
    successCallback: SuccessCallBack,
    errorCallback: ErrorCallback
  ): void;
  startWatching(successCallback: SuccessCallBack): void;
  addListener: (eventType: string) => void;
  removeListeners: (count: number) => void;
}

export default TurboModuleRegistry.getEnforcing<Spec>('TurboLocation');
