export type LocationOptions = {
  desiredAccuracy: string; //IOS => 'bestForNavigation' | 'best' | 'nearestTenMeters' | 'hundredMeters' | 'threeKilometers'
  activityType: string; //IOS =>'other' | 'otherNavigation' | 'automotiveNavigation' |'automotiveNavigation' | 'airborne' |'airborne'
  pausesLocationUpdatesAutomatically: boolean; //IOS => ONLY
  useLiveUpdate?: boolean; //IOS 17 only
  waitForAccuracy?: boolean; //Android => Only
  distanceFilter?: number;
};
