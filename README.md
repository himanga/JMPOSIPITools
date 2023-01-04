# JMP OSI PI Data
This add-in is available in the Add-Ins section of the JMP Community.  Find it here:
https://community.jmp.com/t5/JMP-Add-Ins/OSI-PI-Data/ta-p/224525

Source code is available on github:
https://github.com/himanga/JMPOSIPIData

## Building from Source
Copy the contents of the src folder to a zip file, then change the file extension to .jmpaddin

Title: To Modify this Add-in

About: Developer Dependencies

To make changes to and rebuild this add-in (this is rare), you will also need:

- Natural Docs (program to install)
- jsl-hamcrest add-in for JMP (add-in for JMP, available on community.jmp.com)
- Powershell
- git (program to install)
- GitHub

About: Steps

- Clone git repository
- Make changes
- Document code using natural docs language
- Update and run unit tests
- Run the powershell script to build the add-in, adjusting the path to the Natural Docs exe if necessary.
- test add-in
- Update the version number and deploy prod version of add-in
- Commit changes in git and push commits to github.
- Open a pull request on github

## Contributors
- [Predictum Inc.](https://predictum.com/)
