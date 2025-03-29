;;;;;;;;;; Loading ;;;;;;;;;;
    #include %A_Scriptdir%\libs\CoreLibsFor_AHK\BaseLibs\Header.ahk
    ;--------------------------------------------------
    #IfWinActive, Warframe
    global PWN := "Warframe" ; Program window name

;;;;;;;;;; Setting ;;;;;;;;;;
    Exodia_ThrowingTime := 50      ; Время броска
    Exodia_LandingTime  := 450     ; Время приземления (оно же время стрельбы с оружия)
    ;--------------------------------------------------
    SkipArchGunKey       = Numpad0 ; Быстрый запуск оружия арчвинга
    RepairArchGun       := False   ; Ремонт перезарядки арчвинга при его быстром запуске (True — включено, False — выключено)
    ;--------------------------------------------------
    GuiPositionY        := 0.9600  ; Изменение положения интерфейса по вертикали (Y-координата) только для этого скрипта
    
;;;;;;;;;; Variables ;;;;;;;;;;
    global gCountdownStamp

;;;;;;;;;; Hotkeys ;;;;;;;;;;
    Hotkey, *%StartKey%, ClassicExodia
    Hotkey, *%SkipArchGunKey%, SkipArchGun

;;;;;;;;;; Gui ;;;;;;;;;;
    PlaceForTheText := " Disabled "
    ;--------------------------------------------------
    UpdateDGP({"Transparency" : gTransparency, "Blur" : gBlur, "Scale" : gInterfaceScale})
    GuiInGame("Start", "MainInterface")
        Gui, MainInterface: Add, Text, xm ym +Center, Profit-Taker Orb
        Gui, MainInterface: Add, Text, x+m +Center +Border cRed +Section vScriptStatus_Gui, %PlaceForTheText%
        GuiControl, MainInterface: Text, ScriptStatus_Gui, Disabled
        Gui, MainInterface: Add, Text, x+m +Center, FPS:
        Gui, MainInterface: Add, Text, x+m +Center +Border cFuchsia,` %SettingFPS% `
        ;--------------------------------------------------
        Gui, MainInterface: Add, Text, xm y+m +Center, Debug Melee:
        Gui, MainInterface: Add, Text, xs yp +Center +Border cFuchsia vCountdown_Gui, %PlaceForTheText%
        GuiControl, MainInterface: Text, Countdown_Gui, - - - - -
    GuiInGame("End", "MainInterface", {"ratio" : [GuiPositionX,GuiPositionY]})
    fSuspendGui("On", "MainInterface")
    if DebugGui
        fDebugGui("Create", MainInterface)
    if HideTheInterface
        SetTimer, ShowHideGui , 250, -1
Return

;;;;;;;;;; Time management ;;;;;;;;;;
    CountdownToError() {
        A_Time := Round((15000 - TimePassed(gCountdownStamp)) / 1000, 1)
        if (A_Time > 0)
            GuiControl, MainInterface: Text, Countdown_Gui, %A_Time% sec
        Else {
            GuiControl, MainInterface: Text, Countdown_Gui, - - - - -
            SetTimer, CountdownToError, Off
        }   
    }

;;;;;;;;;; Scripts ;;;;;;;;;;
    ClassicExodia() {
        global
        local A_Stamp, B_Stamp
        GuiControl, MainInterface: Text, ScriptStatus_Gui, Enabled
        GuiControl, MainInterface: +cLime +Redraw , ScriptStatus_Gui
        While GetKeyState(StartKey, "p") {
            TimeStamp(A_Stamp)
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
            TimeStamp(B_Stamp)
            Loop, {
                Send, {Blind}{%PrimFireKey%}
                fSleep(1)
                if (Exodia_LandingTime < TimePassed(B_Stamp)) 
                    Break
            }
            fDebugGui("Edit", "Single cycle", TimePassed(A_Stamp) " ms")
        }
        GuiControl, MainInterface: Text, ScriptStatus_Gui, Disabled
        GuiControl, MainInterface: +cRed +Redraw , ScriptStatus_Gui
    }

    SkipArchGun() {
        global
        local A_Stamp
        TimeStamp(A_Stamp)
        Send, {Blind}{%ZoomKey%}
        fSleep(2)
        Send, {Blind}{%ArchGunKey%}{%OperatorKey%}
        fSleep(4,135)
        Send, {Blind}{%MeleeKey%}
        if RepairArchGun {
            fSleep(2,40)
            Send, {Blind}{%OperatorKey%}
            fSleep(4,135)
            Send, {Blind}{%MeleeKey%}
        }
        TimeStamp(gCountdownStamp)
        SetTimer, CountdownToError, 100
        fDebugGui("Edit", "Skip ArchGun", TimePassed(A_Stamp) " ms")
    }