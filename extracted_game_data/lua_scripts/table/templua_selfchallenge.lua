


assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/selfchallenge')), '')
local datalist = {}
local textname = 'selfchallenge.txt'


local function analyse(param)
	 local data = {}
	 data.id = ConvertToNumber("selfchallenge", "id", param[1])
	 data.holdCost = ConvertToNumber("selfchallenge", "holdCost", param[2])
	 data.joinCost = ConvertToNumber("selfchallenge", "joinCost", param[3])
	 data.lastDays = param[4]
	 data.barrierNum = param[5]
	 data.sceneIds = param[6]
	 data.difficulty = ConvertToNumber("selfchallenge", "difficulty", param[7])
	 data.trackType = ConvertToNumber("selfchallenge", "trackType", param[8])
	 data.holdReward = ConvertToNumber("selfchallenge", "holdReward", param[9])
	 data.flockRewards = param[10]
	 data.dropRewards = param[11]
	 data.finishRewards = param[12]
	 data.trackNpcInfo = param[13]
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
	 local reqBytes = assert(Dll_PB.encode('selfchallenge_config', tab))
	 CS.Horizon.EditorTool.TableCfg.PBCfg.TableToBytes(reqBytes, textname)
end

local t = {}
t.load = analyseList
return t
