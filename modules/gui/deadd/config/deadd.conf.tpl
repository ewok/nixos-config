[notification-center]

marginTop = 0
marginBottom = 0
marginRight = 0

width = 500
monitor = %MAIN_DISPLAY%
followMouse = true

# startupCommand = "deadd-notification-center-startup"

newFirst = true

ignoreTransient = false
useMarkup = true

configSendNotiClosedDbusMessage = false

guessIconFromAppname = true

# See section "Notification based scripting" for an explenation
#match = "title=Abc;body=abc":"app=notify-send"
#modify = "transient=false"
#run = "":"killall notify-send"

[notification-center-notification-popup]

notiDefaultTimeout = 10000
distanceTop = 50
distanceRight = 50
distanceBetween = 20
width = 300
monitor = %MAIN_DISPLAY%
followMouse = true
iconSize = 20
maxImageSize = 100

[colors]
background = rgba(29, 27, 20, 0.6)
notiBackground = rgba(9, 0, 0, 0.5)
notiColor = #fef3f6
critical = rgba(255, 0, 50, 0.5)
criticalColor = #FFF
criticalInCenter = rgba(155, 0, 20, 0.5)
criticalInCenterColor = #FFF
labelColor = #eae2e0

buttonColor = #eae2e0
buttonHover = rgba(0, 20, 20, 0.2)
buttonHoverColor = #fee
buttonBackground = transparent

[buttons]
buttonsPerRow = 5
buttonHeight = 60
buttonMargin = 2

# labels = "VPN":"Bluetooth":"Wifi":"Screensaver"
# commands = "sudo vpnToggle":"bluetoothToggle":"wifiToggle":"screensaverToggle"

buttonColor = #fee
buttonBackground = rgba(255, 255, 255, 0.15)
buttonHover = rgba(0, 20, 20, 0.2)
buttonHoverColor = #fee
buttonTextSize = 12px;
buttonState1 = rgba(255,255,255,0.5)
buttonState1Color = #fff
buttonState1Hover = rgba(0, 20, 20, 0.4)
buttonState1HoverColor = #fee
buttonState2 = rgba(255,255,255,0.3)
buttonState2Color = #fff
buttonState2Hover = rgba(0, 20, 20, 0.3)
buttonState2HoverColor = #fee
