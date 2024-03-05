--[[������ ��������� � ��������� ������� �� ����� signal.txt � �������� ����������
��� ������ ������ � ��������� QUIK ������ ���� ������� ��������� �������:
1. "������� �����";
2. "���������" �� ������� �����������;
3. "������� �� ���������� ������ (��������)"
������ �������� � ���������� � ��� ����� ����������� ���������� ��������������� ������� �������� �������� SEC_CODE �����!!!!!!!!!!!!!!!
--]]
--------------------------
-- ��������� ���������� --
--------------------------
ACCOUNT 				= "A714iyi";		-- ����� ��������� ����� ��������.
CLIENT_CODE 			= "4001SC7";		-- ��� �������.
CLASS_CODE				= "SPBFUT";			-- ����� �����������.
SEC_CODE				= "BRJ2";			-- ��� �����������.
TRANS_ID 				= os.time();		-- ������� ���� � ����� � �������� ������ �������� ��� ���������� ������� ����������.
firm_id 				= "SPBFUT01" 		-- �����.
------------------
-- ���� ������� --
------------------
function OnInit() 				-- � ������ ������� ������������ ����� ����������� ���������������� ��� ����������� ���������� � ���������� ����� �������� ��������� ������ main()
	IsRun = true; 				-- ���������� ���������� ����������� ����, ������� ����� �������� true �� ������� ������� ������ ������������
end--]]

function main() 															-- ������� �������
	while IsRun do 															-- ���������� ����������� ����, � �������...
		if os.sysdate().sec == 50 then 										-- ������ 50-� �������...
			open_signal = io.open(getScriptPath().."/signal.txt", "r"); 	-- ����������� ��� ������ � ����� �� �������� ���� txt
			signal = tonumber(open_signal:read('*all')) 					-- �� ����� ����������� ������ �� ��������� ������� � ��� �������� ������������� ���������� signal
			open_signal:close();
			BST = 1 														-- (Ban on sending transactions) ������ �� �������� ���������� (���� 1, �� �����, ���� 0, �� ������)
-------------------
-- ������� ����� --
-------------------
			tradingStatus 	= tonumber(getParamEx(CLASS_CODE, SEC_CODE, "TRADINGSTATUS").param_value) 	 -- �������� "��������� ������" � ��������� � ����������
			sec_price_step 	= tonumber(getParamEx(CLASS_CODE, SEC_CODE, "SEC_PRICE_STEP").param_value) 	 -- ��� ����
------------------------
-- ���������� ������� --
------------------------
			total_net 		= tonumber(getFuturesHolding(firm_id, ACCOUNT, SEC_CODE, 0).totalnet) 		 -- ������� ������ ������� (��� �������� �����). ���� �������� 0, �� �������� ������� ���, ���� ������ ���� (������������� ��������), �� ������� �������� �������, ������ ���� - �������
		end;
		sleep(100)
	end;
end;

---------------
-- ��������� --
---------------
function OnQuote(CLASS_CODE, SEC_CODE) 									-- ������� ���������� ���������� QUIK ��� ��������� ��������� ������� ���������
	if tradingStatus == 1 												-- ���� ������ ������ "���������"
		then ql2 = getQuoteLevel2(CLASS_CODE, SEC_CODE); 				-- �� �������� ������ �� ���������� ������ � �����������
		message('������: '..tostring(signal)..', ������ �������: '..tostring(total_net)..', BST: '..tostring(BST)) -- ��� ������������� ��������� ��� ������� ��������/�������� �������
		average_bid_qty = ( 											-- ������� � ������� ������� �������� ���� ������ �� ������� � �����
		tonumber(ql2.bid[1].quantity) +
		tonumber(ql2.bid[2].quantity) +
		tonumber(ql2.bid[3].quantity) +
		tonumber(ql2.bid[4].quantity) +
		tonumber(ql2.bid[5].quantity) +
		tonumber(ql2.bid[6].quantity) +
		tonumber(ql2.bid[7].quantity) +
		tonumber(ql2.bid[8].quantity) +
		tonumber(ql2.bid[9].quantity) +
		tonumber(ql2.bid[10].quantity) +
		tonumber(ql2.bid[11].quantity) +
		tonumber(ql2.bid[12].quantity) +
		tonumber(ql2.bid[13].quantity) +
		tonumber(ql2.bid[14].quantity) +
		tonumber(ql2.bid[15].quantity) +
		tonumber(ql2.bid[16].quantity) +
		tonumber(ql2.bid[17].quantity) +
		tonumber(ql2.bid[18].quantity) +
		tonumber(ql2.bid[19].quantity) +
		tonumber(ql2.bid[20].quantity)
		)/20;
		average_offer_qty = ( 											-- ������� � ������� ������� �������� ���� ������ �� ������� � �����
		tonumber(ql2.offer[1].quantity) +
		tonumber(ql2.offer[2].quantity) +
		tonumber(ql2.offer[3].quantity) +
		tonumber(ql2.offer[4].quantity) +
		tonumber(ql2.offer[5].quantity) +
		tonumber(ql2.offer[6].quantity) +
		tonumber(ql2.offer[7].quantity) +
		tonumber(ql2.offer[8].quantity) +
		tonumber(ql2.offer[9].quantity) +
		tonumber(ql2.offer[10].quantity) +
		tonumber(ql2.offer[11].quantity) +
		tonumber(ql2.offer[12].quantity) +
		tonumber(ql2.offer[13].quantity) +
		tonumber(ql2.offer[14].quantity) +
		tonumber(ql2.offer[15].quantity) +
		tonumber(ql2.offer[16].quantity) +
		tonumber(ql2.offer[17].quantity) +
		tonumber(ql2.offer[18].quantity) +
		tonumber(ql2.offer[19].quantity) +
		tonumber(ql2.offer[20].quantity)
		)/20;
-------------
-- ������� --
-------------
				if (signal == 1 																					-- ���� ������� ������ �� �������, �.�. +1
					and average_bid_qty > average_offer_qty 														-- � ������� �������� ���� ������ �� ������� ������ �������� �������� ���� ������ �� �������
					and tonumber(ql2.bid[tonumber(ql2.bid_count)].quantity) > average_bid_qty 						-- � ���������� ������ �� ������ ���� ����������� ���� ��������
					and (BST == 1) 																					-- � ��������� ���������� ������
					and total_net == 0) 																			-- � ��� �������� ������
				then 																								-- ��
					qty, comiss = CalcBuySell(CLASS_CODE, SEC_CODE, CLIENT_CODE, ACCOUNT, tonumber(getParamEx(CLASS_CODE, SEC_CODE, "BID").param_value), true, false) -- ������� ������������� ��� ������� ����������� ���������� ���������� ����� � ������
					price = tonumber(ql2.bid[tonumber(ql2.bid_count)].price) + sec_price_step 			-- ���� ������������ �������� ������ �� ���� ��� ���� ���� bid. ������ math.modf �� ����������, �. �. ���� ����� ������� �����
					operation = 'B' 																				-- ������ �� �������
					new_quantity = 1 --tonumber(qty) 																	-- ���������� ����� ����� ����������� ���������� (���� ��� ����� �� ������ � �������� ������������� �����, �.�. ����� ��������� ��������� ������, ��������� ��������� ������ ����������� ������ ������ ���� ���������)
					OpenPos(); 																						-- ���������� ������ �� �������
					message('������� �� ����: '..tostring(price)..', ������: '..tostring(signal)..', ������ �������: '..tostring(total_net))
------------------------------------------
-- ����������� �������/������ � ������� --
------------------------------------------
				-- ���� �� ����� ������������ ������ �������� ������ ��������������� ��������� ��� ������
				elseif (--signal == 1 																				-- ����� ���� ������� ������ �� �������, �.�. +1
					-- ���� �� ����� ������������ ������� �������� ������ ��������������� ��������� ��� ������
					--and 
					average_bid_qty > average_offer_qty 														-- � ������� �������� ���� ������ �� ������� ������ �������� �������� ���� ������ �� �������
					and tonumber(ql2.bid[tonumber(ql2.bid_count)].quantity) > average_bid_qty 						-- � ���������� ������ �� ������ ���� ����������� ���� ��������
					and (BST == 1) 																					-- � ��������� ���������� ������
					and total_net < 0) 																				-- � ������� �������� �������
				then 																								-- ��
					price = tonumber(ql2.bid[tonumber(ql2.bid_count)].price) + sec_price_step 			-- ���� ������������ �������� ������ �� ���� ��� ���� ���� bid. ������ math.modf �� ����������, �. �. ���� ����� ������� �����
					operation = 'B' 																				-- ������ �� �������
					new_quantity = math.abs(total_net) --* 2 																-- ���������� ����� ����� ������ ����������� ������� ������� (�������� �������� �� 2, ����� ����� ��������� ����� �������)
					OpenPos(); 																						-- ���������� ������ �� �������
					message("�������� ������� "..tostring(price)..', ������: '..tostring(signal)..', ������ �������: '..tostring(total_net))
-------------
-- ������� --
-------------
				elseif (signal == -1 																				-- ����� ���� ������� ������ �� �������, �.�. -1
					and average_offer_qty > average_bid_qty 														-- � ������� �������� ���� ������ �� ������� ������ �������� �������� ���� ������ �� �������
					and tonumber(ql2.offer[1].quantity) > average_offer_qty 										-- � ���������� ������ �� ������ ���� ������ ���� ��������
					and (BST == 1) 																					-- � ��������� ���������� ������
					and total_net == 0) 																			-- � ��� �������� ������
				then 																								-- ��
					qty, comiss = CalcBuySell(CLASS_CODE, SEC_CODE, CLIENT_CODE, ACCOUNT, tonumber(getParamEx(CLASS_CODE, SEC_CODE, "OFFER").param_value), true, false) -- ������� ������������� ��� ������� ����������� ���������� ���������� ����� � ������
					price = tonumber(ql2.offer[1].price) - sec_price_step 								-- ���� ������������ �������� ������ �� ���� ��� ���� ���� offer. ������ math.modf �� ����������, �. �. ���� ����� ������� �����
					operation = 'S' 																				-- ������ �� �������
					new_quantity = 1 --tonumber(qty) 																	-- ���������� ����� ����� ����������� ����������
					OpenPos(); 																						-- ���������� ������ �� �������
					message('������� '..tostring(price)..', ������: '..tostring(signal)..', ������ �������: '..tostring(total_net))
------------------------------------------
-- ����������� �������/������ � ������� --
------------------------------------------
				-- ���� �� ����� ������������ ������ �������� ������ ��������������� ��������� ��� ������
				elseif (--signal == -1 																				-- ���� ���������� ������ �� ������� ��������� ���������� ������ �� �������
					
					--and 
					average_offer_qty > average_bid_qty 														-- � ������� �������� ���� ������ �� ������� ������ �������� �������� ���� ������ �� �������
					and tonumber(ql2.offer[1].quantity) > average_offer_qty 										-- � ���������� ������ �� ������ ���� ������ ���� ��������
					and (BST == 1) 																					-- � ��������� ���������� ������
					and total_net > 0) 																				-- � ������� ������ �� �������
				then 																								-- ��
					price = tonumber(ql2.offer[1].price) - sec_price_step 								-- ���� ������������ �������� ������ �� ���� ��� ���� ���� offer. ������ math.modf �� ����������, �. �. ���� ����� ������� �����
					operation = 'S' 																				-- ������ �� �������
					new_quantity = total_net --* 2 																		-- ���������� ����� ����� ������ ����������� ������� �������
					OpenPos(); 																						-- ���������� ������ �� �������
					message("�������� ������� "..tostring(price)..', ������: '..tostring(signal)..', ������ �������: '..tostring(total_net))
		end;--]]
		--message(tostring(current_bal)) -- ��� ��������
	end
end

function OnStop()
	IsRun = false;
	return 2000
end;
function OpenPos() 											-- ������� ��� ����������� ������ ��� ��������� �������
TRANS_ID = TRANS_ID + 1 									-- �������� ID ��� ��������� ����������
local Transaction = { 										-- ��������� ��������� ��� �������� ����������
	['TRANS_ID'] = tostring(TRANS_ID),						-- ����� ����������
	['ACCOUNT'] = ACCOUNT,									-- ����� ����� ��������
	['CLIENT_CODE'] = CLIENT_CODE,							-- ��� �������
	['CLASSCODE'] = CLASS_CODE,								-- ��� ������
	['SECCODE'] = SEC_CODE,									-- ��� �����������
	['ACTION'] = 'NEW_ORDER',								-- ��� ���������� ('NEW_ORDER' - ����� ������)
	['OPERATION'] = operation,								-- �������� ('B' - buy, ��� 'S' - sell)
	['TYPE'] = 'L',											-- ��� ('L' - ��������������, 'M' - ��������)
	['QUANTITY'] = tostring(new_quantity),					-- ���������� �����
	['PRICE'] = tostring(price)								-- ����. ���� ������ ��������, ��������� 0. �������� ��������� �����
}
	local Res = sendTransaction(Transaction) 				-- ���������� ����������
	if Res ~= '' then message('TransOpenPos(): ������ �������� ����������: '..Res) else message('TransOpenPos(): ���������� ���������� SiH2')
		local timeOut = 20 									-- ����� (���) �������� ����� �������� ����������
		local timeStart = os.time() 						-- ���������� ����� ������ �������� ������ �� ����������
		if os.time() < timeStart + timeOut and isConnected() == 1 then 	-- ���� ������� ����� ������ ������� ������ + ����� �������� � ����������� ���������� � �������� QUIK, ��
			BST = 0 													-- ���������� ������ ���������. �� ���� ��� �� ����� 50-�� �������, ����� �� ��� ������� �� ��������� ����� ����������
		end;
	end;
end;