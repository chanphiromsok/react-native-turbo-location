import { useEffect } from 'react';
import { StyleSheet, Text, View } from 'react-native';
import {
  getCurrentLocation,
  ModuleEventEmitter,
  requestPermission,
} from 'react-native-turbo-location';

export default function App() {
  useEffect(() => {
    ModuleEventEmitter.addListener('onLocationChange', (value) => {
      console.log('ModuleEventEmitter sqrt', value);
    });
    getCurrentLocation();
    requestPermission();
  }, []);
  return (
    <View style={styles.container}>
      <Text>Result:</Text>
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
