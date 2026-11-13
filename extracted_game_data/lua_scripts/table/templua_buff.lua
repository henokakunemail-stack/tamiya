


assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/buff')), '')
local datalist = {}
local textname = 'buff.txt'


local function analyse(param)
	 local data = {}
	 data.id = ConvertToNumber("buff", "id", param[1])
	 data.triggerPos = param[2]
	 data.overlapTap = ConvertToNumber("buff", "overlapTap", param[3])
	 data.baseStack = ConvertToNumber("buff", "baseStack", param[4])
	 data.maxStack = ConvertToNumber("buff", "maxStack", param[5])
	 data.eventType = ConvertToNumber("buff", "eventType", param[6])
	 data.duration = ConvertToNumber("buff", "duration", param[7])
	 data.distance = ConvertToNumber("buff", "distance", param[8])
	 data.probability = ConvertToNumber("buff", "probability", param[9])
	 data.show_anim = param[10]
	 data.show_fx = param[11]
	 data.effectType = ConvertToNumber("buff", "effectType", param[12])
	 data.breakType = ConvertToNumber("buff", "breakType", param[13])
	 data.param1 = param[14]
	 data.param2 = ConvertToNumber("buff", "param2", param[15])
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
	 local reqBytes = assert(Dll_PB.encode('buff_config', tab))
	 CS.Horizon.EditorTool.TableCfg.PBCfg.TableToBytes(reqBytes, textname)
end

local t = {}
t.load = analyseList
return t
