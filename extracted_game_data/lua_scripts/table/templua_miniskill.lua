


assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/miniskill')), '')
local datalist = {}
local textname = 'miniskill.txt'


local function analyse(param)
	 local data = {}
	 data.id = ConvertToNumber("miniskill", "id", param[1])
	 data.name = param[2]
	 data.desc = param[3]
	 data.quality = ConvertToNumber("miniskill", "quality", param[4])
	 data.effectType = ConvertToNumber("miniskill", "effectType", param[5])
	 data.condition = param[6]
	 data.distance = ConvertToNumber("miniskill", "distance", param[7])
	 data.time = ConvertToNumber("miniskill", "time", param[8])
	 data.parameter = param[9]
	 data.triggerCD = ConvertToNumber("miniskill", "triggerCD", param[10])
	 data.triggerCount = ConvertToNumber("miniskill", "triggerCount", param[11])
	 data.maxStack = ConvertToNumber("miniskill", "maxStack", param[12])
	 data.costtype = ConvertToNumber("miniskill", "costtype", param[13])
	 data.costvalue = param[14]
	 data.startFx = param[15]
	 data.runFx = param[16]
	 data.endFx = param[17]
	 data.triggerStartFx = param[18]
	 data.triggerRunFx = param[19]
	 data.triggerEndFx = param[20]
	 data.startAudio = param[21]
	 data.runAudio = param[22]
	 data.endAudio = param[23]
	 data.endbuffid = ConvertToNumber("miniskill", "endbuffid", param[24])
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
	 local reqBytes = assert(Dll_PB.encode('miniskill_config', tab))
	 CS.Horizon.EditorTool.TableCfg.PBCfg.TableToBytes(reqBytes, textname)
end

local t = {}
t.load = analyseList
return t
