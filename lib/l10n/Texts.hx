package l10n;

import js.Browser;
import js.Syntax;

/**
 * Текстовое хранилище.
 * Класс содержит все локализованные тексты приложения в одном месте.
 *   1. Словари `Dictionary` с исходными текстами предварительно необходимо добавить вызовом метода: `add()`.
 *   2. Вы можете добавлять новые словари или изменять тексты уже добавленных в любое время.
 */
class Texts
{
    /**
     * Создать текстовое хранилище.
     */
    public function new() {
    }



    ////////////////
    //   STATIC   //
    ////////////////

    /**
     * Глобальное хранилище всех текстов по умолчанию.
     * - Является общим хранилищем для всей web страницы, хранится в: `window.texts`.
     * - Хранилище инициализируется при первом доступе к нему.
     * - Через это свойство вы можете получить доступ к ресурсам, загруженных **другим** Haxe/JS приложением.
     * 
     * Не может быть `null`
     */
    static public var shared(get, never):Texts;

    static function get_shared():Texts {
        var v:Texts = untyped Browser.window.texts;
        if (v == null) {
            v = new Texts();
            untyped Browser.window.texts = v;
        }

        return v;
    }

    /**
     * Прочитать данные локализации.
     * Парсит переданные данные в формате CSV и возвращает локализацию.
     * 
     * Описание формата:
     * - Строки, начинающиеся с символа # - игнорируются. (Это комментарии)
     * - Одна строка - одна текстовая фраза. (Если вам нужен перенос в тексте, используйте: `\n`)
     * - Первая запятая в строке интерпретируется как разделитель ключа и текстовой фразы, последующие запятые игнорируются.
     * - Ключ текстовой фразы должен быть положительным, целым числом: `unsigned Int32`.
     * - Пустые строки или строки с некорректным ключом - игнорируются.
     * 
     * Пример текстовой фразы:
     * ``
     * 100,Привет {0}, как у тебя дела?\nЯ сегодня поужинал.
     * ``
     * @param data Данные в формате CSV.
     * @param sep Разделитель ШВ фразы и её текста. (Можно изменить при необходимости)
     * @return Словарь с текстами.
     */
    static public function parse(data:String, sep:String = ","):Dictionary {
        var dic:Dictionary = {};
        if (data == null)
            return dic;
        
        var i = 0;
        while (i < data.length) {
            var n = data.indexOf("\n", i);
            if (n == -1)
                n = data.length;
            
            // Пропуск комментария:
            if (data.charAt(i) == "#") {
                i = n + 1;
                continue;
            }

            // Строка:
            var row = data.substring(i, n);

            // Пропуск строки без разделителя:
            var s = row.indexOf(sep);
            if (s == -1) {
                i = n + 1;
                continue;
            }
            
            // Получаем ID:
            var id = Syntax.code("parseInt({0}, 10);", row.substring(0, s));
            if (id > 0) // <-- Проверка на: 0, NaN, null и т.п.
                dic[id] = row.substring(s + 1).split("\\n").join("\n");
            
            i = n + 1;
        }

        return dic; 
    }

    /**
     * Получить текст.
     * Возвращает локализованный текст или указанное значение `none`, если текста с таким ID не найдено. (Может быть `null`)
     * 
     * Краткая форма записи для вызова: `Texts.shared.at(id, none, values, localization);`.
     */
    static public inline function get(id:Int, none:String = null, values:Array<String> = null, localization:LocalizationID = null):String {
        return Texts.shared.at(id, none, values, localization);
    }



    ////////////////
    //   PARAMS   //
    ////////////////

    /**
     * Используемая локализация.
     * Влияет на то, какой текст будет возвращаться в ответ на вызов методов: `at()` и `Texts.get()`.
     * 
     * По умолчанию: `en`.
     */
    public var localization:LocalizationID = "en";

    /**
     * Тексты этого хранилища.
     * Это хеш мапа с ключом `LocalizationID` и значением `Dictionary`.
     * Содержит словари с текстами для каждой локализации.
     * 
     * *Прим. Доступ предоставлен для удобства.*
     * 
     * Не может быть `null`.
     */
    public var data(default, null):Dynamic = {};

    
    
    /////////////////
    //   METHODS   //
    /////////////////

    /**
     * Добавить слова.
     * Заносит в словарь указанной локализации новые текстовые данные, обновляет старые.
     * - Тексты с одинаковым ID заменяются.
     * - Этот метод не изменяет переданный `dictionary`.
     * @param dictionary Словарь текстовых сообщений.
     * @param localization ID Локализации.
     */
     public function add(dictionary:Dictionary, localization:LocalizationID):Void {
        if (dictionary == null || localization == null)
            return;

        var dic:Dictionary = data[untyped localization];
        if (dic == dictionary)
            return;

        if (dic == null) {
            dic = {};
            data[untyped localization] = dictionary;
        }
        
        Syntax.code("for (var key in {0}) { {1}[key] = {0}[key]; }", dictionary, dic);
    }


    /**
     * Получить текст.
     * Возвращает локализованный текст или указанное значение `none`, если текста с таким ID не найдено. (Может быть `null`)
     * 
     * Пример использования и подстановки значений:
     * ```
     * var s = "Привет {0}, тебе сегодня исполнилось {1}?";
     * trace(Texts.get(0, s, ["Артём", "12"])); // Привет Артём, тебе сегодня исполнилось 12?
     * ```
     * @param id ID Текстового сообщения в словаре.
     * @param none Текстовое сообщение, возвращаемое в случае отсутствия запрошенного.
     * @param values Подставляемые значения. Этот механизм работает аналогично хаксовому API.
     * В текстовые вставки вида: `{0}`, `{1}` подставляются указанные значения из values в соответствий с их нумерацией.
     * Строка не анализируется, если этот аргумент равен `null`.
     * @param localization Выбор локализации. По умолчанию: `localization`.
     * @return Текстовое сообщение.
     */
    public function at(id:Int, none:String = null, values:Array<String> = null, localization:LocalizationID = null):String {
        var dic:Dictionary;
        if (localization == null)
            dic = data[untyped this.localization];
        else
            dic = data[untyped localization];

        var str:String;
        if (dic == null) {
            if (none == null)
                return null;
            
            str = none;
        }
        else {
            str = dic[id];

            if (str == null) {
                if (none == null)
                    return null;
                else 
                    str = none;
            }
        }
        
        if (values == null)
            return str;
        
        var i:Int = 0;
        while (true) {
            var s = str.indexOf("{", i);
            if (s == -1)
                return str;
            
            var e = str.indexOf("}", s);
            if (e == -1)
                return str;

            var index:Int = Syntax.code("parseInt({0}, 10);", str.substring(s + 1, e));
            if (index >= 0) { // <-- Это число, а не null, NaN или т.п.
                if (index < values.length) { // <-- Для этого индекса есть значение
                    str = str.substring(0, s) + values[index] + str.substring(e + 1);
                    i += values[index].length;
                }
                else {
                    str = str.substring(0, s) + str.substring(e + 1);
                }
            }
            else {
                i = e + 1;
            }
        }

        return str;
    }
}