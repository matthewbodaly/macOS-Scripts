#!/bin/bash
defaults write /Library/Preferences/com.apple.commerce.plist AutoUpdate -bool FALSE
defaults write /Library/Preferences/com.apple.commerce.plist AutoUpdateRestartRequired -bool FALSE
defaults write /Library/Preferences/com.apple.SoftwareUpdate.plist AutomaticCheckEnabled -bool FALSE
defaults write /Library/Preferences/com.apple.SoftwareUpdate.plist AutomaticDownload -bool FALSE
defaults write /Library/Preferences/com.apple.SoftwareUpdate.plist CriticalUpdateInstall -bool FALSE
defaults write /Library/Preferences/com.apple.SoftwareUpdate.plist ConfigDataInstall -bool FALSE
