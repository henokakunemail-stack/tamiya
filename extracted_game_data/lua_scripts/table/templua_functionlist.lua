


assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/functionlist')), '')
local datalist = {}
local textname = 'functionlist.txt'


local function analyse(param)
	 local data = {}
	 data.id = ConvertToNumber("functionlist", "id", param[1])
	 data.name = param[2]
	 data.icon = param[3]
	 data.level = ConvertToNumber("functionlist", "level", param[4])
	 data.newbieguideId = ConvertToNumber("functionlist", "newbieguideId", param[5])
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
	 local reqBytes = assert(Dll_PB.encode('functionlist_config', tab))
	 CS.Horizon.EditorTool.TableCfg.PBCfg.TableToBytes(reqBytes, textname)
end

local t = {}
t.load = analyseList
return t
