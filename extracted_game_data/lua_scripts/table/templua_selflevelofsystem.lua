


assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/selflevelofsystem')), '')
local datalist = {}
local textname = 'selflevelofsystem.txt'


local function analyse(param)
	 local data = {}
	 data.id = ConvertToNumber("selflevelofsystem", "id", param[1])
	 data.rewardConfigId = ConvertToNumber("selflevelofsystem", "rewardConfigId", param[2])
	 data.sceneId = ConvertToNumber("selflevelofsystem", "sceneId", param[3])
	 data.trackId = ConvertToNumber("selflevelofsystem", "trackId", param[4])
	 data.heroid = ConvertToNumber("selflevelofsystem", "heroid", param[5])
	 data.duration = ConvertToNumber("selflevelofsystem", "duration", param[6])
	 data.weekDay = param[7]
	 data.openTime = param[8]
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
	 local reqBytes = assert(Dll_PB.encode('selflevelofsystem_config', tab))
	 CS.Horizon.EditorTool.TableCfg.PBCfg.TableToBytes(reqBytes, textname)
end

local t = {}
t.load = analyseList
return t
