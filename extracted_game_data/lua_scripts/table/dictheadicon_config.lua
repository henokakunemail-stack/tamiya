



---@class dictheadicon_config




dictheadicon_config = {}
---@type table<number,dictheadicon_config_cell>
local configData = {}
local configIdx = {}




----------以pb方式加载配置表---start
--[[
assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/dictheadicon')), '')
local bytes = mono.LoadBytes('dictheadicon')
local cfg = assert(Dll_PB.decode('dictheadicon_config', bytes))
for i = 1, #cfg.configData do
	 local id = cfg.configData[i].C_ID
	 configData[id] = cfg.configData[i]
end
--]]
----------以txt方式加载配置表---end




----------以txt方式加载配置表---start
local configName = 'dictheadicon.txt'
function dictheadicon_config.Load()
	 local content = loadConfig(configName)
	 local lines = stringSplit(content, '\n')
	 local len = #lines
	 local index = 4
	 while index <= len - 1 do
		 local line = lines[index]
		 local columns = stringSplit(line, '\t')
		 local row = {
		 C_ID = ConvertToNumber(configName, 'C_ID', columns[1]),
		 headtype = ConvertToNumber(configName, 'headtype', columns[2]),
		 subtype = ConvertToNumber(configName, 'subtype', columns[3]),
		 unlocktype = ConvertToNumber(configName, 'unlocktype', columns[4]),
		 cond = columns[5],
		 term = columns[6],
		 endtime = ConvertToNumber(configName, 'endtime', columns[7]),
		 initunlock = ConvertToNumber(configName, 'initunlock', columns[8]),
		 icon = columns[9],
		 name = columns[10],
		 }
		 table.insert(configData,row)
		 configIdx[row.C_ID]=#configData
		 index = index + 1
		 line = nil
		 columns = nil
	 end
	 lines = nil
end
dictheadicon_config.Load()
----------以pb方式加载配置表---end




---@return table<number,dictheadicon_config_cell>
function dictheadicon_config.GetConfigData() return configData end
---@return dictheadicon_config_cell
function dictheadicon_config.GetById(id)
	 if id == nil or configIdx[id]== nil or configData[configIdx[id]] == nil then
		 return nil
	 end
	 return configData[configIdx[id]]
end








----@@@SelfDefine@@@----
local newConfig={}
function dictheadicon_config.SetNewConfigData()
	for _,v in pairs(configData) do
		if newConfig[v.headtype]==nil then
			newConfig[v.headtype]={}
		end
		if newConfig[v.headtype][v.subtype]==nil then
			newConfig[v.headtype][v.subtype]={}
		end
		v.NewIcon=v.icon..".png"
		table.insert(newConfig[v.headtype][v.subtype],v)
	end
end
---@return headicon_config_cell
function dictheadicon_config.GetConfigDataByType(headIconType, headIconAttrType)
	local result={}
	if headIconType then
		if headIconAttrType then
			if newConfig[headIconType] then
				if newConfig[headIconType][headIconAttrType] then
					result= newConfig[headIconType][headIconAttrType]
				end
			end
		else
			if newConfig[headIconType] then
				result= newConfig[headIconType]
			end
		end
	end
	return result
end


----@@@--------@@@----




----%%%FieldSelfDefine%%%----
dictheadicon_config.SetNewConfigData()
----%%%-------------%%%----








return dictheadicon_config
