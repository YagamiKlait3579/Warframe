# Warframe — AHK Macros

🌐 **Язык / Language**

* 🇷🇺 [Русский](#русский)
* 🇺🇸 [English](#english)

---

## Русский

Набор макросов на **AutoHotkey v1** для автоматизации различных действий в **Warframe**.

Проект включает как небольшие вспомогательные скрипты для отдельных действий, так и более сложные макросы для конкретных миссий, Варфреймов и игровых механик.

---

## Установка

1. Установите [**AutoHotkey v1**](https://www.autohotkey.com)  
2. Скачайте архив с проектом и распакуйте его.
3. Не изменяйте структуру папок и файлов внутри архива.
4. Откройте `Settings.ahk` и настройте общие параметры проекта.
5. Запустите нужный `.ahk` файл.

Каждый макрос является отдельным скриптом и может запускаться независимо от остальных.

---

## ⚙️ Настройка и использование

Перед первым запуском рекомендуется ознакомиться со страницей **[Wiki — руководство по настройке](https://github.com/YagamiKlait3579/Warframe/wiki/Руководство-по-макросам)**. Там собрана подробная информация о настройках Warframe, конфигурации `Settings.ahk`, индивидуальных настройках макросов и дополнительных функциях проекта.

`Settings.ahk` — основной файл общих настроек. В нём задаются клавиши управления макросами и параметры, которые используются несколькими скриптами. Для корректной работы макросов важно настроить этот файл под свои игровые настройки.

Обратите внимание на следующие моменты:

- В `SettingFPS` укажите минимальный FPS, который обычно бывает у вас во время игры при просадках. Макросы рассчитаны на работу при **60 FPS и выше**.
- Действия, которые используют макросы, должны быть назначены на клавиши клавиатуры в настройках Warframe. Если действие назначено только на кнопку мыши, продублируйте его на клавиатуру — менять привычное управление мышью не требуется.
- Если одна и та же настройка присутствует и в конкретном макросе, и в `Settings.ahk`, приоритет имеет значение из файла самого макроса.
- Основная клавиша запуска и остановки макросов — `StartKey`, указанная в `Settings.ahk`. Если в отдельном макросе она используется иначе, это будет указано в его описании.

---

## Помощь и обратная связь

Если после прочтения **[Wiki](https://github.com/YagamiKlait3579/Warframe/wiki/Руководство-по-макросам)** у вас всё ещё возникают проблемы с установкой, настройкой или использованием макросов, я могу помочь в свободное время. Перед обращением, пожалуйста, убедитесь, что вы ознакомились с соответствующими инструкциями в **[Wiki](https://github.com/YagamiKlait3579/Warframe/wiki/Руководство-по-макросам)**. Это поможет избежать вопросов, ответы на которые уже есть в документации, и позволит сосредоточиться на решении конкретной проблемы.

Вы можете обратиться ко мне на моём [Discord](https://discord.gg/yrRfUMXAnk)-сервере. Если увидите меня онлайн — не стесняйтесь написать:

> Также я могу поделиться другими своими макросами для Warframe, которые не включены в этот репозиторий. Некоторые из них я не добавлял сюда, потому что считаю их слишком бесполезными для публикации, а некоторые требуют слишком сложной настройки или использования, чтобы имело смысл выкладывать их вместе с полноценным описанием.

Если у вас есть предложения по улучшению существующих макросов или идеи для новых функций, можете сообщить об этом.

---

## ⚠️ Важно

Отношение разработчиков Warframe к использованию макросов неоднозначное. В некоторых случаях игроки получали блокировки, а служба поддержки отвечала, что использование макросов запрещено. В других случаях представители поддержки заявляли, что не возражают против ограниченной автоматизации.

Поэтому нет гарантии, что использование этих макросов не приведёт к блокировке аккаунта. Вы используете их на свой страх и риск.

---

## English

A collection of **AutoHotkey v1** macros for automating various actions in **Warframe**.

The project includes both small utility scripts for individual tasks and more complex macros for specific missions, Warframes, and game mechanics.

---

## Installation

1. Install [**AutoHotkey v1**](https://www.autohotkey.com).
2. Download the project archive and extract it.
3. Do not change the folder and file structure inside the archive.
4. Open `Settings.ahk` and configure the project's common settings.
5. Run the required `.ahk` file.

Each macro is a separate script and can be run independently of the others.

---

## ⚙️ Configuration and Usage

Before running a macro for the first time, it is recommended to read the **[Wiki — Configuration Guide](https://github.com/YagamiKlait3579/Warframe/wiki/Macro-Guide)**. It contains detailed information about Warframe settings, configuring `Settings.ahk`, individual macro settings, and the project's additional functions.

`Settings.ahk` is the main file for shared settings. It contains the keys used to control macros and parameters shared by multiple scripts. To ensure that the macros work correctly, configure this file to match your in-game settings.

Keep the following points in mind:

- Set `SettingFPS` to the lowest FPS you typically reach during gameplay when your frame rate drops. The macros are designed to work at **60 FPS or higher**.
- Any actions used by the macros must be assigned to keyboard keys in Warframe's controls. If an action is assigned only to a mouse button, assign it to a keyboard key as well. You can continue using your usual mouse controls.
- If the same setting appears both in an individual macro and in `Settings.ahk`, the value in the macro's own file takes priority.
- The main key for starting and stopping macros is `StartKey`, defined in `Settings.ahk`. If a particular macro uses it differently, this will be explained in that macro's description.

---

## Help and Feedback

If you still have problems installing, configuring, or using the macros after reading the **[Wiki](https://github.com/YagamiKlait3579/Warframe/wiki/Macro-Guide)**, I can try to help in my free time. Before contacting me, please make sure you have read the relevant instructions in the **[Wiki](https://github.com/YagamiKlait3579/Warframe/wiki/Macro-Guide)**. This helps avoid questions that are already answered in the documentation and allows us to focus on solving the specific problem.

You can contact me on my [Discord](https://discord.gg/yrRfUMXAnk) server. If you see me online, feel free to send me a message.

> I can also share other Warframe macros that are not included in this repository. I left some of them out because I consider them too impractical to publish, while others are too complicated to configure or use to make it worthwhile to publish them with a full description.

If you have suggestions for improving existing macros or ideas for new features, feel free to let me know.

**Please note that my English is not very good. I may not be able to help you if you do not speak Russian.** I apologize for the inconvenience.

---

## ⚠️ Important

The Warframe developers' stance on macro use is not entirely clear. In some cases, players have been banned and Support has stated that macro use is prohibited. In other cases, Support representatives have said that they do not object to limited automation.

Therefore, there is no guarantee that using these macros will not result in an account ban. Use them at your own risk.
