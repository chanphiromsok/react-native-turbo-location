import { useEffect } from 'react';
import { StyleSheet, Text, TouchableOpacity, View } from 'react-native';
import {
  getCurrentLocation,
  requestPermission,
  startWatching,
} from 'react-native-turbo-location';

export default function App() {
  useEffect(() => {
    requestPermission();
    if (true) {
      startWatching(
        (location) => {
          console.log('watching location', location);
        },
        {
          activityType: 'other',
          desiredAccuracy: 'best',
          pausesLocationUpdatesAutomatically: true,
          waitForAccuracy: false,
        }
      );
    }
  }, []);
  return (
    <View style={styles.container}>
      <Text>Result:</Text>
      <TouchableOpacity>
        <Text
          onPress={() => {
            getCurrentLocation(
              {
                activityType: 'other',
                desiredAccuracy: 'hight',
                pausesLocationUpdatesAutomatically: true,
                waitForAccuracy: false,
              },
              (location) => {
                console.log(location);
              },
              (err) => {
                console.log('getError', err);
              }
            );
          }}
        >
          Get Location
        </Text>
      </TouchableOpacity>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
});
