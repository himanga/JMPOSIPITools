# Aveva/OSISoft PI Tools
This add-in is available in the Add-Ins section of the [JMP Community](https://community.jmp.com/t5/JMP-Add-Ins/OSI-PI-Data/ta-p/224525).

Source code is available on [GitHub](https://github.com/himanga/JMPOSIPIData).

## Building from Source
Copy the contents of the src folder to a zip file, then change the file extension to .jmpaddin.  This will not update the help file documentation, for that install both NaturalDocs and the jsl-hamcrest add-in and build the add-in using the included powershell script.

See CONTRIBUTING.md for more details.

## Contributors
- [Isaac Himanga](https://github.com/himanga)
- [Predictum Inc.](https://predictum.com/)
- [Marc Champagne](mailto:Marc.Champagne@adm.com)
- [Jonathan Austin](mailto:jonathanrobaustin@gmail.com)

## Third-Party Data

### Timezone Data

Timezone data is derived from the [IANA Time Zone Database](https://www.iana.org/time-zones)
via [moment-timezone](https://momentjs.com/timezone/) (MIT License).

The file `AddinFiles/tz/tzData.jsl` is generated at build time from the
moment-timezone unpacked data format. To regenerate it, run
`build/buildTzData.ps1` or use the "Refresh timezone data" button in the
add-in (requires internet access).

Source: https://raw.githubusercontent.com/moment/moment-timezone/develop/data/unpacked/latest.json