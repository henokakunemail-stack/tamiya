



---@class dictlabtaglevup_config




dictlabtaglevup_config = {}
---@type table<number,dictlabtaglevup_config_cell>
local configData = {}
local configIdx = {}




----------以pb方式加载配置表---start
--[[
assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/dictlabtaglevup')), '')
local bytes = mono.LoadBytes('dictlabtaglevup')
local cfg = assert(Dll_PB.decode('dictlabtaglevup_config', bytes))
for i = 1, #cfg.configData do
	 local id = cfg.configData[i].C_ID
	 configData[id] = cfg.configData[i]
end
--]]
----------以txt方式加载配置表---end




----------以txt方式加载配置表---start
local configName = 'dictlabtaglevup.txt'
function dictlabtaglevup_config.Load()
	 local content = loadConfig(configName)
	 local lines = stringSplit(content, '\n')
	 local len = #lines
	 local index = 4
	 while index <= len - 1 do
		 local line = lines[index]
		 local columns = stringSplit(line, '\t')
		 local row = {
		 C_ID = ConvertToNumber(configName, 'C_ID', columns[1]),
		 targid = ConvertToNumber(configName, 'targid', columns[2]),
		 taglev = ConvertToNumber(configName, 'taglev', columns[3]),
		 nextexp = ConvertToNumber(configName, 'nextexp', columns[4]),
		 roficiencyname = columns[5],
		 consumeids = columns[6],
		 consumenums = columns[7],
		 addexp = ConvertToNumber(configName, 'addexp', columns[8]),
		 uptime = ConvertToNumber(configName, 'uptime', columns[9]),
		 addval = ConvertToNumber(configName, 'addval', columns[10]),
		 awardids = columns[11],
		 awardnums = columns[12],
		 }
		 table.insert(configData,row)
		 configIdx[row.C_ID]=#configData
		 index = index + 1
		 line = nil
		 columns = nil
	 end
	 lines = nil
end
dictlabtaglevup_config.Load()
----------以pb方式加载配置表---end




---@return table<number,dictlabtaglevup_config_cell>
function dictlabtaglevup_config.GetConfigData() return configData end
---@return dictlabtaglevup_config_cell
function dictlabtaglevup_config.GetById(id)
	 if id == nil or configIdx[id]== nil or configData[configIdx[id]] == nil then
		 return nil
	 end
	 return configData[configIdx[id]]
end








----@@@SelfDefine@@@----

---@type table<number,table<number,number>>@第一个key 是 itemID(配方),第二个是ID 表
local newCfg = {}
function dictlabtaglevup_config.AnalyzeCfg()
	for id, cell in pairs(configData) do
		if newCfg[cell.targid] == nil then
			newCfg[cell.targid] = {}
		end
		table.insert(newCfg[cell.targid], cell.C_ID)
	end

	for targid, lvIdTab in pairs(newCfg) do
		table.sort(lvIdTab, function(a, b)
			return a < b
		end)
	end
end

---@param lv @就是索引
---@return dictlabtaglevup_config_cell
function dictlabtaglevup_config.GetDataByItemLv(itemId, lv)
	if newCfg[itemId] then
		if newCfg[itemId][lv] then
			return dictlabtaglevup_config.GetById(newCfg[itemId][lv])
		end
	end

	return nil
end

function dictlabtaglevup_config.GetDataByItemLvNext(itemId, lv)
	if lv >= #newCfg[itemId] then
		lv = #newCfg[itemId]
	end

	if newCfg[itemId] then
		if newCfg[itemId][lv] then
			return dictlabtaglevup_config.GetById(newCfg[itemId][lv])
		end
	end

	return nil
end

----@@@--------@@@----




----%%%FieldSelfDefine%%%----

dictlabtaglevup_config.AnalyzeCfg()

----%%%-------------%%%----








return dictlabtaglevup_config
