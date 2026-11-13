


assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/pamgroup')), '')
local datalist = {}
local textname = 'pamgroup.txt'


local function analyse(param)
	 local data = {}
	 data.id = ConvertToNumber("pamgroup", "id", param[1])
	 data.createCost = param[2]
	 data.joinCost = param[3]
	 data.createReward = param[4]
	 data.joinReward = param[5]
	 data.rankReward = param[6]
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
	 local reqBytes = assert(Dll_PB.encode('pamgroup_config', tab))
	 CS.Horizon.EditorTool.TableCfg.PBCfg.TableToBytes(reqBytes, textname)
end

local t = {}
t.load = analyseList
return t
