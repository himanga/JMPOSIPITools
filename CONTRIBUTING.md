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

### Internet Access and Proxy Configuration

The `TzData` build step and the "Refresh timezone data" button in the
add-in both download timezone data from GitHub and require internet access.

If your environment uses a proxy server, configure it in JMP before running:

1. In JMP, go to **File > Preferences > Internet**
2. Fill in the proxy server hostname and port
3. For the username, either enter your credentials or use `:` for
   Kerberos/Windows authentication (no username or password required)

Without this configuration the timezone data download will fail silently
and `tzData.jsl` will not be updated.

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

### Known Issues

**JMP 20 — script execution when JMP is already open**

JMP 20 cannot already be open when the test build script runs, otherwise it will just
open the script in a window and not execute it.

Workaround: close all JMP instances before running a build that
includes `Test` or `TzData` steps.

This does not affect JMP 18 or 19. The issue has been reported to
JMP support.

## Versioning

To release a new version:

1. Merge all branches into master
2. Run `build\build_Release.ps1` — ensure all unit tests pass
3. Test all add-in functionality manually — UI elements and live data pulls are not covered by unit tests
4. Ensure Help documentation is up to date
5. Update the following files (do not commit yet):
   - **`AddinFiles/customMetadata.jsl`**: update `addinVersion` and set `state` to `PROD` or `TEST`
   - **`AddinFiles/addin.def`**: update `addinVersion` to match `customMetadata.jsl`, update `minJmpVersion` if necessary
   - **`CHANGELOG.md`**: replace `HEAD` with the version number
6. Run `build\build_Release.ps1` again — the build date is stamped automatically, no manual edit needed
7. Save the output `.jmpaddin` file for upload to GitHub and the JMP Community
8. Create a commit on master with message `Version x.xx` or `Version x.xx TEST`
9. For production releases:
   - Create a git tag in the format `vx.xx` with message `Version x.xx`
   - Create a GitHub release from that tag, copying the relevant CHANGELOG section into the release notes
   - Upload the `.jmpaddin` file to the release assets
10. Create a follow-up `bump` commit on master that:
    - In **`AddinFiles/customMetadata.jsl`**: increments `addinVersion` by 0.0001, increments `buildDate` by 1, sets `state` to `DEV`
    - In **`AddinFiles/addin.def`**: updates `addinVersion` to match
    - In **`CHANGELOG.md`**: adds a new `HEAD` section by duplicating the section headings from the previous release