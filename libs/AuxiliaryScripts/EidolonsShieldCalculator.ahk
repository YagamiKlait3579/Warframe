;;;;;;;;;; Loading ;;;;;;;;;;
#SingleInstance, Force
#Persistent
#NoEnv
;#NoTrayIcon
;--------------------------------------------------
#KeyHistory, 0
;#InstallKeybdHook
;#InstallMouseHook
;#UseHook
;--------------------------------------------------
#MaxHotkeysPerInterval, 9999999
#HotkeyInterval, 9999999
;--------------------------------------------------
#MaxThreads, 255
;#MaxThreadsPerHotkey, 255
;--------------------------------------------------
Process, Priority,, A
CoordMode, ToolTip, Screen
CoordMode, Pixel, Screen
ListLines Off
SendMode, Event ; Input
SetBatchLines -1
SetKeyDelay, -1, -1
SetMouseDelay, -1, -1
SetControlDelay -1
SetWinDelay -1

;;;;;;;;;; Run as Administrator ;;;;;;;;;;
    ; https://www.autohotkey.com/docs/v1/lib/Run.htm#RunAs
    full_command_line := DllCall("GetCommandLine", "str")
    if not (A_IsAdmin or RegExMatch(full_command_line, " /restart(?!\S)")) {
        try { ; leads to having the script re-launching itself as administrator
            if A_IsCompiled
                Run *RunAs "%A_ScriptFullPath%" /restart
            else
                Run *RunAs "%A_AhkPath%" /restart "%A_ScriptFullPath%"
        }
        ExitApp
    }
    full_command_line := ""

;;;;;;;;;; Include ;;;;;;;;;;
    #include %A_Scriptdir%\..\
    SetWorkingDir %A_ScriptDir%\..\
    
    #include %A_Scriptdir%\..\BaseLibs\WorkingWithFiles.ahk
    #include %A_Scriptdir%\..\AuxiliaryScripts\Gdip.ahk

;;;;;;;;;; Variables ;;;;;;;;;;
    global gScreen       := [Round(A_ScreenWidth), Round(A_ScreenHeight)]
    global gScreenCenter := [Round(A_ScreenWidth / 2), Round(A_ScreenHeight / 2)] 
    global gFontScaling  := Round(A_ScreenHeight / 1080, 2)
    global gDPI          := (96 / A_ScreenDPI) 
    global EidolonsShield := [28724.78, 40525.01, 52240.16]
    Propa := { "Damage"         : 9000
              ,"CritMultiplier" : 2
              ,"FireRate"       : 2}
    Raplak := { "Damage"         : 3000
               ,"CritMultiplier" : 2.6
               ,"FireRate"       : 2}

    CheckingFiles(,"Base_ICO", "EidolonsShieldCalculator.ini")
    LoadIniSection(FP_EidolonsShieldCalculator, "Eidolons Shield Calculator")

;;;;;;;;;; Tray Menu ;;;;;;;;;;
    Menu, Tray, Tip, Eidolons Shield Calculator
    Menu, Tray, icon, %FP_Base_ICO%,26, 1

    Menu, Tray, NoStandard
    Menu, Tray, Add, Discord, OpenDiscord
    Menu, Tray, icon, Discord, %FP_Base_ICO%,16

    Menu, Tray, Add, GitHub, OpenGitHub
    Menu, Tray, icon, GitHub, %FP_Base_ICO%,17

    Menu, Tray, Add
    Menu, Tray, Add, Reload, ReloadScript 
    Menu, Tray, icon, Reload, %FP_Base_ICO%,5

    Menu, Tray, Add, Stop (exit), StopScript 
    Menu, Tray, icon, Stop (exit), %FP_Base_ICO%,3

    Menu, Tray, Default, Stop (exit)

    OpenDiscord() { 
        Run, https://discord.gg/yrRfUMXAnk
    }

    OpenGitHub() {
        Run, https://github.com/YagamiKlait3579
    }

    ReloadScript() {
        Suspend, Permit
        Reload
    }

    StopScript() {
        Suspend, Permit
        ExitApp
    }

;;;;;;;;;; Gui ;;;;;;;;;;
    ; ❌✔️
    FontSize := Round((12 * gFontScaling) * gDPI)
    
    Gui, Calculator: +LastFound -DPIScale +Border -MinimizeBox +HwndCalculator
    Gui, Calculator: Color, 000000
    Gui, Calculator: Font, % " s"FontSize " q3", MS Sans Serif
    Gui, Calculator: Show, % " w"(A_ScreenWidth/2) " h"(A_ScreenWidth/2/16*9), Eidolons Shield Calculator
    WinGetPos, KI_X, KI_Y, KI_W, KI_H, ahk_id %Calculator%

    ;*** Raplak ***
        Gui, Calculator: Add, Text, % " x"KI_W*0.01 " y"KI_H*0.05 " w" KI_W*0.21 " +Center +Border cff7d19 hwndMainText vMainText", Raplak
        WinGetPos, MI_X, MI_Y, MI_W, MI_H, ahk_id %MainText%
        Gui, Calculator: Add, Text, xs y+ +BackgroundTrans
        Gui, Calculator: Add, Text, % " xs y+ w" MI_W/2 " +0x00000201 +Right cff7d19", Damage:
        Gui, Calculator: Add, Text, % " x+ w" MI_W/2 " +0x00000201 +Center  cFuchsia vF_RaplakDamage",` ------
        Gui, Calculator: Add, Text, % " xs y+ w" MI_W/2 " +0x00000201 +Right cff7d19", Crit:
        Gui, Calculator: Add, Text, % " x+ w" MI_W/2 " +0x00000201 +Center  cFuchsia vF_RaplakCrit",` ------
        Gui, Calculator: Add, Text, % " xs y+ w" MI_W/2 " +0x00000201 +Right cff7d19", Crit x2:
        Gui, Calculator: Add, Text, % " x+ w" MI_W/2 " +0x00000201 +Center  cFuchsia vF_RaplakDoubleCrit",` ------
        Gui, Calculator: Add, Text, xs y+ +BackgroundTrans
        Gui, Calculator: Add, Text, xs y+ +BackgroundTrans
        Gui, Calculator: Font, w1000
        Gui, Calculator: Add, Text, % " xs y+ w" MI_W " +Border +Center cFuchsia", Raplak damage check `n(not water shield)
        Gui, Calculator: Font, wNorm
        Gui, Calculator: Add, Text, % " xs y+ w" MI_W/2 " +0x00000201 +Right cAqua", Teralyst:
        Gui, Calculator: Add, Text, % " x+ w" MI_W/2 " +0x00000201 +Center  cff7d19 vCD_Raplak1",` ------
        Gui, Calculator: Add, Text, % " xs y+ w" MI_W/2 " +0x00000201 +Right cc80000", Gantulyst:
        Gui, Calculator: Add, Text, % " x+ w" MI_W/2 " +0x00000201 +Center  cff7d19 vCD_Raplak2",` ------
        Gui, Calculator: Add, Text, % " xs y+ w" MI_W/2 " +0x00000201 +Right cGreen", Hydrolyst:
        Gui, Calculator: Add, Text, % " x+ w" MI_W/2 " +0x00000201 +Center  cff7d19 vCD_Raplak3",` ------

    ;*** Propa ***
        Gui, Calculator: Add, Text, % " x"(KI_W*0.01)+MI_W " ys +BackgroundTrans"
        Gui, Calculator: Add, Text, % " x+m ys w" KI_W*0.21 " +Center +Border cff7d19 +Section", Propa
        Gui, Calculator: Add, Text, xp y+ +BackgroundTrans
        Gui, Calculator: Add, Text, % " xs y+ w" MI_W/2 " +0x00000201 +Right cff7d19", Damage:
        Gui, Calculator: Add, Text, % " x+ w" MI_W/2 " +0x00000201 +Center  cFuchsia vF_PropaDamage",` ------
        Gui, Calculator: Add, Text, % " xs y+ w" MI_W/2 " +0x00000201 +Right cff7d19", Crit:
        Gui, Calculator: Add, Text, % " x+ w" MI_W/2 " +0x00000201 +Center  cFuchsia vF_PropaCrit",` ------
        Gui, Calculator: Add, Text, % " xs y+ w" MI_W/2 " +0x00000201 +Right cff7d19", Crit x2:
        Gui, Calculator: Add, Text, % " x+ w" MI_W/2 " +0x00000201 +Center  cFuchsia vF_PropaDoubleCrit",` ------
        Gui, Calculator: Add, Text, xs y+ +BackgroundTrans
        Gui, Calculator: Add, Text, xs y+ +BackgroundTrans
        Gui, Calculator: Font, w1000
        Gui, Calculator: Add, Text, % " xs y+ w" MI_W " +Border +Center cFuchsia", Propa damage check `n(not water shield)
        Gui, Calculator: Font, wNorm
        Gui, Calculator: Add, Text, % " xs y+ w" MI_W/2 " +0x00000201 +Right cAqua", Teralyst:
        Gui, Calculator: Add, Text, % " x+ w" MI_W/2 " +0x00000201 +Center  cff7d19 vCD_Propa1",` ------
        Gui, Calculator: Add, Text, % " xs y+ w" MI_W/2 " +0x00000201 +Right cc80000", Gantulyst:
        Gui, Calculator: Add, Text, % " x+ w" MI_W/2 " +0x00000201 +Center  cff7d19 vCD_Propa2",` ------
        Gui, Calculator: Add, Text, % " xs y+ w" MI_W/2 " +0x00000201 +Right cGreen", Hydrolyst:
        Gui, Calculator: Add, Text, % " x+ w" MI_W/2 " +0x00000201 +Center  cff7d19 vCD_Propa3",` ------

    ;*** Eidolons shield ***
        Gui, Calculator: Add, Text, % " x"KI_W*0.01 " y"KI_H*0.75 " w" MI_W/2 " +BackgroundTrans +Section"
        Gui, Calculator: Add, Text, % " x+ w" MI_W/1.5 " +0x00000201 +Center +Border c007dff", Water shield
        Gui, Calculator: Add, Text, % " x+ w" MI_W/1.5 " +0x00000201 +Center +Border c007dff", Next shield
        ;--------------------------------------------------
        Gui, Calculator: Add, Text, % " xs y+ w" MI_W/2 " +0x00000201 +Right cAqua", Teralyst:
        Gui, Calculator: Add, Text, % " x+ w" MI_W/1.5 " +0x00000201 +Center cAqua", % Round(Round(EidolonsShield.1) / 1000, 3)
        Gui, Calculator: Add, Text, % " x+ w" MI_W/1.5 " +0x00000201 +Center cAqua", % Round(Round(EidolonsShield.1 / 2) / 1000, 3)
        ;--------------------------------------------------
        Gui, Calculator: Add, Text, % " xs y+ w" MI_W/2 " +0x00000201 +Right cc80000", Gantulyst:
        Gui, Calculator: Add, Text, % " x+ w" MI_W/1.5 " +0x00000201 +Center cc80000", % Round(Round(EidolonsShield.2) / 1000, 3)
        Gui, Calculator: Add, Text, % " x+ w" MI_W/1.5 " +0x00000201 +Center cc80000", % Round(Round(EidolonsShield.2 / 2) / 1000, 3)
        ;--------------------------------------------------
        Gui, Calculator: Add, Text, % " xs y+ w" MI_W/2 " +0x00000201 +Right cGreen", Hydrolyst:
        Gui, Calculator: Add, Text, % " x+ w" MI_W/1.5 " +0x00000201 +Center cGreen", % Round(Round(EidolonsShield.3) / 1000, 3)
        Gui, Calculator: Add, Text, % " x+ w" MI_W/1.5 " +0x00000201 +Center cGreen", % Round(Round(EidolonsShield.3 / 2) / 1000, 3)
        
    ;*** Modifiers ***
        Gui, Calculator: Add, Text, % " x"KI_W*0.775 " y"KI_H*0.05 " w" MI_W " +BackgroundTrans +Section"
        Gui, Calculator: Font, w1000
        Gui, Calculator: Add, Text, % " xs ys w" MI_W " +0x00000201 +Center +Border cFuchsia", Crit boost `n
        Gui, Calculator: Font, wNorm
        Gui, Calculator: Add, Text, % " xs y+m w"MI_W*0.05
        Gui, Calculator: Add, Checkbox, % " x+ w"MI_W*0.15 " Checked" CB_VoltShield " vCB_VoltShield gUpdate"
        Gui, Calculator: Add, Text, % " x+ w" MI_W-(MI_W*0.20) " +0x00000201 +Left cff7d19", Volt shield
        Gui, Calculator: Add, Text, % " xs y+ w"MI_W*0.05
        Gui, Calculator: Add, Checkbox, % " x+ w"MI_W*0.15 " Checked" CB_MaduraiBoostCrit " vCB_MaduraiBoostCrit gUpdate" 
        Gui, Calculator: Add, Text, % " x+ w" MI_W-(MI_W*0.20) " +0x00000201 +Left cff7d19", Madurai boost crit
        ;--------------------------------------------------
        Gui, Calculator: Add, Text, xs y+m +BackgroundTrans
        Gui, Calculator: Font, w1000
        Gui, Calculator: Add, Text, % " xs y+m w" MI_W " +0x00000201 +Center +Border cFuchsia", Damage boost `n
        Gui, Calculator: Font, wNorm
        Gui, Calculator: Add, Text, % " xs y+m w"MI_W*0.05
        Gui, Calculator: Add, Checkbox, % " x+ w"MI_W*0.15 " Checked" CB_EternalEradicate " vCB_EternalEradicate gUpdate" 
        Gui, Calculator: Add, Text, % " x+ w" MI_W-(MI_W*0.20) " +0x00000201 +Left cff7d19", Eternal eradicate
        Gui, Calculator: Add, Text, % " xs y+ w"MI_W*0.05
        Gui, Calculator: Add, Checkbox, % " x+ w"MI_W*0.15 " Checked" CB_Bless " vCB_Bless gUpdate" 
        Gui, Calculator: Add, Text, % " x+ w" MI_W-(MI_W*0.20) " +0x00000201 +Left cff7d19", Bless
        Gui, Calculator: Add, Text, % " xs y+ w"MI_W*0.05
        Gui, Calculator: Add, Checkbox, % " x+ w"MI_W*0.15 " Checked" CB_MaduraiPassive " vCB_MaduraiPassive gUpdate" 
        Gui, Calculator: Add, Text, % " x+ w" MI_W-(MI_W*0.20) " +0x00000201 +Left cff7d19", Madurai passive
        Gui, Calculator: Add, Text, % " xs y+ w"MI_W*0.05
        Gui, Calculator: Add, Checkbox, % " x+ w"MI_W*0.15 " Checked" CB_DuviriPassive " vCB_DuviriPassive gUpdate" 
        Gui, Calculator: Add, Text, % " x+ w" MI_W-(MI_W*0.20) " +0x00000201 +Left cff7d19", Duviri passive
        Gui, Calculator: Add, Text, % " xs y+ w"MI_W*0.05
        Gui, Calculator: Add, Checkbox, % " x+ w"MI_W*0.15 " Checked" CB_Unairu " vCB_Unairu gUpdate" 
        Gui, Calculator: Add, Text, % " x+ w" MI_W-(MI_W*0.20) " +0x00000201 +Left cff7d19", Unairu
        Gui, Calculator: Add, Text, % " xs y+ w"MI_W*0.05
        Gui, Calculator: Add, Checkbox, % " x+ w"MI_W*0.15 " Checked" CB_MaduraiFirstAbility " vCB_MaduraiFirstAbility gUpdate" 
        Gui, Calculator: Add, Text, % " x+ w" MI_W-(MI_W*0.20) " +0x00000201 +Left cff7d19", Madurai first ability
        Gui, Calculator: Add, Text, % " xs y+ w"MI_W*0.05
        Gui, Calculator: Add, Checkbox, % " x+ w"MI_W*0.15 " Checked" CB_MaduraiSecondAbility " vCB_MaduraiSecondAbility gUpdate" 
        Gui, Calculator: Add, Text, % " x+ w" MI_W-(MI_W*0.20) " +0x00000201 +Left cff7d19", Madurai second ability
        Gui, Calculator: Add, Text, % " xs y+ w"MI_W*0.05 "+Section"
        Gui, Calculator: Add, Checkbox, % " x+ w"MI_W*0.15 " Checked" CB_Jade " vCB_Jade gUpdate" 
        Gui, Calculator: Add, Text, % " x+ w" MI_W-(MI_W*0.60) " +0x00000201 +Left cff7d19", Jade
        Gui, Calculator: Add, Edit, % " x+ w" MI_W-(MI_W*0.60) " h"MI_H " -TabStop +Number +Center Limit4 vE_Jade gUpdate", %E_Jade%

    ;*** Links ***
        Gui, Calculator: Add, Picture, % "xs y"KI_H*0.7 " w"MI_W " h-1 +Border +BackgroundTrans gOpenDiscord", % "HBITMAP:" ReadImages(CheckingFiles(,"Base_Images.dll"), "DiscordLogo")
        Gui, Calculator: Add, Picture, % "xs y+m w"MI_W " h-1 +Border +BackgroundTrans gOpenGitHub", % "HBITMAP:" ReadImages(CheckingFiles(,"Base_Images.dll"), "GitHubLogo")

    ;*** Background ***
        Gui, Calculator: Margin, 0, 0
        Gui, Calculator: Add, Picture, % "x0 y0 w"(A_ScreenWidth/2) " h-1", % "HBITMAP:" ReadImages(CheckingFiles(,"Warframe_Images.dll"), "EidolonsShieldCalculator")

;;;;;;;;;; Start ;;;;;;;;;;
    OnExit("ExitCalculator")
    Update()
Return

;;;;;;;;;; Eidolons Shield Calculator ;;;;;;;;;;
    Update() {
        global
        local A_Loop, A_key, A_Propa, A_Raplak
        Gui, Submit, NoHide
        A_Propa := DamageCalculation(Propa)
        for A_Loop, A_key in ["Damage", "Crit", "DoubleCrit"] 
            GuiControl, Calculator: Text, % "F_Propa" A_key, % (A_Propa[A_key] > 1000 ? Round(A_Propa[A_key] / 1000, 3) : A_Propa[A_key])
        for A_Loop, A_key in EidolonsShield {
            GuiControl, Calculator: Text, % "CD_Propa" A_Loop, % ((A_Propa.Crit > Round(A_key / 2)) ? "✔" : ((A_Propa.DoubleCrit > Round(A_key / 2)) ? "50/50" : "❌"))
            GuiControl, % "Calculator: +c" ((A_Propa.Crit > Round(A_key / 2)) ? "Lime" : ((A_Propa.DoubleCrit > Round(A_key / 2)) ? "Yellow" : "Red")) " +Redraw", % "CD_Propa" A_Loop
        }
        A_Raplak := DamageCalculation(Raplak)
        for A_Loop, A_key in ["Damage", "Crit", "DoubleCrit"] 
            GuiControl, Calculator: Text, % "F_Raplak" A_key, % (A_Raplak[A_key] > 1000 ? Round(A_Raplak[A_key] / 1000, 3) : A_Raplak[A_key])
        for A_Loop, A_key in EidolonsShield {
            GuiControl, Calculator: Text, % "CD_Raplak" A_Loop, % ((A_Raplak.Crit > Round(A_key / 2)) ? "✔" : ((A_Raplak.DoubleCrit > Round(A_key / 2)) ? "50/50" : "❌"))
            GuiControl, % "Calculator: +c" ((A_Raplak.Crit > Round(A_key / 2)) ? "Lime" : ((A_Raplak.DoubleCrit > Round(A_key / 2)) ? "Yellow" : "Red")) " +Redraw", % "CD_Raplak" A_Loop
        }
    }

    DamageCalculation(properties) {
        global
        local Damage, Crit, DoubleCrit
        Damage := properties.Damage
        ;*** Base modifiers ***
        if CB_EternalEradicate      ; Eternal Eradicate (Вечное Искоренение) +60%
            Damage += properties.Damage * 0.60
        if CB_MaduraiPassive        ; Madurai passive (Пассивное усиление школы Мадурай) +30%
            Damage += properties.Damage * 0.30
        if CB_DuviriPassive         ; Duviri passive (Пассивное усиление модуляров Дувири) +25%
            Damage += properties.Damage * 0.25
        if CB_Unairu                ; Unairu (Баф огонька школы Унайру) +100%
            Damage += properties.Damage * 1.00
        if CB_MaduraiFirstAbility   ; Madurai first ability (Усиление первой способности школы Мадурай) +1000%
            Damage += properties.Damage * 10.00
        if CB_Jade                  ; Jade ability (Усиление способностью варфрейма Джейд) ???
            Damage += properties.Damage * (E_Jade * 0.01)
        ;*** Multiplicative modifiers ***
        if CB_Bless                 ; Bless (Усиление урона реле) 25%
            Damage += Damage * 0.25
        if CB_MaduraiSecondAbility  ; Madurai second ability (Усиление второй способности школы Мадурай) 50%
            Damage += Damage * 0.50
        ;*** Critical modifiers ***
        Crit := Damage * (2 * properties.CritMultiplier) ; Passive eidolon bonus (Пассивный множитель крита эйдолонов)
        if CB_MaduraiBoostCrit
            Crit *= 2               ; Madurai boost crit (Усиление крит урона школы Мадурай) 100%
        if CB_VoltShield
            Crit *= 2               ; Volt shield (Усиление крит урона от щита вольта) 100%
        ;*** Final calculations ***
        Damage := Round((Damage * 0.04) + (108 / properties.FireRate))
        Crit := Round((Crit * 0.04) + (108 / properties.FireRate))
        DoubleCrit := Crit * 2      ; Double crit damage (Урон двойного крита)
        Return {"Damage" : Damage, "Crit" : Crit, "DoubleCrit" : DoubleCrit}
    }

;;;;;;;;;; Exit ;;;;;;;;;;
    CalculatorGuiClose:
        ExitApp
    Return

    ExitCalculator() {
        global
        local A_Checkbox := ["CB_VoltShield", "CB_MaduraiBoostCrit", "CB_EternalEradicate"
                            , "CB_Bless", "CB_MaduraiPassive", "CB_DuviriPassive", "CB_Unairu"
                            , "CB_MaduraiFirstAbility", "CB_MaduraiSecondAbility", "CB_Jade", "E_Jade"]
        for A_Loop, A_key in A_Checkbox {
            StringReplace, B_Key, %A_key%, ""
            IniWrite, %B_Key% , %FP_EidolonsShieldCalculator%, Eidolons Shield Calculator, %A_key%
        }      
    }