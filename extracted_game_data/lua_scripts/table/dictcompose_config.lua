



---@class dictcompose_config




dictcompose_config = {}
---@type table<number,dictcompose_config_cell>
local configData = {}
local configIdx = {}




----------以pb方式加载配置表---start
--[[
assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/dictcompose')), '')
local bytes = mono.LoadBytes('dictcompose')
local cfg = assert(Dll_PB.decode('dictcompose_config', bytes))
for i = 1, #cfg.configData do
	 local id = cfg.configData[i].C_ID
	 configData[id] = cfg.configData[i]
end
--]]
----------以txt方式加载配置表---end




----------以txt方式加载配置表---start
local configName = 'dictcompose.txt'
function dictcompose_config.Load()
	 local content = loadConfig(configName)
	 local lines = stringSplit(content, '\n')
	 local len = #lines
	 local index = 4
	 while index <= len - 1 do
		 local line = lines[index]
		 local columns = stringSplit(line, '\t')
		 local row = {
		 C_ID = ConvertToNumber(configName, 'C_ID', columns[1]),
		 addexp = ConvertToNumber(configName, 'addexp', columns[2]),
		 consumeids = columns[3],
		 consumenums = columns[4],
		 composegold = ConvertToNumber(configName, 'composegold', columns[5]),
		 breakrand = ConvertToNumber(configName, 'breakrand', columns[6]),
		 }
		 table.insert(configData,row)
		 configIdx[row.C_ID]=#configData
		 index = index + 1
		 line = nil
		 columns = nil
	 end
	 lines = nil
end
dictcompose_config.Load()
----------以pb方式加载配置表---end




---@return table<number,dictcompose_config_cell>
function dictcompose_config.GetConfigData() return configData end
---@return dictcompose_config_cell
function dictcompose_config.GetById(id)
	 if id == nil or configIdx[id]== nil or configData[configIdx[id]] == nil then
		 return nil
	 end
	 return configData[configIdx[id]]
end








----@@@SelfDefine@@@----

---@type table<number,table<number,number>> @第一个是配方ID 第二个表示索引表，里面是它的合成ID
local newCfgTable = {}
local cmpTagNameId = {}--一个合成ID 对应 一个 配方id
function dictcompose_config.AnalyseConfig()
	for k, v in pairs(configData) do
		if newCfgTable[v.targid] == nil then
			newCfgTable[v.targid] = {}
		end

		cmpTagNameId[v.partid] = v.targid

		table.insert(newCfgTable[v.targid], v.partid)
	end

end

---@return table<number,number> @返回该配方的表
function dictcompose_config.GetIdTabByItemId(targid)
	local idTable = {}
	if newCfgTable[targid] then
		idTable = newCfgTable[targid]

		table.sort(idTable)

		return idTable
	end

	return idTable
end

---@return number @根据合成ID 找对应的配方ID
function dictcompose_config.GetItemIdByCmpId(partid)
	return cmpTagNameId[partid]
end

---@return number @根据合成ID 找Item
function dictcompose_config.GetItemIdByPartid(partid)
	for k, v in ipairs(configData) do
		if v.partid==partid then
			return v
		end
	end
	return nil
end

----@@@--------@@@----




----%%%FieldSelfDefine%%%----

--dictcompose_config.AnalyseConfig()

----%%%-------------%%%----








return dictcompose_config
