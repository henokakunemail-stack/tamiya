


assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/pagedetails')), '')
local datalist = {}
local textname = 'pagedetails.txt'


local function analyse(param)
	 local data = {}
	 data.id = ConvertToNumber("pagedetails", "id", param[1])
	 data.title = param[2]
	 data.desc = param[3]
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
	 local reqBytes = assert(Dll_PB.encode('pagedetails_config', tab))
	 CS.Horizon.EditorTool.TableCfg.PBCfg.TableToBytes(reqBytes, textname)
end

local t = {}
t.load = analyseList
return t
