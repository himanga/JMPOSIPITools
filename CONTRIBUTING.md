# How to Contribute

Your contributions to this project are welcome. Submit issues or pull requests to get things started.

## Developer Dependencies

To make changes to and rebuild this add-in, you will need:

- **JMP Pro** — path must match the version configured in `build/buildConfig.ps1` (default: `%ProgramFiles%\JMP\JMPPRO\19\jmp.exe`)
- **Natural Docs** — path must match the one configured in `build/buildConfig.ps1` (default: `C:\Program Files (x86)\Natural Docs\NaturalDocs.exe`)
- **jsl-hamcrest** JMP add-in — available on community.jmp.com
- **PowerShell** with internet access on first build (the `MarkdownToHtml` module is installed automatically if missing)
- **git**
- **GitHub account**

### Timezone Data Build Configuration

The `TzData` build step downloads timezone data from GitHub by running
`tzBuilder.jsl` in a headless JMP session. If your network requires a
proxy server, you can configure it for this step without affecting the
rest of JMP by setting `$TzDataPreJSL` and `$TzDataPostJSL` in your
`build/buildConfig.local.ps1` file.

These variables contain raw JSL that is injected into the temporary
script that runs `tzBuilder.jsl`. `$TzDataPreJSL` runs before the
download and `$TzDataPostJSL` runs after, regardless of whether the
download succeeded.

A typical use is to save the current JMP proxy settings, apply corporate
proxy settings for the download, then restore the originals:

```powershell
$TzDataPreJSL  = @'
global:existingproxyserver = Get Preferences (Proxy Server);
global:existingproxyport   = Get Preferences (Proxy Port);
global:existingproxyuser   = Get Preferences (Proxy User);
global:existingbypassproxy = Get Preferences (Bypass Proxy);
Preferences[1] << Set( Proxy Server( "http://proxy.example.com" ) );
Preferences[1] << Set( Proxy Port( 80 ) );
Preferences[1] << Set( Proxy User( ":" ) );
Preferences[1] << Set( Bypass Proxy( "" ) );
'@
$TzDataPostJSL = @'
Preferences[1] << Set( Proxy Server( global:existingproxyserver ) );
Preferences[1] << Set( Proxy Port( global:existingproxyport ) );
Preferences[1] << Set( Proxy User( global:existingproxyuser ) );
Preferences[1] << Set( Bypass Proxy( global:existingbypassproxy ) );
'@
```

Use `":"` as the proxy username for Kerberos/Windows authentication.

Note that these proxy settings apply only to the headless JMP session
that runs `tzBuilder.jsl`. They do not affect the unit test session or
your normal JMP environment. The unit test session connects directly to
the PI server and will fail if a proxy is configured in JMP — disable
the proxy in JMP preferences before running the `Test` build step if
your machine requires one for internet access.

See `build/buildConfig.ps1` for all available configuration variables
and their defaults.

## Steps to Contribute

1. Install dependencies above
2. Fork and clone the repository
3. Make changes
4. Document any new or modified functions using NaturalDocs comment syntax
5. Add or update unit tests for any new functions where testing makes sense
6. Run `build\build_Release.ps1` to build the add-in and run unit tests — all tests must pass
7. If JMP or NaturalDocs are installed in non-default locations, create
   `build/buildConfig.local.ps1` (already gitignored) and override just
   the paths you need. See `build/buildConfig.ps1` for available variables.
8. Test add-in functionality manually — unit tests do not cover user interaction or live data pulls
9. Commit and push changes to your fork
10. Open a pull request to the original repository

## Build Scripts

There are two build scripts in the `build\` folder:

- **`build_Quick.ps1`** — builds the add-in and opens it in JMP without running unit tests. Use this during active development.
- **`build_Release.ps1`** — builds the add-in, runs all unit tests, and reports results. Use this before submitting a pull request.

Both scripts read their configuration from `build\buildConfig.ps1`. The `.jmpaddin` output file is named automatically as `JMPOSIPITools_{version}_{state}.jmpaddin`.

### Network Test Configuration

Network-dependent tests require a `Tests/testConfig.local.jsl` file
(gitignored). Copy `Tests/testConfig.default.jsl` and fill in values
for your environment:

- `testServerTimezone` — IANA timezone of the PI server
- `testClientTimezone` — IANA timezone of this machine
- `testClientOffsetMins` — current UTC offset of this machine in minutes
  (positive = west of UTC, e.g. CDT = -300)
- `testServerOffsetMins` — current UTC offset of the PI server in minutes

Update `testClientOffsetMins` and `testServerOffsetMins` when DST transitions occur.

### Known Issues

**JMP 20 — script execution when JMP is already open**

JMP 20 cannot already be open when the test build script runs, otherwise it will just
open the script in a window and not execute it.

Workaround: close all JMP instances before running a build that
includes `Test` or `TzData` steps.

This does not affect JMP 18 or 19. The issue has been reported to
JMP support.

**JMP proxy configuration conflicts with network tests**

The `TzData` build step downloads timezone data from GitHub and requires
a proxy server configured in JMP (File > Preferences > Internet) if your
network uses one. However, the unit test suite includes network tests that
connect directly to a PI server — these will fail if the JMP proxy is
configured, because the proxy will intercept the PI connection.

If both apply to your environment:
- Run the `TzData` step separately with the proxy enabled in JMP
- Disable the proxy in JMP preferences before running the `Test` step
- Use the custom build step selector (press [C] in `buildInteractive.ps1`)
  to run `TzData` and `Test` as separate builds

## Versioning

To release a new version:

- Merge all feature branches that are ready into master
- Run `build\build.ps1` as release, ensure all unit tests pass and no other errors
- Test all add-in functionality manually — UI elements and live data pulls are not covered by unit tests
- Ensure Help documentation is up to date
- Update the following files (do not commit yet):
   - **`AddinFiles/customMetadata.jsl`**: update `addinVersion` and set `state` to `PROD` or `TEST`
   - **`AddinFiles/addin.def`**: update `addinVersion` to match `customMetadata.jsl`, update `minJmpVersion` if necessary
   - **`CHANGELOG.md`**: replace `HEAD` with the version number
- Run `build\build_Release.ps1` again copy the build date for later use
- Save the output `.jmpaddin` file for upload to GitHub and the JMP Community
- Update
   - **`AddinFiles/customMetadata.jsl`** set the build date to match the output of the build from above (the one stored in the .jmpaddinfile)
- Create a commit on master with message `Version x.xx` or `Version x.xx Test`
- For production releases:
   - Create a git tag in the format `vx.xx` with message `Version x.xx`
   - Create a GitHub release from that tag, copying the relevant CHANGELOG section into the release notes
   - Upload the `.jmpaddin` file to the release assets
- Create a follow-up `bump` commit on master that:
    - In **`AddinFiles/customMetadata.jsl`**: increments `addinVersion` by 0.0001, increments `buildDate` by 1, sets `state` to `DEV`
    - In **`AddinFiles/addin.def`**: updates `addinVersion` to match
    - In **`CHANGELOG.md`**: adds a new `HEAD` section by duplicating the section headings from the previous release