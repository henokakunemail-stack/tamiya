


assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/apsticker')), '')
local datalist = {}
local textname = 'apsticker.txt'


local function analyse(param)
	 local data = {}
	 data.id = ConvertToNumber("apsticker", "id", param[1])
	 data.name = param[2]
	 data.des = param[3]
	 data.type = ConvertToNumber("apsticker", "type", param[4])
	 data.icon = param[5]
	 data.mat = param[6]
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
	 local reqBytes = assert(Dll_PB.encode('apsticker_config', tab))
	 CS.Horizon.EditorTool.TableCfg.PBCfg.TableToBytes(reqBytes, textname)
end

local t = {}
t.load = analyseList
return t
