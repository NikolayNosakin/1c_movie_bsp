﻿
Процедура ОбновитьФильмНаСервере(Кино) Экспорт
	
	API_KEY = Константы.kinopoisk_unofficial_api_token.Получить();
	Если API_KEY = "" Тогда
		Сообщить("Ошибка. Ключ АПИ для подключения не заполнен.");
		Возврат;
	КонецЕсли;	
	АдресСервера = "kinopoiskapiunofficial.tech";
	api = "api/v2.2/films/" + Кино.КодКинопоиск;
	HTTPЗапрос = Новый HTTPЗапрос;                                                               
	HTTPЗапрос.АдресРесурса = api;
	HTTPЗапрос.Заголовки.Вставить("X-API-KEY", API_KEY);
	HTTPЗапрос.Заголовки.Вставить("Content-Type", "application/json");
	
	Соединение = Новый HTTPСоединение(АдресСервера,,,,,, Новый ЗащищенноеСоединениеOpenSSL());
	
	ОшибкаСообщение = "";
	Ошибка = Ложь;	
	Попытка 
		ОтветHTTP = Соединение.Получить(HTTPЗапрос)
	Исключение
		Попытка
			ОтветHTTP = Соединение.ОтправитьДляОбработки(HTTPЗапрос);
		Исключение
			ОшибкаСообщение = ОписаниеОшибки() + Символы.ПС;
			Сообщить(ОшибкаСообщение);
			Ошибка = Истина;
		КонецПопытки;
	КонецПопытки;
	
	Если НЕ Ошибка Тогда
		Ответ = ОтветHTTP.ПолучитьТелоКакСтроку();					
		Попытка
			ОбновитьДанныеФильма(Ответ,Кино);
		Исключение КонецПопытки;
	КонецЕсли;
	
КонецПроцедуры 

Функция НайтиСоздатьСтрану(НазваниеСтраны)
	Страна = Справочники.Страны.НайтиПоНаименованию(НазваниеСтраны);
	Если страна.Пустая() Тогда
		об = Справочники.Страны.СоздатьЭлемент();
		Об.Наименование = НазваниеСтраны;
		об.Записать();
		Страна = об.Ссылка;
	КонецЕсли;
	Возврат Страна;
КонецФункции

Функция НайтиСоздатьЖанр(НазваниеЖанра)
	Жанр = Справочники.Жанры.НайтиПоНаименованию(НазваниеЖанра);
	Если Жанр.Пустая() Тогда
		об = Справочники.Жанры.СоздатьЭлемент();
		Об.Наименование = НазваниеЖанра;
		об.Записать();
		Жанр = об.Ссылка;
	КонецЕсли;
	Возврат Жанр;
КонецФункции

Процедура ОбновитьДанныеФильма(json,Кино)
	
	ЧтениеJson = Новый ЧтениеJson;
	ЧтениеJson.УстановитьСтроку(json);
	
	Данные = ПрочитатьJson(ЧтениеJson);
	
	Об = Кино;
	Об.Наименование = ?(Данные.nameRu = Неопределено или Данные.nameRu = "", Данные.nameOriginal,Данные.nameRu);
	Об.КодIMDB = Данные.imdbId;
	Об.Описание = Данные.description;
	Об.ГодВыпуска = Данные;	
	Об.ОригинальноеНазвание = Данные.nameOriginal;
	Об.ГодВыпуска = Формат(Данные.year, "ЧГ=100");
	Об.Страны.Очистить();
	Для каждого стрСтраны Из Данные.countries ЦИкл
		стр = Об.Страны.Добавить();
		стр.Страна = НайтиСоздатьСтрану(стрСтраны.country);	
	КонецЦикла;	
	
	Об.Жанры.Очистить();
	Для каждого стрСтраны Из Данные.genres ЦИкл
		стр = Об.Жанры.Добавить();
		стр.Жанр = НайтиСоздатьЖанр(стрСтраны.genre);	
	КонецЦикла;
	
	Если Данные.type = "FILM" ТОгда 	
		Об.Тип = Перечисления.ТипыКино.Фильм;
	ИначеЕсли Данные.type = "TV_SERIES" ТОгда
		Об.Тип = Перечисления.ТипыКино.Сериал; 
		Об.ГодОкончания = Формат(Данные.endYear, "ЧГ=100");
	КонецЕсли;		
	
КонецПроцедуры
  
Процедура ОбновитьСезоныСерииНаСервере(Кино) Экспорт
	
	API_KEY = Константы.kinopoisk_unofficial_api_token.Получить();
	Если API_KEY = "" Тогда
		Сообщить("Ошибка. Ключ АПИ для подключения не заполнен.");
		Возврат;
	КонецЕсли;	
	АдресСервера = "kinopoiskapiunofficial.tech";
	api = "api/v2.2/films/" + Кино.КодКинопоиск + "/seasons";
	HTTPЗапрос = Новый HTTPЗапрос;                                                               
	HTTPЗапрос.АдресРесурса = api;
	HTTPЗапрос.Заголовки.Вставить("X-API-KEY", API_KEY);
	HTTPЗапрос.Заголовки.Вставить("Content-Type", "application/json");
	
	Соединение = Новый HTTPСоединение(АдресСервера,,,,,, Новый ЗащищенноеСоединениеOpenSSL());
	
	ОшибкаСообщение = "";
	Ошибка = Ложь;	
	Попытка 
		ОтветHTTP = Соединение.Получить(HTTPЗапрос)
	Исключение
		Попытка
			ОтветHTTP = Соединение.ОтправитьДляОбработки(HTTPЗапрос);
		Исключение
			ОшибкаСообщение = ОписаниеОшибки() + Символы.ПС;
			Сообщить(ОшибкаСообщение);
			Ошибка = Истина;
		КонецПопытки;
	КонецПопытки;
	
	Если НЕ Ошибка Тогда
		Ответ = ОтветHTTP.ПолучитьТелоКакСтроку();					
		Попытка
			ОбновитьДанныеСериала(Ответ,Кино);
		Исключение КонецПопытки;
	КонецЕсли;
	
КонецПроцедуры 

Процедура ОбновитьДанныеСериала(json,Кино)
	
	ЧтениеJson = Новый ЧтениеJson;
	ЧтениеJson.УстановитьСтроку(json);	
	Данные = ПрочитатьJson(ЧтениеJson);	
	Кино.КоличествоСезонов = Данные.total;
	
	Для каждого стрСезоны из Данные.items Цикл
		
		Сезон = стрСезоны.number;
		Для каждого стрСерии Из стрСезоны.episodes Цикл
			Отбор = Новый Структура;
			Отбор.Вставить("Сезон", Строка(Сезон));
			Отбор.Вставить("Серия", Строка(стрСерии.episodeNumber));			
			НайденныеСтроки = Кино.Серии.НайтиСтроки(Отбор);
			Если НайденныеСтроки.Количество() Тогда
				Строка = НайденныеСтроки[0];
			Иначе
				Строка = Кино.Серии.Добавить();
			КонецЕсли;
			Строка.Сезон = Сезон;
			Строка.Серия = стрСерии.episodeNumber;
			Строка.Описание = стрСерии.synopsis;
			Строка.НазваниеСерии = ?(стрСерии.nameRu = "",стрСерии.nameEn,стрСерии.nameRu);
			Попытка
				Строка.ДатаВыходаСерии = Дата(СтрЗаменить(стрСерии.releaseDate,"-",""));
			Исключение КонецПопытки;                                                		
		КонецЦикла;
		
	КонецЦикла;
	
КонецПроцедуры