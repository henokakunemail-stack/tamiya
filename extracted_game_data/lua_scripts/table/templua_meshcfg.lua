


assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/meshcfg')), '')
local datalist = {}
local textname = 'meshcfg.txt'


local function analyse(param)
	 local data = {}
	 data.id = ConvertToNumber("meshcfg", "id", param[1])
	 data.mesh = param[2]
	 data.initialmodel = param[3]
	 data.thickness = ConvertToNumber("meshcfg", "thickness", param[4])
	 data.showmodel = param[5]
	 data.flag = ConvertToNumber("meshcfg", "flag", param[6])
	 data.meshcolor = param[7]
	 data.meshmatch = param[8]
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
	 local reqBytes = assert(Dll_PB.encode('meshcfg_config', tab))
	 CS.Horizon.EditorTool.TableCfg.PBCfg.TableToBytes(reqBytes, textname)
end

local t = {}
t.load = analyseList
return t
