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