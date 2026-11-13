


assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/attrfeature')), '')
local datalist = {}
local textname = 'attrfeature.txt'


local function analyse(param)
	 local data = {}
	 data.id = ConvertToNumber("attrfeature", "id", param[1])
	 data.attr = ConvertToNumber("attrfeature", "attr", param[2])
	 data.type = ConvertToNumber("attrfeature", "type", param[3])
	 data.icon = param[4]
	 data.bg = param[5]
	 data.char = param[6]
	 data.desc = param[7]
	 data.isShow = ConvertToNumber("attrfeature", "isShow", param[8])
	 data.interval = param[9]
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
	 local reqBytes = assert(Dll_PB.encode('attrfeature_config', tab))
	 CS.Horizon.EditorTool.TableCfg.PBCfg.TableToBytes(reqBytes, textname)
end

local t = {}
t.load = analyseList
return t
