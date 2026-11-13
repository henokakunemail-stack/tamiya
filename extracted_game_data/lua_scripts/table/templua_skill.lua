


assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/skill')), '')
local datalist = {}
local textname = 'skill.txt'


local function analyse(param)
	 local data = {}
	 data.id = ConvertToNumber("skill", "id", param[1])
	 data.skillidtype = ConvertToNumber("skill", "skillidtype", param[2])
	 data.name = param[3]
	 data.des = param[4]
	 data.icon = param[5]
	 data.skill_show_ui = param[6]
	 data.showinmatch = ConvertToNumber("skill", "showinmatch", param[7])
	 data.cooldown = ConvertToNumber("skill", "cooldown", param[8])
	 data.addspeedlevel = ConvertToNumber("skill", "addspeedlevel", param[9])
	 data.torqueaddpercent = ConvertToNumber("skill", "torqueaddpercent", param[10])
	 data.torqueaddvalue = ConvertToNumber("skill", "torqueaddvalue", param[11])
	 data.frictionaddpercent = ConvertToNumber("skill", "frictionaddpercent", param[12])
	 data.frictionaddvalue = ConvertToNumber("skill", "frictionaddvalue", param[13])
	 data.rpmaddpercent = ConvertToNumber("skill", "rpmaddpercent", param[14])
	 data.rpmaddvalue = ConvertToNumber("skill", "rpmaddvalue", param[15])
	 data.stableaddpercent = ConvertToNumber("skill", "stableaddpercent", param[16])
	 data.stableaddvalue = ConvertToNumber("skill", "stableaddvalue", param[17])
	 data.configtype = ConvertToNumber("skill", "configtype", param[18])
	 data.startfx = param[19]
	 data.triggerfx = param[20]
	 data.lastfx = param[21]
	 data.lasttime = ConvertToNumber("skill", "lasttime", param[22])
	 data.endfx = param[23]
	 data.dirfttype = ConvertToNumber("skill", "dirfttype", param[24])
	 data.audiofx = param[25]
	 data.cameragroup = ConvertToNumber("skill", "cameragroup", param[26])
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
	 local reqBytes = assert(Dll_PB.encode('skill_config', tab))
	 CS.Horizon.EditorTool.TableCfg.PBCfg.TableToBytes(reqBytes, textname)
end

local t = {}
t.load = analyseList
return t
