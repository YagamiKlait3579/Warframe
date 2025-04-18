;;;;;;;;;; Loading ;;;;;;;;;;
    #include %A_Scriptdir%\libs\CoreLibsFor_AHK\BaseLibs\Header.ahk
    ;--------------------------------------------------
    #IfWinActive, Warframe
    global PWN := "Warframe" ; Program window name
    OnExit("BeforeExiting")

;;;;;;;;;; Setting ;;;;;;;;;;
    ModKey            = Shift   ; При удержании этой клавиши можно включать\выключать бафы, а также менять время повтора.
    TriumphKey       := 1       ; Вкл\выкл применения бафа овергварда
    WordwardenKey    := 2       ; Вкл\выкл применения бафа сапп книги
    PageflightKey    := 3       ; Вкл\выкл применения бафа птички для дебафа врагов
    ;--------------------------------------------------
    AutoRepeatKey     = End     ; Вкл\выкл авто обновления бафов
    ;--------------------------------------------------
    AbilityCastSpeed := 400     ; Время применения одной способности
    ;--------------------------------------------------
    GuiPositionY     := 0.9600 ; Изменение положения интерфейса по вертикали (Y-координата) только для этого скрипта

;;;;;;;;;; Variables ;;;;;;;;;;
    CheckingFiles(,"SavedSettings.ini")
    LoadIniSection(FP_SavedSettings, SubStr(A_ScriptName, 1, InStr(A_ScriptName, ".", , -1) - 1))
    global A_ScriptStatus := 0
    ;--------------------------------------------------
    global gTime := gTime ? gTime : 60000
    ;--------------------------------------------------
    global Triumph_Flag := Triumph_Flag ? Triumph_Flag : 0
    global Wordwarden_Flag := Wordwarden_Flag ? Wordwarden_Flag : 0
    global Pageflight_Flag := Pageflight_Flag ? Pageflight_Flag : 0
    ;--------------------------------------------------
    global AutoRepeat := AutoRepeat ? AutoRepeat : 0

;;;;;;;;;; Hotkeys ;;;;;;;;;;
    Hotkey, *%StartKey%, StartStop

    fHotkey := Func("SwitchFunctions").Bind("AutoRepeat")
    Hotkey, *%AutoRepeatKey% , %fHotkey%
    fHotkey := Func("SwitchFunctions").Bind("Triumph")
    Hotkey, %ModKey% & %TriumphKey% , %fHotkey%
    fHotkey := Func("SwitchFunctions").Bind("Wordwarden")
    Hotkey, %ModKey% & %WordwardenKey% , %fHotkey%
    fHotkey := Func("SwitchFunctions").Bind("Pageflight")
    Hotkey, %ModKey% & %PageflightKey% , %fHotkey%

    Hotkey, %ModKey% & %IncreaseKey%, IncreaseTiming
    Hotkey, %ModKey% & %DecreaseKey%, DecreaseTiming

;;;;;;;;;; Gui ;;;;;;;;;;
    PlaceForTheText := " 120 sec "
    ;--------------------------------------------------
    UpdateDGP({"Transparency" : gTransparency, "Blur" : gBlur, "Scale" : gInterfaceScale})
    GuiInGame("Start", "MainInterface")
        Gui, MainInterface: Add, Text, xm ym +Right HwndStartWinth,` Dante (sup):
        Gui, MainInterface: Add, Text, x+m +Center +Border cRed vScriptStatus_Gui,` Disabled ` ; Enabled
        Gui, MainInterface: Add, Text, x+m +Center +Border cYellow vAutoRepeat_Gui, %PlaceForTheText%
        GuiControl, MainInterface: Text, AutoRepeat_Gui, % AutoRepeat ? " Auto " : " Semi "
        Gui, MainInterface: Add, Text, x+m +Center +Border cFuchsia HwndEndWinth vTime_Gui, %PlaceForTheText%
        GuiControl, MainInterface: Text, Time_Gui, % Round(gTime / 1000) " sec"
        ;--------------------------------------------------
        A_Width := ((GuiLineWidth(StartWinth, EndWinth) - (DGP.Margin.1 * 2)) / 3)
        Gui, MainInterface: Add, Text, % "xm y+m w" A_Width " +Center +Border c" (Triumph_Flag ? "Lime" : "Red") " vT1", Triumph
        Gui, MainInterface: Add, Text, % "x+m w" A_Width " +Center +Border c" (Wordwarden_Flag ? "Lime" : "Red") " vT2", Wordwarden
        Gui, MainInterface: Add, Text, % "x+m w" A_Width " +Center +Border c" (Pageflight_Flag ? "Lime" : "Red") " vT3", Pageflight
    GuiInGame("End", "MainInterface", {"ratio" : [GuiPositionX,GuiPositionY]})
    fSuspendGui("On", "MainInterface")
    if DebugGui
        fDebugGui("Create", MainInterface)
    if HideTheInterface
        SetTimer, ShowHideGui , 250, -1
    Return

;;;;;;;;;; Control Functions ;;;;;;;;;;
    StartStop() {
        A_ScriptStatus := !A_ScriptStatus
        if A_ScriptStatus {
            GuiControl, MainInterface: Text, ScriptStatus_Gui, Enabled
            GuiControl, MainInterface: +cLime +Redraw, ScriptStatus_Gui
            SetTimer, Dante, 1
        } Else
            Reload
    }

    SwitchFunctions(param) {
        global
        switch param {
            case "AutoRepeat" : AutoRepeat := !AutoRepeat
            case "Triumph"    : Triumph_Flag := !Triumph_Flag
            case "Wordwarden" : Wordwarden_Flag := !Wordwarden_Flag
            case "Pageflight" : Pageflight_Flag := !Pageflight_Flag
        }
        GuiControl, MainInterface: Text, AutoRepeat_Gui, % AutoRepeat ? " Auto " : " Semi "
        for A_loop, A_key in [Triumph_Flag, Wordwarden_Flag, Pageflight_Flag]
            GuiControl, % "MainInterface: +c" (A_key ? "Lime" : "Red") " +Redraw", % "T" A_loop
    }

;;;;;;;;;; Scripts ;;;;;;;;;;
    Dante() {
        global
        local A_Start
        TimeStamp(A_Start)
        for A_loop, A_key in [Triumph_Flag, Wordwarden_Flag, Pageflight_Flag]
            if A_key {
                FinalVerse(A_loop)
                lSleep(AbilityCastSpeed * 2)
            }
        loop, {
            if !AutoRepeat {
                SetTimer, Dante, Off
                A_ScriptStatus := 0
                GuiControl, MainInterface: Text, ScriptStatus_Gui, Disabled
                GuiControl, MainInterface: +cRed +Redraw, ScriptStatus_Gui
                fDebugGui("Edit", "------------", "------------")
                Break
            } Else {
                lSleep(50)
                fDebugGui("Edit", "Time to repeat", Round((gTime - TimePassed(A_Start)) / 1000, 1) " sec")
            }   
        } Until (TimePassed(A_Start) >= (gTime - 50))
    }

    FinalVerse(param) {
        global
        switch param {
            case "Triumph", 1 : { ; Overguard
                Send, {Blind}{%AbilityB_Key%}
                lSleep(AbilityCastSpeed)
                Send, {Blind}{%AbilityB_Key%}
            }
            case "Wordwarden", 2 : {
                Send, {Blind}{%AbilityB_Key%}
                lSleep(AbilityCastSpeed)
                Send, {Blind}{%AbilityC_Key%}
            }
            case "Pageflight", 3 : { ; Add status damage
                Send, {Blind}{%AbilityC_Key%}
                lSleep(AbilityCastSpeed)
                Send, {Blind}{%AbilityB_Key%}
            }
        }
        lSleep(AbilityCastSpeed)
        Send, {Blind}{%AbilityD_Key%}
    }

;;;;;;;;;; Time management ;;;;;;;;;;
    IncreaseTiming:
        if (gTime + 1000 > 120000)
            Return
        gTime += 1000
        GuiControl, MainInterface: Text, Time_Gui, % Round(gTime / 1000) " sec"
    Return

    DecreaseTiming:
        if (gTime - 1000 < 1)
            Return
        gTime -= 1000
        GuiControl, MainInterface: Text, Time_Gui, % Round(gTime / 1000) " sec"
    Return

;;;;;;;;;; Exit ;;;;;;;;;;
    BeforeExiting() {
        global
        IniWrite, %gTime%, %FP_SavedSettings%, Dante (sup), gTime
        ;--------------------------------------------------
        IniWrite, %Triumph_Flag%, %FP_SavedSettings%, Dante (sup), Triumph_Flag
        IniWrite, %Wordwarden_Flag%, %FP_SavedSettings%, Dante (sup), Wordwarden_Flag
        IniWrite, %Pageflight_Flag%, %FP_SavedSettings%, Dante (sup), Pageflight_Flag
        ;--------------------------------------------------
        IniWrite, %AutoRepeat%, %FP_SavedSettings%, Dante (sup), AutoRepeat
    }