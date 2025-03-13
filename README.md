# DynamicWeight
SkyrimSE/AE Papyrus mod. Dynamic change player weight by level. Support OBodyNG

## Used Function type

* Linear
    * `y = (100 / level-limit) * level`
    * By default, level-limit = 80
* exponential
    * `y = 100 * (1 - 2^-bx)`
    * By default, b = 0.1

View the graph on [Desmos](https://www.desmos.com/calculator/xsgfqfb0tr?lang=zh-CN)

## Requirements

- [vcpkg](https://github.com/microsoft/vcpkg)
* [PapyrusUtil SE](https://www.nexusmods.com/skyrimspecialedition/mods/13048) v4.6
* [powerofthree's Papyrus Extender](https://www.nexusmods.com/skyrimspecialedition/mods/22854) v5.10.0
* [ConsoleUtilSSE NG](https://www.nexusmods.com/skyrimspecialedition/mods/76649) v1.5.1
* Optional
    * [OBody Next Generation](https://www.nexusmods.com/skyrimspecialedition/mods/77016) v4.3.7
    * [RaceMenu](https://www.nexusmods.com/skyrimspecialedition/mods/19080) v0.4.19.16

## Build

* Add `7z.exe` to environment `Path`
* Create a symlink `bethesda-skyrim-scripts` to `/path/to/skyrim-se/Data/Source/scripts

```powershell
vcpkg install
# debug
.\build.ps1 "1.0.0"
# release
.\build.ps1 "1.0.0" -debug $false
```
