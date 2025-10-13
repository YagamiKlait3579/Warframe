;;;;;;;;;; Loading ;;;;;;;;;;
    #include %A_Scriptdir%\libs\CoreLibsFor_AHK\BaseLibs\Header.ahk
    ;--------------------------------------------------
    #IfWinActive, Warframe
    global PWN := "Warframe" ; Program window name
    CheckForUpdates("YagamiKlait3579", "Warframe", "main", CheckingFiles("File", False, "Header.ahk"))
    OnExit("BeforeExiting")

;;;;;;;;;; Setting ;;;;;;;;;;
    RepeatTime          := 15         ; Время применения одной способности (sec)
    ;--------------------------------------------------
    MT_Color            := "32e1e1"   ; Цвет энергии оператора (внизу с лево)
    MT_A_Color          := 50         ; Отклонения от оригинала цвета (от 0 до 255)
    ExitKey              = Numpad0    ; Выйти на следующем раунде
    SwitchExitKey        = F1         ; Вкл\Выкл выхода из миссии по таймеру
    EditExitTimekey      = F2         ; Редактировать время для таймера выхода
    ;--------------------------------------------------
    /* 
        Для работы SafeMode вы должны зайти на миссию в соло режиме.
        Если скрипт заметит что персонаж умер, то он откроет меню для остановки миссии, 
        чтобы вы ее не провалили, и будет ждать вашего присутствия.
    */
    SafeMode            := True
    Text_Death          := "|<>FBFDFA-0.80$174.00000000000000000000000000000Ts000000000000000000000000000Ty000000000000000000000000000Tz000000000000000000000000000Q3U00000000000000000000000000Q1U00000000000000000000000000Q1k00000000000000000000000000Q1k7k0zUNs0T0Q670Ty0T0kC71k7kQ1kDw1lkPw0zUC670Ty1zUkC71kDwQ1UQS3UsSC1lkC6C0QC3XUkC73kQQQ3Us630MQ73Us76C0QC31kkC73kMCRz0k700MM730M36Q0QC70kkC77ks6Tz0k700MM330M3aM0QC60kkC77kk6Q1Uk300sM370Q1zs0QC7zkkC7AkzyQ0kk30DUM370Q1zk0QC7zkzy7AkzyQ0kk30DkM370Q1zs0QC600zy7Mkk0Q0sk300sM370Q3aQ0QC600zi7Mkk0Q0sk700MM370M36Q0QC700kC7Ekk0Q0ks700MM730M76C0s6700kC7kks0Q1kMC30MQ73UsD6C0sC300kC7UkM0Q3kTw3UsSC1lkC671sC3kkkC7UkSCTzUDw1lkPw0zUS677zzVzkkC70kDyTy07k0T0Ns0T0Q63bzzUT0kC70k3s00000000M0000000703000000000000000000M0000000703000000000000000000M0000000703000000000000000000M0000000703000000000000000000M0000000703000000000000000000M0000000000000000000000000000000000000000000000000U"
    SM_A_FindText       := 0.20       ; Разброс точности текста для библиотеки Find Text
    ;--------------------------------------------------
    GuiPositionY        := 0.9600     ; Изменение положения интерфейса по вертикали (Y-координата) только для этого скрипта

;;;;;;;;;; Variables ;;;;;;;;;;
    LoadIniSection(CheckingFiles("File", True, "SavedSettings.ini"), SubStr(A_ScriptName, 1, InStr(A_ScriptName, ".", , -1) - 1))
    ;--------------------------------------------------
    global A_ScriptStatus := 0
    global RoundFlag, StatusMission, ExitMissionFlag, ExitMissionFlag2, gExitMissionStamp
    ; MT - MissionTrigger
    MT_Coords := [Round((A_ScreenWidth / 4) * 3), Round((A_ScreenHeight / 4) * 3), A_ScreenWidth, A_ScreenHeight]
    ; SM - Safe mode
    SM_Coords :=  [Round((A_ScreenWidth / 8) * 2), Round(A_ScreenHeight / 8), Round((A_ScreenWidth / 8) * 6), Round((A_ScreenHeight / 8) * 2)]

;;;;;;;;;; Hotkeys ;;;;;;;;;;
    Hotkey, *%StartKey%, StartStop
    Hotkey, *%ExitKey%, fExitNextMission

    Hotkey, *%SwitchExitKey%, fExitMissionTimer
    Hotkey, *%EditExitTimekey%, EditTimeGui

;;;;;;;;;; Gui ;;;;;;;;;;
    PlaceForTheText := " Ширина самого длинного текста "
    ;--------------------------------------------------
    UpdateDGP({"Transparency" : gTransparency, "Blur" : gBlur, "Scale" : gInterfaceScale})
    GuiInGame("Start", "MainInterface")
        Gui, MainInterface: Add, Text, xm ym +Center +Section vT1, % SubStr(A_ScriptName, 1, InStr(A_ScriptName, ".", , -1) - 1)
        Gui, MainInterface: Add, Text, x+m +Center +Border cRed vScriptStatus_Gui,` Disabled `
        Gui, MainInterface: Add, Text, x+m +Center +Border cFuchsia vTimer_Gui,` ----- `
        ;--------------------------------------------------
        Gui, MainInterface: Add, Text, xs y+m +Right vT2, % SubStr(A_ScriptName, 1, InStr(A_ScriptName, ".", , -1) - 1)
        GuiControl, MainInterface: Text, T2, Auto exit
        Gui, MainInterface: Add, Text, x+m +Center +Border cRed vAutoExit_Gui,` Disabled `
        Gui, MainInterface: Add, Text, x+m +Center +Border cFuchsia vAutoExit_GuiTimer,` 999 H : 999 M : 999S `
        if ExitMissionFlag2 {
            GuiInGame("Edit", "MainInterface", {"id" : "AutoExit_Gui", "Color" : "Lime", "Text" : "Enabled"})
            aTime := TimeConverter("Time", gExitMissionStamp)
            GuiControl, MainInterface: Text, AutoExit_GuiTimer, % aTime.1 " H : " aTime.2 " M : " aTime.3 " S"
        }
        Else {
            GuiInGame("Edit", "MainInterface", {"id" : "AutoExit_Gui", "Color" : "Red", "Text" : "Disabled"})
            GuiControl, MainInterface: Text, AutoExit_GuiTimer, 00 H : 00 M : 00 S
        }
    GuiInGame("End", "MainInterface", {"ratio" : [GuiPositionX,GuiPositionY]})
    fSuspendGui("On", "MainInterface")
    if DebugGui
        fDebugGui("Create", MainInterface)
    if HideTheInterface
        SetTimer, ShowHideGui , 250, -1
    if ExitMissionFlag2
        SetTimer, UpdateGUI , 250
Return

;;;;;;;;;; Gui functions ;;;;;;;;;;
    EditTimeGui() {
        global
        local FontSize := Round(((13 * gFontScaling) * gDPI) * (0.01 * gInterfaceScale))
        local Margin   := [Round(FontSize * 1.25), Round(FontSize * 0.75)]
        Gui, EditTimeGui: +AlwaysOnTop +LastFound -DPIScale +Border -MinimizeBox +HwndEditTimeGui
        Gui, EditTimeGui: Color, 151515
        Gui, EditTimeGui: Margin, % Margin.1, % Margin.2
        Gui, EditTimeGui: Font, % " s"FontSize " q3", MS Sans Serif
        ;--------------------------------------------------
        local x1, y1, w1, h1
        local Text := "  seconds  "
        local RemainingTime := TimeConverter("Time", gExitMissionStamp)
        Gui, EditTimeGui: Add, Text, xm ym cFFD700 +center +Border vT_Hour +HwndT_Hour, %Text%
        GuiControl, EditTimeGui: Text, T_Hour, Hour
        Gui, EditTimeGui: Add, Text, x+m ym cFFD700 +center +Border vT_Minutes +HwndT_Minutes, %Text%
        GuiControl, EditTimeGui: Text, T_Minutes, Minutes
        Gui, EditTimeGui: Add, Text, x+m ym cFFD700 +center +Border vT_Seconds +HwndT_Seconds, %Text%
        GuiControl, EditTimeGui: Text, T_Seconds, Seconds
            ;--------------------------------------------------
            WinGetPos, x1, y1, w1, h1, % "ahk_id" T_Hour
            Gui, EditTimeGui: Add, Edit, xm y+m +Limit2 +Number +Right -TabStop vEditHour, 00000
            Gui, EditTimeGui: Add, UpDown, range0-12
            GuiControl, EditTimeGui: Text, EditHour, % RemainingTime.1
            ;--------------------------------------------------
            WinGetPos, x1, y1, w1, h1, % "ahk_id" T_Minutes
            Gui, EditTimeGui: Add, Edit, x%x1% yp +Limit2 +Number +Right -TabStop vEditMinutes, 00000
            Gui, EditTimeGui: Add, UpDown, range0-59
            GuiControl, EditTimeGui: Text, EditMinutes, % RemainingTime.2
            ;--------------------------------------------------
            WinGetPos, x1, y1, w1, h1, % "ahk_id" T_Seconds
            Gui, EditTimeGui: Add, Edit, x%x1% yp +Limit2 +Number +Right -TabStop vEditSeconds, 00000
            Gui, EditTimeGui: Add, UpDown, range0-59
            GuiControl, EditTimeGui: Text, EditSeconds, % RemainingTime.3
        ;--------------------------------------------------
        w1 := GuiLineWidth(T_Hour, T_Seconds)
        Gui, EditTimeGui: Add, Text, xm y+m w%w1% cFFD700 +center +Border +0x00000201 vT1 gUpdateValues, `n
        GuiControl, EditTimeGui: Text, T1, Accept
        w1 := A_ScreenWidth / 3
        h1 := (w1 / 16) * 9
        Gui, EditTimeGui: Show, w%w1% h%h1%, Auto exit from the mission
        Gui, EditTimeGui: Add, Picture, % "x0 y0 w" w1 " h-1", % "HBITMAP:" ReadImages(CheckingFiles("File", False, "Warframe_Images.dll"), "Equinox_Index")
    }

    UpdateValues(param = "") {
        global
        Gui, Submit, NoHide
        gExitMissionStamp := TimeConverter("Stamp", [EditHour, EditMinutes, EditSeconds])
        Gui, EditTimeGui: Destroy
        GuiControl, MainInterface: Text, AutoExit_GuiTimer, % EditHour " H : " EditMinutes " M : " EditSeconds " S"
        ExitMissionFlag2 := True
        GuiInGame("Edit", "MainInterface", {"id" : "AutoExit_Gui", "Color" : "Lime", "Text" : "Enabled"})
        SetTimer, UpdateGUI , 250
	}

    UpdateGUI() {
        global
        local aTime := TimeConverter("Time", gExitMissionStamp)
        GuiControl, MainInterface: Text, AutoExit_GuiTimer, % aTime.1 " H : " aTime.2 " M : " aTime.3 " S"
        if ((aTime.1 <= 0) && (aTime.2 <= 0) && ( aTime.3 <= 0) && !ExitMissionFlag)
            fExitNextMission()
    }

;;;;;;;;;; Functions ;;;;;;;;;;
    fStatusMission() {
        global
        PixelSearch,,, MT_Coords[1], MT_Coords[2], MT_Coords[3], MT_Coords[4], "0x"MT_Color, MT_A_Color, Fast RGB
        if !ErrorLevel
            TimeStamp(StatusMission)
        if (TimePassed(StatusMission) > 1000)
            Return True
        Else
            Return False
    }

    fExitNextMission() {
        global
        ExitMissionFlag := !ExitMissionFlag
        if ExitMissionFlag {
            GuiInGame("Start", "ExitMission")
            Gui, ExitMission: Add, Text, % " xm ym w" (DebugGui ? GuiLineWidth(DebugGui) : GuiLineWidth(MainInterface)) " +Center cRed", Exit to next mission
            if DebugGui
                GuiInGame("End", "ExitMission", {"Hwnd" : DebugGui})
            Else
                GuiInGame("End", "ExitMission", {"Hwnd" : MainInterface})
        } Else {
            GuiInGame("Destroy", "ExitMission")
        }
    }

    fExitMissionTimer(param = "") {
        global
        ExitMissionFlag2 := ((param = "Off") ? False : ((param = "On") ? True : !ExitMissionFlag2))
        if ExitMissionFlag2 {
            GuiInGame("Edit", "MainInterface", {"id" : "AutoExit_Gui", "Color" : "Lime", "Text" : "Enabled"})
            SetTimer, UpdateGUI , 250
        }
        Else {
            GuiInGame("Edit", "MainInterface", {"id" : "AutoExit_Gui", "Color" : "Red", "Text" : "Disabled"})
            SetTimer, UpdateGUI , Off
            GuiControl, MainInterface: Text, AutoExit_GuiTimer, 00 H : 00 M : 00 S
        }
    }

;;;;;;;;;; Scripts ;;;;;;;;;;
    StartStop() {
        global
        if !A_ScriptStatus {
            A_ScriptStatus := !A_ScriptStatus
            RoundFlag := RoundFlag ? RoundFlag : WorldTimeStamp()
            TimeStamp(StatusMission)
            SetTimer, Main, 1
            GuiInGame("Edit", "MainInterface", {"id" : "ScriptStatus_Gui", "Color" : "Lime", "Text" : "Enabled"})
        } else 
            Reload
    }

    Main() {
        global
        local mTime, sTime, timePassed, A_Stamp
        TimeStamp(A_Stamp)
        Send, {Blind}{%OperatorKey%}
        lSleep(250)
        Send, {Blind}{%MeleeKey%}
        lSleep(20)
        Send, {Blind}{%PrimFireKey% Down}
        lSleep(1000)
        Send, {Blind}{%PrimFireKey% Up}
        lSleep(20)
        Send, {Blind}{%AbilityA_Key%}
        lSleep(20)
        Loop, {
            if SafeMode {
                if FindText(,, SM_Coords[1], SM_Coords[2], SM_Coords[3], SM_Coords[4], SM_A_FindText, SM_A_FindText, Text_Death) {
                    Send, {Blind}{Esc}
                    SetTimer, Main, off
                    GuiInGame("Edit", "MainInterface", {"id" : "ScriptStatus_Gui", "Color" : "Red", "Text" : "Disabled"})
                    fExitMissionTimer("Off")
                    A_ScriptStatus := False
                    fDebugGui("Edit", "You're dead", A_Hour " hour : " A_Min " min : " A_Sec " sec")
                    Break
                }
            }
            GuiControl, MainInterface: Text, Timer_Gui, % Round(RepeatTime - TimePassed(A_Stamp,, "sec"), 1)
            if fStatusMission() {
                timePassed := Round(WorldTimePassed(RoundFlag,, "sec"))
                mTime := (timePassed < 60) ? 0 : Floor(timePassed / 60)
                sTime := (timePassed < 60) ? timePassed : Round(timePassed - (mTime * 60))
                fDebugGui("Edit", "Last round time", mTime " min : " sTime " sec")
                if ExitMissionFlag {
                    SetTimer, Main, off
                    GuiInGame("Edit", "MainInterface", {"id" : "ScriptStatus_Gui", "Color" : "Red", "Text" : "Disabled"})
                    fSetCursor(A_ScreenWidth / 4, (A_ScreenHeight / 2))
                    fExitNextMission()
                    fExitMissionTimer("Off")
                    A_ScriptStatus := False
                } Else
                    fSetCursor((A_ScreenWidth / 4) * 3, (A_ScreenHeight / 2))
                lSleep(250)
                fMouseInput("Left")
                WorldTimeStamp(RoundFlag)
                lSleep(2000)
                Break
            }
        } until (TimePassed(A_Stamp,, "sec") > RepeatTime)
        GuiControl, MainInterface: Text, Timer_Gui,` ----- `
    }

;;;;;;;;;; Time management ;;;;;;;;;;
    TimeConverter(Command, param) {
        switch Command {
            case "Time" : {
                DllCall("GetSystemTimeAsFileTime", "Int64P", aStamp)
                RemainingTime := param - aStamp
                if (RemainingTime < 0)
                    Return [0,0,0]
                RemainingTime := Round(RemainingTime / Frequency)
                hTime := (RemainingTime < 3600) ? 0 : Floor(RemainingTime / 3600)
                RemainingTime := Round(RemainingTime - (hTime * 3600))
                mTime := (RemainingTime < 60) ? 0 : Floor(RemainingTime / 60)
                RemainingTime := Round(RemainingTime - (mTime * 60))
                Return_time := [hTime, mTime, RemainingTime]
                Return Return_time
            }
            case "Stamp", "TimeStamp" : {
                Return_time := Round(((param.1 * 3600) + (param.2 * 60) + param.3) * Frequency)
                DllCall("GetSystemTimeAsFileTime", "Int64P", aStamp)
                Return_time := Return_time + aStamp
                Return Return_time
            }
        }
    }

;;;;;;;;;; Exit ;;;;;;;;;;
    BeforeExiting() {
        global
        IniWrite, %gExitMissionStamp%, %OP_SavedSettings%, % SubStr(A_ScriptName, 1, InStr(A_ScriptName, ".", , -1) - 1), gExitMissionStamp
        IniWrite, %ExitMissionFlag2%, %OP_SavedSettings%, % SubStr(A_ScriptName, 1, InStr(A_ScriptName, ".", , -1) - 1), ExitMissionFlag2
    }

    EditTimeGuiGuiClose() {
        Gui, EditTimeGui: Destroy
    }