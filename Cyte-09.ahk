;;;;;;;;;; Loading ;;;;;;;;;;
    #include %A_Scriptdir%\libs\CoreLibsFor_AHK\BaseLibs\Header.ahk
    ;--------------------------------------------------
    #IfWinActive, Warframe
    global PWN := "Warframe" ; Program window name
    CheckForUpdates("YagamiKlait3579", "Warframe", "main", CheckingFiles("File", False, "Header.ahk"))
    OnExit("BeforeExiting")
    Ammo_ColorList := []

;;;;;;;;;; Info ;;;;;;;;;;
    /*
        Макрос для автоматизации способностей Cyte-09.

        Макрос автоматически применяет первую и четвертую способности при
        нахождении в Варфрейме, если соответствующие способности доступны.
        При удержании кнопки стрельбы макрос также автоматически применяет
        вторую способность, когда выбранная стихия боеприпасов не обнаружена
        на экране. Это позволяет обновлять боеприпасы выбранной стихии по мере
        необходимости, не прерывая стрельбу вручную.

        Для выбора контролируемой стихии используйте клавиши IncreaseKey
        и DecreaseKey из файла Settings.ahk, удерживая клавишу EditStatusKey.
        Текущая выбранная стихия отображается в интерфейсе макроса.
        Доступны десять вариантов: Heat, Cold, Electricity, Toxin, Blast,
        Radiation, Gas, Magnetic, Viral и Corrosive. Вариант SPAM отключает
        проверку стихии и позволяет постоянно применять вторую способность
        при удержании кнопки стрельбы.

        Макрос проверяет состояние Варфрейма и доступность способностей
        по цветам определённых областей экрана. Поэтому координаты и цвета
        триггеров в настройках необходимо адаптировать под своё разрешение
        экрана и интерфейс игры.

        Макрос активируется и отключается клавишей StartKey, указанной
        в файле Settings.ahk. 

        Основные настройки находятся в секции Setting данного файла.
        Также существуют общие настройки в файле Settings.ahk. Если какая-либо
        настройка указана одновременно здесь и в Settings.ahk, значение из этого
        макроса имеет приоритет.

        Также присутствуют общие дополнительные функции для всех макросов проекта.
        Подробнее об их функционале вы можете прочитать на странице GitHub проекта.
    */
    
;;;;;;;;;; Setting ;;;;;;;;;;
    SkillCastTime   := 1000     ; Время применения одной способности (ms) 
    EditStatusKey    = Alt      ; Переключение проверяемой стихии клавишами IncreaseKey и DecreaseKey при удержании этой клавиши
    DebugGuiKey      =          ; Показыть\Скрыть зоны триггеров для отладки
    ; Operator
    Operator_Coords  := [1867, 935, 1890, 955]    ; Координаты триггера оператора
    Operator_Color   := "dcdddd"                  ; Цвет триггера (цвет в HEX формате)
    Operator_AColor  := 30                        ; Отклонения от оригинала цвета (от 0 до 255)
    ; First ability
    FirstA_Coords    := [1650, 997, 1670, 1010]   ; Координаты триггера первой способности
    FirstA_Color     := "5ad205"                  ; Цвет триггера (цвет в HEX формате)
    FirstA_AColor    := 10                        ; Отклонения от оригинала цвета (от 0 до 255)
    ; Fourth ability
    FourthA_Coords   := [1785, 1005, 1805, 1015]  ; Координаты триггера четвертой способности
    FourthA_Color    := "5ad205"                  ; Цвет триггера (цвет в HEX формате)
    FourthA_AColor   := 10                        ; Отклонения от оригинала цвета (от 0 до 255)
    ; Ammo
    Ammo_Coords      := [1770, 930, 1790, 945]    ; Координаты триггера стихии патронов
    ; Массив списка стихий [Имя в GUI, цвет в HEX формате, Отклонения от оригинала цвета]           
    Ammo_ColorList[1] := ["Heat"        , "d25d02", 50]
    Ammo_ColorList[2] := ["Cold"        , "4472d1", 50]
    Ammo_ColorList[3] := ["Electricity" , "8863b4", 50]
    Ammo_ColorList[4] := ["Toxin"       , "549c45", 50]
    Ammo_ColorList[5] := ["Blast"       , "9f7371", 50]
    Ammo_ColorList[6] := ["Radiation"   , "d8b401", 50]
    Ammo_ColorList[7] := ["Gas"         , "5dc5a3", 50]
    Ammo_ColorList[8] := ["Magnetic"    , "979a97", 50]
    Ammo_ColorList[9] := ["Viral"       , "da89bb", 50]
    Ammo_ColorList[10]:= ["Corrosive"   , "bac601", 50]

;;;;;;;;;; Variables ;;;;;;;;;;
    Ammo_ColorList.InsertAt(1, ["SPAM", "Fuchsia"])
    ;--------------------------------------------------
    if !CheckingFiles("File", True, "SavedSettings.ini")
        FileAppend, , % A_WorkingDir . "\libs\SavedSettings.ini"
    LoadIniSection(CheckingFiles("File", True, "SavedSettings.ini"), SubStr(A_ScriptName, 1, InStr(A_ScriptName, ".", , -1) - 1))
    ;--------------------------------------------------
    global SelectedStatus := SelectedStatus > Ammo_ColorList.Count() ? 1 : (SelectedStatus ? SelectedStatus : 1)
    global A_ScriptStatus := 0

;;;;;;;;;; Hotkeys ;;;;;;;;;;
    Hotkey, *%StartKey%, StartStop
    Hotkey, *%DebugGuiKey%, TestAllGui

    fHotkey := Func("StatusSwitching").Bind("Increase")
    Hotkey, *%IncreaseKey%, %fHotkey%
    fHotkey := Func("StatusSwitching").Bind("Decrease")
    Hotkey, *%DecreaseKey%, %fHotkey%
    fHotkey := ""

;;;;;;;;;; Gui ;;;;;;;;;;
    PlaceForTheText := "   Electricity   "
    ;--------------------------------------------------
    UpdateDGP({"Transparency" : gTransparency, "Blur" : gBlur, "Scale" : gInterfaceScale})
    GuiInGame("Start", "MainInterface")
        Gui, MainInterface: Add, Text, xm ym +Center, % SubStr(A_ScriptName, 1, InStr(A_ScriptName, ".", , -1) - 1)
        Gui, MainInterface: Add, Text, x+m +Center +Border cRed +Section vScriptStatus_Gui,` Disabled `
        Gui, MainInterface: Add, Text, x+m +Center +Border cFu +Section vSelectedStatus_Gui, %PlaceForTheText%
        GuiInGame("Edit", "MainInterface", {"id" : "SelectedStatus_Gui", "Color" : Ammo_ColorList[SelectedStatus].2, "Text" : Ammo_ColorList[SelectedStatus].1})
    GuiInGame("End", "MainInterface", {"ratio" : [GuiPositionX,GuiPositionY]})
    fSuspendGui("On", "MainInterface")
    if DebugGui
        fDebugGui("Create", MainInterface)
    if HideTheInterface
        SetTimer, ShowHideGui , 250, -1
Return

;;;;;;;;;; Function ;;;;;;;;;;
    StartStop() {
        A_ScriptStatus := !A_ScriptStatus
        if A_ScriptStatus {
            GuiInGame("Edit", "MainInterface", {"id" : "ScriptStatus_Gui", "Color" : "Lime", "Text" : "Enabled"})
            SetTimer, Main, -1
        } Else
            GuiInGame("Edit", "MainInterface", {"id" : "ScriptStatus_Gui", "Color" : "Red", "Text" : "Disabled"})
    }
    
    fPixelSearch(Coords, Color, A_Clolor, repeat = 1) {
        loop, %repeat% {
            PixelSearch,,, Coords[1], Coords[2], Coords[3], Coords[4], "0x"Color, A_Clolor, Fast RGB
            if !ErrorLevel
                Return True
        }
        Return False
    }

    StatusSwitching(param1) {
        global
        switch param1 {
            case "Increase", "Add", "+": {
                if !GetKeyState(EditStatusKey, "p") {
                    Send, {Blind}{%IncreaseKey%}
                    Return
                }
                SelectedStatus := SelectedStatus + 1 > Ammo_ColorList.Count() ? 1 : SelectedStatus + 1
            }
            case "Decrease", "Subtract", "-": {
                if !GetKeyState(EditStatusKey, "p") {
                    Send, {Blind}{%DecreaseKey%}
                    Return
                }
                SelectedStatus := SelectedStatus - 1 < 1 ? Ammo_ColorList.Count() : SelectedStatus - 1
            }
        }
        GuiInGame("Edit", "MainInterface", {"id" : "SelectedStatus_Gui", "Color" : Ammo_ColorList[SelectedStatus].2, "Text" : Ammo_ColorList[SelectedStatus].1})
    }

    TestAllGui() {
        global
        static B_Gui
        B_Gui := !B_Gui
        if B_Gui {
            fBorder("FirstAbility" , {"Coords" : FirstA_Coords  , "Color" : "Yellow", "Size" : 2})
            fBorder("FourthAbility", {"Coords" : FourthA_Coords , "Color" : "Yellow", "Size" : 2})
            fBorder("Operator"     , {"Coords" : Operator_Coords, "Color" : "Yellow", "Size" : 2})
            fBorder("Ammo"         , {"Coords" : Ammo_Coords    , "Color" : "Yellow", "Size" : 2})
        } Else {
            fBorder("FirstAbility","Destroy")
            fBorder("FourthAbility","Destroy")
            fBorder("Operator","Destroy")
            fBorder("Ammo","Destroy")
        }
    }

;;;;;;;;;; Scripts ;;;;;;;;;;
    Main() {
        global
        local Stamp_A
        While A_ScriptStatus {
            TimeStamp(Stamp_A)
            if fPixelSearch(Operator_Coords, Operator_Color, Operator_AColor) {
                if fPixelSearch(FirstA_Coords, FirstA_Color, FirstA_AColor) {
                    Sleep, 250
                    Send, {Blind}{%AbilityA_Key%}
                    Sleep, SkillCastTime
                }
                if fPixelSearch(FourthA_Coords, FourthA_Color, FourthA_AColor) {
                    Sleep, 250
                    Send, {Blind}{%AbilityD_Key%}
                    Sleep, SkillCastTime
                }
                if GetKeyState("LButton", "p") && ((SelectedStatus = 1) || !fPixelSearch(Ammo_Coords, Ammo_ColorList[SelectedStatus].2, Ammo_ColorList[SelectedStatus].3)) {
                    Send, {Blind}{%AbilityB_Key%}
                }
                fDebugGui("Edit", "Warframe", TimePassed(Stamp_A))
            } Else {
                fDebugGui("Edit", "Operator", TimePassed(Stamp_A))
            }
        }
    }

;;;;;;;;;; Exit ;;;;;;;;;;
    BeforeExiting() {
        global
        IniWrite, %SelectedStatus%, %OP_SavedSettings%, % SubStr(A_ScriptName, 1, InStr(A_ScriptName, ".", , -1) - 1), SelectedStatus
    }