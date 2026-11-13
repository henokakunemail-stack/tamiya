


assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/shopgrid')), '')
local datalist = {}
local textname = 'shopgrid.txt'


local function analyse(param)
	 local data = {}
	 data.id = ConvertToNumber("shopgrid", "id", param[1])
	 data.grid = ConvertToNumber("shopgrid", "grid", param[2])
	 data.shopId = ConvertToNumber("shopgrid", "shopId", param[3])
	 data.groupId = ConvertToNumber("shopgrid", "groupId", param[4])
	 data.refreshDay = ConvertToNumber("shopgrid", "refreshDay", param[5])
	 data.endTime = param[6]
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
	 local reqBytes = assert(Dll_PB.encode('shopgrid_config', tab))
	 CS.Horizon.EditorTool.TableCfg.PBCfg.TableToBytes(reqBytes, textname)
end

local t = {}
t.load = analyseList
return t
