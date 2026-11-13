


assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/guild')), '')
local datalist = {}
local textname = 'guild.txt'


local function analyse(param)
	 local data = {}
	 data.id = ConvertToNumber("guild", "id", param[1])
	 data.level = ConvertToNumber("guild", "level", param[2])
	 data.exp = param[3]
	 data.maxNum = param[4]
	 data.limitNum4 = ConvertToNumber("guild", "limitNum4", param[5])
	 data.limitNum3 = ConvertToNumber("guild", "limitNum3", param[6])
	 data.limitNum2 = ConvertToNumber("guild", "limitNum2", param[7])
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
	 local reqBytes = assert(Dll_PB.encode('guild_config', tab))
	 CS.Horizon.EditorTool.TableCfg.PBCfg.TableToBytes(reqBytes, textname)
end

local t = {}
t.load = analyseList
return t
