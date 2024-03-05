-- Запись данных всех свечей графика заданного интервала в файл. Запись выполняется с определённым интервалом.
CLASS_CODE				= "SPBFUT";			-- Класс бумаги
SEC_CODE				= "BRJ2";			-- Код бумаги
interval				= INTERVAL_M5 		-- В данный момент интервал 1 минута
------------------
-- Тело скрипта --
------------------
function OnInit() 				-- В данной функции пользователь имеет возможность инициализировать все необходимые переменные и библиотеки перед запуском основного потока main()
	IsRun = true; 				-- Глобальная переменная логического типа, которая имеет значение true до момента нажатия кнопки «Остановить»
end;
function main()
	while IsRun do
		if os.sysdate().sec == 30 then 			-- Каждые 15 секунд обновляет файл с данными, полученными с сервера (внимание!), поэтому если данные с сервера не пришли файл будет пустой даже если в терминале есть график
			CSV = io.open(getScriptPath().."/BRJ2_Data.csv", "w"); -- Создает, или открывает для чтения/добавления файл CSV в той же папке в режиме с возможностью записи, позволяющий изменять существующие файлы и создавать новые файлы (нечитаемые), где находится данный скрипт
			local Position = CSV:seek("end",0); 	-- Встает в конец файла, получает номер позиции
			if Position == 0 then 					-- Если позиция в начале, то
				local Header = "Date,Time,Open,High,Low,Close,Volume\n" -- Создает строку с заголовками столбцов
				ds, Error = CreateDataSource (CLASS_CODE, SEC_CODE, interval)
				CSV:write(Header); 					-- Добавляет строку заголовков в файл
				CSV:flush(); 						-- Сохраняет изменения в файле
			end;
			ds, Error = CreateDataSource (CLASS_CODE, SEC_CODE, interval); 		 -- Создаем таблицу со всеми свечами нужного интервала, класса и кода;
			local try_count = 0 												 -- Ограничиваем количество попыток (времени) ожидания получения данных от сервера;
			while ds:Size() == 0 and try_count < 1000 do 						 -- Ждем пока не получим данные от сервера, либо пока не закончится время ожидания (количество попыток)
				sleep(100)
				try_count = try_count + 1
			end
			if error_desc ~= nil and error_desc ~= "" then 						 -- Если от сервера пришла ошибка, то выведем ее и прервем выполнение
				message("Ошибка получения таблицы свечей:" .. error_desc)
				return 0
			end
			Size = ds:Size()
			for i=Size, 1, -1 do
				CSV:write(tostring(ds:T(i).year)..'-'..tostring(ds:T(i).month)..'-'..tostring(ds:T(i).day)..','..tostring(ds:T(i).hour)..':'..tostring(ds:T(i).min)..','..tostring(ds:O(i))..','..tostring(ds:H(i))..','..tostring(ds:L(i))..','..tostring(ds:C(i))..','..tostring(ds:V(i)), "\n"); -- последняя строка сверху
			end;
			ds:SetEmptyCallback();--]
			CSV:close();
			--message('Внимание! Данные обновлены!') -- При необходимости закомментировать данную строку
			sleep(2000)
		end
	end;
end

function OnStop()
	IsRun = false;
	return 2000
end;