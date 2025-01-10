import { useEffect } from 'react';
import { StyleSheet, Text, TouchableOpacity, View } from 'react-native';
import {
  getCurrentLocation,
  requestPermission,
} from 'react-native-turbo-location';

export default function App() {
  useEffect(() => {
    requestPermission();
  }, []);
  return (
    <View style={styles.container}>
      <Text>Result:</Text>
      <TouchableOpacity>
        <Text
          onPress={() => {
            getCurrentLocation(
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
