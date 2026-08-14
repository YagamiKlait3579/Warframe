# Warframe — AHK Macros

🌐 **Language / Язык**

* 🇷🇺 [Русский](#русский)
* 🇺🇸 [English](#english)

---

## Русский

Набор макросов на **AutoHotkey v1** для автоматизации различных действий в **Warframe**.

Этот проект содержит макросы исключительно для Warframe. Здесь собраны как небольшие вспомогательные скрипты для отдельных действий, так и более сложные макросы для конкретных миссий, персонажей и игровых механик.

Большинство макросов имеют собственные настройки и описание непосредственно в начале файла. Перед использованием рекомендуется ознакомиться с `Settings.ahk` — в нём находятся общие настройки проекта, клавиши управления и параметры, которые используются сразу несколькими макросами.

---

## Установка

1. Установите **AutoHotkey v1**.
2. Скачайте архив с проектом и распакуйте его.
3. Не изменяйте структуру папок и файлов внутри архива.
4. Откройте `Settings.ahk` и настройте клавиши и остальные параметры под свою игру.
5. Запустите нужный `.ahk` файл.

Каждый макрос является отдельным скриптом и может запускаться независимо от остальных.

---

## ⚙️ Настройка `Settings.ahk`

`Settings.ahk` — основной файл общих настроек проекта. Его правильная настройка важна для корректной работы большинства макросов.

### FPS

Укажите в `SettingFPS` **минимальный FPS**, который у вас бывает во время игры при просадках, а не среднее или максимальное значение.

Некоторые действия макросов зависят от скорости работы игры, поэтому при слишком низком FPS отдельные нажатия могут не успевать обрабатываться. Макросы рассчитаны на работу при **60 FPS и выше**.

Например, если обычно у вас 144 FPS, но во время тяжёлых моментов FPS может падать до 90, указывать следует `90`.

### In-game settings

Для корректной работы функций необходимо назначить все клавиши из раздела **In-game settings (Настройки в игре)** непосредственно в управлении Warframe **на клавиатуру**.

Например, если макрос использует стрельбу, прицеливание или альтернативный огонь, соответствующие действия должны иметь назначенные клавиши в самой игре, после чего эти же клавиши необходимо указать в `Settings.ahk`.

Особое внимание обратите на:

* `EmoteAgreeKey`
* `EmoteAgreeKey2`

Это одно и то же действие в игре, но оно должно быть назначено **на две разные клавиши**.

### Common functions

В разделе **Common functions (Общие функции)** находятся дополнительные функции, доступные независимо от того, какой основной макрос сейчас запущен.

Описание их возможностей приведено ниже.

Если какая-либо функция вам не нужна, её клавишу можно оставить пустой — в таком случае функция будет отключена.

---

# Дополнительные функции

Эти функции работают **всегда**, независимо от того, какой основной макрос сейчас запущен.

### Madurai Ability Buff

Быстро переключается в режим Оператора, активирует пассивную способность школы Мадурай **«Мощность Броска»** и мистификатор **«Линька: Напористость»**, после чего возвращается обратно в Варфрейма.

Функция предназначена для быстрого усиления следующей способности Варфрейма без необходимости выполнять всю последовательность действий вручную.

**Клавиша:** `mAbilityBuffKey`

---

### Energy Drain

Работает в режиме Оператора и быстро расходует его энергию, позволяя активировать мистификатор **«Вечный Натиск»**.

Дополнительно можно включить:

* `AddAbilityED1` — перед опустошением энергии один раз используется способность Оператора для активации мистификатора **«Вечное Искоренение»**.
* `MagusMeltED1` — во время опустошения энергии накапливаются заряды мистификатора **«Расплав Волхва»**.

`MagusMeltED1` может работать некорректно при FPS ниже 100. При его включении процесс опустошения энергии также становится визуально более долгим и заметным.

**Клавиша:** `EnergyDrainKey`

---

### Magus Anomaly

Позволяет постоянно применять эффект мистификатора **«Аномалия Волхва»**.

Режим работы определяется параметром `MagusAnomalySpam`:

* `False` — нажатие клавиши включает функцию, повторное нажатие выключает её.
* `True` — функция работает, пока удерживается клавиша активации.

**Клавиша:** `MagusAnomalyKey`

---

### Cancel Animation

Позволяет практически мгновенно отменять анимацию переноса между Оператором и Варфреймом.

Для корректного срабатывания необходимо стоять **на ровной поверхности**, а непосредственно перед персонажем не должно быть препятствий.

⚠️ Важно: данная механика по сути использует особенности (баги) поведения анимаций в игре. В будущем разработчики Warframe могут исправить это поведение, и тогда функция может перестать работать или работать иначе.

**Клавиша:** `CancelAnimationKey`

---

### Switching Macros

Позволяет быстро переключиться на любой другой макрос из основной папки проекта прямо во время игры.

Вместо того чтобы закрывать текущий макрос, открывать папку проекта и вручную запускать другой файл, достаточно нажать назначенную клавишу и выбрать нужный макрос из появившегося списка.

**Клавиша:** `SwitchingMacrosKey`

---

## Eidolons Shield Calculator

Когда открыт любой макрос проекта, из меню в системном трее можно открыть **Eidolons Shield Calculator**.

Это вспомогательная программа для расчёта урона Оператора по Эйдолонам с учётом различных усилений и условий.

Она может быть полезна при настройке экипировки и проверке того, какой урон будет наносить Оператор при различных комбинациях усилений.

---

## Настройка отдельных макросов

После настройки `Settings.ahk` каждый конкретный макрос может иметь собственные настройки и описание, расположенные в начале соответствующего `.ahk` файла.

В этих разделах обычно указаны параметры поведения макроса, дополнительные опции, описание логики работы и рекомендации по использованию.

Это позволяет настраивать поведение макроса без необходимости редактировать его код.

Если одна и та же настройка присутствует и в конкретном макросе, и в `Settings.ahk`, приоритет всегда имеет значение из конкретного макроса.

Основная клавиша запуска и остановки макросов — `StartKey`, указанная в `Settings.ahk`. Если в конкретном макросе она используется иначе, это отдельно указано в его описании.

---

## Помощь и обратная связь

Если у вас возникли проблемы с установкой, настройкой или использованием макросов, я могу помочь в свободное время.

Вы можете обратиться ко мне на моём Discord-сервере. Если увидите меня онлайн — не стесняйтесь написать:

**Discord:** https://discord.gg/yrRfUMXAnk

Также я могу поделиться и другими своими макросами для Warframe, которые не включены в этот репозиторий. Некоторые из них я не добавлял сюда, потому что считаю их слишком бесполезными для публикации, а некоторые требуют слишком сложной настройки или использования, чтобы имело смысл выкладывать их вместе с полноценным описанием.

Если у вас есть предложения по улучшению существующих макросов или идеи для новых функций — также можете сообщить об этом.

---

## Дисклеймер

Макросы создавались прежде всего для личного использования и могут зависеть от настроек игры, FPS, выбранного снаряжения и других условий.

Перед использованием нового макроса рекомендуется сначала проверить его работу в безопасных условиях и убедиться, что все клавиши в `Settings.ahk` соответствуют вашим настройкам Warframe.

---
# ⚠️ Важно

Отношение разработчиков Warframe к использованию макросов неоднозначное. В некоторых случаях игроки получали блокировки, а служба поддержки отвечала, что использование макросов запрещено. В других случаях представители поддержки заявляли, что они не против некоторой небольшой автоматизации.

Поэтому не существует гарантии, что использование данных макросов не приведёт к блокировке аккаунта. Вы используете их на свой страх и риск.

---

## English

A collection of **AutoHotkey v1** macros for automating various actions in **Warframe**.

This project contains macros specifically for Warframe. It includes both small utility scripts for individual actions and more complex macros for specific missions, Warframes, and game mechanics.

Most macros have their own settings and description at the beginning of the file. Before using them, it is recommended to check `Settings.ahk` — it contains the project's common settings, key bindings, and parameters shared by multiple macros.

---

## Installation

1. Install **AutoHotkey v1**.
2. Download the project archive and extract it.
3. Do not change the folder and file structure inside the archive.
4. Open `Settings.ahk` and configure the keys and other parameters for your game.
5. Run the required `.ahk` file.

Each macro is a separate script and can be run independently from the others.

---

## ⚙️ `Settings.ahk` Configuration

`Settings.ahk` is the main file containing the project's common settings. Proper configuration is important for most macros to work correctly.

### FPS

Set `SettingFPS` to the **minimum FPS** you can get during gameplay when experiencing FPS drops, rather than your average or maximum FPS.

Some macro actions depend on the game's processing speed, so at very low FPS some key presses may not be processed correctly. The macros are designed to work at **60 FPS or higher**.

For example, if you normally have 144 FPS but your FPS can drop to 90 during demanding situations, you should set `SettingFPS` to `90`.

### In-game settings

For all functions to work correctly, all keys from the **In-game settings** section must be assigned to **keyboard keys** in Warframe's controls.

For example, if a macro uses shooting, aiming, or alternate fire, these actions must have keyboard bindings in the game, and the same keys must then be specified in `Settings.ahk`.

Pay special attention to:

* `EmoteAgreeKey`
* `EmoteAgreeKey2`

These represent the same action in the game, but the action must be assigned to **two different keys**.

### Common functions

The **Common functions** section contains additional functions that are available regardless of which main macro is currently running.

Their functionality is described below.

If you do not need a particular function, you can simply leave its key binding empty. The function will then be disabled.

---

# Additional Functions

These functions work **at all times**, regardless of which main macro is currently running.

### Madurai Ability Buff

Quickly switches to Operator mode, activates the Madurai school passive **"Power of the Void"** and the **"Magus Aggress"** Arcane to enhance the next Warframe ability, then returns to the Warframe.

This function is intended to quickly prepare a powerful ability without manually performing the entire sequence.

**Key:** `mAbilityBuffKey`

---

### Energy Drain

Works while in Operator mode and quickly drains Operator energy, allowing the **"Magus Replenish"** Arcane to be activated.

The following options can also be enabled:

* `AddAbilityED1` — uses an Operator ability once before draining energy to activate **"Magus Melt"**.
* `MagusMeltED1` — builds charges of the **"Magus Melt"** Arcane while draining energy.

`MagusMeltED1` may not work correctly below 100 FPS. When enabled, the energy-draining process also becomes visually slower and more noticeable.

**Key:** `EnergyDrainKey`

---

### Magus Anomaly

Allows the effect of the **"Magus Anomaly"** Arcane to be applied continuously.

The way the activation key works is controlled by `MagusAnomalySpam`:

* `False` — press the key to enable the function, press it again to disable it.
* `True` — the function works while the activation key is being held.

**Key:** `MagusAnomalyKey`

---

### Cancel Animation

Allows the transfer animation between Operator and Warframe to be cancelled almost instantly.

For the function to work correctly, you must be standing **on a flat surface**, with no obstacles directly in front of you.

⚠️ **Important:** this mechanic essentially relies on quirks (bugs) in the game's animation behavior. The Warframe developers may fix this behavior in the future, in which case the function may stop working or behave differently.

**Key:** `CancelAnimationKey`

---

### Switching Macros

Allows you to quickly switch to any other macro from the main project folder while in-game.

Instead of closing the current macro, opening the macro folder, and manually launching another file, simply press the assigned key and select the required macro from the displayed list.

**Key:** `SwitchingMacrosKey`

---

## Eidolons Shield Calculator

When any project macro is running, **Eidolons Shield Calculator** can be opened from the system tray menu.

This is a utility for calculating Operator damage against Eidolons while taking different buffs and conditions into account.

It can be useful when configuring your equipment and checking how much damage the Operator will deal with different combinations of buffs.

---

## Individual Macro Settings

After configuring `Settings.ahk`, each individual macro may have its own settings and description located at the beginning of its `.ahk` file.

These sections usually contain the macro's behavior parameters, additional options, usage information, and recommendations.

This allows you to configure the macro's behavior without modifying its code.

If the same setting exists both in a specific macro and in `Settings.ahk`, the value from the **specific macro always takes priority**.

The main key used to start and stop macros is `StartKey`, which is defined in `Settings.ahk`. If a particular macro uses it for a different purpose, this will be stated separately in its description.

---

## Help and Feedback

If you have problems with installing, configuring, or using the macros, I can try to help when I have free time.

You can contact me on my Discord server. If you see me online, feel free to message me:

**Discord:** https://discord.gg/yrRfUMXAnk

**Please note that my English is not very good. I may not be able to help you if you do not speak Russian.** I apologize for the inconvenience.

I can also share other Warframe macros that are not included in this repository. Some of them were left out because I consider them too useless to publish, while others are too complicated to configure or use to make it worthwhile to publish them with a proper description.

If you have suggestions for improving existing macros or ideas for new features, you can also let me know.

---

## Disclaimer

These macros were primarily created for personal use and may depend on your game settings, FPS, selected equipment, and other conditions.

Before using a new macro, it is recommended to test it in a safe environment and make sure that all keys in `Settings.ahk` match your Warframe settings.

---

# ⚠️ Important

The Warframe developers' stance on the use of macros is somewhat unclear. In some cases, players have received bans, with Support stating that macros are not allowed. In other cases, Support representatives have said that they are not against some limited automation.

Therefore, there is no guarantee that using these macros will not result in an account ban. You use them entirely at your own risk.

