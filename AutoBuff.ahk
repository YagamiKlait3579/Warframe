;;;;;;;;;; Loading ;;;;;;;;;;
    #include %A_Scriptdir%\libs\CoreLibsFor_AHK\BaseLibs\Header.ahk
    ;--------------------------------------------------
    #IfWinActive, Warframe
    global PWN := "Warframe" ; Program window name
    CheckForUpdates("YagamiKlait3579", "Warframe", "main", CheckingFiles("File", False, "Header.ahk"))
    OnExit("BeforeExiting")

;;;;;;;;;; Info ;;;;;;;;;;
    /*
        Макрос для быстрого бафа команды в начале миссий Арбитраж.
        Автоматически выполняет необходимую последовательность действий для выбранного
        персонажа, чтобы игроку не приходилось вручную выполнять все действия перед
        началом миссии.

        Поддерживаются следующие варианты:
          • Wisp  — полный набор действий для раздачи бафов Wisp.
          • Jade (min)  — минимальный вариант бафа Jade.
          • Jade (full) — полный вариант последовательности бафов Jade.
          • Nidus — автоматическая последовательность подготовки и раздачи бафа Nidus.

        Нужный вариант выбирается непосредственно во время игры. Удерживая EditStatusKey
        и нажимая IncreaseKey или DecreaseKey, можно переключаться между доступными
        методами. Текущий выбранный вариант отображается в интерфейсе макроса.

        После выбора метода нажмите стандартную клавишу StartKey, указанную в
        Settings.ahk — макрос автоматически выполнит соответствующую последовательность
        действий. После завершения камера возвращается примерно в исходное положение.

        Важно понимать, что я не занимаюсь Арбитражем профессионально и отвечал
        в этом проекте преимущественно за техническую часть автоматизации.
        Последовательность действий и варианты бафов основаны на инструкциях
        и рекомендациях игроков с дружественного сервера Queen Anne’s Revenge.
    
        На сервере Queen Anne’s Revenge можно найти дополнительную информацию
        по Арбитражу, билды персонажей и другие полезные материалы от игроков,
        на основе которых создавался и тестировался данный макрос:
        https://discord.gg/34jRFd5V4w

        Также часть общих настроек берётся из Settings.ahk. Если одна и та же настройка
        присутствует и в этом макросе, и в Settings.ahk, настройка из этого макроса
        имеет приоритет.

        Также присутствуют общие дополнительные функции для всех макросов проекта.
        Подробнее об их функционале вы можете прочитать на GitHub проекта.
    */

;;;;;;;;;; Setting ;;;;;;;;;;
    cameraReturn  := 500    ; Величина возврата камеры после выполнения бафа.
    EditStatusKey  = Alt    ; Переключение метода ударов клавишами IncreaseKey и DecreaseKey при удержании этой клавиши

;;;;;;;;;; Variables ;;;;;;;;;;
    if !CheckingFiles("File", True, "SavedSettings.ini")
        FileAppend, , % A_WorkingDir . "\libs\SavedSettings.ini"
    LoadIniSection(CheckingFiles("File", True, "SavedSettings.ini"), SubStr(A_ScriptName, 1, InStr(A_ScriptName, ".", , -1) - 1))
    ;--------------------------------------------------
    FunctionList := ["Wisp","JadeMin", "JadeFull", "Nidus"]
    global gFunctions := {}
    Loop, % FunctionList.Count()
        gFunctions.InsertAt(A_Index, Func(FunctionList[A_Index]))
    global A_Function := A_Function ? A_Function : 1

;;;;;;;;;; Hotkeys ;;;;;;;;;;
    Hotkey, *%StartKey%, Main

    for A_Loop, A_key in [DecreaseKey, IncreaseKey] {
        fHotkey := Func("SwitchFunctions").Bind(A_Loop)
        Hotkey, %EditStatusKey% & %A_key%, %fHotkey%
    } 
    fHotkey := ""

;;;;;;;;;; Gui ;;;;;;;;;;
    PlaceForTheText := " Wisp Wisp Wisp "
    ;--------------------------------------------------
    UpdateDGP({"Transparency" : gTransparency, "Blur" : gBlur, "Scale" : gInterfaceScale})
    GuiInGame("Start", "MainInterface")
        Gui, MainInterface: Add, Text, xm ym +Center, % SubStr(A_ScriptName, 1, InStr(A_ScriptName, ".", , -1) - 1)
        Gui, MainInterface: Add, Text, x+m +Center +Border cYellow vMethod_Gui, %PlaceForTheText%
        SwitchFunctions()
    GuiInGame("End", "MainInterface", {"ratio" : [GuiPositionX,GuiPositionY]})
    fSuspendGui("On", "MainInterface")
    if DebugGui
        fDebugGui("Create", MainInterface)
    if HideTheInterface
        SetTimer, ShowHideGui , 250, -1
Return

;;;;;;;;;; Function ;;;;;;;;;;
    Main() {
        global
        gFunctions[A_Function].call()
    }

    SwitchFunctions(param = "") {
        global
        switch param {
            case 1 : A_Function := A_Function + 1 > FunctionList.Count() ? 1 : A_Function += 1
            case 2 : A_Function := A_Function - 1 < 1 ? FunctionList.Count() : A_Function -= 1
            Default : 
        }
        switch A_Function {
            case 1 : GuiControl, MainInterface: Text, Method_Gui, Wisp
            case 2 : GuiControl, MainInterface: Text, Method_Gui, Jade (min)
            case 3 : GuiControl, MainInterface: Text, Method_Gui, Jade (full)
            case 4 : GuiControl, MainInterface: Text, Method_Gui, Nidus
        }
    }

    upPowerAbilities(param = "Full") {
        global
        Send, {Blind}{%OperatorKey%}
        lSleep(200)
        TimeStamp(AbilityB)
        switch param {
            case "Full" :
                Send, {Blind}{%AbilityB_Key%}
                lSleep(20)
                        Send, {Blind}{%CrouchKey% Down}
                        lSleep(20)
                        Loop, 3 {
                            Send, {Blind}{%JumpKey%}
                            lSleep(100)
                        }
                Send, {Blind}{%CrouchKey% Up}
            case "Min" : Send, {Blind}{%AbilityB_Key%}
        }
        lSleep(400, AbilityB)
        Send, {Blind}{%MeleeKey%}
    }

;;;;;;;;;; Scripts ;;;;;;;;;;
    Wisp() {
        global
        TimeStamp(AutoBuff_Start)
        Loop, 4 
            fMoveMouse(0, -gscreen[2]), fSleep(1)
        Send, {Blind}{%MeleeKey%}
        lSleep(100)
        upPowerAbilities()
        lSleep(50)
        Send, {Blind}{%MeleeKey%}
        Send, {Blind}{%AbilityA_Key% Down}
        lSleep(400)
        Send, {Blind}{%AbilityA_Key% Up}
        lSleep(700)
        upPowerAbilities("Min")
        lSleep(100)
        Send, {Blind}{%AbilityA_Key% Down}
        lSleep(400)
        Send, {Blind}{%AbilityA_Key% Up}
        lSleep(700)
        upPowerAbilities("Min")
        lSleep(100)
        Send, {Blind}{%AbilityA_Key%}
        lSleep(400)
        Send, {Blind}{%AbilityA_Key% Down}
        lSleep(400)
        Send, {Blind}{%AbilityA_Key% Up}
        fMoveMouse(0, cameraReturn)
        fDebugGui("Edit", "Auto Buff", TimePassed(AutoBuff_Start) " ms") 
    }

    JadeMin() {
        global
        TimeStamp(AutoBuff_Start)
        Loop, 4 
            fMoveMouse(0, -gscreen[2]), fSleep(1)
        Send, {Blind}{%MeleeKey%}
        lSleep(100)
        upPowerAbilities()
        lSleep(50)
        Send, {Blind}{%AbilityB_Key% Down}
        lSleep(400)
        Send, {Blind}{%AbilityB_Key% Up}
        fMoveMouse(0, cameraReturn)
        fDebugGui("Edit", "Auto Buff", TimePassed(AutoBuff_Start) " ms") 
    }

    JadeFull() {
        global
        TimeStamp(AutoBuff_Start)
        Loop, 4 
            fMoveMouse(0, -gscreen[2]), fSleep(1)
        Send, {Blind}{%MeleeKey%}
        lSleep(100)
        upPowerAbilities()
        lSleep(50)
        Send, {Blind}{%AbilityB_Key%}
        lSleep(400)
        Send, {Blind}{%AbilityB_Key% Down}
        lSleep(400)
        Send, {Blind}{%AbilityB_Key% Up}
        lSleep(700)
        upPowerAbilities("Min")
        lSleep(100)
        Send, {Blind}{%AbilityD_Key%}
        fMoveMouse(0, cameraReturn)
        fDebugGui("Edit", "Auto Buff", TimePassed(AutoBuff_Start) " ms") 
    }

    Nidus() {
        global
        TimeStamp(AutoBuff_Start)
        Send, {Blind}{%AbilityD_Key%}
        lSleep(1000)
        fMoveMouse(-cameraReturn/3, 0)
        lSleep(500)
        Send, {Blind}{%AbilityD_Key%}
        lSleep(1500)
        Send, {Blind}{%ZoomKey%}
        fSleep(2)
        Send, {Blind}{%ArchGunKey%}{%OperatorKey%}
        fSleep(4,135)
        Send, {Blind}{%MeleeKey%}
        fSleep(2,40)
        Send, {Blind}{%OperatorKey%}
        fSleep(4,135)
        Send, {Blind}{%MeleeKey%}
        lSleep(500)
        Loop, 10 {
            Send, {Blind}{%PrimFireKey%}
            lSleep(100)
        }
        lSleep(100)
        Loop, 4 
            fMoveMouse(0, -gscreen[2]), fSleep(1)
        lSleep(100)
        upPowerAbilities()
        lSleep(100)
        fMoveMouse(0, cameraReturn)
        fDebugGui("Edit", "Auto Buff", TimePassed(AutoBuff_Start) " ms") 
    }

;;;;;;;;;; Exit ;;;;;;;;;;
    BeforeExiting() {
        global
        IniWrite, %A_Function%, %OP_SavedSettings%, % SubStr(A_ScriptName, 1, InStr(A_ScriptName, ".", , -1) - 1), A_Function
    }