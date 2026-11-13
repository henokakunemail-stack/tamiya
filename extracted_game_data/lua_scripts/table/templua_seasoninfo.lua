


assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/seasoninfo')), '')
local datalist = {}
local textname = 'seasoninfo.txt'


local function analyse(param)
	 local data = {}
	 data.id = ConvertToNumber("seasoninfo", "id", param[1])
	 data.season = param[2]
	 data.openTime = param[3]
	 data.closeTime = param[4]
	 data.trackId = ConvertToNumber("seasoninfo", "trackId", param[5])
	 data.sceneId = param[6]
	 data.mileAgeReward = param[7]
	 data.rankReward = param[8]
	 data.banParts = param[9]
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
	 local reqBytes = assert(Dll_PB.encode('seasoninfo_config', tab))
	 CS.Horizon.EditorTool.TableCfg.PBCfg.TableToBytes(reqBytes, textname)
end

local t = {}
t.load = analyseList
return t
