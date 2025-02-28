;;;;;;;;;; Loading ;;;;;;;;;;
    #include %A_Scriptdir%\libs\BaseLibs\Header.ahk
    #IfWinActive, Warframe
    global PWN := "Warframe" ; Program window name
    OnExit("BeforeExiting")

;;;;;;;;;; Setting ;;;;;;;;;;
    ;;;;; Nidus ;;;;;
    SwitchNidusKey     = Up        ; Переключить скрипт на Нидуса
    Minimap_Coords    := [30,130,140,190]   ; Координаты поиска противников на мини-карте
    Enemies_Color     := "c80406"  ; Цвет противников на мини-карте (цвет в HEX формате)
    Enemies_A_Color   := 10        ; Отклонения от оригинала цвета (от 0 до 255)
    ;;;;; Nekros ;;;;;
    CutsceneTime      := 5100      ; Ожидание старта миссий (время заставки) (ms.)
    SwitchLeftKey      = Left      ; Переключить скрипт на прыжок в левую сторону
    SwitchRightKey     = Right     ; Переключить скрипт на прыжок в правую сторону
    AutoRepeat_Flag   := True      ; Авто повтор скрипта (True — включено, False — выключено)
    EndMission_Flag   := True      ; Авто сбор лута по окончанию миссии (True — включено, False — выключено)
    EndMission_Time   := 5100      ; Время на сбор лута
    ;;;;; Test ;;;;;
    TestNekrosStartKey = Numpad1   ; Тест прыжка в начале миссии
    TestNekrosEndKey   = Numpad2   ; Тест прыжка в конце миссии
    TestNidusKey       = Numpad3   ; Тест действий Нидуса
    ;;;;; Find Text ;;;;;
    EAR_A_FindText    := 0.20                  ; Разброс точности текста для библиотеки Find Text
    Text_Coords       := [820,150,1100,210]    ; Координаты текста о статусе миссии
    Text_Start1       := "|<>*122$78.zzzzzzzzzzzzzU1zzzzzzzzzzzU0TzzzzzzzzzzU0DzzzzzzzzzzXwDzzzzzzzzzzXy7zzzzzzzzzzXz7zzzzzzzzzzXz7s7VyCDXy07Xz7k3lwCDXy07Xz7U1lwSDXy07Xz7XlkwSDXy77XyDbsssSDXy77U0DzsssyDXy77U0TzsssyDXy77U1zs0wMy03yD7XzzU0wEy03yD7Xzz3swFy03yD7Xzz7sy1yDXwD7XzzDsy1yDXwD7Xzz7ky3yDXwD7Xzz00y3yDXk01Xzz08z3yDXU01XzzUMz7yDXU01zzzzzz7zzzXzlzzzzzz7zzzXzlzzzzzyDzzzXzlzzzzzwDzzzXzlzzzzzkDzzzXzlzzzzzkTzzzXzlzzzzzlzzzzzzzzzzzzzzzzzzzzU"
    Text_Start2       := ""
    Text_End          := "|<>*138$112.zzzzzzzzzzzzzzzzzzz00Dy3zU0T00zU0TwTwM00zU3y01w03y01zkzlU03w07s07k0Ds07y3z6DyDkwDXzz7zzVwTsDwMzsyDsSDzwTzy7lzUzlXzXszlszzlzzsz7w1z6DyDXz7Xzz7zzXwTl7wMzsyTwSDzwTzyDlz4TlXzXtzls0zlzzsz7wMz6DyDbzbU0z03zXwTXXwMzswTwS01w07yDlyCDlXzXlzlsz3k0zsz7ssT6DyD7zbXyD7zzXwT7lwMzsyTySDwQTzwDlwT7lXzXtzlszllzzkz7k0T7DyDXz7Xz77zz7wS00zszsyDwSDwQTzwTls03znzXszlszllzzlz7XyDzDyDVyDXyD7zyDwSDsTwzsz00y00w03U00kzltXzXy07s07k0A0017z77DyDw1zU0z00k004TwATzzzzzzzzzzz7zwTzzzzzzzzzzzzzzwTzlzzzzzzzzzzzzzzzlzz7zzzzzzzzzzzzzzz7zwTzzzzzzzzzzzzzzwTzlzzzzzzzzzzzzzzzlzzDzzzzzzzzzzzzzzzzzzzzzzU"

;;;;;;;;;; Variables ;;;;;;;;;;
    ; EAR = Endo AutoRun
    CheckingFiles(,"SavedSettings.ini")
    LoadIniSection(FP_SavedSettings, "Endo AutoRun")
    global A_ScriptStatus := 0
    global EAR_Method := EAR_Method ? EAR_Method : "Left"
    
;;;;;;;;;; Hotkeys ;;;;;;;;;;
    Hotkey, *%StartKey%, BaseScript

    fHotkey := Func("Nidus").Bind("Test")
    Hotkey, *%TestNidusKey%, %fHotkey%

    fHotkey := Func("TestJump").Bind("Start")
    Hotkey, *%TestNekrosStartKey%, %fHotkey%
    fHotkey := Func("TestJump").Bind("End")
    Hotkey, *%TestNekrosEndKey%, %fHotkey%

    fHotkey := Func("SwitchMethod").Bind("Nidus")
    Hotkey, *%SwitchNidusKey% , %fHotkey%
    fHotkey := Func("SwitchMethod").Bind("Left")
    Hotkey, *%SwitchLeftKey% , %fHotkey%
    fHotkey := Func("SwitchMethod").Bind("Right")
    Hotkey, *%SwitchRightKey% , %fHotkey%
    fHotkey := ""

;;;;;;;;;; Gui ;;;;;;;;;;
    PlaceForTheText := " Right ==> "
    ;--------------------------------------------------
    UpdateDGP({"Transparency" : gTransparency, "Blur" : gBlur, "Scale" : gInterfaceScale})
    GuiInGame("Start", "MainInterface")
        Gui, MainInterface: Add, Text, xm ym +Right,` Endo AutoRun:
        Gui, MainInterface: Add, Text, x+m +Center +Border cRed vScriptStatus_Gui,` Disabled `
        Gui, MainInterface: Add, Text, x+ +Center +Border cFuchsia vTime_Gui, %PlaceForTheText%
        GuiControl, MainInterface: Text, Time_Gui, %EAR_Method%
    GuiInGame("End", "MainInterface", {"ratio" : [GuiPositionX,GuiPositionY]})
    fSuspendGui("On", "MainInterface")
    if DebugGui
        fDebugGui("Create", MainInterface)
    if HideTheInterface
        SetTimer, ShowHideGui , 250, -1
    Return

;;;;;;;;;; Functions ;;;;;;;;;;
    BaseScript() {
        global
        if !A_ScriptStatus {
            A_ScriptStatus := !A_ScriptStatus
            SetTimer, EndoAutoRun, -1
            GuiControl, MainInterface: Text, ScriptStatus_Gui, Enabled
            GuiControl, MainInterface: +cLime +Redraw , ScriptStatus_Gui
        } else 
            Reload
    }

    SwitchMethod(key = "") {
        global
        switch key {
            case "Nidus" : EAR_Method := "Nidus"
            case "Left"  : EAR_Method := "Left"
            case "Right" : EAR_Method := "Right"
            Default : EAR_Method := "Left" ? "Right" : "Left"
        }
        GuiControl, MainInterface: Text, Time_Gui, %EAR_Method%
    }

    TestJump(param) {
        global
        BlockInput, On
        switch param {
            case "Start" : Nekros_Start(EAR_Method)
            case "End"   : Nekros_End(EAR_Method)
        }
        BlockInput, Off
    }

;;;;;;;;;; Scripts ;;;;;;;;;;
    EndoAutoRun() {
        global
        local A_Start
        switch EAR_Method {
            case "Nidus" : {
                fBorder("Minimap", {"Coords" : Minimap_Coords, "Color" : "Yellow", "Size" : 2})
                Loop
                    Nidus()
            }
            case "Left", "Right" : {
                fBorder("MissionStatus", {"Coords" : Text_Coords, "Color" : "Yellow", "Size" : 2})
                Loop, {
                    if FindText(,, Text_Coords[1], Text_Coords[2], Text_Coords[3], Text_Coords[4], EAR_A_FindText, EAR_A_FindText, Text_Start1) {
                        TimeStamp(A_Start)
                        BlockInput, On
                        lSleep(CutsceneTime)
                        Nekros_Start(EAR_Method)
                        BlockInput, Off
                        if (!AutoRepeat_Flag && !EndMission_Flag) {
                            fBorder("MissionStatus","Destroy")
                            Break
                        }
                    }
                    if EndMission_Flag { 
                        if FindText(,, Text_Coords[1], Text_Coords[2], Text_Coords[3], Text_Coords[4], EAR_A_FindText, EAR_A_FindText, Text_End) {
                            BlockInput, On
                            Nekros_End(EAR_Method)
                            BlockInput, Off
                            fDebugGui("Edit", "Mission time", Round(TimePassed(A_Start,, "sec")) " sec.")
                            if !AutoRepeat_Flag {
                                fBorder("MissionStatus","Destroy")
                                Break
                            }
                        }
                    }
                }
            }
        }
        GuiControl, MainInterface: Text, ScriptStatus_Gui, Disabled
        GuiControl, MainInterface: +cRed +Redraw , ScriptStatus_Gui
    }

;;;;;;;;;; Nidus ;;;;;;;;;;
    Nidus(param = "") {
        global
            if (param != "Test")
                Loop 
                    PixelSearch,,, Minimap_Coords[1], Minimap_Coords[2], Minimap_Coords[3], Minimap_Coords[4], "0x"Enemies_Color, Enemies_A_Color, Fast RGB
                Until !ErrorLevel
                fBorder("Minimap", {"EditColor" : "Lime"})
                fMoveMouse(-2800, -100) ; Поворот камеры в сторону броска первой личинки (x,y)
                lSleep(2000) ; Ждем появления всех противников (ms.)
                Send, {Blind}{%AbilityB_Key%}
                lSleep(500) ; Время через которое остановить личинку (ms.)
                Send, {Blind}{%AbilityB_Key%}
                lSleep(1000) ; Время через которое подорвать личинку (ms.)
                Send, {Blind}{%AbilityB_Key%}
                lSleep(1000) ; Ждем исчезновения первой личинки (ms.)
                Loop, 3
                    fMoveMouse(0, -gscreen[2]), lSleep(10)
                Send, {Blind}{%AbilityB_Key%}
                lSleep(1500) ; Время через которое подорвать личинку (ms.)
                Send, {Blind}{%AbilityB_Key%}
                fMoveMouse(2800, 1900) ; Поворот камеры в стартовую позицию (x,y)
                fBorder("Minimap", {"EditColor" : "Yellow"})
    }

;;;;;;;;;; Nekros ;;;;;;;;;;
    Nekros_Start(param) {
        global
        local A_Start
        TimeStamp(A_Start)
        switch param {
            case "Left"  : { ; ПРЫЖОК В ЛЕВУЮ ПОЗИЦИЮ
                fMoveMouse(-1700, -50) ; Поворачиваем камеру в сторону двери (x,y)
                lSleep(20)
                Send, {Blind}{%CrouchKey% Down}
                lSleep(20)
                Send, {Blind}{%JumpKey%}{%CrouchKey% Up}{%AbilityC_Key%}
                lSleep(20)
                fMoveMouse(1050, 0) ; Поворот камеры в сторону стены, для выравнивания своей позиции (x,y)
                lSleep(1500) ; Ждем приземления после первого прыжка и окончания применения способности некроса (ms.)
                Send, {Blind}{%CrouchKey% Down}
                lSleep(20)
                Send, {Blind}{%JumpKey%}{%CrouchKey% Up}
                lSleep(1750) ; Ждем приземления после второго прыжка (ms.)
                Loop, 3
                    fMoveMouse(0, -gscreen[2]), lSleep(10)
                ;--------------------------------------------------
                ; Обходим столб
                Send, {Blind}{%ShiftKey% Down}{%sKey% Down}
                lSleep(400) ; Время ходьбы назад (ms.)
                Send, {Blind}{%sKey% Up}{%dKey% Down}
                lSleep(650) ; Время ходьбы в право (ms.)
                Send, {Blind}{%dKey% Up}{%wKey% Down}
                lSleep(400) ; Время ходьбы в перед (ms.)
                Send, {Blind}{%wKey% Up}{%ShiftKey% Up}
                ;--------------------------------------------------
                lSleep(20)
                Send, {Blind}{%OperatorKey%}
                fMoveMouse(3900, 2200)  ; Поворот камеры в сторону прыжка оператора (x,y)
                lSleep(170)
                Send, {Blind}{%CrouchKey% Down}
                lSleep(20)
                Send, {Blind}{%JumpKey% Down}
                lSleep(500) ; Время заряда прыжка оператора (влияет на дальность его прыжка) (ms.)
                Send, {Blind}{%JumpKey% Up}
                lSleep(250) ; Время остановки прыжка оператора в нужной позиции (ms.)
                Send, {Blind}{%PrimFireKey%}{%CrouchKey% Up}
                lSleep(20)
                fMoveMouse(-1680, -65) ; Поворот камеры в конечную точку  (x,y)
                fDebugGui("Edit", "Running time", TimePassed(A_Start) " ms.")
            }
            case "Right" : { ; ПРЫЖОК В ПРАВУЮ ПОЗИЦИЮ
                fMoveMouse(300, 150) ; Поворачиваем камеру для обхода столба в некоторых позициях спавна (x,y)
                lSleep(20)
                Send, {Blind}{%CrouchKey% Down}
                lSleep(20)
                Send, {Blind}{%JumpKey%}{%CrouchKey% Up}{%AbilityC_Key%}
                lSleep(1500) ; Ждем окончания применения способности некроса (ms.)
                Send, {Blind}{%ShiftKey%}
                lSleep(1000) ; Ждем приземления и выравнивание своей позиции об стену (ms.)
                ;--------------------------------------------------
                ; Обходим столб
                Send, {Blind}{%aKey% Down}
                lSleep(800) ; Время ходьбы в лево (ms.)
                Send, {Blind}{%aKey% Up}{%wKey% Down}
                lSleep(800) ; Время ходьбы в перед (ms.)
                Send, {Blind}{%wKey% Up}
                ;--------------------------------------------------
                fMoveMouse(900, 100) ; Поворот камеры в сторону прыжка (x,y)
                lSleep(20)
                Send, {Blind}{%CrouchKey% Down}
                lSleep(20)
                Send, {Blind}{%JumpKey%}{%CrouchKey% Up}
                lSleep(750) ; Время до включения планирования (ms.)
                Send, {Blind}{%ZoomKey% Down}
                lSleep(500) ; Время до отключения планирования (ms.)
                Send, {Blind}{%ZoomKey% Up}
                lSleep(750) ; Ждем приземления после прыжка (ms.)
                fMoveMouse(-1900, -200) ; Поворот камеры в сторону двери (после прыжка вы должны упереться в угол для выравнивания своей позиции) (x,y)
                lSleep(20)
                Send, {Blind}{%CrouchKey% Down}
                lSleep(20)
                Send, {Blind}{%JumpKey%}{%CrouchKey% Up}
                lSleep(700) ; Ждем приземления после прыжка (ms.)
                fMoveMouse(-400, 0) ; Поворот камеры для отступа назад (для соприкосновения триггера двух дверей) (x,y)
                lSleep(20)
                Send, {Blind}{%sKey% Down}
                lSleep(1200) ; Время ходьбы назад (ms.)
                Send, {Blind}{%sKey% Up}
                lSleep(20)
                Send, {Blind}{%OperatorKey%}
                fMoveMouse(-2920, 0) ; Поворот камеры в сторону прыжка оператора (x,y)
                lSleep(170)
                Send, {Blind}{%CrouchKey% Down}
                lSleep(20)
                Send, {Blind}{%JumpKey% Down}
                lSleep(500) ; Время заряда прыжка оператора (влияет на дальность его прыжка) (ms.)
                Send, {Blind}{%JumpKey% Up}
                lSleep(200) ; Время остановки прыжка оператора в нужной позиции (ms.)
                Send, {Blind}{%PrimFireKey%}{%CrouchKey% Up}
                lSleep(20)
                fMoveMouse(3660, 20) ; Поворот камеры в конечную точку  (x,y)
                fDebugGui("Edit", "Running time", TimePassed(A_Start) " ms.")
            }
        }
    }

    Nekros_End(param) {
        global
        local A_Start
        TimeStamp(A_Start)
        switch param {
            case "Left"  : { ; Сбор эндо из левой позиции
                fMoveMouse(-1250, -250) ; Поворот камеры в сторону двери (x,y)
                lSleep(20)
                Send, {Blind}{%CrouchKey% Down}
                lSleep(20)
                Send, {Blind}{%JumpKey%}
                lSleep(500) ; Ждем пока оператор не долетит до двери (ms.)
                fMoveMouse(250, 0) ; Поворот в сторону бочки (x,y)
                lSleep(20)
                Send, {Blind}{%JumpKey%}
                lSleep(500) ; Ждем пока оператор не долетит до бочки (ms.)
                fMoveMouse(-1150, 0) ; Поворот в сторону финальной точки (x,y)
                lSleep(20)
                Send, {Blind}{%JumpKey% Down}
                lSleep(250) ; Время заряда прыжка оператора (влияет на дальность его прыжка) (ms.)
                Send, {Blind}{%JumpKey% Up}
                lSleep(350) ; Время остановки прыжка оператора в нужной позиции (ms.)
                Send, {Blind}{%PrimFireKey%}{%CrouchKey% Up}
                lSleep(20)
                Send, {Blind}{%OperatorKey%}
                lSleep(170)
                fMoveMouse(0, -500) ; Опускаем камеру в сторону пола для сбора лута (x,y)
                lSleep(20)
            }
            case "Right" : { ; Сбор эндо из правой позиции
                fMoveMouse(-1700, -200) ; Поворот камеры в сторону двери (x,y)
                lSleep(20)
                Send, {Blind}{%CrouchKey% Down}
                lSleep(20)
                Send, {Blind}{%JumpKey%}
                lSleep(500) ; Ждем пока оператор не долетит до двери (ms.)
                fMoveMouse(50, 250) ; Поворот в сторону финальной точки (x,y)
                lSleep(20)
                Send, {Blind}{%JumpKey% Down}
                lSleep(500) ; Время заряда прыжка оператора (влияет на дальность его прыжка) (ms.)
                Send, {Blind}{%JumpKey% Up}
                lSleep(200) ; Время остановки прыжка оператора в нужной позиции (ms.)
                Send, {Blind}{%PrimFireKey%}{%CrouchKey% Up}
                lSleep(20)
                Send, {Blind}{%OperatorKey%}
                lSleep(170)
                fMoveMouse(0, -500) ; Опускаем камеру в сторону пола для сбора лута (x,y)
                lSleep(20)
            }
        }
        Loop, {
            fMoveMouse(500,0) ; Поворот камеры за 1 раз для сбора лута (x,y)
            lSleep(20)
            Send, {Blind}{%AbilityA_Key%}
            lSleep(100) ; Частота повторений первой способности и поворотов камеры для сбора лута (ms.)
        } until (TimePassed(A_Start ) > EndMission_Time)
    }

;;;;;;;;;; Exit ;;;;;;;;;;
    BeforeExiting() {
        global
        BlockInput, Off
        IniWrite, %EAR_Method%, %FP_SavedSettings%, Endo AutoRun, EAR_Method
    }