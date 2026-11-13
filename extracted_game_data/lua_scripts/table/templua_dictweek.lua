


assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/dictweek')), '')
local datalist = {}
local textname = 'dictweek.txt'


local function analyse(param)
	 local data = {}
	 data.id = ConvertToNumber("dictweek", "id", param[1])
	 data.cardId  = ConvertToNumber("dictweek", "cardId ", param[2])
	 data.goodsid = param[3]
	 data.cardType = ConvertToNumber("dictweek", "cardType", param[4])
	 data.price = param[5]
	 data.goodprice = param[6]
	 data.firstBuy = ConvertToNumber("dictweek", "firstBuy", param[7])
	 data.firstNum = ConvertToNumber("dictweek", "firstNum", param[8])
	 data.dayDiamond = ConvertToNumber("dictweek", "dayDiamond", param[9])
	 data.dayDiaNum = ConvertToNumber("dictweek", "dayDiaNum", param[10])
	 data.dayGold = ConvertToNumber("dictweek", "dayGold", param[11])
	 data.dayGoldNum = ConvertToNumber("dictweek", "dayGoldNum", param[12])
	 data.weekBg = param[13]
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
	 local reqBytes = assert(Dll_PB.encode('dictweek_config', tab))
	 CS.Horizon.EditorTool.TableCfg.PBCfg.TableToBytes(reqBytes, textname)
end

local t = {}
t.load = analyseList
return t
