;;;;;;;;;; Loading ;;;;;;;;;;
    #include %A_Scriptdir%\libs\CoreLibsFor_AHK\BaseLibs\Header.ahk
    ;--------------------------------------------------
    ;#IfWinActive, Warframe
    ;global PWN := "Warframe" ; Program window name

;;;;;;;;;; Setting ;;;;;;;;;;

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
        ; Конфигурация репозитория
        repoOwner := "YagamiKlait3579"     ; Замените на ваше имя пользователя GitHub
        repoName := "Warframe"      ; Замените на название вашего репозитория
        currentVersion := "1.0.0"             ; Текущая версия вашего скрипта (измените на свою)
        
        try {
            ; Получаем информацию о последнем коммите из GitHub API
            apiUrl := "https://api.github.com/repos/" repoOwner "/" repoName "/commits/main"
            
            ; Создаем HTTP запрос
            req := ComObjCreate("WinHttp.WinHttpRequest.5.1")
            req.Open("GET", apiUrl, true)
            req.SetRequestHeader("User-Agent", "AutoHotkeyScript")
            req.Send()
            req.WaitForResponse()
            
            ; Парсим JSON ответ
            response := req.ResponseText
            if (req.Status != 200) {
                return ; Не удалось получить данные
            }
            
            ; Извлекаем дату последнего коммита (исправленное регулярное выражение)
            lastCommitDate := ""
            if RegExMatch(response, """date"":\s*""([^""]+)""", match) {
                lastCommitDate := match1
            }
            
            if (lastCommitDate != "") {
                ; Преобразуем дату коммита в формат, который можно сравнить
                lastCommitTime := ParseGitHubDate(lastCommitDate)
                
                ; Получаем дату сборки текущего скрипта
                scriptTime := GetScriptModificationTime()
                
                ; Сравниваем даты
                if (lastCommitTime > scriptTime) {
                    ; Найдена новая версия
                    MsgBox, 68, Обновление доступно, 
                    (LTrim
                    Доступна новая версия макросов!
                    Ваша версия: %currentVersion%
                    
                    Хотите перейти на страницу репозитория для загрузки обновления?
                    )
                    
                    IfMsgBox, Yes
                    {
                        Run, https://github.com/%repoOwner%/%repoName%
                    }
                    return true
                }
            }
        } catch e {
            ; Ошибка при проверке обновлений - молча игнорируем
        }
        return false
    }

    ParseGitHubDate(dateStr) {
        ; Преобразуем дату GitHub в формат YYYYMMDDHH24MISS
        ; Пример входной строки: "2023-04-01T12:34:56Z"
        formatted := RegExReplace(dateStr, "(\d{4})-(\d{2})-(\d{2})T(\d{2}):(\d{2}):(\d{2})Z", "$1$2$3$4$5$6")
        return formatted
    }
    
    GetScriptModificationTime() {
        ; Получаем дату изменения текущего скрипта
        FileGetTime, scriptTime, %A_ScriptFullPath%, M
        FormatTime, scriptTime, %scriptTime%, yyyyMMddHHmmss
        return scriptTime
    }