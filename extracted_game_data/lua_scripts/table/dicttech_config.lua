



---@class dicttech_config




dicttech_config = {}
---@type table<number,dicttech_config_cell>
local configData = {}
local configIdx = {}




----------以pb方式加载配置表---start
--[[
assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/dicttech')), '')
local bytes = mono.LoadBytes('dicttech')
local cfg = assert(Dll_PB.decode('dicttech_config', bytes))
for i = 1, #cfg.configData do
	 local id = cfg.configData[i].C_ID
	 configData[id] = cfg.configData[i]
end
--]]
----------以txt方式加载配置表---end




----------以txt方式加载配置表---start
local configName = 'dicttech.txt'
function dicttech_config.Load()
	 local content = loadConfig(configName)
	 local lines = stringSplit(content, '\n')
	 local len = #lines
	 local index = 4
	 while index <= len - 1 do
		 local line = lines[index]
		 local columns = stringSplit(line, '\t')
		 local row = {
		 C_ID = ConvertToNumber(configName, 'C_ID', columns[1]),
		 name = columns[2],
		 desc = columns[3],
		 icon = columns[4],
		 alivecd = ConvertToNumber(configName, 'alivecd', columns[5]),
		 aliveconsumes = columns[6],
		 alivenums = columns[7],
		 proctracks = columns[8],
		 floor = ConvertToNumber(configName, 'floor', columns[9]),
		 }
		 table.insert(configData,row)
		 configIdx[row.C_ID]=#configData
		 index = index + 1
		 line = nil
		 columns = nil
	 end
	 lines = nil
end
dicttech_config.Load()
----------以pb方式加载配置表---end




---@return table<number,dicttech_config_cell>
function dicttech_config.GetConfigData() return configData end
---@return dicttech_config_cell
function dicttech_config.GetById(id)
	 if id == nil or configIdx[id]== nil or configData[configIdx[id]] == nil then
		 return nil
	 end
	 return configData[configIdx[id]]
end








----@@@SelfDefine@@@----
---@type table<number,number> @以floor分类的表
local floorDic = {}
local floorTable = {} --分类字典
local floorFullTable = {} --分类

---@return table<number> dicttech_config_cell
function dicttech_config.InitFloorTable()
    for k, v in pairs(configData) do
        if floorDic[v.floor] == nil then
            floorDic[v.floor] = k
        end
        if floorFullTable[v.floor] == nil then
            floorFullTable[v.floor] = {}
        end
        table.insert(floorFullTable[v.floor], k)
    end

    for tagKey, _ in pairs(floorDic) do
        table.insert(floorTable, tagKey)
    end
end

---@return dicttech_config_cell
function dicttech_config.GetDataByFloor(floor)
    for i, v in pairs(floorFullTable) do
        if i == floor then
            return v
        end
    end
    return nil
end

function dicttech_config.GetFloorDic()
    return floorDic
end

function dicttech_config.GetFloorFullTable()
    return floorFullTable
end

function dicttech_config.GetTechIDByProctracksID(ProctracksID)
    for i, v in pairs(configData) do
        local proctracksData = stringSplit(v.proctracks, ':')
        for j, k in pairs(proctracksData) do
            if k == tostring(ProctracksID) then
                return v
            end
        end
    end
    return nil
end

----@@@--------@@@----




----%%%FieldSelfDefine%%%----
dicttech_config.InitFloorTable()
----%%%-------------%%%----








return dicttech_config
