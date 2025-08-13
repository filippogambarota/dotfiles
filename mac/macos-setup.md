# Useful Commands

## Dock

1000 seconds to show the dock ~ as disabling

```
defaults write com.apple.dock autohide-delay -float 1000; killall Dock
```

restore the defaults

```
defaults delete com.apple.dock autohide-delay; killall Dock
```
