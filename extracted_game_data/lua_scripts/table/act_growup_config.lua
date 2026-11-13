



---@class act_growup_config




act_growup_config = {}
---@type table<number,act_growup_config_cell>
local configData = {}
local configIdx = {}




----------以pb方式加载配置表---start
--[[
assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/act_growup')), '')
local bytes = mono.LoadBytes('act_growup')
local cfg = assert(Dll_PB.decode('act_growup_config', bytes))
for i = 1, #cfg.configData do
	 local id = cfg.configData[i].C_ID
	 configData[id] = cfg.configData[i]
end
--]]
----------以txt方式加载配置表---end




----------以txt方式加载配置表---start
local configName = 'act_growup.txt'
function act_growup_config.Load()
	 local content = loadConfig(configName)
	 local lines = stringSplit(content, '\n')
	 local len = #lines
	 local index = 4
	 while index <= len - 1 do
		 local line = lines[index]
		 local columns = stringSplit(line, '\t')
		 local row = {
		 C_ID = ConvertToNumber(configName, 'C_ID', columns[1]),
		 growtype = ConvertToNumber(configName, 'growtype', columns[2]),
		 lev = ConvertToNumber(configName, 'lev', columns[3]),
		 awardids = columns[4],
		 awardnums = columns[5],
		 hawardids = columns[6],
		 hawardnums = columns[7],
		 }
		 table.insert(configData,row)
		 configIdx[row.C_ID]=#configData
		 index = index + 1
		 line = nil
		 columns = nil
	 end
	 lines = nil
end
act_growup_config.Load()
----------以pb方式加载配置表---end




---@return table<number,act_growup_config_cell>
function act_growup_config.GetConfigData() return configData end
---@return act_growup_config_cell
function act_growup_config.GetById(id)
	 if id == nil or configIdx[id]== nil or configData[configIdx[id]] == nil then
		 return nil
	 end
	 return configData[configIdx[id]]
end








----@@@SelfDefine@@@----
function act_growup_config.GetAllData()
	local _Data = { }
	for i, v in pairs(configData) do
		table.insert(_Data, v)
	end
	return _Data
end

function act_growup_config.GetAllDataByType(_type)
	local _Data = { }
	for i, v in pairs(configData) do
		if v.growtype == _type then
			table.insert(_Data, v)
		end
	end
	return _Data
end

function act_growup_config.GetAllNumByDiamond()
	local diamondNum = 0
	for i, v in pairs(configData) do
		if v.awardids == tostring(CurrencyType.Diamond) then
			diamondNum = diamondNum + v.awardnums
		end
		if v.hawardids == tostring(CurrencyType.Diamond) then
			diamondNum = diamondNum + v.hawardnums
		end

	end
	return diamondNum
end

function act_growup_config.GetAllNumByDiamondByType(_type, _start, _length)
	local _diamond = tostring(CurrencyType.Diamond)
	local diamondNum = 0

	local _data = {}
	for i, v in pairs(configData) do
		if v.growtype == _type then
			table.insert(_data, v)
		end
	end

	for i = _start, _length do
		if _data[i].awardids == _diamond then
			diamondNum = diamondNum + _data[i].awardnums
		end
		if _data[i].hawardids == _diamond then
			diamondNum = diamondNum + _data[i].hawardnums
		end
	end

	return diamondNum
end

----@@@--------@@@----




----%%%FieldSelfDefine%%%----

----%%%-------------%%%----








return act_growup_config
