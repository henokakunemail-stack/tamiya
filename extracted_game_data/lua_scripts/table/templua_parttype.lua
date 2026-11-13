


assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/parttype')), '')
local datalist = {}
local textname = 'parttype.txt'


local function analyse(param)
	 local data = {}
	 data.id = ConvertToNumber("parttype", "id", param[1])
	 data.bagtype = ConvertToNumber("parttype", "bagtype", param[2])
	 data.bagtypename = param[3]
	 data.type = ConvertToNumber("parttype", "type", param[4])
	 data.typename = param[5]
	 data.bag_icon = param[6]
	 data.childtype = ConvertToNumber("parttype", "childtype", param[7])
	 data.childtypename = param[8]
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
	 local reqBytes = assert(Dll_PB.encode('parttype_config', tab))
	 CS.Horizon.EditorTool.TableCfg.PBCfg.TableToBytes(reqBytes, textname)
end

local t = {}
t.load = analyseList
return t
