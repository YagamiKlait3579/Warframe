;;;;;;;;;; Loading ;;;;;;;;;;
    #include %A_Scriptdir%\libs\BaseLibs\Header.ahk
    #IfWinActive, Warframe
    global PWN := "Warframe" ; Program window name
    OnExit("BeforeExiting")

;;;;;;;;;; Setting ;;;;;;;;;;
    StartAbilityKey      = Shift  ; Нажатие этой клавиши + способность включает повтор этой способности
    EditTimeKey          = Alt    ; Нажатие этой клавиши + способность включает режим изменения времени этой способности
    TimeStep            := 100    ; Шаг изменение времени для способности
    BigTimeStep         := 1000   ; Шаг изменение времени для способности при удержании клавиши BigTimeStepKey
    BigTimeStepKey       = Shift
    ;--------------------------------------------------
    Exodia_ThrowingTime := 50     ; Время броска
    Exodia_LandingTime  := 450    ; Время приземления
    ExodiaSpamKey        = PgDn   ; Вкл\Выкл повторения бросков при зажатии клавиши
    ;--------------------------------------------------
    GuiPositionY        := 0.9600 ; Изменение положения интерфейса по вертикали (Y-координата) только для этого скрипта

;;;;;;;;;; Variables ;;;;;;;;;;
    CheckingFiles(,"SavedSettings.ini")
    LoadIniSection(FP_SavedSettings, "Master Tenno")
    ;--------------------------------------------------
    global gAbilityTimer := [AbilityTimer_A, AbilityTimer_B, AbilityTimer_C, AbilityTimer_D]
    global A_AbilityKey := [AbilityA_Key, AbilityB_Key, AbilityC_Key, AbilityD_Key]
    global A_Activity := [0,0,0,0], A_Stamp := [], A_TimeEdit
    
;;;;;;;;;; Hotkeys ;;;;;;;;;;
    Hotkey, *%StartKey%, ClassicExodia

    for A_Loop, A_key in A_AbilityKey {
        fHotkey := Func("TimeEdit").Bind(A_Loop)
        Hotkey, %EditTimeKey% & %A_key%, %fHotkey%
    } 
    for A_Loop, A_key in A_AbilityKey {
        fHotkey := Func("StartStop").Bind(A_Loop)
        Hotkey, %StartAbilityKey% & %A_key%, %fHotkey%
    } 
    fHotkey := ""

    Hotkey, *%IncreaseKey%, IncreaseTiming
    Hotkey, *%DecreaseKey%, DecreaseTiming

    Hotkey, *%ExodiaSpamKey%, SwitchExodia

;;;;;;;;;; Gui ;;;;;;;;;;
    PlaceForTheText := "999999"
    PlaceForTheText2 := "  Classic  "
    ;--------------------------------------------------
    UpdateDGP({"Transparency" : gTransparency, "Blur" : gBlur, "Scale" : gInterfaceScale})
    GuiInGame("Start", "MainInterface")
        Gui, MainInterface: Add, Text, xm ym +Center +Border cRed vAbility1,`  1  `
        Gui, MainInterface: Add, Text, x+ ym +Center +Border cFuchsia vTimer1, %PlaceForTheText%
        GuiControl, MainInterface: Text, Timer1, % gAbilityTimer.1
        Gui, MainInterface: Add, Text, x+m ym +Center +Border cRed vAbility2,`  2  `
        Gui, MainInterface: Add, Text, x+ ym +Center +Border cFuchsia vTimer2, %PlaceForTheText%
        GuiControl, MainInterface: Text, Timer2, % gAbilityTimer.2
        Gui, MainInterface: Add, Text, x+m ym +Center +Border +Section cRed vAbility3,`  3  `
        Gui, MainInterface: Add, Text, x+ ym +Center +Border cFuchsia vTimer3, %PlaceForTheText%
        GuiControl, MainInterface: Text, Timer3, % gAbilityTimer.3
        Gui, MainInterface: Add, Text, x+m ym +Center +Border cRed vAbility4,`  4  `
        Gui, MainInterface: Add, Text, x+ ym +Center +Border cFuchsia vTimer4, %PlaceForTheText%
        GuiControl, MainInterface: Text, Timer4, % gAbilityTimer.4
        ;--------------------------------------------------
        Gui, MainInterface: Add, Text, xm y+m +Right,` Exodia:
        Gui, MainInterface: Add, Text, x+m +Center +Border cYellow vExodiaSpam_Gui, %PlaceForTheText2%
        GuiControl, MainInterface: Text, ExodiaSpam_Gui, % ExodiaSpam ? "Auto" : "Semi"
        Gui, MainInterface: Add, Text, xs yp +Right,` FPS:
        Gui, MainInterface: Add, Text, x+m +Center +Border cFuchsia,`  %SettingFPS%  `
    GuiInGame("End", "MainInterface", {"ratio" : [GuiPositionX,GuiPositionY]})
    fSuspendGui("On", "MainInterface")
    if DebugGui
        fDebugGui("Create", MainInterface)
    if HideTheInterface
        SetTimer, ShowHideGui , 250, -2
    Return

;;;;;;;;;; Scripts ;;;;;;;;;;
    ClassicExodia:
        While GetKeyState(StartKey, "p"){
            TimeStamp(ExodiaStart)
            Send, {Blind}{%JumpKey%}
            fSleep(2)
            Send, {Blind}{%JumpKey%}
            fSleep(2)
            Send, {Blind}{%ZoomKey% Down}
            fSleep(2)
            Send, {Blind}{%MeleeKey%}
            fSleep(2)
            Send, {Blind}{%ZoomKey% Up}
            if !ExodiaSpam
                Break
            lSleep(Exodia_ThrowingTime)
            Send, {Blind}{%EmoteAgreeKey%}
            fSleep(2)
            Send, {Blind}{%EmoteAgreeKey2%}
            lSleep(Exodia_LandingTime)
            Send, {Blind}{%ZoomKey%}
            fSleep(2)
            fDebugGui("Edit", "Exodia throw", TimePassed(ExodiaStart))
        }
        fSleep(2)
        Send, {Blind}{%ZoomKey%}
        fDebugGui("Edit", "Exodia throw", TimePassed(ExodiaStart))
    Return

    BaseScript:
        for A_Loop, A_key in A_Activity {
            if A_key && (TimePassed(A_Stamp[A_Loop]) > gAbilityTimer[A_Loop]) {
                B_key := A_AbilityKey[A_Loop]
                Send, {Blind}{%B_key%}
                A_Stamp[A_Loop] := TimeStamp()
            }
        }
    Return

;;;;;;;;;; Control Functions ;;;;;;;;;;
    StartStop(key) {
        A_Activity[key] := !A_Activity[key]
        Loop, 4
            GuiControl, % "MainInterface: " (A_Activity[A_Index] ? "+cLime" : "+cRed") " +Redraw", % "Ability" A_Index
        A_Stamp[key] := TimeStamp()
        if A_Activity.1 || A_Activity.2 || A_Activity.3 || A_Activity.4
            SetTimer, BaseScript, 1, -1
        else
            SetTimer, BaseScript, off
    }

    SwitchExodia:
        ExodiaSpam := !ExodiaSpam
        GuiControl, MainInterface: Text, ExodiaSpam_Gui, % ExodiaSpam ? "Auto" : "Semi"
    Return

    TimeEdit(key) {
        Loop, 4
            GuiControl, % "MainInterface: +cFuchsia +Redraw", % "Timer" A_Index
        A_TimeEdit := (A_TimeEdit = key) ? "" : key
        if A_TimeEdit
            GuiControl, % "MainInterface: +cYellow +Redraw", % "Timer" key
    }

;;;;;;;;;; Time management ;;;;;;;;;;
    IncreaseTiming:
        if !A_TimeEdit {
            Send, {Blind}{%IncreaseKey%}
            Return
        }
        if GetKeyState(BigTimeStepKey, "p") {
            if (gAbilityTimer[A_TimeEdit] + BigTimeStep > 99999)
                Return
            gAbilityTimer[A_TimeEdit] += BigTimeStep
        } else if (gAbilityTimer[A_TimeEdit] + TimeStep > 99999)
            Return
        else
            gAbilityTimer[A_TimeEdit] += TimeStep
        GuiControl, MainInterface: Text, % "Timer" A_TimeEdit, % gAbilityTimer[A_TimeEdit]
    Return

    DecreaseTiming:
        if !A_TimeEdit {
            Send, {Blind}{%DecreaseKey%}
            Return
        }
        if GetKeyState(BigTimeStepKey, "p") {
            if (gAbilityTimer[A_TimeEdit] - BigTimeStep < 1)
                Return
            gAbilityTimer[A_TimeEdit] -= BigTimeStep
        } else if (gAbilityTimer[A_TimeEdit] - TimeStep < 1)
            Return
        else
            gAbilityTimer[A_TimeEdit] -= TimeStep
        GuiControl, MainInterface: Text, % "Timer" A_TimeEdit, % gAbilityTimer[A_TimeEdit]
    Return

;;;;;;;;;; Exit ;;;;;;;;;;
    BeforeExiting() {
        global
        for A_Loop, A_key in ["AbilityTimer_A", "AbilityTimer_B", "AbilityTimer_C", "AbilityTimer_D"]
            IniWrite, % gAbilityTimer[A_Loop] , %FP_SavedSettings%, Master Tenno, %A_key%
        IniWrite, %ExodiaSpam%, %FP_SavedSettings%, Master Tenno, ExodiaSpam
    }