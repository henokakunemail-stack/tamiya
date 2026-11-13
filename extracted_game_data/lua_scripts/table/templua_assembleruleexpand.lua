


assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/assembleruleexpand')), '')
local datalist = {}
local textname = 'assembleruleexpand.txt'


local function analyse(param)
	 local data = {}
	 data.id = ConvertToNumber("assembleruleexpand", "id", param[1])
	 data.groove = ConvertToNumber("assembleruleexpand", "groove", param[2])
	 data.type = ConvertToNumber("assembleruleexpand", "type", param[3])
	 data.param1 = param[4]
	 data.param2 = param[5]
	 data.param3 = param[6]
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
	 local reqBytes = assert(Dll_PB.encode('assembleruleexpand_config', tab))
	 CS.Horizon.EditorTool.TableCfg.PBCfg.TableToBytes(reqBytes, textname)
end

local t = {}
t.load = analyseList
return t
