


assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/globalseason')), '')
local datalist = {}
local textname = 'globalseason.txt'


local function analyse(param)
	 local data = {}
	 data.id = ConvertToNumber("globalseason", "id", param[1])
	 data.season = ConvertToNumber("globalseason", "season", param[2])
	 data.openTime = param[3]
	 data.closeTime = param[4]
	 data.sceneInfo = param[5]
	 data.winReward = param[6]
	 data.rankReward = param[7]
	 data.integralReward = param[8]
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
	 local reqBytes = assert(Dll_PB.encode('globalseason_config', tab))
	 CS.Horizon.EditorTool.TableCfg.PBCfg.TableToBytes(reqBytes, textname)
end

local t = {}
t.load = analyseList
return t
