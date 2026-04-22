# Changelog
Notable changes to this project are documented here.

## [HEAD]

### Added
- 

### Changed
- 

### Fixed
- 

## [0.1304]

### Added
- Settings are saved to the output table and they can be recalled.
- User picks time zone to return data in

### Changed
- Behind the scenes: refactored code into smaller files
- Behind the scenes: all query functions take inputs from parameters
- Render README and CHANGELOG during build for cleaner view in the add-in

### Fixed
- JMP LivebBugs from earlier changes this release
- Time zone offsets can be 15 min, not just full hours
- Times are incorrect when the data set spans multiple time zones - the local time is corrected.

## [0.1303]

### Added
- Script to check all user connections (search for CheckConnectionsinUserPref in help)

### Changed
- Behind the scenes: better testing and function isolation.

### Fixed
- Fixed bug in About screen

## [0.1302]

### Added
- 

### Changed
- 

### Fixed
- Fixed bug in About screen

## [0.1301]

### Added
- User can set output table name.
- User can choose which fields to return for some query types

### Changed
- Switched tag entry from text box to data table
- Behind the scenes: updated internal functions to use new JMP functionality.
- Behind the scenes: automatically run unit tests when building add-in

### Fixed
- Better handling of corrupt preferences file

## [0.13]

### Added

### Changed
- Modified JMP Live script to include the entire add-in namespace - easier to create a script including types of queries.

### Fixed
- API error for some all archived value data pulls.

## [0.11]

### Added
- Build using powershell.
- Support for JMP Live

### Changed
- Connects to PI via the PI's Web API insead of via DAS.
- User can save a list of connections in preferences.

### Fixed

## [0.1]

### Added
- Build using powershell.

### Changed
- Connects to PI via the PI's Web API insead of via DAS.
- User can save a list of connections in preferences.

### Fixed

## [0.03]

### Added

### Changed

### Fixed

Bugs related to initial deployment.
