


assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/selfchapterticket')), '')
local datalist = {}
local textname = 'selfchapterticket.txt'


local function analyse(param)
	 local data = {}
	 data.id = ConvertToNumber("selfchapterticket", "id", param[1])
	 data.holdCost = ConvertToNumber("selfchapterticket", "holdCost", param[2])
	 data.racename = param[3]
	 data.UnLockLevel = ConvertToNumber("selfchapterticket", "UnLockLevel", param[4])
	 data.joinLimit = ConvertToNumber("selfchapterticket", "joinLimit", param[5])
	 data.levelLimit = ConvertToNumber("selfchapterticket", "levelLimit", param[6])
	 data.duration = ConvertToNumber("selfchapterticket", "duration", param[7])
	 data.levelIds = param[8]
	 data.holdReward = param[9]
	 data.icon = param[10]
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
	 local reqBytes = assert(Dll_PB.encode('selfchapterticket_config', tab))
	 CS.Horizon.EditorTool.TableCfg.PBCfg.TableToBytes(reqBytes, textname)
end

local t = {}
t.load = analyseList
return t
