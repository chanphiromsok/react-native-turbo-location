.PHONY: clean-build-ios
clean-build-ios:
	yarn clean && cd example && cd ios && pod install && xed . && cd .. && yarn start --reset-cache