


assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/trackmaterial')), '')
local datalist = {}
local textname = 'trackmaterial.txt'


local function analyse(param)
	 local data = {}
	 data.id = ConvertToNumber("trackmaterial", "id", param[1])
	 data.fx = param[2]
	 data.dFriction = ConvertToNumber("trackmaterial", "dFriction", param[3])
	 data.staticFriction = ConvertToNumber("trackmaterial", "staticFriction", param[4])
	 data.Restitution = ConvertToNumber("trackmaterial", "Restitution", param[5])
	 data.buffID = ConvertToNumber("trackmaterial", "buffID", param[6])
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
	 local reqBytes = assert(Dll_PB.encode('trackmaterial_config', tab))
	 CS.Horizon.EditorTool.TableCfg.PBCfg.TableToBytes(reqBytes, textname)
end

local t = {}
t.load = analyseList
return t
