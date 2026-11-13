


assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/recruitgame')), '')
local datalist = {}
local textname = 'recruitgame.txt'


local function analyse(param)
	 local data = {}
	 data.id = ConvertToNumber("recruitgame", "id", param[1])
	 data.recruitid = ConvertToNumber("recruitgame", "recruitid", param[2])
	 data.sort = ConvertToNumber("recruitgame", "sort", param[3])
	 data.name = param[4]
	 data.moneyType = ConvertToNumber("recruitgame", "moneyType", param[5])
	 data.oneExpend = ConvertToNumber("recruitgame", "oneExpend", param[6])
	 data.tenExpend = ConvertToNumber("recruitgame", "tenExpend", param[7])
	 data.ticketid = ConvertToNumber("recruitgame", "ticketid", param[8])
	 data.freecd = param[9]
	 data.freenum = ConvertToNumber("recruitgame", "freenum", param[10])
	 data.readytime = param[11]
	 data.begintime = param[12]
	 data.endtime = param[13]
	 data.tenExpendAwardid = ConvertToNumber("recruitgame", "tenExpendAwardid", param[14])
	 data.prizenum = ConvertToNumber("recruitgame", "prizenum", param[15])
	 data.appointAwardid = ConvertToNumber("recruitgame", "appointAwardid", param[16])
	 data.addup = ConvertToNumber("recruitgame", "addup", param[17])
	 data.addget = param[18]
	 data.daysum = ConvertToNumber("recruitgame", "daysum", param[19])
	 data.typeIcon = param[20]
	 data.currencyIcon = param[21]
	 data.ticketIcon = param[22]
	 data.drawIcon = param[23]
	 data.drawBack = param[24]
	 data.dictawardname = param[25]
	 data.dictawarddes = param[26]
	 table.insert(datalist, data)
end

local function analyseList()
	 local content = CS.Horizon.EditorTool.TableCfg.PBCfg.ReadTxt(textname)
	 local strs = stringSplit(content, '\n')
	 for i = 4, #strs - 1 do
		 local temp = stringSplit(strs[i], '\t')
		 analyse(temp)
	 end
	 local tab = { configData = datalist }
	 local reqBytes = assert(Dll_PB.encode('recruitgame_config', tab))
	 CS.Horizon.EditorTool.TableCfg.PBCfg.TableToBytes(reqBytes, textname)
end

local t = {}
t.load = analyseList
return t
