;;;;;;;;;; Loading ;;;;;;;;;;
    #include %A_Scriptdir%\libs\CoreLibsFor_AHK\BaseLibs\Header.ahk
    ;--------------------------------------------------
    #IfWinActive, Warframe
    global PWN := "Warframe" ; Program window name
    CheckForUpdates("YagamiKlait3579", "Warframe", "main", CheckingFiles("File", False, "Header.ahk"))

;;;;;;;;;; Info ;;;;;;;;;;
    /*
        Макрос для упрощения фарма босса «Сфера извлечения прибыли».

        Основная функция — автоматическое чередование бросков Зо с мистификатором
        «Заражение эксодии» и стрельбы из выбранного оружия. Для запуска и работы
        макроса удерживайте стандартную клавишу StartKey, указанную в Settings.ahk.

        Дополнительная функция позволяет быстрый призыв Арчвинг-оружия без
        стандартной длительной анимации. Она использует несколько игровых багов,
        поэтому при её использовании есть важная особенность:

        После быстрого призыва запускается скрытый 15-секундный таймер. Когда он
        истекает, игра проверяет, находится ли в этот момент Арчвинг-оружие в руках.
        Если нет — клавиша оружия ближнего боя (по умолчанию E) блокируется:
        нельзя атаковать оружием ближнего боя, спешиться с Арчвинга, и прочие действия
        связанные с этой клавишей. Эта блокировка сохраняется до тех пор, 
        пока вы не возьмёте и не уберёте любую удочку. Поэтому перед миссией обязательно
        убедитесь, что удочка находится в вашем снаряжении.

        Важно: игра проверяет состояние именно в момент окончания 15 секунд.
        Не имеет значения, какое оружие было в руках раньше. Поэтому после быстрого
        призыва достаточно убедиться, что в момент окончания таймера у вас
        находится Арчвинг-оружие.

        Если не хотите следить за таймером, после быстрого призыва можно убрать
        Арчвинг-оружие и призвать его ещё раз обычным способом с полной анимацией.
        Это отменяет скрытый таймер и позволяет продолжить игру без риска
        возникновения блокировки.

        Быстрый призыв основан на игровых багах, а не на штатной механике Warframe.
        Поэтому его работа может зависеть от текущей версии игры. В некоторых патчах
        баг переставал работать для игроков, которые находились в миссии в качестве
        клиента, а после последующих обновлений снова начинал работать. Не
        исключено, что в будущем разработчики полностью исправят этот баг или
        изменят его поведение. Если быстрый призыв перестал работать после
        обновления игры, это не обязательно означает ошибку в макросе.

        В настройке RepairArchGun можно включить исправление перезарядки после
        быстрого призыва. Без него оружие призывается немного быстрее, но после
        призыва может оказаться доступной только одна обойма. Это обычно используют
        для спидрана, где одной обоймы достаточно. При включении RepairArchGun
        разница во времени призыва составляет всего несколько сотен миллисекунд,
        зато перезарядка оружия сохраняется.

        Общие настройки проекта находятся в Settings.ahk. Если какая-либо настройка
        указана одновременно здесь и в Settings.ahk, настройка этого макроса имеет
        приоритет.

        Также присутствуют общие дополнительные функции для всех макросов проекта.
        Подробнее об их функционале вы можете прочитать на GitHub проекта.
    */

;;;;;;;;;; Setting ;;;;;;;;;;
    Exodia_ThrowingTime := 50      ; Время броска
    Exodia_LandingTime  := 450     ; Время приземления (оно же время стрельбы с оружия)
    ;--------------------------------------------------
    SkipArchGunKey       = Numpad0 ; Быстрый запуск оружия арчвинга
    RepairArchGun       := False   ; Ремонт перезарядки арчвинга при его быстром запуске (True — включено, False — выключено)
    ;--------------------------------------------------
    GuiPositionY        := 0.9600  ; Изменение положения интерфейса по вертикали (Y-координата) только для этого скрипта
    
;;;;;;;;;; Variables ;;;;;;;;;;
    global gCountdownStamp

;;;;;;;;;; Hotkeys ;;;;;;;;;;
    Hotkey, *%StartKey%, ClassicExodia
    Hotkey, *%SkipArchGunKey%, SkipArchGun

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
        ;--------------------------------------------------
        Gui, MainInterface: Add, Text, xm y+m +Center, Debug Melee:
        Gui, MainInterface: Add, Text, xs yp +Center +Border cFuchsia vCountdown_Gui, %PlaceForTheText%
        GuiControl, MainInterface: Text, Countdown_Gui, - - - - -
    GuiInGame("End", "MainInterface", {"ratio" : [GuiPositionX,GuiPositionY]})
    fSuspendGui("On", "MainInterface")
    if DebugGui
        fDebugGui("Create", MainInterface)
    if HideTheInterface
        SetTimer, ShowHideGui , 250, -1
Return

;;;;;;;;;; Time management ;;;;;;;;;;
    CountdownToError() {
        A_Time := Round((15000 - TimePassed(gCountdownStamp)) / 1000, 1)
        if (A_Time > 0)
            GuiControl, MainInterface: Text, Countdown_Gui, %A_Time% sec
        Else {
            GuiControl, MainInterface: Text, Countdown_Gui, - - - - -
            SetTimer, CountdownToError, Off
        }   
    }

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

    SkipArchGun() {
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
        TimeStamp(gCountdownStamp)
        SetTimer, CountdownToError, 100
        fDebugGui("Edit", "Skip ArchGun", TimePassed(A_Stamp) " ms")
    }