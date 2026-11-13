



---@class dictdesigngift_config




dictdesigngift_config = {}
---@type table<number,dictdesigngift_config_cell>
local configData = {}
local configIdx = {}




----------以pb方式加载配置表---start
--[[
assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/dictdesigngift')), '')
local bytes = mono.LoadBytes('dictdesigngift')
local cfg = assert(Dll_PB.decode('dictdesigngift_config', bytes))
for i = 1, #cfg.configData do
	 local id = cfg.configData[i].C_ID
	 configData[id] = cfg.configData[i]
end
--]]
----------以txt方式加载配置表---end




----------以txt方式加载配置表---start
local configName = 'dictdesigngift.txt'
function dictdesigngift_config.Load()
	 local content = loadConfig(configName)
	 local lines = stringSplit(content, '\n')
	 local len = #lines
	 local index = 4
	 while index <= len - 1 do
		 local line = lines[index]
		 local columns = stringSplit(line, '\t')
		 local row = {
		 C_ID = ConvertToNumber(configName, 'C_ID', columns[1]),
		 itemid = ConvertToNumber(configName, 'itemid', columns[2]),
		 gridno = ConvertToNumber(configName, 'gridno', columns[3]),
		 giftids = columns[4],
		 giftnums = columns[5],
		 }
		 table.insert(configData,row)
		 configIdx[row.C_ID]=#configData
		 index = index + 1
		 line = nil
		 columns = nil
	 end
	 lines = nil
end
dictdesigngift_config.Load()
----------以pb方式加载配置表---end




---@return table<number,dictdesigngift_config_cell>
function dictdesigngift_config.GetConfigData() return configData end
---@return dictdesigngift_config_cell
function dictdesigngift_config.GetById(id)
	 if id == nil or configIdx[id]== nil or configData[configIdx[id]] == nil then
		 return nil
	 end
	 return configData[configIdx[id]]
end








----@@@SelfDefine@@@----
function dictdesigngift_config.GetDataById(id)
	local giftData = {}

	for i, v in pairs(configData) do
		if v.itemid == id then
			table.insert(giftData, v)
		end
	end

	return giftData
end


----@@@--------@@@----




----%%%FieldSelfDefine%%%----

----%%%-------------%%%----








return dictdesigngift_config
