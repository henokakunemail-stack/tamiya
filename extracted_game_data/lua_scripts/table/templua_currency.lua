


assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/currency')), '')
local datalist = {}
local textname = 'currency.txt'


local function analyse(param)
	 local data = {}
	 data.id = ConvertToNumber("currency", "id", param[1])
	 data.name = param[2]
	 data.description = param[3]
	 data.icon = param[4]
	 data.quality = ConvertToNumber("currency", "quality", param[5])
	 data.icon2 = param[6]
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
	 local reqBytes = assert(Dll_PB.encode('currency_config', tab))
	 CS.Horizon.EditorTool.TableCfg.PBCfg.TableToBytes(reqBytes, textname)
end

local t = {}
t.load = analyseList
return t
