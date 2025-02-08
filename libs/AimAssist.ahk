;;;;;;;;;; Loading ;;;;;;;;;;
    ;#include FindText.ahk
    ;#include GuiInGame.ahk
    ;#include TimeControl.ahk
    ;#include InputDevice.ahk

;;;;;;;;;; Variables ;;;;;;;;;;
    ;global gScreenCenter := Array(Ceil(A_ScreenWidth / 2), Ceil(A_ScreenHeight / 2))

;;;;;;;;;; Main functions ;;;;;;;;;;
AimLocPin(SearchArea, FindText, A_FindText = 0.30, MouseSpeed = 1) {
    /* 
        AimLocPin предназначена для автоматического наведения на метки в игре Warframe.

        SearchArea: Определяет область поиска метки на экране, начиная от центра.

        FindText: код картинки для библиотеки FindText

        A_FindText: Задает допустимое отклонение найденного изображения от оригинала. 
        Значение варьируется от 0.01 до 1.00, где 0.01 — минимальное отклонение, а 1.00 — максимальное.

        MouseSpeed: Указывает скорость перемещения курсора мыши. Чем ниже скорость, тем точнее будет наведение. 
        Рекомендуется установить в игре значение скорости мыши на 0, а в драйвере мыши настроить комфортную скорость, 
        так как настройки Windows и драйвера мыши не влияют на работу функции.

        Функция автоматически останавливается, когда определяет, что прицел находится на метке.
        Если навестить на метку не удалось функция возвращает 1, при удачном наведении возвращает 0.
    */
    MouseSpeed := MouseSpeed < 1 ? 1 : MouseSpeed > 50 ? 50 : MouseSpeed
    PointingAccuracy := Round(Sqrt(MouseSpeed) * 0.74)
    StopAim := Array(gScreenCenter[1] - PointingAccuracy, gScreenCenter[2] - PointingAccuracy, gScreenCenter[1] + PointingAccuracy, gScreenCenter[2] + PointingAccuracy)
    SA := Array(gScreenCenter[1] - SearchArea, gScreenCenter[2] - SearchArea, gScreenCenter[1] + SearchArea, gScreenCenter[2] + SearchArea)
    fBorder("AimLocPin", {"Center" : SearchArea, "Color" : "Yellow"})
    Loop, {
        FindText(LocPinX, LocPinY, SA[1], SA[2], SA[3], SA[4], A_FindText, A_FindText, FindText)
        if (!LocPinX && !LocPinY) {
            fBorder("AimLocPin", "Destroy")
            Return 1
        }
        moving_X := LocPinX < StopAim[1] ? Floor(((LocPinX - gScreenCenter[1]) / MouseSpeed)) : LocPinX > StopAim[3] ? Ceil(((LocPinX - gScreenCenter[1]) / MouseSpeed)) : 0
        moving_Y := LocPinY < StopAim[2] ? Floor(((LocPinY - gScreenCenter[2]) / MouseSpeed)) : LocPinY > StopAim[4] ? Ceil(((LocPinY - gScreenCenter[2]) / MouseSpeed)) : 0
        if (moving_X = 0 && moving_Y = 0)
            Break
        fMoveMouse(moving_X, -moving_Y)
    }
    fBorder("AimLocPin", "Destroy")
    Return 0
}

CaptureLocPin(SearchArea, FindText, Time, TimeStamp = "", A_FindText = 0.30, MouseSpeed = 1) {
    /* 
        CaptureLocPin объединяет функциональность двух других функций: AimLocPin и lSleep. 
        Она предназначена для наведения на метку и удержания прицела на ней, даже если вы находитесь в движении.
        Возможно вы найдете ей другое применение, все зависит от вашей фантазии.
    */
    DllCall("QueryPerformanceCounter", "Int64*", CounterBefore)
    CounterBefore := TimeStamp != "" ? TimeStamp : CounterBefore
    MouseSpeed := MouseSpeed < 1 ? 1 : MouseSpeed > 50 ? 50 : MouseSpeed
    SA := Array(gScreenCenter[1] - SearchArea, gScreenCenter[2] - SearchArea, gScreenCenter[1] + SearchArea, gScreenCenter[2] + SearchArea)
    fBorder("CaptureLocPin", {"Center" : SearchArea, "Color" : "Yellow"})
    Loop, {
        FindText(LocPinX, LocPinY, SA[1], SA[2], SA[3], SA[4], A_FindText, A_FindText, FindText)
        moving_X := Round(((LocPinX - gScreenCenter[1]) / MouseSpeed))
        moving_Y := Round(((LocPinY - gScreenCenter[2]) / MouseSpeed))
        fMoveMouse(moving_X, -moving_Y)
    } Until (Time < TimePassed(CounterBefore))
    fBorder("CaptureLocPin", "Destroy")
}