;;;;;;;;;; Hotkeys ;;;;;;;;;;
    Hotkey, *%SwitchingMacrosKey%, SwitchingMacros

;;;;;;;;;; Functions ;;;;;;;;;;
    SwitchingMacros() {
        local ahkFiles := []
        Loop, Files, % A_ScriptDir "\*.ahk"
        {
            if (A_LoopFileName = "Settings.ahk")
                continue
            ahkFiles.Push(A_LoopFileName)
        }
        local longestName := ""
        local A_Loop, A_key
        for A_Loop, A_key in ahkFiles
            if (StrLen(A_key) > StrLen(longestName))
                longestName := A_key
        ;--------------------------------------------------
        local FontSize := Round(((15 * gFontScaling) * gDPI) * (0.01 * gInterfaceScale))
        local Margin   := [Round(FontSize * 1.25), Round(FontSize * 0.75)]
        Gui, SwitchingMacros: +AlwaysOnTop +LastFound -DPIScale +Border -MinimizeBox +HwndSwitchingMacros
        Gui, SwitchingMacros: Color, 101010
        Gui, SwitchingMacros: Margin, % Margin.1, % Margin.2
        Gui, SwitchingMacros: Font, % " s"FontSize " q3", MS Sans Serif
        ;--------------------------------------------------
        local funcObj
        for A_Loop, A_key in ahkFiles {
            Gui, SwitchingMacros: Add, Text, % " xm y+m ce16419 +Center +Border +HwndSwitchingMacros" A_Loop " vSM_B"A_Loop, %longestName%
            GuiControl, SwitchingMacros: Text, SM_B%A_Loop%, % SubStr(A_key, 1, InStr(A_key, ".", , -1) - 1)
            funcObj := Func("Run_SwitchingMacros").Bind(A_key)
            GuiControl SwitchingMacros: +g, SM_B%A_Loop%, %FuncObj%
        }
        WinGetPos, SM_X, SM_Y, SM_W, SM_H, ahk_id %SwitchingMacros1%
        allWidth  := SM_W + (Margin.1 * 2)
        allHeight := ((SM_H + Margin.2) * ahkFiles.Length()) + Margin.2
        ;--------------------------------------------------
        Gui, SwitchingMacros: Show, , Switching Macros
        if (((allWidth / 16) * 9) > allHeight)
            Gui, SwitchingMacros: Add, Picture, % "x0 y0 w" allWidth " h-1", % "HBITMAP:" ReadImages(CheckingFiles("File", False, "Warframe_Images.dll"), "SwitchingMacros")
        else
            Gui, SwitchingMacros: Add, Picture, % "x0 y0 w-1 h" allHeight, % "HBITMAP:" ReadImages(CheckingFiles("File", False, "Warframe_Images.dll"), "SwitchingMacros")
    }

    Run_SwitchingMacros(Name) {
        Run, % """" ProgramSearch("AutoHotkey 1") """ """ A_ScriptDir "\" Name """"
        ExitApp
    }

;;;;;;;;;; Exit ;;;;;;;;;;
    SwitchingMacrosGuiClose() {
        Gui, SwitchingMacros: Destroy
    }