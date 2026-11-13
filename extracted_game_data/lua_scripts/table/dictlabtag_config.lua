



---@class dictlabtag_config




dictlabtag_config = {}
---@type table<number,dictlabtag_config_cell>
local configData = {}
local configIdx = {}




----------以pb方式加载配置表---start
--[[
assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/dictlabtag')), '')
local bytes = mono.LoadBytes('dictlabtag')
local cfg = assert(Dll_PB.decode('dictlabtag_config', bytes))
for i = 1, #cfg.configData do
	 local id = cfg.configData[i].C_ID
	 configData[id] = cfg.configData[i]
end
--]]
----------以txt方式加载配置表---end




----------以txt方式加载配置表---start
local configName = 'dictlabtag.txt'
function dictlabtag_config.Load()
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
		 articleid = ConvertToNumber(configName, 'articleid', columns[3]),
		 tag = ConvertToNumber(configName, 'tag', columns[4]),
		 icon = columns[5],
		 tagname = columns[6],
		 projectname = columns[7],
		 }
		 table.insert(configData,row)
		 configIdx[row.C_ID]=#configData
		 index = index + 1
		 line = nil
		 columns = nil
	 end
	 lines = nil
end
dictlabtag_config.Load()
----------以pb方式加载配置表---end




---@return table<number,dictlabtag_config_cell>
function dictlabtag_config.GetConfigData() return configData end
---@return dictlabtag_config_cell
function dictlabtag_config.GetById(id)
	 if id == nil or configIdx[id]== nil or configData[configIdx[id]] == nil then
		 return nil
	 end
	 return configData[configIdx[id]]
end








----@@@SelfDefine@@@----

---@return dictlabtag_config_cell
function dictlabtag_config.GetByTargid(targid)
	if targid == nil then
		return nil
	end

	for id, cell in ipairs(configData) do
		if cell.targid == targid then

			return configData[id]
		end
	end

	return nil
end

---@type table<number,number> @以tag分类的表
local tagDic = {}--key 是tag类型  value 是ID
local tagTable = {}--key 是索引 value 是tag
local tagFullTable = {}--key 是 tag value是 ID 表

---@return table<number> dictlabtag_config_cell
function dictlabtag_config.InitTagTable()
	for k, v in pairs(configData) do
		if tagDic[v.tag] == nil then
			tagDic[v.tag] = k
		end
		if tagFullTable[v.tag] == nil then
			tagFullTable[v.tag] = {}
		end
		table.insert(tagFullTable[v.tag], k)
	end

	for tagKey, _ in pairs(tagDic) do
		table.insert(tagTable, tagKey)
	end
end

---@return dictlabtag_config_cell
function dictlabtag_config.GetDataByTag(tag)
	if tagDic[tag] then
		return dictlabtag_config.GetById(tagDic[tag])
	end
	return nil
end

----@@@--------@@@----




----%%%FieldSelfDefine%%%----

dictlabtag_config.InitTagTable()

----%%%-------------%%%----








return dictlabtag_config
