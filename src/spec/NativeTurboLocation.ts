import type { TurboModule } from 'react-native';
import { TurboModuleRegistry } from 'react-native';

type Location = {
  latitude: number;
  longitude: number;
  heading: number;
  accuracy: number;
  timestamp: number;
  altitude: number;
  speed: number;
};
export interface Spec extends TurboModule {
  getCurrentLocation(): Promise<Location>;
  startWatching(): Promise<void>;
  addListener: (eventType: string) => void;
  removeListeners: (count: number) => void;
}

export default TurboModuleRegistry.getEnforcing<Spec>('TurboLocation');
