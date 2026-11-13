



---@class newbieguide_config




newbieguide_config = {}
---@type table<number,newbieguide_config_cell>
local configData = {}
local configIdx = {}




----------以pb方式加载配置表---start
--[[
assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/newbieguide')), '')
local bytes = mono.LoadBytes('newbieguide')
local cfg = assert(Dll_PB.decode('newbieguide_config', bytes))
for i = 1, #cfg.configData do
	 local id = cfg.configData[i].C_ID
	 configData[id] = cfg.configData[i]
end
--]]
----------以txt方式加载配置表---end




----------以txt方式加载配置表---start
local configName = 'newbieguide.txt'
function newbieguide_config.Load()
	 local content = loadConfig(configName)
	 local lines = stringSplit(content, '\n')
	 local len = #lines
	 local index = 4
	 while index <= len - 1 do
		 local line = lines[index]
		 local columns = stringSplit(line, '\t')
		 local row = {
		 C_ID = ConvertToNumber(configName, 'C_ID', columns[1]),
		 group = ConvertToNumber(configName, 'group', columns[2]),
		 step = ConvertToNumber(configName, 'step', columns[3]),
		 nextStep = ConvertToNumber(configName, 'nextStep', columns[4]),
		 triggerType = ConvertToNumber(configName, 'triggerType', columns[5]),
		 triggerPara = columns[6],
		 BattleType = ConvertToNumber(configName, 'BattleType', columns[7]),
		 BattleNoFail = ConvertToNumber(configName, 'BattleNoFail', columns[8]),
		 isContinueBattle = ConvertToNumber(configName, 'isContinueBattle', columns[9]),
		 type = ConvertToNumber(configName, 'type', columns[10]),
		 interfaceID = columns[11],
		 isKey = ConvertToNumber(configName, 'isKey', columns[12]),
		 complettype = ConvertToNumber(configName, 'complettype', columns[13]),
		 completParam = ConvertToNumber(configName, 'completParam', columns[14]),
		 UiName = columns[15],
		 completCon = columns[16],
		 ScrollViewName = columns[17],
		 Scrolltype = ConvertToNumber(configName, 'Scrolltype', columns[18]),
		 ScrollMove = ConvertToNumber(configName, 'ScrollMove', columns[19]),
		 ScrollIndex = columns[20],
		 OpenPopupName = columns[21],
		 ArrowTowards = ConvertToNumber(configName, 'ArrowTowards', columns[22]),
		 videoName = columns[23],
		 NPC = ConvertToNumber(configName, 'NPC', columns[24]),
		 NPCPosX = ConvertToNumber(configName, 'NPCPosX', columns[25]),
		 NPCPosY = ConvertToNumber(configName, 'NPCPosY', columns[26]),
		 Desc = columns[27],
		 DescType = ConvertToNumber(configName, 'DescType', columns[28]),
		 guideCV = columns[29],
		 shrinkTime = ConvertToNumber(configName, 'shrinkTime', columns[30]),
		 Iscollider = ConvertToNumber(configName, 'Iscollider', columns[31]),
		 dialogMask = ConvertToNumber(configName, 'dialogMask', columns[32]),
		 nextStepMask = ConvertToNumber(configName, 'nextStepMask', columns[33]),
		 maskAnim = ConvertToNumber(configName, 'maskAnim', columns[34]),
		 nextLevelId = ConvertToNumber(configName, 'nextLevelId', columns[35]),
		 curLoading = ConvertToNumber(configName, 'curLoading', columns[36]),
		 }
		 table.insert(configData,row)
		 configIdx[row.C_ID]=#configData
		 index = index + 1
		 line = nil
		 columns = nil
	 end
	 lines = nil
end
newbieguide_config.Load()
----------以pb方式加载配置表---end




---@return table<number,newbieguide_config_cell>
function newbieguide_config.GetConfigData() return configData end
---@return newbieguide_config_cell
function newbieguide_config.GetById(id)
	 if id == nil or configIdx[id]== nil or configData[configIdx[id]] == nil then
		 return nil
	 end
	 return configData[configIdx[id]]
end








----@@@SelfDefine@@@----

----@@@--------@@@----




----%%%FieldSelfDefine%%%----

----%%%-------------%%%----








return newbieguide_config
