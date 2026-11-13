


assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/attrtype')), '')
local datalist = {}
local textname = 'attrtype.txt'


local function analyse(param)
	 local data = {}
	 data.id = ConvertToNumber("attrtype", "id", param[1])
	 data.name = param[2]
	 data.type = ConvertToNumber("attrtype", "type", param[3])
	 data.tag = ConvertToNumber("attrtype", "tag", param[4])
	 data.tagName = param[5]
	 data.desc = param[6]
	 data.showradio = ConvertToNumber("attrtype", "showradio", param[7])
	 data.format = param[8]
	 data.formula = ConvertToNumber("attrtype", "formula", param[9])
	 data.interval = param[10]
	 data.init = ConvertToNumber("attrtype", "init", param[11])
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
	 local reqBytes = assert(Dll_PB.encode('attrtype_config', tab))
	 CS.Horizon.EditorTool.TableCfg.PBCfg.TableToBytes(reqBytes, textname)
end

local t = {}
t.load = analyseList
return t
