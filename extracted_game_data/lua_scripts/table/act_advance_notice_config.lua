



---@class act_advance_notice_config




act_advance_notice_config = {}
---@type table<number,act_advance_notice_config_cell>
local configData = {}
local configIdx = {}




----------以pb方式加载配置表---start
--[[
assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/act_advance_notice')), '')
local bytes = mono.LoadBytes('act_advance_notice')
local cfg = assert(Dll_PB.decode('act_advance_notice_config', bytes))
for i = 1, #cfg.configData do
	 local id = cfg.configData[i].C_ID
	 configData[id] = cfg.configData[i]
end
--]]
----------以txt方式加载配置表---end




----------以txt方式加载配置表---start
local configName = 'act_advance_notice.txt'
function act_advance_notice_config.Load()
	 local content = loadConfig(configName)
	 local lines = stringSplit(content, '\n')
	 local len = #lines
	 local index = 4
	 while index <= len - 1 do
		 local line = lines[index]
		 local columns = stringSplit(line, '\t')
		 local row = {
		 C_ID = ConvertToNumber(configName, 'C_ID', columns[1]),
		 acttype = ConvertToNumber(configName, 'acttype', columns[2]),
		 orderseq = ConvertToNumber(configName, 'orderseq', columns[3]),
		 actbg = columns[4],
		 actname = columns[5],
		 }
		 table.insert(configData,row)
		 configIdx[row.C_ID]=#configData
		 index = index + 1
		 line = nil
		 columns = nil
	 end
	 lines = nil
end
act_advance_notice_config.Load()
----------以pb方式加载配置表---end




---@return table<number,act_advance_notice_config_cell>
function act_advance_notice_config.GetConfigData() return configData end
---@return act_advance_notice_config_cell
function act_advance_notice_config.GetById(id)
	 if id == nil or configIdx[id]== nil or configData[configIdx[id]] == nil then
		 return nil
	 end
	 return configData[configIdx[id]]
end








----@@@SelfDefine@@@----

----@@@--------@@@----




----%%%FieldSelfDefine%%%----

----%%%-------------%%%----








return act_advance_notice_config
