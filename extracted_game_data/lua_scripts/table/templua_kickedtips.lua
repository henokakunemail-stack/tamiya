


assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/kickedtips')), '')
local datalist = {}
local textname = 'kickedtips.txt'


local function analyse(param)
	 local data = {}
	 data.id = ConvertToNumber("kickedtips", "id", param[1])
	 data.type = ConvertToNumber("kickedtips", "type", param[2])
	 data.content = param[3]
	 data.button1 = ConvertToNumber("kickedtips", "button1", param[4])
	 data.button2 = ConvertToNumber("kickedtips", "button2", param[5])
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
	 local reqBytes = assert(Dll_PB.encode('kickedtips_config', tab))
	 CS.Horizon.EditorTool.TableCfg.PBCfg.TableToBytes(reqBytes, textname)
end

local t = {}
t.load = analyseList
return t
