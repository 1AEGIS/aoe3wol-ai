<p align="center"><img alt="Age of Empires III - Wars of Liberty Logo" src="http://aoe3wol.com/images/logo%20full.png"></p>

<h1 align="center">Age of Empires III - Wars of Liberty</h1>

<p align="justify">This repository contains the source code for Wars of Liberty's UHC Plugins, as well as AI scripts for all civilization leaders.</p>

## UHC Plugins

<p align="justify">The <i>AI Plugin</i> contains a few additional syscalls to be used in AI and TR scripts. It is necessary since certain features - such as XML parsing - can't be coded directly in XS. It can be used in other mods as long as these mods use UHC `v1.6` or higher.</p>

## Personalities

<p align="justify">Apart from Te Rauparaha (the leader of the Maori civilization), all of WoL's civilization leaders are managed by the standard AI script which consists of the following files:</p>

- `AI3/aiLoaderStandard.xs`
- `AI3/aiWoLHeader.xs`
- `AI3/aiWoLMain.xs`

<p align="justify">The AI script for Te Rauparaha is experimental, hence it may be unstable and may not perform as good as the standard AI script. It consists of the following files:</p>

- `AI3/_aiArray.xs`
- `AI3/_aiForecasts.xs`
- `AI3/_aiHeader.xs`
- `AI3/_aiPlans.xs`
- `AI3/_aiQueries.xs`
- `AI3/_TeRauparaha.xs`

## Authors

- **Thinot "AlistairJah" Mandresy**
  - author of WoL's "new" standard AI script (nicknamed "Steven AI", released in the patch `v1.0.9`)
  - author of Te Rauparaha, the Maori leader's AI script
  - maintainer of WoL's UHC Plugins
- **RizkyRamadhan** (Lumba Lumba Hijau):
  - maintainer of WoL's standard AI script since WoL v1.0.15

## Credits & Thanks

- **Microsoft Games** and **Robot Entertainment** for Age of Empires III.
- The **WoL Team** for Wars of Liberty.
- **Daniel Pereira** and **Kang Cliff** for creating the [original UHC project](https://github.com/danielpereira/AoE3UnHardcoded).
- **KevSoft**, **Eaglemut**, **[Kao](https://github.com/shidesu/)** and **[Mandos](https://github.com/mandosrex/)** for UHC2.

Very special thanks for **Vincent Leroy** ("Circle of Ossus") for his massive support and enthusiasm :) Miss you, buddy!

## Links

- [Age of Empires III (2007) on Steam](https://store.steampowered.com/app/105450/Age_of_Empires_III_2007/)
- [Wars of Liberty - Official Website](http://aoe3wol.com/)
- [Wars of Liberty - Discord Server](https://discord.gg/Jpjm9Ja)
