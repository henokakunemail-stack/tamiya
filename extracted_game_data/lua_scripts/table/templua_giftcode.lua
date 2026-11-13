


assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/giftcode')), '')
local datalist = {}
local textname = 'giftcode.txt'


local function analyse(param)
	 local data = {}
	 data.id = ConvertToNumber("giftcode", "id", param[1])
	 data.type = ConvertToNumber("giftcode", "type", param[2])
	 data.reward = param[3]
	 data.openTime = param[4]
	 data.closeTime = param[5]
	 data.code = param[6]
	 data.frequency = ConvertToNumber("giftcode", "frequency", param[7])
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
	 local reqBytes = assert(Dll_PB.encode('giftcode_config', tab))
	 CS.Horizon.EditorTool.TableCfg.PBCfg.TableToBytes(reqBytes, textname)
end

local t = {}
t.load = analyseList
return t
