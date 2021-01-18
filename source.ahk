#SingleInstance, Force
#Persistent
#UseHook
#NoEnv
#ErrorStdOut
#SingleInstance, Force

#Include Lib\base.ahk

global script = "ASHelper remaked"
global author = "clownless"
global author_contact_url = "https://clownless.xyz"

IniRead, ReportInR, config.ini, DrivingSchool, ReportInR, 0
IniRead, HotkeyExam, config.ini, DrivingSchool, HotkeyExam, ^1
Hotkey, % HotkeyExam, LabelExam, On, UseErrorLevel
IniRead, HotkeyTime, config.ini, DrivingSchool, HotkeyTime, ^2
Hotkey, % HotkeyTime, LabelTime, On, UseErrorLevel
IniRead, HotkeyCall, config.ini, DrivingSchool, HotkeyCall, ^3
Hotkey, % HotkeyCall, LabelCall, On, UseErrorLevel
Gui, New
Gui, Font, S9, Lucida Sans Unicode
if (ReportInR)
Gui, Add, Checkbox, x62 y10 vReportInR checked, Доклады в рацию
else
Gui, Add, Checkbox, x62 y10 vReportInR, Доклады в рацию
Gui, Add, Text, x29  y40,Диалоговое окно:
Gui, Add, Hotkey, x149 y38 w80 vHotkeyCall, %HotkeyCall%
Gui, Add, Text, x29  y70,/exam:
Gui, Add, Hotkey, x149 y68 w80 vHotkeyExam, %HotkeyExam%
Gui, Add, Text, x29  y100,/time:
Gui, Add, Hotkey, x149 y98 w80 vHotkeyTime, %HotkeyTime%
Gui, Add, Button, x10 y+10 w80 gAuthor, Создатель
Gui, Add, Button, x+5 w80 gHelpMe, Помощь
Gui, Add, Button, x+5 w80 gSaveConfig, Сохранить
Gui, Add, Button, x62 y+5 gApplyConfig, Применить настройки
Gui, Show,, %script%
return
Author:
MsgBox, 4, Information about %script%, Автор скрипта %script% - %author%.`nХотите связаться с ним?
ifMsgBox Yes
Run, %author_contact_url%
return
HelpMe:
MsgBox, 262144, Information about %script%, После изменения кнопки активации диалога, нажмите "Применить настройки".`n%HotkeyExam% - /exam.`n%HotkeyTime% - /time.`n%HotkeyCall%, при зажатом ПКМ и наведенной стрелочкой на необходимого вам`n игрока - вызов диалогового окна с основными функциями.`nF2 - Pause script.`nF3 - Reload script.`n`n`n*Если вы хотите принять экзамен у игрока, то сначала нажмите %HotkeyExam% (чтоб вызвать его на экзамен), а после, зажимайте ПКМ и жмите %HotkeyCall%. Появится диалоговое окно. Дальше думаю все понятно.`n*Если вы хотите продать лицензию/страховку, просто зажмите ПКМ и жмите %HotkeyCall%. После чего появится диалоговое окно. Дальше думаю все понятно.
return
SaveConfig:
Gui, Submit, NoHide
IniWrite, %ReportInR%, config.ini, DrivingSchool, ReportInR
IniWrite, %HotkeyCall%, config.ini, DrivingSchool, HotkeyCall
IniWrite, %HotkeyExam%, config.ini, DrivingSchool, HotkeyExam
IniWrite, %HotkeyTime%, config.ini, DrivingSchool, HotkeyTime
return
GuiClose:
gosub, SaveConfig
Exitapp
return
ApplyConfig:
IniRead, HotkeyExam, config.ini, DrivingSchool, HotkeyExam, ^1
IniRead, HotkeyTime, config.ini, DrivingSchool, HotkeyTime, ^2
IniRead, HotkeyCall, config.ini, DrivingSchool, HotkeyCall, ^3
Hotkey, % HotkeyExam, LabelExam, Off, UseErrorLevel
Hotkey, % HotkeyTime, LabelTime, Off, UseErrorLevel
Hotkey, % HotkeyСall, LabelCall, Off, UseErrorLevel
Gosub, SaveConfig
Hotkey, % HotkeyExam, LabelExam, On, UseErrorLevel
Hotkey, % HotkeyTime, LabelTime, On, UseErrorLevel
Hotkey, % HotkeyCall, LabelCall, On, UseErrorLevel
return
LabelCall:
Pod := getId()
Pid := getIdByPed(getTargetPed())
MySkin := getPlayerSkinId()
SkinPlayer := getTargetPlayerSkinIdById(Pid)
SexSkinPlayer := getsexbyskin(SkinPlayer)
if (SexSkinPlayer = 1) {
    Mess1 := ""
}
else if (SexSkinPlayer = 2) {
    Mess1 := "а"
}
SexSkin := getsexbyskin(MySkin)
if (SexSkin = 1) {
    RP1 := ""
}
else if (SexSkin = 2) {
    RP1 := "а"
}
if ( Pid == -1) {
    addChatMessageEx("FF0000", "[Ошибка]: Никакой игрок не был захвачен.")
    return
}
ExName := RegExReplace(getPlayerNameById(Pid),"_"," ")
MyName := RegExReplace(getUsername(), "_"," ")
showDialog(4, "{6600FF}" script, "{99FFFF}>>>{FFFFFF} Сдача на наземный транспорт`n{99FFFF}>>>{FFFFFF} Сдача на воздушный транспорт`n{99FFFF}>>>{FFFFFF} Продать лицензии на водный`n{99FFFF}>>>{FFFFFF} Продать лицензии на оружие`n{99FFFF}>>>{FFFFFF} Страховка", "Закрыть")
NexStep := 1
Result := LineResult()
if (!Result)
return
if (Result = "1") {
    SendChat("Здравствуйте, я " Myname ". Я буду принимать у вас экзамен. Покажите ваш паспорт.")
    Sleep 2000
    SendChat("/n Введите команду: /pass " getId())
    Sleep, 500
    addChatMessageEx("FF00FF", " Для дальнейшего принятия экзамена нажмите 1. Если не допущен, то нажмите 2. NonRP nick, то нажмите 3.")
    while (!GetKeyState("1", "P") && !GetKeyState("2", "P") && !GetKeyState("3", "P"))
    continue
    if (GetKeyState("3", "P")) {
        ArrayExamNonRP := ["У вас опечатка в паспорте", "/n Для смены nonRP ника введите команду - /mn и выберите пункт: смена нонРП ника.", "/me движением правой руки достал" RP1 " бумаги из	портфеля", "/me начал" RP1 " заполнять бумаги", "/do Написал" RP1 ": №" Pid " от " A_DD "." A_MM "." A_YYYY " " A_Hour ":" A_Min ".", "/me достал" RP1 " заявление на пересдачу,затем поставил" RP1 " печать", "/me передал" RP1 " заявление клиенту"]
        ArrayToSendChat(ArrayExamNonRP)
        return
    }else if (GetKeyState("2", "P")) {
        ArrayExamFalse := ["/me движением правой руки достал" RP1 " бумаги из портфеля", "/me начал" RP1 " заполнять бумаги", "/do Написал" RP1 ": " ExName " №" Pid "П от " A_DD "." A_MM "." A_YYYY " " A_Hour ":" A_Min ".", "/me достал" RP1 " заявление на пересдачу,затем поставил" RP1 " печать", "/me передал" RP1 " заявление клиенту", "/exam"]
        ArrayToSendChat(ArrayExamFalse)
        Sleep, 500
    Send, {down}
        Sleep, 50
    Send, {down}
        Sleep, 50
    Send, {enter}
        Sleep, 500
        if (ReportInR)
        SendChat("/f " ExName " не сдал" Mess1 ". Информация: " ExName " №" Pid "П от " A_DD "." A_MM "." A_YYYY " " A_Hour ":" A_Min ".")
        Sleep, 500
    }else if (GetKeyState("1", "P")) {
        ArrayExamTrue := ["/do Кейс с бланками в левой руке.", "/me приоткрыл" RP1 " кейс, после чего достал" RP1 " один бланк с ручкой", "/me записал" RP1 " имя,затем фамилию экзаменуемого в бланк", "/me оставшиеся бланки аккуратно сложил" RP1 " в кейс, после чего закрыл" RP1 " его"]
        ArrayToSendChat(ArrayExamTrue)
        if (ReportInR)
        SendChat("/f Начал" RP1 " проводить экзамен у " ExName ".")
        Sleep, 2300
        SendChat("Хорошо, " ExName ", пройдемте за мной для практической сдачи экзамена.")
        Sleep, 500
        addChatMessageEx("00FFFF", "Когда будете подбегать к автомобилю, нажмите 1.")
        KeyWait, 1, D
        Sleep, 5
        ArrayToSendChat(["Садитесь в машину на место водителя и ожидайте моих указаний.", "Сейчас мы проведем экзамен на управление наземным видом транспорта.", "Если вам будет что-то непонятно говорите сразу мне, я вам помогу.", "Заведите двигатель и пристегните ремень безопасности.", "/n Завести двигатель - CTRL. Пристегнуть ремень, введите - /me пристегнул ремень безопасности"])
        Sleep, 500
        addChatMessageEx("00FFFF", "Для дальнейшего принятия экзамена, нажмите 1.")
        KeyWait, 1, D
        SendChat("Езжайте в центр площадки и останoвитесь у линии старт, поехали.")
        Sleep, 500
        addChatMessageEx("00FFFF", "Если человек не сдал экзамен, пропишите команду /fail")
        NextStep := 1
        loop {
            if (!NextStep) {
                ArrayToSendChat(["Вы провалили экзамен.", "/me движением правой руки достал" RP1 " бумаги из портфеля", "/me начал" RP1 " заполнять бумаги", "/do Написал" RP1 ": Отправлен на пересдачу.", "/me достал" RP1 " заявление на пересдачу, затем поставил" RP1 " печать", "/me передал" RP1 " заявление клиенту"])
                Sleep, 500
                break
            }
            if IsPlayerInRangeOfPoint(-2054.575928,-176.534698,35.920311,10) and (NextStep = 1) {
                Sleep 1000
                SendChat("Проедьте по лежачим полицейским до конусов. Затем змейкой вокруг конусов.")
                NextStep := 2
            }else if IsPlayerInRangeOfPoint(-2052.755859,-198.885147,35.927391,10) and (NextStep = 2) {
                Sleep 1000
                SendChat("Соблюдайте указания стрелок на асфальте и объезжайте конусы змейкой.")
                NextStep := 3
            }else if IsPlayerInRangeOfPoint(-2055.958984,-244.708893,35.927391,7) and (NextStep = 3) {
                Sleep 1000
                SendChat("Теперь поставьте машину в обозначенную область.")
                NextStep := 4
            }else if IsPlayerInRangeOfPoint(-2065.067383,-245.351425,35.920311,5) and (NextStep = 4) {
                Sleep 1000
                SendChat("Теперь езжайте по стрелкам вокруг конусов в сторону эстакады.")
                NextStep := 5
            }else if IsPlayerInRangeOfPoint(-2046.779175,-257.600464,35.920311,10) and (NextStep = 5) {
                Sleep 1000
                SendChat("Подъезжайте к эстакаде и остановитесь перед линией.")
                NextStep := 6
            }else  if IsPlayerInRangeOfPoint(-2027.718018,-247.739395,35.920311,10) and (NextStep = 6) {
                Sleep 1000
                SendChat("Теперь осторожно проезжайте по мосту, затем возле надписи стоп остановитесь.")
                NextStep := 7
            }else if IsPlayerInRangeOfPoint(-2027.311035,-213.617371,35.920311,10) and (NextStep = 7) {
                ArrayExamEnd := ["Хорошо, теперь поставьте автомобиль на парковку, откуда мы выезжали.", "/do Кейс с документами в руках.", "/me приоткрыл" RP1 " кейс, после чего достал" RP1 " бумаги , затем начал" RP1 " их заполнять", "/do Написал" RP1 ": " ExName " №" Pid "Н от " A_DD "." A_MM "." A_YYYY " " A_Hour ":" A_Min ".", "/me достал" RP1 " правой рукой водительское удостоверение", "/me после чего передал" RP1 " клиенту водительское удостоверение вместе с  документами", "/me после заполнения документов, аккуратно сложил" RP1 " документы ,после чего закрыл" RP1 " кейс"]
                ArrayToSendChat(ArrayExamEnd)
                if (ReportInR)
                SendChat("/f " ExName " получил" Mess1 " права. Информация: " ExName " №" Pid "Н от " A_DD "." A_MM "." A_YYYY " " A_Hour ":" A_Min ".")
                break
            }
        }
    }
}else if (Result = "2") {
    SendChat("Здравствуйте, я " Myname ". Я буду принимать у вас экзамен. Покажите ваш паспорт.")
    Sleep 2000
    SendChat("/n Введите команду: /pass " getId())
    Sleep, 500
    addChatMessageEx("00FFFF", "Для дальнейшего принятия экзамена нажмите 1. Если не допущен, то нажмите 2. NonRP nick, то нажмите 3.")
    while (!GetKeyState("1", "P") && !GetKeyState("2", "P") && !GetKeyState("3", "P"))
    continue
    if (GetKeyState("3", "P")) {
        ArrayExamNonRP := ["У вас опечатка в паспорте", "/n Для смены nonRP ника введите команду - /mn и выберите пункт: смена нонРП ника.", "/me движением правой руки достал" RP1 " бумаги из портфеля", "/me начал" RP1 " заполнять бумаги", "/do Написал" RP1 ": №" Pid " от " A_DD "." A_MM "." A_YYYY " " A_Hour ":" A_Min ".", "/me достал" RP1 " заявление на пересдачу , затем поставил" RP1 " печать", "/me передал" RP1 " заявление клиенту"]
        ArrayToSendChat(ArrayExamNonRP)
        return
    }else if (GetKeyState("2", "P")) {
        ArrayExamFalse := ["/me движением правой руки достал" RP1 " бумаги из портфеля", "/me начал" RP1 " заполнять бумаги", "/do Написал" RP1 ": " ExName " №" Pid "П от " A_DD "." A_MM "." A_YYYY " " A_Hour ":" A_Min ".", "/me достал" RP1 " заявление на пересдачу,затем поставил" RP1 " печать", "/me передал" RP1 " заявление клиенту", "/exam"]
        ArrayToSendChat(ArrayExamFalse)
        Sleep, 500
        if (ReportInR)
        SendChat("/f " ExName " не сдал" Mess1 ". Информация: " ExName " №" Pid "П от " A_DD "." A_MM "." A_YYYY " " A_Hour ":" A_Min ".")
        Sleep, 500
    }else if (GetKeyState("1", "P")) {
        ArrayExamTrue := ["/do Кейс с бланками в левой руке.", "/me приоткрыл" RP1 " кейс, после чего достал" RP1 " один бланк с ручкой", "/me записал" RP1 " имя ,затем  фамилию экзаменуемого в бланк", "/me оставшиеся бланки аккуратно сложил" RP1 " в кейс, после чего закрыл" RP1 " его"]
        ArrayToSendChat(ArrayExamTrue)
        if (ReportInR)
        SendChat("/f Начал" RP1 " проводить экзамен у " ExName ".")
        Sleep, 2300
        SendChat("Хорошо, " ExName ", пройдемте за мной для практической сдачи экзамена.")
        addChatMessageEx("00FFFF", "Когда будете подбегать к вертолету, нажмите 1.")
        KeyWait, 1, D
        ArrayToSendChat(["Садитесь на место пилота - слева и ждите моих указаний.", "Теперь пристегнитесь и наденьте наушники.", "/n *Введите /me пристегнулся, после чего надел наушники", "/me надел" RP1 " наушники", "Сейчас мы проведём экзамен на право управления воздушным транспортом.", "У вас есть право на 2 ошибки в процессе экзамена, 3 ошибки - вы не сдали.", "Ошибкой считается, если вы что-то заденете в полёте или взорвете вертолёт.", "Заведите двигатель.", "/n Чтобы завести двигатель, нажмите CTRL."])
        addChatMessageEx("00FFFF", "Когда игрок заведет двигатель, нажмите 1.")
        KeyWait, 1, D
        SendChat("Можно взлетать, летим вокруг Автошколы и садимся на место, где взяли вертолёт.")
        Sleep, 2000
        SendChat("/n Используйте: Q и E, стрелки вверх и вниз, W и S.")
        Sleep, 500
        addChatMessageEx("00FFFF", "Когда захотите начать RP отыгровку для выдачи прав, нажмите 1. Если провалил, то нажмите 2.")
        while (!GetKeyState("1", "P") && !GetKeyState("2", "P"))
        continue
        if (GetKeyState("2", "P")) {
            ArrayToSendChat(["Вы провалили экзамен.", "/me движением правой руки достал" RP1 " бумаги из портфеля", "/me начал" RP1 " заполнять бумаги", "/do Написал" RP1 ": Отправлен на пересдачу.", "/me достал" RP1 " заявление на пересдачу , затем поставил" RP1 " печать", "/me передал" RP1 " заявление клиенту", "/exam"])
            return
        }
        if (GetKeyState("1", "P")) {
            ArrayExamEndV := ["/do Кейс с документами в руках.", "/me приоткрыл" RP1 " кейс, после чего достал" RP1 " бумаги,затем  начал" RP1 " их заполнять", "/do Написал: " ExName " №" Pid "В от " A_DD "." A_MM "." A_YYYY " " A_Hour ":" A_Min ".", "/me достал" RP1 " правой рукой водительское удостоверение", "/me после чего передал" RP1 " клиенту водительское удостоверение вместе с документами", "/me после заполнения документов, аккуратно сложил" RP1 " документы,затем  закрыл" RP1 " кейс"]
            ArrayToSendChat(ArrayExamEndV)
            if (ReportInR)
            SendChat("/f " ExName " получил" Mess1 " права. Информация: " ExName " №" Pid "В от " A_DD "." A_MM "." A_YYYY " " A_Hour ":" A_Min ".")
            return
        }
    }
}else if (Result = "3") {
    SendChat("Предъявите, пожалуйста, ваш паспорт и мед. карту.")
    Sleep 2000
    SendChat("/n *Показать паспорт - /pass " Pod ", мед. карту - /med " Pod "")
    Sleep, 500
    addChatMessageEx("00FFFF", "Для продажи лицензии нажмите 1. Для отказа в продаже лицензии нажмите 2.")
    while (!GetKeyState("1", "P") && !GetKeyState("2", "P"))
    continue
    if (GetKeyState("2", "P")) {
        SendChat("Увы, но я не могу продать вам лицензию. До свидания.")
        return
    } else if (GetKeyState("1", "P")) {
        ArrayLicV := ["/do В левой руке находится дипломат с лицензиями.", "/me открыл" RP1 " кейс,затем вытащил" RP1 " из него нужные лицензии", "/me  вытащил" RP1 " ручку из кармана ,после чего заполнил" RP1 " лицензии", "/do Написал" RP1 ": Лицензия | Водный транспорт | " ExName " | " A_DD "." A_MM "." A_YYYY " " A_Hour ":" A_Min ".", "/me передал" RP1 " лицензию покупателю", "Вот ваша лицензия, держите.", "/selllic " Pid " 1"]
        ArrayToSendChat(ArrayLicV)
        return
    }
}else if (Result = "4") {
    SendChat("Предъявите, пожалуйста, ваш паспорт и мед. карту.")
    Sleep 2000
    SendChat("/n *Показать паспорт - /pass " Pod ", мед. карту - /med " Pod "")
    Sleep, 500
    addChatMessageEx("00FFFF", "Для продажи лицензии нажмите 1. Для отказа в продаже лицензии нажмите 2.")
    while (!GetKeyState("1", "P") && !GetKeyState("2", "P"))
    continue
    if (GetKeyState("2", "P")) {
        SendChat("Увы, но я не могу продать вам лицензию. До свидания.")
    } else if (GetKeyState("1", "P")) {
        ArrayLicG := ["/do В левой руке находится дипломат с лицензиями.", "/me открыл" RP1 " кейс,после чего вытащил" RP1 " из него нужные лицензии", "/me после чего вытащил" RP1 " ручку из кармана,затем заполнил" RP1 " лицензии", "/do Написал" RP1 ": Лицензия | Оружие | " ExName " | " A_DD "." A_MM "." A_YYYY " " A_Hour ":" A_Min ".", "/me затем передал" RP1 " лицензию покупателю", "Вот ваша лицензия, держите.", "/selllic " Pid " 2"]
        ArrayToSendChat(ArrayLicG)
    }
}else if (Result = "5") {
    SendChat("На какой срок вы хотите застраховать свой автомобиль: 10, 30 или 60 дней?")
    Sleep, 500
    addChatMessageEx("00FFFF", "Для продложения RP отыгроки нажмите ПРОБЕЛ.")
    KeyWait, Space, D
    SendChat("Хорошо, давайте ваш паспорт, мед. карту и паспорт транспортного средства.")
    Sleep, 2500
    SendChat("/n *Показать паспорт - /pass " Pod ", мед.карту - /med " Pod ", ПТС - /pts " Pod "")
    Sleep, 500
    addChatMessageEx("00FFFF","Для продолжение RP отыгроки нажмите 1. Для отказа в продаже страховки нажмите 2.")
    while (!GetKeyState("1", "P") && !GetKeyState("2", "P"))
    continue
    if (GetKeyState("2", "P")) {
        SendChat("Увы, но я не могу продать вам страховку. До свидания.")
    } else if (GetKeyState("1", "P")) {
        ArrayStrah := ["/do Кейс с документами, бланками, талонами со страховкой в правой руке.", "/me открыл" RP1 " кейс, после чего достал" RP1 " документы ,затем начал" RP1 " их заполнять", "/do Написал" RP1 ": " ExName " | Страховка | " A_DD "." A_MM "." A_YYYY " " A_Hour ":" A_Min ".", "/me ниже поставил" RP1 " печать Autoschool-Insurance, дату с подписью", "/me после продажи страховки аккуратно сложил" RP1 " документы,затем закрыл" RP1 " кейс", "/me передал" RP1 " страховку клиенту", "Вот ваша страховка, держите."]
        ArrayToSendChat(ArrayStrah)
        Sleep, 500
    SendInput, {f6}/insurance %Pid%{space}
        return
    }
}
return
LineResult() {
    if (!isDialogOpen())
    return false
    if (getDialogStyle() = 0 || getDialogStyle() = 1 || getDialogStyle() = 3)
    return false
    while (!GetKeyState("LButton", "P") && !GetKeyState("Enter", "P") && !GetKeyState("Esc", "P"))
    continue
    if (GetKeyState("Enter", "P"))
    return getDialogLineNumber()
    else if (GetKeyState("Esc", "P"))
    return false
    else{
        KeyWait, LButton
        KeyWait, LButton, D T0.25
        if (ErrorLevel)
        return LineResult()
        else
        return getDialogLineNumber()
    }
}
ExitApp
LabelExam:
SendChat("/exam")
return
LabelTime:
SendChat("/time")
return
F2::Pause
F3::Reload
ArrayToSendChat(ArrayName) {
    for i, element in ArrayName
    {
        SendChat(element)
        sleep 2300
    }
    return
}
$~Enter::
if (isInChat() && !isDialogOpen())
{
    Sleep 200
    dwAddress := dwSAMP + 0x12D8F8
    chatInput := readString(hGTA, dwAddress, 256)
    if (chatInput = "/fail")
    NextStep := false
}
return
