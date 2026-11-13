


assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/camera')), '')
local datalist = {}
local textname = 'camera.txt'


local function analyse(param)
	 local data = {}
	 data.id = ConvertToNumber("camera", "id", param[1])
	 data.scene_camera = param[2]
	 data.scene_camera_time = param[3]
	 data.battle_camera_mode = ConvertToNumber("camera", "battle_camera_mode", param[4])
	 data.start_camera = param[5]
	 data.end_camera = param[6]
	 data.cameraId = param[7]
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
	 local reqBytes = assert(Dll_PB.encode('camera_config', tab))
	 CS.Horizon.EditorTool.TableCfg.PBCfg.TableToBytes(reqBytes, textname)
end

local t = {}
t.load = analyseList
return t
