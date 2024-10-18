#Persistent
#MaxThreadsPerHotkey 2

; Initialize variables
toggle := false
clicked := false  
lastX := 0
lastY := 0
settingsFile := "settings.ini"

; Set default values
defaultKey := "Control"
defaultWidth := 1920
defaultHeight := 1080
defaultTolerance := 110
defaultImageFile := "shake.png"
ImageWidth := 103
ImageHeight := 31

; Load saved settings or use default
LoadSettings()

; Create GUI with increased width and tabs
Gui, Add, Tab2, vTab, Main|Settings

; Main Tab
Gui, Tab, Main
Gui, Add, Text, , Tolerance:
Gui, Add, Edit, vToleranceInput w200, %tolerance%
Gui, Add, Button, gExit w150, Exit
Gui, Add, Button, gSaveSettings, Save Settings
Gui, Add, Button, gLoadSettings, Load Settings

; Settings Tab
Gui, Tab, Settings
Gui, Add, Text, , Keybind (default: Control):
Gui, Add, Edit, vKeyBind w200, %defaultKey%
Gui, Add, Text, , Screen Width (default: 1920):
Gui, Add, Edit, vScreenWidth w150, %ScreenWidth%
Gui, Add, Text, , Screen Height (default: 1080):
Gui, Add, Edit, vScreenHeight w150, %ScreenHeight%
Gui, Add, Text, , Custom Image:
Gui, Add, Edit, vImageFile w200, %ImageFile%
Gui, Add, Button, gSelectImage, Select Image
Gui, Add, Button, gResetDefaults, Reset to Defaults
Gui, Add, Button, gSetKeybind, Set Keybind  ; Added Set Keybind button

; Show GUI
Gui, Show, w400 h300, FISCH GUI v1.0.0 By Celllnside
return

SetKeybind:
    ; Retrieve user input
    Gui, Submit, NoHide

    ; Set the new hotkey
    Hotkey, *%KeyBind%, ToggleImageSearch, On
    return

SelectImage:
    ; Allow the user to select a custom image file
    FileSelectFile, ImageFile, 3,, Select Image, Image Files (*.png)
    GuiControl,, ImageFile, %ImageFile%
    return

SaveSettings:
    ; Save the current settings to a file
    Gui, Submit, NoHide
    IniWrite, %KeyBind%, %settingsFile%, Settings, KeyBind
    IniWrite, %ScreenWidth%, %settingsFile%, Settings, ScreenWidth
    IniWrite, %ScreenHeight%, %settingsFile%, Settings, ScreenHeight
    IniWrite, %ToleranceInput%, %settingsFile%, Settings, Tolerance
    IniWrite, %ImageFile%, %settingsFile%, Settings, ImageFile
    MsgBox, Settings saved!
    return

LoadSettings:
    ; Load settings from the file
    IniRead, KeyBind, %settingsFile%, Settings, KeyBind, %defaultKey%
    IniRead, ScreenWidth, %settingsFile%, Settings, ScreenWidth, %defaultWidth%
    IniRead, ScreenHeight, %settingsFile%, Settings, ScreenHeight, %defaultHeight%
    IniRead, tolerance, %settingsFile%, Settings, Tolerance, %defaultTolerance%
    IniRead, ImageFile, %settingsFile%, Settings, ImageFile, %defaultImageFile%
    GuiControl,, KeyBind, %KeyBind%
    GuiControl,, ScreenWidth, %ScreenWidth%
    GuiControl,, ScreenHeight, %ScreenHeight%
    GuiControl,, ToleranceInput, %tolerance%
    GuiControl,, ImageFile, %ImageFile%
    MsgBox, Settings loaded!
    return

ResetDefaults:
    ; Reset settings to default values
    GuiControl,, KeyBind, %defaultKey%
    GuiControl,, ScreenWidth, %defaultWidth%
    GuiControl,, ScreenHeight, %defaultHeight%
    GuiControl,, ToleranceInput, %defaultTolerance%
    GuiControl,, ImageFile, %defaultImageFile%
    MsgBox, Settings reset to defaults!
    return

ToggleImageSearch:
    toggle := !toggle
    if (toggle)
    {
        SoundPlay, *16 ; Plays the default Windows Asterisk sound
        SetTimer, ImageSearchAndClick, 50
    }
    else
    {
        SoundPlay, *64 ; Plays the default Windows Asterisk sound
        SetTimer, ImageSearchAndClick, Off
    }
    return

^1::ExitApp

ImageSearchAndClick:
    ; Set search area based on screen resolution
    Gui, Submit, NoHide
    x1 := ScreenWidth * 0.19 ; 366 pixels out of 1920 width
    y1 := ScreenHeight * 0.055 ; 60 pixels out of 1080 height
    x2 := ScreenWidth * 0.84 ; 1620 pixels out of 1920 width
    y2 := ScreenHeight * 0.903 ; 975 pixels out of 1080 height

    ImageSearch, foundX, foundY, x1, y1, x2, y2, *%ToleranceInput% %ImageFile%
    
    if !ErrorLevel
    {
        if (!clicked && (foundX != lastX || foundY != lastY))
        {
            MouseX := foundX + (ImageWidth / 2)
            MouseY := foundY + (ImageHeight / 2)
            
            MouseMove, MouseX, MouseY, 3
            Sleep, 150 + (Random(0, 50))
            Click
            
            lastX := foundX
            lastY := foundY
            
            clicked := true
            Sleep, 100 + (Random(0, 50))
            SetTimer, ResetClickFlag, -200
        }
    }
    else
    {
        clicked := false
    }
    return

ResetClickFlag:
    clicked := false
    return

Random(min, max)
{
    Random, result, %min%, %max%
    return result
}

Exit:
    Gui, Destroy
    ExitApp

LoadSettings()
{
    ; Load settings from the file or use defaults
    IniRead, KeyBind, %settingsFile%, Settings, KeyBind, %defaultKey%
    IniRead, ScreenWidth, %settingsFile%, Settings, ScreenWidth, %defaultWidth%
    IniRead, ScreenHeight, %settingsFile%, Settings, ScreenHeight, %defaultHeight%
    IniRead, tolerance, %settingsFile%, Settings, Tolerance, %defaultTolerance%
    IniRead, ImageFile, %settingsFile%, Settings, ImageFile, %defaultImageFile%
}