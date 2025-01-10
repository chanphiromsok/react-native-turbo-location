import { useEffect } from 'react';
import { Alert, StyleSheet, Text, TouchableOpacity, View } from 'react-native';
import {
  getCurrentLocation,
  ModuleEventEmitter,
  requestPermission,
} from 'react-native-turbo-location';

export default function App() {
  useEffect(() => {
    ModuleEventEmitter.addListener('onLocationChange', (value) => {
      console.log('ModuleEventEmitter sqrt', value);
      Alert.alert(`${value.coords.latitude} ${value.coords.longitude}`);
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
