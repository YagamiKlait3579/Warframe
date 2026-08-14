;;;;;;;;;; Loading ;;;;;;;;;;
    #include %A_Scriptdir%\libs\CoreLibsFor_AHK\BaseLibs\Header.ahk
    ;--------------------------------------------------
    #IfWinActive, Warframe
    global PWN := "Warframe" ; Program window name
    CheckForUpdates("YagamiKlait3579", "Warframe", "main", CheckingFiles("File", False, "Header.ahk"))
    OnExit("BeforeExiting")

;;;;;;;;;; Info ;;;;;;;;;;
    /*
        Макрос для соло-фарма ресурсов в Warframe.
    
        Обычно используется вместе с Некросом, у которого вместо одной из
        способностей установлена способность Мэг «Притяжение» с аугментом,
        позволяющим собирать ресурсы. В качестве оружия обычно используется Окукор.
        Игрок занимает удобную позицию, например тупик, куда стягиваются враги, 
        после чего макрос автоматически удерживает основную атаку и периодически 
        применяет «Притяжение». Благодаря этому можно длительное время фармить 
        в одной точке, пока урона оружия достаточно для убийства появляющихся врагов.
    
        Интервал между применениями способности можно изменять прямо во время
        работы макроса. Для этого удерживайте EditTimeKey и используйте
        IncreaseKey / DecreaseKey. Текущее значение интервала отображается
        в интерфейсе макроса.
    
        Макрос активируется стандартной клавишей StartKey, указанной в файле
        Settings.ahk.
    
        Также присутствуют общие дополнительные функции для всех макросов проекта.
        Подробнее об их функционале вы можете прочитать на GitHub проекта.
    */

;;;;;;;;;; Setting ;;;;;;;;;;
    EditTimeKey      = ALt   ; Изменяет время клавишами IncreaseKey и DecreaseKey при удержании этой клавиши
    MagKey          := 4     ; Клавиша с способностью "Притяжение" от Мэг

;;;;;;;;;; Variables ;;;;;;;;;;
    if !CheckingFiles("File", True, "SavedSettings.ini")
        FileAppend, , % A_WorkingDir . "\libs\SavedSettings.ini"
    LoadIniSection(CheckingFiles("File", True, "SavedSettings.ini"), SubStr(A_ScriptName, 1, InStr(A_ScriptName, ".", , -1) - 1))
    ;--------------------------------------------------
    gPause := gPause ? gPause : 100
    global A_ScriptStatus := 0
    AbilityList := [AbilityA_Key, AbilityB_Key, AbilityC_Key, AbilityD_Key]

;;;;;;;;;; Hotkeys ;;;;;;;;;;
    Hotkey, *%StartKey%, StartStop

    fHotkey := Func("TimeManagement").Bind("Increase", 50)
    Hotkey, *%IncreaseKey%, %fHotkey%
    fHotkey := Func("TimeManagement").Bind("Decrease", 50)
    Hotkey, *%DecreaseKey%, %fHotkey%

;;;;;;;;;; Gui ;;;;;;;;;;
    PlaceForTheText := " Ширина самого длинного текста "
    ;--------------------------------------------------
    UpdateDGP({"Transparency" : gTransparency, "Blur" : gBlur, "Scale" : gInterfaceScale})
    GuiInGame("Start", "MainInterface")
        Gui, MainInterface: Add, Text, xm ym +Center, % SubStr(A_ScriptName, 1, InStr(A_ScriptName, ".", , -1) - 1)
        Gui, MainInterface: Add, Text, x+m +Center +Border cRed +Section vScriptStatus_Gui,` Disabled `
        Gui, MainInterface: Add, Text, x+m +Center +Border cFuchsia vT1, 99999
        GuiControl, MainInterface: Text, T1, % gPause
    GuiInGame("End", "MainInterface", {"ratio" : [GuiPositionX,GuiPositionY]})
    fSuspendGui("On", "MainInterface")
    if DebugGui
        fDebugGui("Create", MainInterface)
    if HideTheInterface
        SetTimer, ShowHideGui , 250, -1
Return

;;;;;;;;;; Scripts ;;;;;;;;;;
    StartStop() {
        global
        A_ScriptStatus := !A_ScriptStatus
        if A_ScriptStatus {
            SetTimer, Main, -1
            GuiInGame("Edit", "MainInterface", {"id" : "ScriptStatus_Gui", "Color" : "Lime", "Text" : "Enabled"})
        } else
            GuiInGame("Edit", "MainInterface", {"id" : "ScriptStatus_Gui", "Color" : "Red", "Text" : "Disabled"})
    }

    Main() {
        global
        local A_Key := AbilityList[MagKey]
        Send, {Blind}{%PrimFireKey%}
        lSleep(50)
        Send, {Blind}{%PrimFireKey% Down}
        While A_ScriptStatus {
            Send, {Blind}{%A_Key%}
            lSleep(gPause)
        }
        Send, {Blind}{%PrimFireKey% Up}
    }

;;;;;;;;;; Time management ;;;;;;;;;;
    TimeManagement(param1, param2 = 1) {
        global
        switch param1 {
            case "Increase", "Add", "+": {
                if !GetKeyState(EditTimeKey, "p") {
                    Send, {Blind}{%IncreaseKey%}
                    Return
                }
                if (gPause + 1 > 10000)
                    Return
                gPause += param2
            }
            case "Decrease", "Subtract", "-": {
                if !GetKeyState(EditTimeKey, "p") {
                    Send, {Blind}{%DecreaseKey%}
                    Return
                }
                if (gPause - 1 < 0)
                    Return
                gPause -= param2
            }
        }
        GuiControl, MainInterface: Text, T1, % gPause
    }

;;;;;;;;;; Exit ;;;;;;;;;;
    BeforeExiting() {
        global
        IniWrite, %gPause%, %OP_SavedSettings%, % SubStr(A_ScriptName, 1, InStr(A_ScriptName, ".", , -1) - 1), gPause
    }