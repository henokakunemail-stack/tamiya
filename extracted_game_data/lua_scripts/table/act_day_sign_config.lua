



---@class act_day_sign_config




act_day_sign_config = {}
---@type table<number,act_day_sign_config_cell>
local configData = {}
local configIdx = {}




----------以pb方式加载配置表---start
--[[
assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/act_day_sign')), '')
local bytes = mono.LoadBytes('act_day_sign')
local cfg = assert(Dll_PB.decode('act_day_sign_config', bytes))
for i = 1, #cfg.configData do
	 local id = cfg.configData[i].C_ID
	 configData[id] = cfg.configData[i]
end
--]]
----------以txt方式加载配置表---end




----------以txt方式加载配置表---start
local configName = 'act_day_sign.txt'
function act_day_sign_config.Load()
	 local content = loadConfig(configName)
	 local lines = stringSplit(content, '\n')
	 local len = #lines
	 local index = 4
	 while index <= len - 1 do
		 local line = lines[index]
		 local columns = stringSplit(line, '\t')
		 local row = {
		 C_ID = ConvertToNumber(configName, 'C_ID', columns[1]),
		 begintime = ConvertToNumber(configName, 'begintime', columns[2]),
		 endtime = ConvertToNumber(configName, 'endtime', columns[3]),
		 dayawards = columns[4],
		 awardnums = columns[5],
		 exppay = ConvertToNumber(configName, 'exppay', columns[6]),
		 }
		 table.insert(configData,row)
		 configIdx[row.C_ID]=#configData
		 index = index + 1
		 line = nil
		 columns = nil
	 end
	 lines = nil
end
act_day_sign_config.Load()
----------以pb方式加载配置表---end




---@return table<number,act_day_sign_config_cell>
function act_day_sign_config.GetConfigData() return configData end
---@return act_day_sign_config_cell
function act_day_sign_config.GetById(id)
	 if id == nil or configIdx[id]== nil or configData[configIdx[id]] == nil then
		 return nil
	 end
	 return configData[configIdx[id]]
end








----@@@SelfDefine@@@----
function act_day_sign_config.GetDayDataById(id,Iid)
	local dayData={}

	local _data = act_day_sign_config.GetById(id)
	local awards =stringSplit(_data.dayawards,':')
	local nums =stringSplit(_data.awardnums,':')
	for i = 1, #awards do
		table.insert(dayData,{awards[i],nums[i]})
	end

	return dayData[Iid]
end

----@@@--------@@@----




----%%%FieldSelfDefine%%%----

----%%%-------------%%%----








return act_day_sign_config
