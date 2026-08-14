;;;;;;;;;; Loading ;;;;;;;;;;
    #include %A_Scriptdir%\libs\CoreLibsFor_AHK\BaseLibs\Header.ahk
    ;--------------------------------------------------
    #IfWinActive, Warframe
    global PWN := "Warframe" ; Program window name
    CheckForUpdates("YagamiKlait3579", "Warframe", "main", CheckingFiles("File", False, "Header.ahk"))

;;;;;;;;;; Info ;;;;;;;;;;
    /*
        Макрос для быстрого применения усилений Эквинокс в начале миссий низкого уровня
        (примерно 8–10 уровень) по открытию реликвий в Warframe.

        Макрос предназначен для коротких забегов, которые при использовании
        соответствующего билда Эквинокс занимают около 30–40 секунд. Он автоматически
        применяет все необходимые способности и усиления в начале миссии, избавляя
        от необходимости каждый раз выполнять эту последовательность вручную.

        При активации выполняется следующая последовательность:
        • усиление школы Мадурай;
        • 2 способность — "Потенцирование" (способность от Гельминта);
        • 3 способность Эквинокс;
        • 2 способность — "Потенцирование";
        • повторное усиление школы Мадурай;
        • 4 способность Эквинокс.

        Макрос рассчитан на Эквинокс с билдом, ориентированным преимущественно
        на радиус способностей. После выполнения последовательности можно сразу
        начинать прохождение миссии и бежать до эвакуации.

        Активация макроса выполняется на стандартную клавишу StartKey,
        указанную в файле Settings.ahk.

        Также присутствуют общие дополнительные функции для всех макросов проекта.
        Подробнее об их функционале вы можете прочитать на GitHub проекта.
    */

;;;;;;;;;; Setting ;;;;;;;;;;

;;;;;;;;;; Variables ;;;;;;;;;;

;;;;;;;;;; Hotkeys ;;;;;;;;;;
    Hotkey, *%StartKey%, Main

;;;;;;;;;; Gui ;;;;;;;;;;
    PlaceForTheText := " Ширина самого длинного текста "
    ;--------------------------------------------------
    UpdateDGP({"Transparency" : gTransparency, "Blur" : gBlur, "Scale" : gInterfaceScale})
    GuiInGame("Start", "MainInterface")
        Gui, MainInterface: Add, Text, xm ym +Center, % SubStr(A_ScriptName, 1, InStr(A_ScriptName, ".", , -1) - 1)
    GuiInGame("End", "MainInterface", {"ratio" : [GuiPositionX,GuiPositionY]})
    fSuspendGui("On", "MainInterface")
    if DebugGui
        fDebugGui("Create", MainInterface)
    if HideTheInterface
        SetTimer, ShowHideGui , 250, -1
Return

;;;;;;;;;; Scripts ;;;;;;;;;;
    Main:
        Madurai_AbilityBuff()
        lSleep(20)
        Send, {Blind}{%AbilityB_Key%}
        lSleep(750)
        Send, {Blind}{%AbilityC_Key%}
        lSleep(750)
        Send, {Blind}{%AbilityB_Key%}
        lSleep(750)
        Madurai_AbilityBuff()
        lSleep(20)
        Send, {Blind}{%AbilityD_Key%}
    Return




