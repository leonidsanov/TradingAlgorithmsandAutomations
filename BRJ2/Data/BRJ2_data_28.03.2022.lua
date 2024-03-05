-- ������ ������ ���� ������ ������� ��������� ��������� � ����. ������ ����������� � ����������� ����������.
CLASS_CODE				= "SPBFUT";			-- ����� ������
SEC_CODE				= "BRJ2";			-- ��� ������
interval				= INTERVAL_M5 		-- � ������ ������ �������� 1 ������
------------------
-- ���� ������� --
------------------
function OnInit() 				-- � ������ ������� ������������ ����� ����������� ���������������� ��� ����������� ���������� � ���������� ����� �������� ��������� ������ main()
	IsRun = true; 				-- ���������� ���������� ����������� ����, ������� ����� �������� true �� ������� ������� ������ ������������
end;
function main()
	while IsRun do
		if os.sysdate().sec == 30 then 			-- ������ 15 ������ ��������� ���� � �������, ����������� � ������� (��������!), ������� ���� ������ � ������� �� ������ ���� ����� ������ ���� ���� � ��������� ���� ������
			CSV = io.open(getScriptPath().."/BRJ2_Data.csv", "w"); -- �������, ��� ��������� ��� ������/���������� ���� CSV � ��� �� ����� � ������ � ������������ ������, ����������� �������� ������������ ����� � ��������� ����� ����� (����������), ��� ��������� ������ ������
			local Position = CSV:seek("end",0); 	-- ������ � ����� �����, �������� ����� �������
			if Position == 0 then 					-- ���� ������� � ������, ��
				local Header = "Date,Time,Open,High,Low,Close,Volume\n" -- ������� ������ � ����������� ��������
				ds, Error = CreateDataSource (CLASS_CODE, SEC_CODE, interval)
				CSV:write(Header); 					-- ��������� ������ ���������� � ����
				CSV:flush(); 						-- ��������� ��������� � �����
			end;
			ds, Error = CreateDataSource (CLASS_CODE, SEC_CODE, interval); 		 -- ������� ������� �� ����� ������� ������� ���������, ������ � ����;
			local try_count = 0 												 -- ������������ ���������� ������� (�������) �������� ��������� ������ �� �������;
			while ds:Size() == 0 and try_count < 1000 do 						 -- ���� ���� �� ������� ������ �� �������, ���� ���� �� ���������� ����� �������� (���������� �������)
				sleep(100)
				try_count = try_count + 1
			end
			if error_desc ~= nil and error_desc ~= "" then 						 -- ���� �� ������� ������ ������, �� ������� �� � ������� ����������
				message("������ ��������� ������� ������:" .. error_desc)
				return 0
			end
			Size = ds:Size()
			for i=Size, 1, -1 do
				CSV:write(tostring(ds:T(i).year)..'-'..tostring(ds:T(i).month)..'-'..tostring(ds:T(i).day)..','..tostring(ds:T(i).hour)..':'..tostring(ds:T(i).min)..','..tostring(ds:O(i))..','..tostring(ds:H(i))..','..tostring(ds:L(i))..','..tostring(ds:C(i))..','..tostring(ds:V(i)), "\n"); -- ��������� ������ ������
			end;
			ds:SetEmptyCallback();--]
			CSV:close();
			--message('��������! ������ ���������!') -- ��� ������������� ���������������� ������ ������
			sleep(2000)
		end
	end;
end

function OnStop()
	IsRun = false;
	return 2000
end;