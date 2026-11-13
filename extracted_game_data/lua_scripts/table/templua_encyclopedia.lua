


assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/encyclopedia')), '')
local datalist = {}
local textname = 'encyclopedia.txt'


local function analyse(param)
	 local data = {}
	 data.id = ConvertToNumber("encyclopedia", "id", param[1])
	 data.page = ConvertToNumber("encyclopedia", "page", param[2])
	 data.pageName = param[3]
	 data.type = ConvertToNumber("encyclopedia", "type", param[4])
	 data.typeName = param[5]
	 data.name = param[6]
	 data.desc = param[7]
	 data.icon = param[8]
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
	 local reqBytes = assert(Dll_PB.encode('encyclopedia_config', tab))
	 CS.Horizon.EditorTool.TableCfg.PBCfg.TableToBytes(reqBytes, textname)
end

local t = {}
t.load = analyseList
return t
