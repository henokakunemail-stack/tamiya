


assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/selflevelreward')), '')
local datalist = {}
local textname = 'selflevelreward.txt'


local function analyse(param)
	 local data = {}
	 data.id = ConvertToNumber("selflevelreward", "id", param[1])
	 data.npcs3 = param[2]
	 data.npcs5 = param[3]
	 data.reward1 = ConvertToNumber("selflevelreward", "reward1", param[4])
	 data.reward2 = ConvertToNumber("selflevelreward", "reward2", param[5])
	 data.reward3 = ConvertToNumber("selflevelreward", "reward3", param[6])
	 data.joinReward = ConvertToNumber("selflevelreward", "joinReward", param[7])
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
	 local reqBytes = assert(Dll_PB.encode('selflevelreward_config', tab))
	 CS.Horizon.EditorTool.TableCfg.PBCfg.TableToBytes(reqBytes, textname)
end

local t = {}
t.load = analyseList
return t
