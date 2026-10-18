;;;;;;;;;; Loading ;;;;;;;;;;
    #include %A_Scriptdir%\libs\CoreLibsFor_AHK\BaseLibs\Header.ahk
    ;--------------------------------------------------
    #IfWinActive, Warframe
    global PWN := "Warframe" ; Program window name
    CheckForUpdates("YagamiKlait3579", "Warframe", "main", CheckingFiles("File", False, "Header.ahk"))
    OnExit("BeforeExiting")

;;;;;;;;;; Info ;;;;;;;;;;
    /*
        Макрос для автоматизации бросков Глефы в Warframe. 

        При удержании стандартной клавиши StartKey, указанной в Settings.ahk,
        макрос циклически выполняет бросок Глефы и её подрыв в полёте.

        Задержку между действиями можно настроить с помощью клавиш
        IncreaseKey и DecreaseKey. Для изменения задержки удерживайте
        клавишу EditTimeKey и нажимайте соответствующую клавишу увеличения
        или уменьшения. Текущее значение отображается в интерфейсе макроса.

        Общие настройки проекта находятся в Settings.ahk. Если какая-либо настройка
        указана одновременно здесь и в Settings.ahk, настройка этого макроса имеет
        приоритет.

        Также присутствуют общие дополнительные функции для всех макросов проекта.
        Подробнее об их функционале вы можете прочитать на GitHub проекта.
    */
    
;;;;;;;;;; Setting ;;;;;;;;;;
    EditTimeKey     = ALt   ; Изменяет время клавишами IncreaseKey и DecreaseKey при удержании этой клавиши
    TimeStep       := 50    ; Шаг изменение времени

;;;;;;;;;; Variables ;;;;;;;;;;
    if !CheckingFiles("File", True, "SavedSettings.ini")
        FileAppend, , % A_WorkingDir . "\libs\SavedSettings.ini"
    LoadIniSection(CheckingFiles("File", True, "SavedSettings.ini"), SubStr(A_ScriptName, 1, InStr(A_ScriptName, ".", , -1) - 1))
    ;--------------------------------------------------
    gPause := gPause ? gPause : 750

;;;;;;;;;; Hotkeys ;;;;;;;;;;
    Hotkey, *%StartKey%, Main

    fHotkey := Func("TimeManagement").Bind("Increase", TimeStep)
    Hotkey, *%IncreaseKey%, %fHotkey%
    fHotkey := Func("TimeManagement").Bind("Decrease", TimeStep)
    Hotkey, *%DecreaseKey%, %fHotkey%
    fHotkey := ""

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
    Main() {
        global 
        GuiInGame("Edit", "MainInterface", {"id" : "ScriptStatus_Gui", "Color" : "Lime", "Text" : "Enabled"})
        While GetKeyState(StartKey, "p") {
            SendInput, {Blind}{%MeleeKey% down}
            lSleep(450)
            SendInput, {Blind}{%MeleeKey% up}
            lSleep(gPause)
            SendInput, {Blind}{%AltFireKey%}
            lSleep(gPause - 450)
        }
        GuiInGame("Edit", "MainInterface", {"id" : "ScriptStatus_Gui", "Color" : "Red", "Text" : "Disabled"})
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
                if (gPause + 1 > 1000)
                    Return
                gPause += param2
            }
            case "Decrease", "Subtract", "-": {
                if !GetKeyState(EditTimeKey, "p") {
                    Send, {Blind}{%DecreaseKey%}
                    Return
                }
                if (gPause - 1 < 250)
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