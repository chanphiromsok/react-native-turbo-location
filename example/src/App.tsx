import { useEffect } from 'react';
import { Alert, StyleSheet, Text, View } from 'react-native';
import {
  ModuleEventEmitter,
  getCurrentLocation,
} from 'react-native-turbo-location';

export default function App() {
  useEffect(() => {
    ModuleEventEmitter.addListener('onLocationChange', (value) => {
      console.log('ModuleEventEmitter sqrt', value);
    });
    getCurrentLocation().then((v) => {
      Alert.alert('Call ' + v);
    });
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
