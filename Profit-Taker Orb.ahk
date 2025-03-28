;;;;;;;;;; Loading ;;;;;;;;;;
    #include %A_Scriptdir%\libs\BaseLibs\Header.ahk
    #IfWinActive, Warframe
    global PWN := "Warframe" ; Program window name

;;;;;;;;;; Setting ;;;;;;;;;;
    Exodia_ThrowingTime := 50     ; Время броска
    Exodia_LandingTime  := 450    ; Время приземления (оно же время стрельбы с оружия)

;;;;;;;;;; Variables ;;;;;;;;;;

;;;;;;;;;; Hotkeys ;;;;;;;;;;
    Hotkey, *%StartKey%, BaseScript

;;;;;;;;;; Gui ;;;;;;;;;;
    PlaceForTheText := "Ширина самого длинного текста"
    ;--------------------------------------------------
    UpdateDGP({"Transparency" : gTransparency, "Blur" : gBlur, "Scale" : gInterfaceScale})
    GuiInGame("Start", "MainInterface")
        Gui, MainInterface: Add, Text, xm ym +Center, Profit-Taker Orb
        Gui, MainInterface: Add, Text, x+m +Center +Border cRed vScriptStatus_Gui,` Disabled `
        Gui, MainInterface: Add, Text, x+m +Center, FPS:
        Gui, MainInterface: Add, Text, x+m +Center +Border cFuchsia,` %SettingFPS% `
    GuiInGame("End", "MainInterface", {"ratio" : [GuiPositionX,GuiPositionY]})
    fSuspendGui("On", "MainInterface")
    if DebugGui
        fDebugGui("Create", MainInterface)
    if HideTheInterface
        SetTimer, ShowHideGui , 250, -1
Return

;;;;;;;;;; Scripts ;;;;;;;;;;
    BaseScript:
        GuiControl, MainInterface: Text, ScriptStatus_Gui, Enabled
        GuiControl, MainInterface: +cLime +Redraw , ScriptStatus_Gui
        While GetKeyState(StartKey, "p") {
            TimeStamp(A_Start)
            Send, {Blind}{%JumpKey%}
            fSleep(2)
            Send, {Blind}{%JumpKey%}
            fSleep(2)
            Send, {Blind}{%ZoomKey% Down}
            fSleep(2)
            Send, {Blind}{%MeleeKey%}
            fSleep(2)
            Send, {Blind}{%ZoomKey% Up}
            lSleep(Exodia_ThrowingTime)
            Send, {Blind}{%EmoteAgreeKey%}
            fSleep(2)
            Send, {Blind}{%EmoteAgreeKey2%}
            TimeStamp(B_Start)
            Loop, {
                Send, {Blind}{%PrimFireKey%}
                fSleep(1)
                if (Exodia_LandingTime < TimePassed(B_Start)) 
                    Break
            }
            fDebugGui("Edit", "Single cycle", TimePassed(A_Start) " ms")
        }
        GuiControl, MainInterface: Text, ScriptStatus_Gui, Disabled
        GuiControl, MainInterface: +cRed +Redraw , ScriptStatus_Gui
    Return