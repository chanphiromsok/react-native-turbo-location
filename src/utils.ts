import type { LocationOptions } from './type';

export const getOptions = (options?: LocationOptions): LocationOptions => {
  return {
    activityType: options?.activityType || 'other',
    desiredAccuracy: options?.desiredAccuracy || 'best',
    pausesLocationUpdatesAutomatically: true,
    waitForAccuracy: false,
    useLiveUpdate: !!options?.useLiveUpdate,
  };
};
