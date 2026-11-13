


assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/shop')), '')
local datalist = {}
local textname = 'shop.txt'


local function analyse(param)
	 local data = {}
	 data.id = ConvertToNumber("shop", "id", param[1])
	 data.inshop = ConvertToNumber("shop", "inshop", param[2])
	 data.shopId = ConvertToNumber("shop", "shopId", param[3])
	 data.shopType = ConvertToNumber("shop", "shopType", param[4])
	 data.shopname = param[5]
	 data.currencyType = ConvertToNumber("shop", "currencyType", param[6])
	 data.limitlv = ConvertToNumber("shop", "limitlv", param[7])
	 data.costType = ConvertToNumber("shop", "costType", param[8])
	 data.cycle = ConvertToNumber("shop", "cycle", param[9])
	 data.Index = ConvertToNumber("shop", "Index", param[10])
	 data.costShow = param[11]
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
	 local reqBytes = assert(Dll_PB.encode('shop_config', tab))
	 CS.Horizon.EditorTool.TableCfg.PBCfg.TableToBytes(reqBytes, textname)
end

local t = {}
t.load = analyseList
return t
