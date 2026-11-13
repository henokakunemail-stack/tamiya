


assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/dropgroup')), '')
local datalist = {}
local textname = 'dropgroup.txt'


local function analyse(param)
	 local data = {}
	 data.id = ConvertToNumber("dropgroup", "id", param[1])
	 data.dropId = ConvertToNumber("dropgroup", "dropId", param[2])
	 data.dropType = ConvertToNumber("dropgroup", "dropType", param[3])
	 data.itemId = param[4]
	 data.num = ConvertToNumber("dropgroup", "num", param[5])
	 data.weight = ConvertToNumber("dropgroup", "weight", param[6])
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
	 local reqBytes = assert(Dll_PB.encode('dropgroup_config', tab))
	 CS.Horizon.EditorTool.TableCfg.PBCfg.TableToBytes(reqBytes, textname)
end

local t = {}
t.load = analyseList
return t
