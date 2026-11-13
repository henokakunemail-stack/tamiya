


assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/relation')), '')
local datalist = {}
local textname = 'relation.txt'


local function analyse(param)
	 local data = {}
	 data.id = ConvertToNumber("relation", "id", param[1])
	 data.type = ConvertToNumber("relation", "type", param[2])
	 data.posId = ConvertToNumber("relation", "posId", param[3])
	 data.posIds = param[4]
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
	 local reqBytes = assert(Dll_PB.encode('relation_config', tab))
	 CS.Horizon.EditorTool.TableCfg.PBCfg.TableToBytes(reqBytes, textname)
end

local t = {}
t.load = analyseList
return t
