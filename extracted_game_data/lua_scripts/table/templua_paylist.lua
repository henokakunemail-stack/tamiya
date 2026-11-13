


assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/paylist')), '')
local datalist = {}
local textname = 'paylist.txt'


local function analyse(param)
	 local data = {}
	 data.id = ConvertToNumber("paylist", "id", param[1])
	 data.type = ConvertToNumber("paylist", "type", param[2])
	 data.goodsid = param[3]
	 data.google = ConvertToNumber("paylist", "google", param[4])
	 data.goodsname = param[5]
	 data.icon = param[6]
	 data.currencyType = param[7]
	 data.price = param[8]
	 data.goodprice = param[9]
	 data.diamond = ConvertToNumber("paylist", "diamond", param[10])
	 data.firstGiftDiamond = ConvertToNumber("paylist", "firstGiftDiamond", param[11])
	 data.otherGiftDiamond = ConvertToNumber("paylist", "otherGiftDiamond", param[12])
	 data.last = ConvertToNumber("paylist", "last", param[13])
	 data.rewardId = param[14]
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
	 local reqBytes = assert(Dll_PB.encode('paylist_config', tab))
	 CS.Horizon.EditorTool.TableCfg.PBCfg.TableToBytes(reqBytes, textname)
end

local t = {}
t.load = analyseList
return t
