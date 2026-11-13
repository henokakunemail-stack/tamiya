



---@class dictrecruitlab_config




dictrecruitlab_config = {}
---@type table<number,dictrecruitlab_config_cell>
local configData = {}
local configIdx = {}




----------以pb方式加载配置表---start
--[[
assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/dictrecruitlab')), '')
local bytes = mono.LoadBytes('dictrecruitlab')
local cfg = assert(Dll_PB.decode('dictrecruitlab_config', bytes))
for i = 1, #cfg.configData do
	 local id = cfg.configData[i].C_ID
	 configData[id] = cfg.configData[i]
end
--]]
----------以txt方式加载配置表---end




----------以txt方式加载配置表---start
local configName = 'dictrecruitlab.txt'
function dictrecruitlab_config.Load()
	 local content = loadConfig(configName)
	 local lines = stringSplit(content, '\n')
	 local len = #lines
	 local index = 4
	 while index <= len - 1 do
		 local line = lines[index]
		 local columns = stringSplit(line, '\t')
		 local row = {
		 C_ID = ConvertToNumber(configName, 'C_ID', columns[1]),
		 recruitid = ConvertToNumber(configName, 'recruitid', columns[2]),
		 awardid = ConvertToNumber(configName, 'awardid', columns[3]),
		 prize = ConvertToNumber(configName, 'prize', columns[4]),
		 recruitlabDesc = columns[5],
		 showFabric = ConvertToNumber(configName, 'showFabric', columns[6]),
		 }
		 table.insert(configData,row)
		 configIdx[row.C_ID]=#configData
		 index = index + 1
		 line = nil
		 columns = nil
	 end
	 lines = nil
end
dictrecruitlab_config.Load()
----------以pb方式加载配置表---end




---@return table<number,dictrecruitlab_config_cell>
function dictrecruitlab_config.GetConfigData() return configData end
---@return dictrecruitlab_config_cell
function dictrecruitlab_config.GetById(id)
	 if id == nil or configIdx[id]== nil or configData[configIdx[id]] == nil then
		 return nil
	 end
	 return configData[configIdx[id]]
end








----@@@SelfDefine@@@----
---@type table<number,table<number,dictrecruitlab_config_cell>>@第一个是recruitId
local probability={}


function dictrecruitlab_config.SortConfigData()
	---@type dictrecruitlab_config_cell
	for id ,cell in pairs(configData)do
		if probability[cell.recruitid]==nil then
			probability[cell.recruitid]={}
		end
		table.insert(probability[cell.recruitid],cell)
	end
end

---@return table<number,dictrecruitlab_config_cell>
function dictrecruitlab_config.GetDataByRecruitId(recruitId)
	return probability[recruitId]
end

----@@@--------@@@----




----%%%FieldSelfDefine%%%----
dictrecruitlab_config.SortConfigData()
----%%%-------------%%%----








return dictrecruitlab_config
