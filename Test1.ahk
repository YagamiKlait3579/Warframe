;;;;;;;;;; Loading ;;;;;;;;;;
    #include %A_Scriptdir%\libs\CoreLibsFor_AHK\BaseLibs\Header.ahk
    ;--------------------------------------------------
    ;#IfWinActive, Warframe
    ;global PWN := "Warframe" ; Program window name

;;;;;;;;;; Setting ;;;;;;;;;;
;
;;;;;;;;;; Variables ;;;;;;;;;;

;;;;;;;;;; Hotkeys ;;;;;;;;;;
    Hotkey, *%StartKey%, BaseScript

;;;;;;;;;; Gui ;;;;;;;;;;
    PlaceForTheText := " Ширина самого длинного текста "
    ;--------------------------------------------------
    UpdateDGP({"Transparency" : gTransparency, "Blur" : gBlur, "Scale" : gInterfaceScale})
    GuiInGame("Start", "MainInterface")
        Gui, MainInterface: Add, Text, xm ym +Center vT1, %PlaceForTheText%
        GuiControl, MainInterface: Text, T1, % SubStr(A_ScriptName, 1, InStr(A_ScriptName, ".", , -1) - 1)
    GuiInGame("End", "MainInterface", {"ratio" : [GuiPositionX,GuiPositionY]})
    fSuspendGui("On", "MainInterface")
    if DebugGui
        fDebugGui("Create", MainInterface)
    if HideTheInterface
        SetTimer, ShowHideGui , 250, -1
Return

;;;;;;;;;; Scripts ;;;;;;;;;;
    BaseScript:
        CheckForUpdates()
    Return
    
    CheckForUpdates() {
        ; Настройки
        repoOwner := "YagamiKlait3579"
        repoName := "Warframe"
        currentVersion := "1.0.0"
        checkFile := A_ScriptDir "\libs\CoreLibsFor_AHK\BaseLibs\Header.ahk"
        
        if !FileExist(checkFile)
            return false
        
        try {
            ; 1. Получаем дату последнего коммита (UTC)
            apiUrl := "https://api.github.com/repos/" repoOwner "/" repoName "/commits/main"
            req := ComObjCreate("WinHttp.WinHttpRequest.5.1")
            req.Open("GET", apiUrl, true)
            req.SetRequestHeader("User-Agent", "AHK-Update-Checker")
            req.Send()
            req.WaitForResponse()
            
            if (req.Status != 200)
                return false
            
            ; 2. Парсим дату из GitHub (UTC время)
            if !RegExMatch(req.ResponseText, """date"":\s*""([^""]+)""", match)
                return false
                
            ; 3. Преобразуем GitHub дату в формат YYYYMMDDHH24MISS
            RegExMatch(match1, "(\d{4})-(\d{2})-(\d{2})T(\d{2}):(\d{2}):(\d{2})Z", dt)
            gitTime := dt1 dt2 dt3 dt4 dt5 dt6  ; UTC время
            
            ; 4. Получаем время создания файла (локальное время)
            FileGetTime, fileLocalTime, %checkFile%, C
            
            ; 5. Вычисляем разницу часового пояса
            localNow := A_Now
            utcNow := A_NowUTC
            timeDiff := localNow - utcNow  ; Разница в секундах
            
            ; 6. Конвертируем время файла в UTC
            fileUTC := fileLocalTime - timeDiff
            
            ; 7. Сравниваем времена
            if (gitTime > fileUTC) {
                MsgBox, 68, Доступно обновление, 
                (LTrim
                Доступна новая версия макросов!
                Ваша версия: %currentVersion%
                
                Открыть страницу загрузки?
                )
                
                IfMsgBox, Yes
                    Run, https://github.com/%repoOwner%/%repoName%
                return true
            }
        }
        catch {
            ; Тихий сбой при ошибках
        }
        return false
    }