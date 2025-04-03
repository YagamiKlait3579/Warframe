;;;;;;;;;; Loading ;;;;;;;;;;
    #include %A_Scriptdir%\libs\CoreLibsFor_AHK\BaseLibs\Header.ahk
    ;--------------------------------------------------
    #IfWinActive, Warframe
    global PWN := "Warframe" ; Program window name

;;;;;;;;;; Setting ;;;;;;;;;;

;;;;;;;;;; Variables ;;;;;;;;;;
    EnergizedMunitionsKey := 4      ; Клавиша на которой привита способность "Энергетические боеприпасы" от гельминта
    DurationOfEclipse     := 53     ; Длительность способности "Затмение" (sec)
    SkillCastTime         := 1000   ; Время применения одной способности (ms)

;;;;;;;;;; Hotkeys ;;;;;;;;;;
    Hotkey, *%StartKey%, BaseScript

;;;;;;;;;; Gui ;;;;;;;;;;
    PlaceForTheText := " Ширина самого длинного текста "
    ;--------------------------------------------------
    UpdateDGP({"Transparency" : gTransparency, "Blur" : gBlur, "Scale" : gInterfaceScale})
    GuiInGame("Start", "MainInterface")
        Gui, MainInterface: Add, Text, xm ym +Center vT1, % SubStr(A_ScriptName, 1, InStr(A_ScriptName, ".", , -1) - 1)
        Gui, MainInterface: Add, Text, x+m +Center +Border cRed +Section vScriptStatus_Gui,` Disabled `
    GuiInGame("End", "MainInterface", {"ratio" : [GuiPositionX,GuiPositionY]})
    fSuspendGui("On", "MainInterface")
    if DebugGui
        fDebugGui("Create", MainInterface)
    if HideTheInterface
        SetTimer, ShowHideGui , 250, -1
Return

;;;;;;;;;; Scripts ;;;;;;;;;;
    BaseScript() {
        global
        static A_Stamp := A_Stamp ? A_Stamp : 1
        GuiControl, MainInterface: Text, ScriptStatus_Gui, Enabled
        GuiControl, MainInterface: +cLime +Redraw , ScriptStatus_Gui
        While GetKeyState(StartKey, "p") {
            if (WorldTimePassed(A_Stamp,, "sec") > DurationOfEclipse) {
                WorldTimeStamp(A_Stamp)
                lSleep(SkillCastTime)
                Send, {Blind}{%AbilityC_Key%}
            }
            lSleep(20)
            Send, {Blind}{%AbilityA_Key%}
            lSleep(20)
            Send, {Blind}{%AbilityD_Key%}
            lSleep(20)
            Send, {Blind}{%PrimFireKey%}
        }
        GuiControl, MainInterface: Text, ScriptStatus_Gui, Disabled
        GuiControl, MainInterface: +cRed +Redraw , ScriptStatus_Gui
    }