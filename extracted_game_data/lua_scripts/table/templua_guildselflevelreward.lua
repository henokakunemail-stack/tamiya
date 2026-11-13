


assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/guildselflevelreward')), '')
local datalist = {}
local textname = 'guildselflevelreward.txt'


local function analyse(param)
	 local data = {}
	 data.id = ConvertToNumber("guildselflevelreward", "id", param[1])
	 data.npcs3 = param[2]
	 data.npcs5 = param[3]
	 data.reward1 = ConvertToNumber("guildselflevelreward", "reward1", param[4])
	 data.reward2 = ConvertToNumber("guildselflevelreward", "reward2", param[5])
	 data.reward3 = ConvertToNumber("guildselflevelreward", "reward3", param[6])
	 data.joinReward = ConvertToNumber("guildselflevelreward", "joinReward", param[7])
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
	 local reqBytes = assert(Dll_PB.encode('guildselflevelreward_config', tab))
	 CS.Horizon.EditorTool.TableCfg.PBCfg.TableToBytes(reqBytes, textname)
end

local t = {}
t.load = analyseList
return t
