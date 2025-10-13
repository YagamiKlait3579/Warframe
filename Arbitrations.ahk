;;;;;;;;;; Loading ;;;;;;;;;;
    #include %A_Scriptdir%\libs\CoreLibsFor_AHK\BaseLibs\Header.ahk
    ;--------------------------------------------------
    #IfWinActive, Warframe
    global PWN := "Warframe" ; Program window name
    CheckForUpdates("YagamiKlait3579", "Warframe", "main", CheckingFiles("File", False, "Header.ahk"))
    OnExit("BeforeExiting")

;;;;;;;;;; Setting ;;;;;;;;;;
    SkillCastTime         := 1000   ; Время применения одной способности (ms)
    EnergizedMunitionsKey := 4      ; Клавиша с способностью "Энергетические боеприпасы" от Гельминта
    ;;; Saryn
    DurationOfSpores      := 85     ; Длительность "Дозы яда" (sec)
    DurationOfToxicLash   := 95     ; Длительность "Токсичный хлыст" (sec)
    ;;; Mirage
    DurationOfEclipse     := 53     ; Длительность способности "Затмение" (sec)
    
;;;;;;;;;; Variables ;;;;;;;;;;
    LoadIniSection(CheckingFiles("File", True, "SavedSettings.ini"), SubStr(A_ScriptName, 1, InStr(A_ScriptName, ".", , -1) - 1))
    ;--------------------------------------------------
    global RunningProfile, RunningFlag := False
    ReloadFlag := ReloadFlag ? ReloadFlag : False
    ;--------------------------------------------------
    if !ReloadFlag
        ChoosingProfile()
    if !RunningProfile {
        MsgBox, 16, % SubStr(A_ScriptName, 1, InStr(A_ScriptName, ".", , -1) - 1), Ошибка выбора профиля.`nProfile selection error.
        ExitApp
    }

;;;;;;;;;; Hotkeys ;;;;;;;;;;
    Hotkey, *%StartKey%, Main

;;;;;;;;;; Gui ;;;;;;;;;;
    PlaceForTheText := " Ширина самого длинного текста "
    ;--------------------------------------------------
    UpdateDGP({"Transparency" : gTransparency, "Blur" : gBlur, "Scale" : gInterfaceScale})
    GuiInGame("Start", "MainInterface")
        Gui, MainInterface: Add, Text, xm ym +Center vT1, % SubStr(A_ScriptName, 1, InStr(A_ScriptName, ".", , -1) - 1) "( " RunningProfile " )"
        Gui, MainInterface: Add, Text, x+m +Center +Border cRed +Section vScriptStatus_Gui,` Disabled `
    GuiInGame("End", "MainInterface", {"ratio" : [GuiPositionX,GuiPositionY]})
    fSuspendGui("On", "MainInterface")
    if DebugGui
        fDebugGui("Create", MainInterface)
    if HideTheInterface
        SetTimer, ShowHideGui , 250, -1
Return

;;;;;;;;;; Gui functions ;;;;;;;;;;
    ChoosingProfile() {
        global
        local FontSize := Round(((15 * gFontScaling) * gDPI) * (0.01 * gInterfaceScale))
        local Margin   := [Round(FontSize * 1.25), Round(FontSize * 0.75)]
        Gui, ChoosingProfile: +AlwaysOnTop +LastFound -DPIScale +Border -MinimizeBox +HwndChoosingProfile
        Gui, ChoosingProfile: Color, 101010
        Gui, ChoosingProfile: Margin, % Margin.1, % Margin.2
        Gui, ChoosingProfile: Font, % " s"FontSize " q3", MS Sans Serif
        ;--------------------------------------------------
        local Text := " Name warframe "
        local funcObj
        for A_Loop, A_key in ["Saryn", "Mirage"] {
            funcObj := Func("ProfileUpload").Bind(A_key)
            Gui, ChoosingProfile: Add, Text,% " xm y+m cFFD700 +Center +Border v" A_key "_GUI", %Text%
            GuiControl, ChoosingProfile: Text, %A_key%_GUI , %A_key%
            GuiControl, ChoosingProfile: +g, %A_key%_GUI, %funcObj%         
        }
        local w1, h1
        w1 := A_ScreenWidth / 4
        h1 := (w1 / 16) * 9
        Gui, ChoosingProfile: Show, w%w1% h%h1%, Arbitrations profile
        Gui, ChoosingProfile: Add, Picture, % "x0 y0 w" w1 " h-1", % "HBITMAP:" ReadImages(CheckingFiles("File", False, "Warframe_Images.dll"), "Arbitrations")
        Loop, {
            lSleep(1)
        } Until RunningFlag
    }

    ProfileUpload(param) {
        global
        RunningFlag := True
        RunningProfile := param
        Gui, ChoosingProfile: Destroy
    }

    ChoosingProfileGuiClose() {
        Gui, ChoosingProfile: Destroy
        ExitApp
    }

;;;;;;;;;; Scripts ;;;;;;;;;;
    Main() {
        global
        static A_Stamp := A_Stamp ? A_Stamp : 1
        static B_Stamp := B_Stamp ? B_Stamp : 1
        GuiInGame("Edit", "MainInterface", {"id" : "ScriptStatus_Gui", "Color" : "Lime", "Text" : "Enabled"})
        While GetKeyState(StartKey, "p") {
            switch RunningProfile {
                case "Saryn" : {
                    if (WorldTimePassed(B_Stamp,, "sec") > DurationOfSpores) {
                        WorldTimeStamp(B_Stamp)
                        lSleep(SkillCastTime)
                        Send, {Blind}{%AbilityA_Key% Down}
                        lSleep(250)
                        Send, {Blind}{%AbilityA_Key% Up}
                    }
                    if (WorldTimePassed(A_Stamp,, "sec") > DurationOfToxicLash) {
                        WorldTimeStamp(A_Stamp)
                        lSleep(SkillCastTime)
                        Send, {Blind}{%AbilityC_Key%}
                    }
                }
                case "Mirage" : {
                    if (WorldTimePassed(A_Stamp,, "sec") > DurationOfEclipse) {
                        WorldTimeStamp(A_Stamp)
                        lSleep(SkillCastTime)
                        Send, {Blind}{%AbilityC_Key%}
                    }
                    lSleep(20)
                    Send, {Blind}{%AbilityA_Key%}
                }
            }
            lSleep(20)
            Send, {Blind}{%EnergizedMunitionsKey%}
            lSleep(20)
            Send, {Blind}{%PrimFireKey%}
        }
        GuiInGame("Edit", "MainInterface", {"id" : "ScriptStatus_Gui", "Color" : "Red", "Text" : "Disabled"})
    }

;;;;;;;;;; Exit ;;;;;;;;;;
    BeforeExiting() {
        global
        IniWrite, % ((A_ExitReason = "Reload") ? True : False), %OP_SavedSettings%, % SubStr(A_ScriptName, 1, InStr(A_ScriptName, ".", , -1) - 1), ReloadFlag
        IniWrite, %RunningProfile% , %OP_SavedSettings%, % SubStr(A_ScriptName, 1, InStr(A_ScriptName, ".", , -1) - 1), RunningProfile
    }