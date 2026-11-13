


assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/activityitem')), '')
local datalist = {}
local textname = 'activityitem.txt'


local function analyse(param)
	 local data = {}
	 data.id = ConvertToNumber("activityitem", "id", param[1])
	 data.activityid = ConvertToNumber("activityitem", "activityid", param[2])
	 data.sort = ConvertToNumber("activityitem", "sort", param[3])
	 data.activityType = ConvertToNumber("activityitem", "activityType", param[4])
	 data.timeType = ConvertToNumber("activityitem", "timeType", param[5])
	 data.openTime = param[6]
	 data.endTime = param[7]
	 data.reward = param[8]
	 data.maxCount = ConvertToNumber("activityitem", "maxCount", param[9])
	 data.vip = ConvertToNumber("activityitem", "vip", param[10])
	 data.ejectPar = param[11]
	 data.nextId = param[12]
	 data.payId = ConvertToNumber("activityitem", "payId", param[13])
	 data.diamond = ConvertToNumber("activityitem", "diamond", param[14])
	 data.giftIcon = param[15]
	 data.name = param[16]
	 data.title = param[17]
	 data.reference = param[18]
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
	 local reqBytes = assert(Dll_PB.encode('activityitem_config', tab))
	 CS.Horizon.EditorTool.TableCfg.PBCfg.TableToBytes(reqBytes, textname)
end

local t = {}
t.load = analyseList
return t
