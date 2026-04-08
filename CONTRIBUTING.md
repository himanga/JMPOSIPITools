# How to Contribute

Your contributions to this project are welcome.  Submit issues or merge requests to get things started.

## Developer Dependencies
To make changes to and rebuild this add-in, you will also need:

- Natural Docs (program to install)
- jsl-hamcrest add-in for JMP (add-in for JMP, available on community.jmp.com)
- Powershell
- git (program to install)
- GitHub account

## Steps to Contribute

- Install dependencies above
- Fork and clone git repository
- Make changes
- Document code using natural docs language
- Update and run unit tests for any new functions for which unit testing makes sense
- Run the powershell script to build the add-in, adjusting the path to the Natural Docs exe if necessary.
- test add-in functionality (unit tests do not test user interaction or actually pulling data)
- Commit changes in git and push commits to GitHub
- Open a pull request to the original repository

## Versioning
To release a new version:
- Merge all branches into master
- Run the build script - ensure all unit tests pass
- Test all functionality of the add-in - user interfance elements are not tested in unit tests
- Ensure Help documentation is updated
- Create a commmit on the master branch with a message similar to 'Version x.xx' or 'Version x.xxxx Test'
    - In AddinFiles/customMetadata.jsl, update:
        - addinVersion (if a major update, can leave it for testing)
        - buildDate (copy this from the output of the build script temp add-in files)
        - state (to PROD or TEST)
    - In AddinFiles/addin.def, update:
        - addinVersion (match the one in customMetadata.jsl)
        - minJmpVersion if necessary
    - In CHANGELOG.md: 
        - Change HEAD to match the version number
- Rebuild the add-in, rename the .jmpaddin file to be simila to 'JMPOSIPITools_x.xx' and save this copy so you can upload it to GitHub and the JMP Community for production releases
- If a production release - create a new tag in the format 'vx.xx' with a message similar to 'Version x.xx'
- Create a release in github from that tag, copy the changelog section into the release details
- Upload the .jmpaddin file to thhe assets for that release
- Create a commit on the master branch with the message 'bump' that updates:
    - In AddinFiles/customMetadata.jsl, update:
        - addinVersion (increment by 0.0001)
        - buildDate (increment by 1)
        - state (to DEV)
    - In AddinFiles/addin.def, update:
        - addinVersion (match the one in customMetadata.jsl)
    - In CHANGELOG.md: 
        - Duplicate the headings repeated in each section, with HEAD as the version number
