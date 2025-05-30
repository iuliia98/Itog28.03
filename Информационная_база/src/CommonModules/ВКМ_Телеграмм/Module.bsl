#Область ПрограммныйИнтерфейс

Процедура ОтправитьСообщенияВТелеграмм() Экспорт
	
	//8004028661:AAFnBpAd1lMuGEq2IVh3W2z7Kua16ri-KI0

	ТокенБота = Константы.ВКМ_ТокенУправленияТелеграмБотом.Получить();
	
	Если Не ЗначениеЗаполнено(ТокенБота) Тогда
		
       ТекстСообщения = "Установите токен управления телеграмм-ботом в константе";
			
	   ОбщегоНазначения.СообщитьПользователю(ТекстСообщения);	
		
	   Возврат;
		
	КонецЕсли;
	
	//-1002301388183
	ИдентификаторГруппы = Константы.ВКМ_ИдентификаторГруппыДляОповещения.Получить();
	
	Если Не ЗначениеЗаполнено(ИдентификаторГруппы) Тогда
		
		ТекстСообщения = "Установите идентификатор группы в константе";
			
	    ОбщегоНазначения.СообщитьПользователю(ТекстСообщения);	
	    
		Возврат;
		
	КонецЕсли;
	
	Выборка = ПолучитьСообщениеДляТгБота();
		
	Пока Выборка.Следующий() Цикл
		
		Ответ = ОтправитьСообщениеВТелеграмм(Выборка.ТекстСообщения, ТокенБота, ИдентификаторГруппы);
		
		//Объект = Выборка.Ссылка.ПолучитьОбъект();
        //Объект.Удалить(); 
		
		Если Ответ = Неопределено Тогда
			
			Продолжить;	
			
		КонецЕсли; 
		
		Если Ответ.КодСостояния = 200 Тогда
			
			УведомлениеОбъект = Выборка.Ссылка.ПолучитьОбъект();	
			УведомлениеОбъект.Удалить();
			
		Иначе
			
			ОписаниеОшибки = Ответ.ПолучитьТелоКакСтроку();	
			ЖурналРегистрации.ДобавитьСообщениеДляЖурналаРегистрации(УровеньЖурналаРегистрации.Ошибка,,,ОписаниеОшибки);
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ОтправитьСообщениеВТелеграмм(Знач ТекстСообщения, Знач ТокенБота, Знач ИдентификаторГруппы)
	
	Ответ = Неопределено;
	
	Попытка 
		
		ЗащищенноеСоединение = Новый ЗащищенноеСоединениеOpenSSL();
		Соединение = Новый HTTPСоединение("api.telegram.org",443,,,,,ЗащищенноеСоединение);
		
		
		ДанныеСообщения = Новый Структура;
		ДанныеСообщения.Вставить("chat_id",ИдентификаторГруппы);
		ДанныеСообщения.Вставить("text",ТекстСообщения);
		
		ЗаписьJSON = Новый ЗаписьJSON;
		ЗаписьJSON.УстановитьСтроку();
		ЗаписатьJSON(ЗаписьJSON,ДанныеСообщения);
		СообщениеДляОтправки = ЗаписьJSON.Закрыть();
		
		Заголовки = Новый Соответствие;
		Заголовки.Вставить("content-type", "application/json");
		
		HTTPЗапрос = Новый HTTPЗапрос("bot"+ ТокенБота + "/sendMessage", Заголовки);
		HTTPЗапрос.УстановитьТелоИзСтроки(СообщениеДляОтправки);
		Ответ = Соединение.ОтправитьДляОбработки(HTTPЗапрос);
		
	Исключение
		
		ЖурналРегистрации.ДобавитьСообщениеДляЖурналаРегистрации(УровеньЖурналаРегистрации.Ошибка,,,ОписаниеОшибки());		
		Возврат Неопределено;
		
	КонецПопытки;
	
		Возврат Ответ;
		
КонецФункции

Функция ПолучитьСообщениеДляТгБота()
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	ВКМ_СообщенияДляТгБота.Ссылка,
	|	ВКМ_СообщенияДляТгБота.ТекстСообщения
	|ИЗ
	|	Справочник.ВКМ_СообщенияДляТгБота КАК ВКМ_СообщенияДляТгБота";

	
	Возврат Запрос.Выполнить().Выбрать();
	
КонецФункции

#КонецОбласти 

