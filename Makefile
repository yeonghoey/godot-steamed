STEAMWORKS_SDK = steamworks_sdk_146.zip

ifeq "$(wildcard $(STEAMWORKS_SDK))" ""
$(error '$(STEAMWORKS_SDK)' doesn't exist)
endif


sdk: $(STEAMWORKS_SDK)
	unzip '$(STEAMWORKS_SDK)'