


assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/guildselfchapterticket')), '')
local datalist = {}
local textname = 'guildselfchapterticket.txt'


local function analyse(param)
	 local data = {}
	 data.id = ConvertToNumber("guildselfchapterticket", "id", param[1])
	 data.holdCost = ConvertToNumber("guildselfchapterticket", "holdCost", param[2])
	 data.racename = param[3]
	 data.joinLimit = ConvertToNumber("guildselfchapterticket", "joinLimit", param[4])
	 data.levelLimit = ConvertToNumber("guildselfchapterticket", "levelLimit", param[5])
	 data.duration = ConvertToNumber("guildselfchapterticket", "duration", param[6])
	 data.levelIds = param[7]
	 data.holdReward = param[8]
	 data.icon = param[9]
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
	 local reqBytes = assert(Dll_PB.encode('guildselfchapterticket_config', tab))
	 CS.Horizon.EditorTool.TableCfg.PBCfg.TableToBytes(reqBytes, textname)
end

local t = {}
t.load = analyseList
return t
