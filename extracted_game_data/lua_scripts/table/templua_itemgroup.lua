


assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/itemgroup')), '')
local datalist = {}
local textname = 'itemgroup.txt'


local function analyse(param)
	 local data = {}
	 data.id = ConvertToNumber("itemgroup", "id", param[1])
	 data.groupId = ConvertToNumber("itemgroup", "groupId", param[2])
	 data.goodId = ConvertToNumber("itemgroup", "goodId", param[3])
	 data.num = ConvertToNumber("itemgroup", "num", param[4])
	 data.mark = ConvertToNumber("itemgroup", "mark", param[5])
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
	 local reqBytes = assert(Dll_PB.encode('itemgroup_config', tab))
	 CS.Horizon.EditorTool.TableCfg.PBCfg.TableToBytes(reqBytes, textname)
end

local t = {}
t.load = analyseList
return t
