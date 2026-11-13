



---@class dictaward_config




dictaward_config = {}
---@type table<number,dictaward_config_cell>
local configData = {}
local configIdx = {}




----------以pb方式加载配置表---start
--[[
assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/dictaward')), '')
local bytes = mono.LoadBytes('dictaward')
local cfg = assert(Dll_PB.decode('dictaward_config', bytes))
for i = 1, #cfg.configData do
	 local id = cfg.configData[i].C_ID
	 configData[id] = cfg.configData[i]
end
--]]
----------以txt方式加载配置表---end




----------以txt方式加载配置表---start
local configName = 'dictaward.txt'
function dictaward_config.Load()
	 local content = loadConfig(configName)
	 local lines = stringSplit(content, '\n')
	 local len = #lines
	 local index = 4
	 while index <= len - 1 do
		 local line = lines[index]
		 local columns = stringSplit(line, '\t')
		 local row = {
		 C_ID = ConvertToNumber(configName, 'C_ID', columns[1]),
		 awardid = ConvertToNumber(configName, 'awardid', columns[2]),
		 propsid = ConvertToNumber(configName, 'propsid', columns[3]),
		 propsnum = ConvertToNumber(configName, 'propsnum', columns[4]),
		 prize = ConvertToNumber(configName, 'prize', columns[5]),
		 }
		 table.insert(configData,row)
		 configIdx[row.C_ID]=#configData
		 index = index + 1
		 line = nil
		 columns = nil
	 end
	 lines = nil
end
dictaward_config.Load()
----------以pb方式加载配置表---end




---@return table<number,dictaward_config_cell>
function dictaward_config.GetConfigData() return configData end
---@return dictaward_config_cell
function dictaward_config.GetById(id)
	 if id == nil or configIdx[id]== nil or configData[configIdx[id]] == nil then
		 return nil
	 end
	 return configData[configIdx[id]]
end








----@@@SelfDefine@@@----
---@type table<number,table<number,table<number,number>>> @第一个是recruitID，第二个是配件品质的表，从高到低排列，第三个是物品的ID表
local award = {}
---@type table<number,number> 品质的索引表，根据索引排序
local sortFabric = {}

function dictaward_config.SortConfigData()
	---@type dictaward_config_cell
	for id, cell in pairs(configData) do
		if cell.awardid ~= 0 then
			if award[cell.awardid] == nil then
				award[cell.awardid] = {}
			end
			table.insert(award[cell.awardid],cell)
		end
	end
end

---@return table<number,dictaward_config_cell>@返回part的ID表
function dictaward_config.GetPropTableByIdIdx(recruitId)
	return award[recruitId]
end

----@@@--------@@@----




----%%%FieldSelfDefine%%%----
dictaward_config.SortConfigData()
----%%%-------------%%%----








return dictaward_config
