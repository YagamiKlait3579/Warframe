;;;;;;;;;; Loading ;;;;;;;;;;
    #include %A_Scriptdir%\libs\CoreLibsFor_AHK\BaseLibs\Header.ahk
    ;--------------------------------------------------
    #IfWinActive, Warframe
    global PWN := "Warframe" ; Program window name
    CheckForUpdates("YagamiKlait3579", "Warframe", "main", CheckingFiles("File", False, "Header.ahk"))

;;;;;;;;;; Info ;;;;;;;;;;
    /* 
        Макрос для Мисы, позволяющий использовать ультимейт во время движения 
        без необходимости полностью останавливаться на каждом использовании.

        Ультимейт управляется через StartKey: при зажатии клавиши макрос включает 
        ультимейт и удерживает его активным, а после отпускания — выключает. 
        Это позволяет удобно использовать ультимейт короткими перекастами во время 
        движения, например во время прыжка.

        Также присутствуют общие дополнительные функции для всех макросов проекта. 
        Подробнее об их функционале вы можете прочитать на GitHub проекта.
    */

;;;;;;;;;; Setting ;;;;;;;;;;
    SkillCastTime         := 300   ; Время применения одной способности (ms)
    
;;;;;;;;;; Variables ;;;;;;;;;;
    
;;;;;;;;;; Hotkeys ;;;;;;;;;;
    Hotkey, *%StartKey%, Main

;;;;;;;;;; Gui ;;;;;;;;;;
    PlaceForTheText := " Misa misa "
    ;--------------------------------------------------
    UpdateDGP({"Transparency" : gTransparency, "Blur" : gBlur, "Scale" : gInterfaceScale})
    GuiInGame("Start", "MainInterface")
        Gui, MainInterface: Add, Text, xm ym +Center vT1, %PlaceForTheText%
        GuiControl, MainInterface: Text, T1, % SubStr(A_ScriptName, 1, InStr(A_ScriptName, ".", , -1) - 1)
        Gui, MainInterface: Add, Text, x+m +Center +Border cRed +Section vScriptStatus_Gui,` Disabled `
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
        static A_Stamp := A_Stamp ? A_Stamp : 1
        GuiInGame("Edit", "MainInterface", {"id" : "ScriptStatus_Gui", "Color" : "Lime", "Text" : "Enabled"})
        lSleep(SkillCastTime, A_Stamp)
        Send, {Blind}{%AbilityD_Key%}
        lSleep(SkillCastTime)
        Send, {Blind}{%PrimFireKey% Down}
        While GetKeyState(StartKey, "p") {
            lSleep(1)
        }
        Send, {Blind}{%PrimFireKey% Up}
        Send, {Blind}{%AbilityD_Key%}
        TimeStamp(A_Stamp)
        GuiInGame("Edit", "MainInterface", {"id" : "ScriptStatus_Gui", "Color" : "Red", "Text" : "Disabled"})
    }