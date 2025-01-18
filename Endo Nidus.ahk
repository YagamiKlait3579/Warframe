;;;;;;;;;; Loading ;;;;;;;;;;
    #include %A_Scriptdir%\libs\BaseLibs\Header.ahk
    #IfWinActive, Warframe
    global PWN := "Warframe" ; Program window name
    OnExit("BeforeExiting")

;;;;;;;;;; Setting ;;;;;;;;;;
    EditTimeKey  = Shift  ; При зажатии этой клавиши можно изменить время
    TimeStep    := 25     ; Шаг изменение времени для способности

;;;;;;;;;; Variables ;;;;;;;;;;
    CheckingFiles(,"SavedSettings.ini")
    LoadIniSection(FP_SavedSettings, "Endo Nidus")
    global gTime := gTime ? gTime : 500
    
;;;;;;;;;; Hotkeys ;;;;;;;;;;
    Hotkey, *%StartKey%, EndoNidus

    Hotkey, *%IncreaseKey%, IncreaseTiming
    Hotkey, *%DecreaseKey%, DecreaseTiming

;;;;;;;;;; Gui ;;;;;;;;;;
    PlaceForTheText := "999999"
    ;--------------------------------------------------
    UpdateDGP({"Transparency" : gTransparency, "Blur" : gBlur, "Scale" : gInterfaceScale})
    GuiInGame("Start", "MainInterface")
        Gui, MainInterface: Add, Text, xm ym +Right,` Endo Nidus:
        Gui, MainInterface: Add, Text, x+m +Center +Border cFuchsia vTime_Gui, %PlaceForTheText%
        GuiControl, MainInterface: Text, Time_Gui, %gTime%
    GuiInGame("End", "MainInterface", {"ratio" : [GuiPositionX,GuiPositionY]})
    fSuspendGui("On", "MainInterface")
    if DebugGui
        fDebugGui("Create", MainInterface)
    if HideTheInterface
        SetTimer, ShowHideGui , 250, -1
    Return

;;;;;;;;;; Scripts ;;;;;;;;;;
    EndoNidus:
            Send, {Blind}{%AbilityB_Key%}
            lSleep(gTime)
            Send, {Blind}{%AbilityB_Key%}
    Return

;;;;;;;;;; Time management ;;;;;;;;;;
    IncreaseTiming:
        if !GetKeyState(EditTimeKey, "p") {
            Send, {Blind}{%IncreaseKey%}
            Return
        }
        if (gTime + TimeStep > 9999)
            Return
        gTime += TimeStep
        GuiControl, MainInterface: Text, Time_Gui, %gTime%
    Return

    DecreaseTiming:
        if !GetKeyState(EditTimeKey, "p") {
            Send, {Blind}{%DecreaseKey%}
            Return
        }
        if (gTime - TimeStep < 1)
            Return
        gTime -= TimeStep
        GuiControl, MainInterface: Text, Time_Gui, %gTime%
    Return

;;;;;;;;;; Exit ;;;;;;;;;;
    BeforeExiting() {
        global
        IniWrite, %gTime%, %FP_SavedSettings%, Endo Nidus, gTime
    }