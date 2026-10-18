;;;;;;;;;; Loading ;;;;;;;;;;
    #include %A_Scriptdir%\libs\CoreLibsFor_AHK\BaseLibs\Header.ahk
    ;--------------------------------------------------
    #IfWinActive, Warframe
    global PWN := "Warframe" ; Program window name
    CheckForUpdates("YagamiKlait3579", "Warframe", "main", CheckingFiles("File", False, "Header.ahk"))
    OnExit("BeforeExiting")

;;;;;;;;;; Info ;;;;;;;;;;
    /*
        Скрипт для миссий Арбитража в Warframe.

        Скрипт помогает автоматизировать продолжительную игру за выбранного персонажа:
        самостоятельно поддерживает необходимые способности активными и выполняет
        клики мыши для стрельбы из оружия, не имеющего механики авто-стрельбы.

        Перед запуском необходимо выбрать соответствующего персонажа.

        Доступные персонажи:
        • Saryn — поддерживает "Дозу яда" и "Токсичный хлыст", а также использует
          дополнительную способность от Гельминта и основную атаку.
        • Mirage — поддерживает "Затмение", при необходимости использует
          "Зеркальную Галерею", а также дополнительную способность от Гельминта
          и основную атаку.
        • Cyte-09 — поддерживает "Поиск" и "Доставку", а также использует
          дополнительную способность от Гельминта и основную атаку.

        Использование отдельных способностей можно отключить в настройках.
        Для этого достаточно установить длительность соответствующей способности
        в 0. Для способностей с отдельным параметром включения/отключения
        используется соответствующая настройка.

        Макрос активируется стандартной клавишей StartKey, указанной в файле Settings.ahk.
        Действия выполняются только пока эта клавиша удерживается.

        Основные параметры каждого профиля находятся в разделе Setting ниже.
        Также существуют общие настройки в файле Settings.ahk. Если какая-либо
        настройка указана одновременно здесь и в Settings.ahk, значение из этого
        макроса имеет приоритет.

        Также присутствуют общие дополнительные функции для всех макросов проекта.
        Подробнее об их функционале вы можете прочитать на странице GitHub проекта.
    */

;;;;;;;;;; Setting ;;;;;;;;;;
    SkillCastTime         := 1000   ; Время применения одной способности (ms)
    AntiRepeat            := True   ; Защита от лишних переприменений способностей (True - нажатие, False - зажатие)
    ;--------------------------------------------------
    GelmintAbility        := 4      ; Номер способности заменной Гельминтом
    GelmintInversion      := True   ; Инверсия зажатия-нажатия способности заменной Гельминтом (True - зажатие, False - нажатие)
    GelmintAbilityTime    := 27     ; Частота применения доролнительной способности Гельминта (sec)
    ;;; Saryn
    InversionOfSpores     := False  ; Инверсия зажатия-нажатия "Дозы яда" (True - нажатие, False - зажатие)
    DurationOfSpores      := 85     ; Частота применения способности "Дозы яда" (sec)
    DurationOfToxicLash   := 95     ; Частота применения способности "Токсичный хлыст" (sec)
    ;;; Mirage
    applyHallOfMirrors    := True   ; Применять способность "Зеркальная Галерея" (True - вкл, False - выкл)
    DurationOfEclipse     := 53     ; Частота применения способности "Затмение" (sec)
    ;;; Cyte-09
    DurationOfSeek        := 78     ; Частота применения способности "Поиск" (sec)
    DurationOfResupply    := 200    ; Частота применения способности "Доставка" (ms)
    
;;;;;;;;;; Variables ;;;;;;;;;;
    if !CheckingFiles("File", True, "SavedSettings.ini")
        FileAppend, , % A_WorkingDir . "\libs\SavedSettings.ini"
    LoadIniSection(CheckingFiles("File", True, "SavedSettings.ini"), SubStr(A_ScriptName, 1, InStr(A_ScriptName, ".", , -1) - 1))
    ;--------------------------------------------------
    global RunningProfile, RunningFlag := False
    ReloadFlag := ReloadFlag ? ReloadFlag : False
    ;--------------------------------------------------
    global StampKeyA := 1
    global StampKeyB := 1
    global StampKeyC := 1
    global StampKeyD := 1
    global StampKeyGelmint := 1
    ;--------------------------------------------------
    Loop, 4
        if (GelmintAbility = A_Index) {
            switch A_Index {
                case 1: GelmintAbility := AbilityA_Key
                case 2: GelmintAbility := AbilityB_Key
                case 3: GelmintAbility := AbilityC_Key
                case 4: GelmintAbility := AbilityD_Key
            }
            Break
        }
    ;--------------------------------------------------
    if !ReloadFlag
        ChoosingProfile()
    if !RunningProfile {
        MsgBox, 16, % SubStr(A_ScriptName, 1, InStr(A_ScriptName, ".", , -1) - 1), Ошибка выбора профиля.`nProfile selection error.
        ExitApp
    }

;;;;;;;;;; Hotkeys ;;;;;;;;;;
    Hotkey, *%StartKey%, Main
    ;--------------------------------------------------
    if AntiRepeat {
        for A_Loop, A_key in [AbilityA_Key, AbilityB_Key, AbilityC_Key, AbilityD_Key] {
            fHotkey := Func("fAntiRepeat").Bind(A_Loop)
            Hotkey, ~%A_key%, %fHotkey%
        }  
        fHotkey := ""
    }

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
        for A_Loop, A_key in ["Saryn", "Mirage", "Cyte"] {
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

;;;;;;;;;; Function ;;;;;;;;;;
    fAntiRepeat(number) {
        global
        switch number {
            case 1: TimeStamp(StampKeyA)
            case 2: TimeStamp(StampKeyB)
            case 3: TimeStamp(StampKeyC)
            case 4: TimeStamp(StampKeyD)
            case 4: TimeStamp(StampKeyGelmint)
        }
    }

;;;;;;;;;; Scripts ;;;;;;;;;;
    Main() {
        global
        GuiInGame("Edit", "MainInterface", {"id" : "ScriptStatus_Gui", "Color" : "Lime", "Text" : "Enabled"})
        While GetKeyState(StartKey, "p") {
            switch RunningProfile {
                case "Saryn" : {
                    if (DurationOfSpores && (TimePassed(StampKeyA,, "sec") > DurationOfSpores)) {
                        TimeStamp(StampKeyA)
                        if !InversionOfSpores {
                            Send, {Blind}{%AbilityA_Key% Down}
                            lSleep(250)
                            Send, {Blind}{%AbilityA_Key% Up}
                        } else
                            Send, {Blind}{%AbilityA_Key%}
                        lSleep(SkillCastTime)
                    }
                    if (DurationOfToxicLash && (TimePassed(StampKeyC,, "sec") > DurationOfToxicLash)) {
                        TimeStamp(StampKeyC)
                        Send, {Blind}{%AbilityC_Key%}
                        lSleep(SkillCastTime)
                    }
                }
                case "Mirage" : {
                    if (DurationOfEclipse && (TimePassed(StampKeyC,, "sec") > DurationOfEclipse)) {
                        TimeStamp(StampKeyC)
                        Send, {Blind}{%AbilityC_Key%}
                        lSleep(SkillCastTime)
                    }
                    if applyHallOfMirrors
                        Send, {Blind}{%AbilityA_Key%}
                }
                case "Cyte" : {
                    if (DurationOfSeek && (TimePassed(StampKeyA,, "sec") > DurationOfSeek)) {
                        TimeStamp(StampKeyA)
                        Send, {Blind}{%AbilityA_Key%}
                        lSleep(SkillCastTime)
                    }
                    if (DurationOfResupply && (TimePassed(StampKeyB) > DurationOfResupply)) {
                        TimeStamp(StampKeyB)
                        Send, {Blind}{%AbilityB_Key%}
                    }
                }
            }
            if (GelmintAbilityTime && (TimePassed(StampKeyGelmint,, "sec") > GelmintAbilityTime)) {
                TimeStamp(StampKeyGelmint)
                if GelmintInversion {
                    lSleep(SkillCastTime)
                    Send, {Blind}{%GelmintAbility% Down}
                    lSleep(250)
                    Send, {Blind}{%GelmintAbility% Up}
                } Else {
                    Send, {Blind}{%GelmintAbility%}
                    lSleep(SkillCastTime)
                }
            }
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