;;;;;;;;;; Loading ;;;;;;;;;;

;;;;;;;;;; Variables ;;;;;;;;;;
    global A_MagusAnomaly

;;;;;;;;;; Hotkeys ;;;;;;;;;;
    Hotkey, *%EnergyDrainKey%, EnergyDrain
    Hotkey, *%MagusAnomalyKey%, MagusAnomaly
    Hotkey, *%CancelAnimationKey%, CancelAnimation
    Hotkey, *%InputTestKey%, InputTest
    
;;;;;;;;;; Additional functions ;;;;;;;;;;
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
        fDebugGui("Edit", "Cancel Animation", TimePassed(CancelAnimation_Start))
    }

    InputTest() {
        global
        local AverageInput := ""
        TimeStamp(InputTest_Start)
        loop, {
            TimeStamp(BeforeInput)
            Send, {Blind}{%InputTestKey%}
            TimeStamp(AfterInput)
            fDebugGui("Edit", "Input Test", TimePassed(BeforeInput, AfterInput))
            AverageInput += TimePassed(BeforeInput, AfterInput)
            Sleep, 1
            if (TimePassed(InputTest_Start,,"sec") >= 1) {
                AverageInput := Round(AverageInput / A_Index, 3)
                fDebugGui("Edit", "Input Test", AverageInput)
                Break
            } 
        }
    }