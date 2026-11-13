


assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/mapnode')), '')
local datalist = {}
local textname = 'mapnode.txt'


local function analyse(param)
	 local data = {}
	 data.id = ConvertToNumber("mapnode", "id", param[1])
	 data.chapterid = ConvertToNumber("mapnode", "chapterid", param[2])
	 data.pos = param[3]
	 data.input = param[4]
	 data.output = param[5]
	 data.openstar = ConvertToNumber("mapnode", "openstar", param[6])
	 data.openpass = ConvertToNumber("mapnode", "openpass", param[7])
	 data.openother = param[8]
	 data.temppos = param[9]
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
	 local reqBytes = assert(Dll_PB.encode('mapnode_config', tab))
	 CS.Horizon.EditorTool.TableCfg.PBCfg.TableToBytes(reqBytes, textname)
end

local t = {}
t.load = analyseList
return t
