


assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/scene')), '')
local datalist = {}
local textname = 'scene.txt'


local function analyse(param)
	 local data = {}
	 data.id = ConvertToNumber("scene", "id", param[1])
	 data.name = param[2]
	 data.resName = param[3]
	 data.icon = param[4]
	 data.camera = param[5]
	 data.isfield = ConvertToNumber("scene", "isfield", param[6])
	 data.isroomtrack = ConvertToNumber("scene", "isroomtrack", param[7])
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
	 local reqBytes = assert(Dll_PB.encode('scene_config', tab))
	 CS.Horizon.EditorTool.TableCfg.PBCfg.TableToBytes(reqBytes, textname)
end

local t = {}
t.load = analyseList
return t
