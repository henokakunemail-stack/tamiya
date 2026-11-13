



---@class dictcharge_config




dictcharge_config = {}
---@type table<number,dictcharge_config_cell>
local configData = {}
local configIdx = {}




----------以pb方式加载配置表---start
--[[
assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/dictcharge')), '')
local bytes = mono.LoadBytes('dictcharge')
local cfg = assert(Dll_PB.decode('dictcharge_config', bytes))
for i = 1, #cfg.configData do
	 local id = cfg.configData[i].C_ID
	 configData[id] = cfg.configData[i]
end
--]]
----------以txt方式加载配置表---end




----------以txt方式加载配置表---start
local configName = 'dictcharge.txt'
function dictcharge_config.Load()
	 local content = loadConfig(configName)
	 local lines = stringSplit(content, '\n')
	 local len = #lines
	 local index = 4
	 while index <= len - 1 do
		 local line = lines[index]
		 local columns = stringSplit(line, '\t')
		 local row = {
		 C_ID = ConvertToNumber(configName, 'C_ID', columns[1]),
		 areacode = ConvertToNumber(configName, 'areacode', columns[2]),
		 itemid = ConvertToNumber(configName, 'itemid', columns[3]),
		 innerid = columns[4],
		 inneridios = columns[5],
		 innerid3 = columns[6],
		 innerid4 = columns[7],
		 adjusttoken = columns[8],
		 adjusttoken2 = columns[9],
		 adjusttoken3 = columns[10],
		 adjusttoken4 = columns[11],
		 adjusttoken5 = columns[12],
		 adjusttoken6 = columns[13],
		 adjusttoken7 = columns[14],
		 chargetype = ConvertToNumber(configName, 'chargetype', columns[15]),
		 chargenum = ConvertToNumber(configName, 'chargenum', columns[16]),
		 diamond = ConvertToNumber(configName, 'diamond', columns[17]),
		 addmoney = ConvertToNumber(configName, 'addmoney', columns[18]),
		 acttype = ConvertToNumber(configName, 'acttype', columns[19]),
		 exnum = ConvertToNumber(configName, 'exnum', columns[20]),
		 currencyType = columns[21],
		 pricename = columns[22],
		 name = columns[23],
		 icon = columns[24],
		 brdesc = columns[25],
		 }
		 table.insert(configData,row)
		 configIdx[row.C_ID]=#configData
		 index = index + 1
		 line = nil
		 columns = nil
	 end
	 lines = nil
end
dictcharge_config.Load()
----------以pb方式加载配置表---end




---@return table<number,dictcharge_config_cell>
function dictcharge_config.GetConfigData() return configData end
---@return dictcharge_config_cell
function dictcharge_config.GetById(id)
	 if id == nil or configIdx[id]== nil or configData[configIdx[id]] == nil then
		 return nil
	 end
	 return configData[configIdx[id]]
end








----@@@SelfDefine@@@----
---@type table<ActivityType,number>@value  是ID
local configDataTab = {}
local _NewCfgData={}
local _NewCfgInnerData={}
local _NewCfgInnerIosData={}
local _NewCfgInner2Data={}
local _NewCfgInnerIos2Data={}
function dictcharge_config.InitConfigData()
	for id, cell in pairs(configData) do
		if _NewCfgData[cell.areacode]==nil then
			_NewCfgData[cell.areacode]={}
			_NewCfgInnerData[cell.areacode]={}
			_NewCfgInnerIosData[cell.areacode]={}
			_NewCfgInner2Data[cell.areacode]={}
			_NewCfgInnerIos2Data[cell.areacode]={}
		end
		_NewCfgData[cell.areacode][cell.itemid]=cell
		_NewCfgInnerData[cell.areacode][cell.innerid]=cell
		if cell.inneridios then
			_NewCfgInnerIosData[cell.areacode][cell.inneridios]=cell
		end
		if cell.innerid3 then
			_NewCfgInner2Data[cell.areacode][cell.innerid3]=cell
		end
		if cell.innerid4 then
			_NewCfgInnerIos2Data[cell.areacode][cell.innerid4]=cell
		end
	end
end
function dictcharge_config.GetDataByAreaAndItemId(area,itemid)
	if _NewCfgData[area] then
		return _NewCfgData[area][itemid]
	end
	return _NewCfgData[0][itemid]
end
function dictcharge_config.GetDataByAreaAndInnerId(area,InnerId)
	if _NewCfgInnerData[area] then
		return _NewCfgInnerData[area][InnerId]
	end
	return _NewCfgInnerData[0][InnerId]
end
function dictcharge_config.GetDataByAreaAndInnerIdIos(area,InnerId)
	if _NewCfgInnerIosData[area] then
		return _NewCfgInnerIosData[area][InnerId]
	end
	return _NewCfgInnerIosData[0][InnerId]
end
function dictcharge_config.GetDataByAreaAndInnerId2(area,InnerId)
	if _NewCfgInner2Data[area] then
		return _NewCfgInner2Data[area][InnerId]
	end
	return _NewCfgInner2Data[0][InnerId]
end
function dictcharge_config.GetDataByAreaAndInnerIdIos2(area,InnerId)
	if _NewCfgInnerIos2Data[area] then
		return _NewCfgInnerIos2Data[area][InnerId]
	end
	return _NewCfgInnerIos2Data[0][InnerId]
end

function dictcharge_config.GetDataByArea(area)
	if _NewCfgData[area] then
		return _NewCfgData[area]
	end
	return _NewCfgData[0]
end

---@param activityType ActivityType
function dictcharge_config.GetIdByAvType(chargetype)
	return configDataTab[chargetype]
end

----@@@--------@@@----




----%%%FieldSelfDefine%%%----
dictcharge_config.InitConfigData()
----%%%-------------%%%----








return dictcharge_config
