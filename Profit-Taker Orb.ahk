;;;;;;;;;; Loading ;;;;;;;;;;
    #include %A_Scriptdir%\libs\CoreLibsFor_AHK\BaseLibs\Header.ahk
    ;--------------------------------------------------
    #IfWinActive, Warframe
    global PWN := "Warframe" ; Program window name
    CheckForUpdates("YagamiKlait3579", "Warframe", "main", CheckingFiles("File", False, "Header.ahk"))

;;;;;;;;;; Info ;;;;;;;;;;
    /*
        Макрос для упрощения фарма босса «Сфера извлечения прибыли».

        При удержании стандартной клавиши StartKey, указанной в Settings.ahk,
        макрос автоматически чередует броски Зо с мистификатором «Заражение эксодии»
        и выстрелы из выбранного оружия. Это позволяет выполнять повторяющуюся
        последовательность атак без необходимости вручную переключаться между
        ними.

        Общие настройки проекта находятся в Settings.ahk. Если какая-либо настройка
        указана одновременно здесь и в Settings.ahk, настройка этого макроса имеет
        приоритет.

        Также присутствуют общие дополнительные функции для всех макросов проекта.
        Подробнее об их функционале вы можете прочитать на GitHub проекта.
    */

;;;;;;;;;; Setting ;;;;;;;;;;
    Exodia_ThrowingTime := 50      ; Время броска
    Exodia_LandingTime  := 450     ; Время приземления (оно же время стрельбы с оружия)

;;;;;;;;;; Variables ;;;;;;;;;;

;;;;;;;;;; Hotkeys ;;;;;;;;;;
    Hotkey, *%StartKey%, ClassicExodia

;;;;;;;;;; Gui ;;;;;;;;;;
    PlaceForTheText := " Disabled "
    ;--------------------------------------------------
    UpdateDGP({"Transparency" : gTransparency, "Blur" : gBlur, "Scale" : gInterfaceScale})
    GuiInGame("Start", "MainInterface")
        Gui, MainInterface: Add, Text, xm ym +Center, % SubStr(A_ScriptName, 1, InStr(A_ScriptName, ".", , -1) - 1)
        Gui, MainInterface: Add, Text, x+m +Center +Border cRed +Section vScriptStatus_Gui, %PlaceForTheText%
        GuiControl, MainInterface: Text, ScriptStatus_Gui, Disabled
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
    ClassicExodia() {
        global
        local A_Stamp, B_Stamp
        GuiInGame("Edit", "MainInterface", {"id" : "ScriptStatus_Gui", "Color" : "Lime", "Text" : "Enabled"})
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
        GuiInGame("Edit", "MainInterface", {"id" : "ScriptStatus_Gui", "Color" : "Red", "Text" : "Disabled"})
    }