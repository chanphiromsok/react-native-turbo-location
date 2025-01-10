import { useEffect } from 'react';
import { StyleSheet, Text, TouchableOpacity, View } from 'react-native';
import {
  getCurrentLocation,
  requestPermission,
  startWatching,
} from 'react-native-turbo-location';

export default function App() {
  useEffect(() => {
    startWatching((location) => {
      console.log('Location', location);
    });
    requestPermission();
  }, []);
  return (
    <View style={styles.container}>
      <Text>Result:</Text>
      <TouchableOpacity>
        <Text
          onPress={() => {
            getCurrentLocation((location) => {
              console.log(location);
            });
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
