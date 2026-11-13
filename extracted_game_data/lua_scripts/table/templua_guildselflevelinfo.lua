


assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/guildselflevelinfo')), '')
local datalist = {}
local textname = 'guildselflevelinfo.txt'


local function analyse(param)
	 local data = {}
	 data.id = ConvertToNumber("guildselflevelinfo", "id", param[1])
	 data.holdCost = param[2]
	 data.joinCost = param[3]
	 data.sceneIds = param[4]
	 data.duration = ConvertToNumber("guildselflevelinfo", "duration", param[5])
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
	 local reqBytes = assert(Dll_PB.encode('guildselflevelinfo_config', tab))
	 CS.Horizon.EditorTool.TableCfg.PBCfg.TableToBytes(reqBytes, textname)
end

local t = {}
t.load = analyseList
return t
