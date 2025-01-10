.PHONY: clean-build-ios
clean-build-ios:
	yarn clean && cd example && cd ios && RCT_NEW_ARCH_ENABLED=1 pod install && xed . && cd .. && yarn start --reset-cache