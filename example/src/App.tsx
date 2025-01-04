import { useEffect } from 'react';
import { Text, View, StyleSheet, NativeModules } from 'react-native';
import { multiply } from 'react-native-turbo-location';

const result = multiply(3, 7);

export default function App() {
  useEffect(() => {
    NativeModules.TurboLocation.multiply(3, 7).then((v) => {
      console.log(v);
    });
  }, []);
  return (
    <View style={styles.container}>
      <Text>Result: {result}</Text>
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
