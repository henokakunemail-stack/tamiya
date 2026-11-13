


assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/selflevelinfo')), '')
local datalist = {}
local textname = 'selflevelinfo.txt'


local function analyse(param)
	 local data = {}
	 data.id = ConvertToNumber("selflevelinfo", "id", param[1])
	 data.holdCost = param[2]
	 data.joinCost = param[3]
	 data.sceneIds = param[4]
	 data.duration = ConvertToNumber("selflevelinfo", "duration", param[5])
	 data.num = ConvertToNumber("selflevelinfo", "num", param[6])
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
	 local reqBytes = assert(Dll_PB.encode('selflevelinfo_config', tab))
	 CS.Horizon.EditorTool.TableCfg.PBCfg.TableToBytes(reqBytes, textname)
end

local t = {}
t.load = analyseList
return t
