# godot-steamed
godot-steamed is a simple `Makefile` for compiling [godot] with [GodotSteam].
Because of the copyright, you need to put the Steamworks SDK into the repository manually.

godot-steamed focuses on my personal purpose, which means that there are several assumptions on the environment.
- Running on macOS
- Tools required have already been installed with [brew]
- Steamworks SDK 1.46 (You need to place `steamworks_sdk_146.zip` manually)
- Targets
  - Godot Editor on macOS
  - macOS Export template
  - Windows Export template.

Maybe this doesn't match your needs,
but I hope this at least provides the general steps of what is required when compiling Godot.

[godot]: https://github.com/godotengine/godot
[GodotSteam]: https://github.com/Gramps/GodotSteam
[brew]: https://github.com/Homebrew
