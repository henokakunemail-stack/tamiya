



---@class tracksegmentfactory_config




tracksegmentfactory_config = {}
---@type table<number,tracksegmentfactory_config_cell>
local configData = {}
local configIdx = {}




----------以pb方式加载配置表---start
--[[
assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/tracksegmentfactory')), '')
local bytes = mono.LoadBytes('tracksegmentfactory')
local cfg = assert(Dll_PB.decode('tracksegmentfactory_config', bytes))
for i = 1, #cfg.configData do
	 local id = cfg.configData[i].C_ID
	 configData[id] = cfg.configData[i]
end
--]]
----------以txt方式加载配置表---end




----------以txt方式加载配置表---start
local configName = 'tracksegmentfactory.txt'
function tracksegmentfactory_config.Load()
	 local content = loadConfig(configName)
	 local lines = stringSplit(content, '\n')
	 local len = #lines
	 local index = 4
	 while index <= len - 1 do
		 local line = lines[index]
		 local columns = stringSplit(line, '\t')
		 local row = {
		 C_ID = ConvertToNumber(configName, 'C_ID', columns[1]),
		 type = ConvertToNumber(configName, 'type', columns[2]),
		 typeDesc = columns[3],
		 blue = ConvertToNumber(configName, 'blue', columns[4]),
		 red = ConvertToNumber(configName, 'red', columns[5]),
		 white = ConvertToNumber(configName, 'white', columns[6]),
		 time = ConvertToNumber(configName, 'time', columns[7]),
		 cost = columns[8],
		 technology = ConvertToNumber(configName, 'technology', columns[9]),
		 }
		 table.insert(configData,row)
		 configIdx[row.C_ID]=#configData
		 index = index + 1
		 line = nil
		 columns = nil
	 end
	 lines = nil
end
tracksegmentfactory_config.Load()
----------以pb方式加载配置表---end




---@return table<number,tracksegmentfactory_config_cell>
function tracksegmentfactory_config.GetConfigData() return configData end
---@return tracksegmentfactory_config_cell
function tracksegmentfactory_config.GetById(id)
	 if id == nil or configIdx[id]== nil or configData[configIdx[id]] == nil then
		 return nil
	 end
	 return configData[configIdx[id]]
end








----@@@SelfDefine@@@----
---@type table<number,number> @key是type 表示有多少层  value是id
local NewDataIdx = {}

---@type table<number,number>@层数的索引表 一共多少层
local FloorTab = {}

function tracksegmentfactory_config.AnalyseData()
    ---@param value tracksegmentfactory_config_cell
    for key, value in pairs(configData) do
        if NewDataIdx[value.type] == nil then
            NewDataIdx[value.type] = {}
        end

        table.insert(NewDataIdx[value.type], key)
    end
    for floor, cell in pairs(NewDataIdx) do
        table.insert(FloorTab, floor)
    end
end

function tracksegmentfactory_config.GetFloorByIdx(idx)
    return FloorTab[idx]
end

---@return table<number,number>@返回ID 索引表
function tracksegmentfactory_config.GetDataByAspect(aspect)
    if NewDataIdx[aspect] ~= nil then
        return NewDataIdx[aspect]
    end
    return {}
end

---@return tracksegmentfactory_config_cell
function tracksegmentfactory_config.GetDataByAspectIdx(aspect, idx)
    local idTab = tracksegmentfactory_config.GetDataByAspect(aspect)
    if idTab[idx] then
        return tracksegmentfactory_config.GetById(idTab[idx])
    end
end

function tracksegmentfactory_config.GetAspectCount()
    return #FloorTab
end
----@@@--------@@@----




----%%%FieldSelfDefine%%%----
tracksegmentfactory_config.AnalyseData()
----%%%-------------%%%----








return tracksegmentfactory_config
