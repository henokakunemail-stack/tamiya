


assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/levelup')), '')
local datalist = {}
local textname = 'levelup.txt'


local function analyse(param)
	 local data = {}
	 data.id = ConvertToNumber("levelup", "id", param[1])
	 data.exp = ConvertToNumber("levelup", "exp", param[2])
	 data.levelReward = param[3]
	 data.power = ConvertToNumber("levelup", "power", param[4])
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
	 local reqBytes = assert(Dll_PB.encode('levelup_config', tab))
	 CS.Horizon.EditorTool.TableCfg.PBCfg.TableToBytes(reqBytes, textname)
end

local t = {}
t.load = analyseList
return t
