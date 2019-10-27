STEAMWORKS_SDK = steamworks_sdk_146.zip

ifeq "$(wildcard $(STEAMWORKS_SDK))" ""
$(error '$(STEAMWORKS_SDK)' doesn't exist)
endif


SCONS_FLAGS = --jobs=4


bin/GodotSteamed.app: \
  bin/GodotSteamed.app/Contents/MacOS/Godot \
  bin/GodotSteamed.app/Contents/MacOS/libsteam_api.dylib
	rsync -r 'godot/misc/dist/osx_tools.app/' '$@'


bin/GodotSteamed.app/Contents/MacOS/Godot: godot/bin/godot.osx.tools.64
	mkdir -p '$(dir $@)'
	cp '$<' '$@'
	chmod +x '$@'


bin/GodotSteamed.app/Contents/MacOS/libsteam_api.dylib: \
  sdk/redistributable_bin/osx/libsteam_api.dylib
	mkdir -p '$(dir $@)'
	cp '$<' '$@'


godot/bin/godot.osx.tools.64: | godot/modules/godotsteam
	cd 'godot' && scons $(SCONS_FLAGS) platform=osx


godot/modules/godotsteam: sdk | godot GodotSteam
	cp -a 'GodotSteam/godotsteam' '$@'
	rsync -aR 'sdk/public' '$@'
	rsync -aR 'sdk/redistributable_bin' '$@'


godot GodotSteam:
	git submodule update --init --recursive


sdk: $(STEAMWORKS_SDK)
	unzip '$(STEAMWORKS_SDK)'


clean:
	rm -rf 'bin'
	rm -rf 'godot'
	rm -rf 'GodotSteam'
	rm -rf 'sdk'