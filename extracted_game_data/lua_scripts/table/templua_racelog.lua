


assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/racelog')), '')
local datalist = {}
local textname = 'racelog.txt'


local function analyse(param)
	 local data = {}
	 data.id = ConvertToNumber("racelog", "id", param[1])
	 data.isShow = ConvertToNumber("racelog", "isShow", param[2])
	 data.priority = ConvertToNumber("racelog", "priority", param[3])
	 data.type = ConvertToNumber("racelog", "type", param[4])
	 data.desc = param[5]
	 data.smallDesc = param[6]
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
	 local reqBytes = assert(Dll_PB.encode('racelog_config', tab))
	 CS.Horizon.EditorTool.TableCfg.PBCfg.TableToBytes(reqBytes, textname)
end

local t = {}
t.load = analyseList
return t
