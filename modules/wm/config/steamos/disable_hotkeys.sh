#!/bin/sh

#fl="$HOME/.config/kglobalshortcutsrc"
#
#sed -i 's/=.*,.*,/=none,none,/g' $fl
#sed -i 's/Walk Through Windows=.*/Walk Through Windows=Alt+Tab,Alt+Tab,Walk Through Windows/' $fl # return alt+tab
#!/bin/sh

hotkeysRC="$HOME/.config/kglobalshortcutsrc"

# Remove application launching shortcuts.
sed -i 's/_launch=[^,]*/_launch=none/g' $hotkeysRC

# Remove other global shortcuts.
sed -i 's/^\([^_].*\)=[^,]*/\1=none/g' $hotkeysRC

# Reload hotkeys.
kquitapp5 kglobalaccel && sleep 2s && kglobalaccel5 &
