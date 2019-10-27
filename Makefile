STEAMWORKS_SDK = steamworks_sdk_146.zip

ifeq "$(wildcard $(STEAMWORKS_SDK))" ""
$(error '$(STEAMWORKS_SDK)' doesn't exist)
endif


SCONS_FLAGS = --jobs=4


.PHONY: all tool osx windows clean

all: tool osx windows 
tool: bin/GodotSteamed.app
osx: bin/godot-steamed-osx.zip
windows: bin/godot-steamed-win.exe bin/steam_api64.dll
clean:
	rm -rf 'bin'
	rm -rf 'godot'
	rm -rf 'GodotSteam'
	rm -rf 'sdk'


# Packaging macOS Editor
bin/GodotSteamed.app: \
  bin/GodotSteamed.app/Contents/MacOS/Godot \
  bin/GodotSteamed.app/Contents/MacOS/libsteam_api.dylib
	rsync -r 'godot/misc/dist/osx_tools.app/' '$@'
	touch '$@'


bin/GodotSteamed.app/Contents/MacOS/Godot: godot/bin/godot.osx.tools.64
	mkdir -p '$(dir $@)'
	cp '$<' '$@'
	upx '$@'
	chmod +x '$@'


bin/GodotSteamed.app/Contents/MacOS/libsteam_api.dylib: \
  sdk/redistributable_bin/osx/libsteam_api.dylib
	mkdir -p '$(dir $@)'
	cp '$<' '$@'


# Packaging macOS export template
bin/godot-steamed-osx.zip: bin/osx_template.app
	cd 'bin' && zip -q -9 -r '$(notdir $@)' '$(notdir $<)'


bin/osx_template.app: \
  bin/osx_template.app/Contents/MacOS/godot_osx_release.64 \
  bin/osx_template.app/Contents/MacOS/libsteam_api.dylib
	rsync -r 'godot/misc/dist/osx_template.app/' '$@'
	touch '$@'


bin/osx_template.app/Contents/MacOS/godot_osx_release.64: godot/bin/godot.osx.opt.64
	mkdir -p '$(dir $@)'
	cp '$<' '$@'
	upx '$@'
	chmod +x '$@'


bin/osx_template.app/Contents/MacOS/libsteam_api.dylib: \
  sdk/redistributable_bin/osx/libsteam_api.dylib
	mkdir -p '$(dir $@)'
	cp '$<' '$@'


# Packaging Windows export template
bin/godot-steamed-win.exe: godot/bin/godot.windows.opt.64.exe
	mkdir -p '$(dir $@)'
	cp '$<' '$@'
	upx '$@'
	chmod +x '$@'


bin/steam_api64.dll: sdk/redistributable_bin/win64/steam_api64.dll
	mkdir -p '$(dir $@)'
	cp '$<' '$@'


# Compile
godot/bin/godot.osx.tools.64: | godot/modules/godotsteam
	cd 'godot' && scons $(SCONS_FLAGS) platform=osx


godot/bin/godot.osx.opt.64: | godot/modules/godotsteam
	cd 'godot' && scons $(SCONS_FLAGS) tools=no platform=osx target=release


godot/bin/godot.windows.opt.64.exe: | godot/modules/godotsteam
	# 'use_lto=yes' is crucial; It reduces the binary size from ~100MB to ~40MB.
	cd 'godot' && scons $(SCONS_FLAqGS) tools=no platform=windows target=release use_lto=yes bits=64


# Prepare
godot/modules/godotsteam: | godot GodotSteam sdk
	cp -a 'GodotSteam/godotsteam' '$@'
	rsync -aR 'sdk/public' '$@'
	rsync -aR 'sdk/redistributable_bin' '$@'


godot GodotSteam:
	git submodule update --init --recursive


sdk: $(STEAMWORKS_SDK)
	unzip '$(STEAMWORKS_SDK)'
	touch '$@'