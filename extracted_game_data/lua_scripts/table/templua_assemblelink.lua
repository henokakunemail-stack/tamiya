


assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/assemblelink')), '')
local datalist = {}
local textname = 'assemblelink.txt'


local function analyse(param)
	 local data = {}
	 data.id = ConvertToNumber("assemblelink", "id", param[1])
	 data.linkgroopid = param[2]
	 data.linkoffset = param[3]
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
	 local reqBytes = assert(Dll_PB.encode('assemblelink_config', tab))
	 CS.Horizon.EditorTool.TableCfg.PBCfg.TableToBytes(reqBytes, textname)
end

local t = {}
t.load = analyseList
return t
