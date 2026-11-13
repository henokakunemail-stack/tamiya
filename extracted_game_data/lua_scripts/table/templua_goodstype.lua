


assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/goodstype')), '')
local datalist = {}
local textname = 'goodstype.txt'


local function analyse(param)
	 local data = {}
	 data.id = ConvertToNumber("goodstype", "id", param[1])
	 data.type1 = ConvertToNumber("goodstype", "type1", param[2])
	 data.typename1 = param[3]
	 data.type2 = ConvertToNumber("goodstype", "type2", param[4])
	 data.icon = param[5]
	 data.typename2 = param[6]
	 data.type3 = ConvertToNumber("goodstype", "type3", param[7])
	 data.typename3 = param[8]
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
	 local reqBytes = assert(Dll_PB.encode('goodstype_config', tab))
	 CS.Horizon.EditorTool.TableCfg.PBCfg.TableToBytes(reqBytes, textname)
end

local t = {}
t.load = analyseList
return t
