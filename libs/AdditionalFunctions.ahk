;;;;;;;;;; Loading ;;;;;;;;;;
    #include %A_Scriptdir%\libs\Switching macros.ahk
    
;;;;;;;;;; Tray ;;;;;;;;;;
    Menu, Tray2, Add, Eidolons shield calculator, OpenEidolonsShieldCalculator
    Menu, Tray2, icon, Eidolons shield calculator, %OP_Base_ICO%, 26

;;;;;;;;;; Variables ;;;;;;;;;;
    global A_MagusAnomaly
    global gSkipArchGun_CountdownStamp

;;;;;;;;;; Hotkeys ;;;;;;;;;;
    Hotkey, *%mAbilityBuffKey%, Madurai_AbilityBuff
    Hotkey, *%EnergyDrainKey%, EnergyDrain
    Hotkey, *%MagusAnomalyKey%, MagusAnomaly
    Hotkey, *%CancelAnimationKey%, CancelAnimation
    Hotkey, *%SkipArchGunKey%, SkipArchGun
    Hotkey, *%DialogueSkipKey%, DialogueSkip
    ;--------------------------------------------------
    Hotkey, *%InputTestKey%, InputTest
    Hotkey, *%PixelSearchTestKey%, PixelSearchTest
    
    
;;;;;;;;;; Additional functions ;;;;;;;;;;
    Madurai_AbilityBuff() {
        global
        static A_Stamp := A_Stamp ? A_Stamp : 1
        Loop, 4 
            fMoveMouse(0, -gscreen[2]), fSleep(1)
        Send, {Blind}{%MeleeKey%}
        lSleep(100)
        Send, {Blind}{%OperatorKey%}
        lSleep(200)
        TimeStamp(AbilityB)
        Send, {Blind}{%AbilityB_Key%}
        if (WorldTimePassed(A_Stamp,, "sec") > 15) {
            WorldTimeStamp(A_Stamp)
            lSleep(50)
            Send, {Blind}{%CrouchKey% Down}
            lSleep(50)
            Loop, 3 {
                Send, {Blind}{%JumpKey%}
                lSleep(100)
            }
            Send, {Blind}{%CrouchKey% Up}
        }
        lSleep(400, AbilityB)
        Send, {Blind}{%MeleeKey%}
        lSleep(100)
        Send, {Blind}{%MeleeKey%}
        fSleep(2)
        Send, {Blind}{%EmoteAgreeKey%}
        fSleep(2)
        Send, {Blind}{%EmoteAgreeKey2%}
        fMoveMouse(0, cameraSTB)
    }

    EnergyDrain() {
        global
        if AddAbilityED1
            Send, {Blind}{%AbilityB_Key%}
        Send, {Blind}{%CrouchKey% Down}
        fSleep(1)
        if !MagusMeltED1
            loop, 21 {
                Send, {Blind}{%JumpKey%}{%PrimFireKey%}
                fSleep(1)
            }
        else 
            loop, 21 {
                Send, {Blind}{%JumpKey%}
                fSleep(2)
                Send, {Blind}{%PrimFireKey%}
                fSleep(2)
            }
        Send, {Blind}{%CrouchKey% Up}
        Send, {Blind}{%ToggleCrouchKey%}
    }

    MagusAnomaly() {
        global
        if MagusAnomalySpam
            A_MagusAnomaly := !A_MagusAnomaly 
        SetTimer, fMagusAnomaly, -1
    }

    fMagusAnomaly() {
        global
        While GetKeyState(MagusAnomalyKey, "p") || A_MagusAnomaly {
            Send, {Blind}{%OperatorKey%}
            lSleep(20) 
            Send, {Blind}{%OperatorKey%}
            lSleep(220)
            Send, {Blind}{%MeleeKey%}
            lSleep(50)
            Send, {Blind}{%EmoteAgreeKey%}
            lSleep(30)
            Send, {Blind}{%EmoteAgreeKey2%}
        }   
        Send, {Blind}{%MeleeKey%}
        lSleep(50)
        Send, {Blind}{%EmoteAgreeKey%}
        lSleep(30)
        Send, {Blind}{%EmoteAgreeKey2%}    
    }

    CancelAnimation() {
        global
        TimeStamp(CancelAnimation_Start)
        Send, {Blind}{%ZoomKey% Down}
        lSleep(100)
        Send, {Blind}{%ZoomKey% Up}
        Send, {Blind}{%EmoteHandshakeKey%}
        loop, 15 {
            Send, {Blind}{%OperatorKey%}
            lSleep(1)
        }
        Send, {Blind}{%sKey% Down}
        lSleep(400)
        Send, {Blind}{%sKey% Up}
        Send, {Blind}{%EmoteHandshakeKey%}
        lSleep(1200)
        loop, 15 {
            Send, {Blind}{%OperatorKey%}
            lSleep(1)
        }
        fDebugGui("Edit", "Cancel Animation", TimePassed(CancelAnimation_Start) " ms")
    }

    SkipArchGun(ShowGui = True) {
        global
        local A_Stamp
        TimeStamp(A_Stamp)
        Send, {Blind}{%ZoomKey%}
        fSleep(2)
        Send, {Blind}{%ArchGunKey%}{%OperatorKey%}
        fSleep(4,135)
        Send, {Blind}{%MeleeKey%}
        if RepairArchGun {
            fSleep(2,40)
            Send, {Blind}{%OperatorKey%}
            fSleep(4,135)
            Send, {Blind}{%MeleeKey%}
        } 
        TimeStamp(gSkipArchGun_CountdownStamp)
        fDebugGui("Edit", "Skip ArchGun", TimePassed(A_Stamp) " ms")
        if ShowGui {
            SetTimer, SkipArchGun_CountdownToError, 100
            if !WinExist("ahk_id " SkipArchGun_GUI) {
                UpdateDGP("Default")
                UpdateDGP({"Transparency" : gTransparency, "Blur" : gBlur, "Scale" : gInterfaceScale})
                GuiInGame("Start", "SkipArchGun_GUI")
                Gui, SkipArchGun_GUI: Add, Text, xm ym +Center,` Countdown to the ArchGun error: `
                Gui, SkipArchGun_GUI: Add, Text, x+m yp +Center +Border cFuchsia vSkipArchGun_CD,` - - - - - `
                GuiInGame("End", "SkipArchGun_GUI", {"Hwnd" : [MainInterface,"Left", "Auto", ""]})
            }
        }
    }

    SkipArchGun_CountdownToError() {
        A_Time := Round((15000 - TimePassed(gSkipArchGun_CountdownStamp)) / 1000, 1)
        if (A_Time > 0)
            GuiInGame("Edit", "SkipArchGun_GUI", {"id" : "SkipArchGun_CD", "Text" : A_Time " sec"})
        Else {
            GuiInGame("Destroy", "SkipArchGun_GUI")
            SetTimer, SkipArchGun_CountdownToError, Off
        }   
    }

    DialogueSkip() {
        global
        ;local windowInfo := winfWinGetClientPos(PWN)
        Send, {Blind}{Esc}
        lSleep(250)
        ; 1750, 970
        ;fMouseClick((windowInfo.w * 0.9115)*(DialogueSkipScale * 0.01), (windowInfo.h * 0.8981)*(DialogueSkipScale * 0.01))
        fMouseClick((A_ScreenWidth * 0.9115)*(DialogueSkipScale * 0.01), (A_ScreenHeight * 0.8981)*(DialogueSkipScale * 0.01), 4)
        lSleep(500)
        Loop, 4 {
            Send, {Blind}{Esc}
            lSleep(25)
        }
    }

;;;;;;;;;; Debugging ;;;;;;;;;;
    InputTest() {
        global
        local InputTest_Start, BeforeInput, AfterInput
        local AverageInput := ""
        TimeStamp(InputTest_Start)
        loop, {
            TimeStamp(BeforeInput)
            Send, {Blind}{%InputTestKey%}
            TimeStamp(AfterInput)
            fDebugGui("Edit", "Input Test", TimePassed(BeforeInput, AfterInput) " ms")
            AverageInput += TimePassed(BeforeInput, AfterInput)
            Sleep, 1
            if (TimePassed(InputTest_Start,,"sec") >= 1) {
                AverageInput := Round(AverageInput / A_Index, 3)
                fDebugGui("Edit", "Input Test", AverageInput " ms")
                Break
            } 
        }
    }

    PixelSearchTest() {
        global
        local PixelSearchTest_Start, BeforePixelSearch, AfterPixelSearch
        local AveragePixelSearch := ""
        TimeStamp(PixelSearchTest_Start)
        loop, {
            TimeStamp(BeforePixelSearch)
            PixelSearch, , , gScreenCenter[1]-10, gScreenCenter[2]-10, gScreenCenter[1]+10, gScreenCenter[2]+10, 0xFFFFFF, 10, Fast RGB
            TimeStamp(AfterPixelSearch)
            fDebugGui("Edit", "Pixel Search Test", TimePassed(BeforePixelSearch, AfterPixelSearch) " ms")
            AveragePixelSearch += TimePassed(BeforePixelSearch, AfterPixelSearch)
            Sleep, 1
            if (TimePassed(PixelSearchTest_Start,,"sec") >= 1) {
                AveragePixelSearch := Round(AveragePixelSearch / A_Index, 3)
                fDebugGui("Edit", "Pixel Search Test", AveragePixelSearch " ms")
                Break
            } 
        }
    }

;;;;;;;;;; Links ;;;;;;;;;;
    OpenEidolonsShieldCalculator() {
        Run, % """" ProgramSearch("AutoHotkey 1") """" " " """" CheckingFiles("File", False, "EidolonsShieldCalculator.ahk") """"
    }