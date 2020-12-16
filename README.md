# Haxe пакет управления локализацией для WEB

Описание
------------------------------

Небольшой пакет для управления локализацией в web проекте.
Используется для:
1. Удобного управления текстовыми данными на разных языках. 
2. Хранения текстовых данных в отдельных файлах. (Парсинг CSV)
3. Простой и быстрый способ переключения локализации исходных текстов.
4. Расшаривание доступа к текстовым данным для любого Haxe приложения в рамках одной web страницы.
5. Возможность подстановки значений в исходном тексте. (Аля Haxe API)

**L10n** - Сокращённая аббревиатура от localization.

Как использовать
------------------------------

```
package;

import l10n.Dictionary;
import l10n.Texts;

class Main {
    static public function main() {
        
        // Русские тексты:
        var ru:Dictionary = {};
        ru[1] = "Привет";
        ru[2] = "Ты любишь булочки, {0}?";

        // Английские тексты:
        var en:Dictionary = {};
        en[1] = "Hello";
        en[2] = "Do you like buns, {0}?";
        
        // Китайские тексты: (Из внешнего файла)
        var zh = Texts.parse(   "#Comments\n" + 
                                "1,你好\n" +
                                "2,你喜欢包子吗，{0}}？\n"

        );

        // Добавление локализаций:
        Texts.shared.add(ru, "ru");
        Texts.shared.add(en, "en");
        Texts.shared.add(zh, "zh");

        // Вывод на английском: (По умолчанию)
        trace(Texts.get(1));                        // Hello
        trace(Texts.get(2, "", ["Костя"]));         // Do you like buns, Костя?

        // Вывод на русском: (Переключение)
        Texts.shared.localization = "ru";
        trace(Texts.get(1));                        // Привет
        trace(Texts.get(2, "", ["Костя"]));         // Ты любишь булочки, Костя?

        // Вывод с указанием конкретной локализации:
        trace(Texts.get(1, "", null, "zh"));        // 你好
        trace(Texts.get(2, "", ["Костя"], "zh"));   // 你喜欢包子吗，Костя}？
    }
}
```

Подключение в Haxe
------------------------------

1. Установите haxelib, чтобы можно было использовать библиотеки Haxe.
2. Выполните в терминале команду, чтобы установить библиотеку webl10n глобально себе на локальную машину:
```
haxelib git l10n https://github.com/VolkovRA/WebL10n.git master
```
Синтаксис команды:
```
haxelib git [project-name] [git-clone-path] [branch]
haxelib git minject https://github.com/massiveinteractive/minject.git         # Use HTTP git path.
haxelib git minject git@github.com:massiveinteractive/minject.git             # Use SSH git path.
haxelib git minject git@github.com:massiveinteractive/minject.git v2          # Checkout branch or tag `v2`.
```
3. Добавьте в свой проект библиотеку l10n, чтобы использовать её в коде. Если вы используете HaxeDevelop, то просто добавьте в файл .hxproj запись:
```
<haxelib>
	<library name="l10n" />
</haxelib>
```

Смотрите дополнительную информацию:
 * [Документация Haxelib](https://lib.haxe.org/documentation/using-haxelib/ "Using Haxelib")
 * [Документация HaxeDevelop](https://haxedevelop.org/configure-haxe.html "Configure Haxe")
 * [Localization wiki](https://en.wikipedia.org/wiki/Internationalization_and_localization "Internationalization and localization")