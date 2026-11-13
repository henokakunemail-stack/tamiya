



---@class notice_config




notice_config = {}
---@type table<number,notice_config_cell>
local configData = {}
local configIdx = {}




----------以pb方式加载配置表---start
--[[
assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/notice')), '')
local bytes = mono.LoadBytes('notice')
local cfg = assert(Dll_PB.decode('notice_config', bytes))
for i = 1, #cfg.configData do
	 local id = cfg.configData[i].C_ID
	 configData[id] = cfg.configData[i]
end
--]]
----------以txt方式加载配置表---end




----------以txt方式加载配置表---start
local configName = 'notice.txt'
function notice_config.Load()
	 local content = loadConfig(configName)
	 local lines = stringSplit(content, '\n')
	 local len = #lines
	 local index = 4
	 while index <= len - 1 do
		 local line = lines[index]
		 local columns = stringSplit(line, '\t')
		 local row = {
		 C_ID = ConvertToNumber(configName, 'C_ID', columns[1]),
		 chatType = ConvertToNumber(configName, 'chatType', columns[2]),
		 sysType = ConvertToNumber(configName, 'sysType', columns[3]),
		 templetId = columns[4],
		 showNum = ConvertToNumber(configName, 'showNum', columns[5]),
		 showTime = ConvertToNumber(configName, 'showTime', columns[6]),
		 banner = ConvertToNumber(configName, 'banner', columns[7]),
		 parm = columns[8],
		 remark = columns[9],
		 }
		 table.insert(configData,row)
		 configIdx[row.C_ID]=#configData
		 index = index + 1
		 line = nil
		 columns = nil
	 end
	 lines = nil
end
notice_config.Load()
----------以pb方式加载配置表---end




---@return table<number,notice_config_cell>
function notice_config.GetConfigData() return configData end
---@return notice_config_cell
function notice_config.GetById(id)
	 if id == nil or configIdx[id]== nil or configData[configIdx[id]] == nil then
		 return nil
	 end
	 return configData[configIdx[id]]
end








----@@@SelfDefine@@@----

----@@@--------@@@----




----%%%FieldSelfDefine%%%----

----%%%-------------%%%----








return notice_config
