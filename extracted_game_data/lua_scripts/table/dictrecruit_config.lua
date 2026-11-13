



---@class dictrecruit_config




dictrecruit_config = {}
---@type table<number,dictrecruit_config_cell>
local configData = {}
local configIdx = {}




----------以pb方式加载配置表---start
--[[
assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/dictrecruit')), '')
local bytes = mono.LoadBytes('dictrecruit')
local cfg = assert(Dll_PB.decode('dictrecruit_config', bytes))
for i = 1, #cfg.configData do
	 local id = cfg.configData[i].C_ID
	 configData[id] = cfg.configData[i]
end
--]]
----------以txt方式加载配置表---end




----------以txt方式加载配置表---start
local configName = 'dictrecruit.txt'
function dictrecruit_config.Load()
	 local content = loadConfig(configName)
	 local lines = stringSplit(content, '\n')
	 local len = #lines
	 local index = 4
	 while index <= len - 1 do
		 local line = lines[index]
		 local columns = stringSplit(line, '\t')
		 local row = {
		 C_ID = ConvertToNumber(configName, 'C_ID', columns[1]),
		 serverid = ConvertToNumber(configName, 'serverid', columns[2]),
		 recruitid = ConvertToNumber(configName, 'recruitid', columns[3]),
		 sort = ConvertToNumber(configName, 'sort', columns[4]),
		 moneytype = ConvertToNumber(configName, 'moneytype', columns[5]),
		 oneexpend = ConvertToNumber(configName, 'oneexpend', columns[6]),
		 tenexpend = ConvertToNumber(configName, 'tenexpend', columns[7]),
		 ticketid = ConvertToNumber(configName, 'ticketid', columns[8]),
		 freecd = ConvertToNumber(configName, 'freecd', columns[9]),
		 timeflag = ConvertToNumber(configName, 'timeflag', columns[10]),
		 begintime = ConvertToNumber(configName, 'begintime', columns[11]),
		 endtime = ConvertToNumber(configName, 'endtime', columns[12]),
		 bday = ConvertToNumber(configName, 'bday', columns[13]),
		 eday = ConvertToNumber(configName, 'eday', columns[14]),
		 btime = columns[15],
		 etime = columns[16],
		 tenexpendawardid = ConvertToNumber(configName, 'tenexpendawardid', columns[17]),
		 prizenum = ConvertToNumber(configName, 'prizenum', columns[18]),
		 appointawardid = ConvertToNumber(configName, 'appointawardid', columns[19]),
		 daysum = ConvertToNumber(configName, 'daysum', columns[20]),
		 prizeid = ConvertToNumber(configName, 'prizeid', columns[21]),
		 hitpartid = ConvertToNumber(configName, 'hitpartid', columns[22]),
		 itemids = columns[23],
		 numawards = columns[24],
		 awardids = columns[25],
		 awardnums = columns[26],
		 taskids = columns[27],
		 typeIcon = columns[28],
		 currencyIcon = columns[29],
		 ticketIcon = columns[30],
		 drawIcon = columns[31],
		 drawBack = columns[32],
		 dictawardname = columns[33],
		 dictawarddes = columns[34],
		 noshare = ConvertToNumber(configName, 'noshare', columns[35]),
		 videoname = columns[36],
		 selectpoint = ConvertToNumber(configName, 'selectpoint', columns[37]),
		 atttype = columns[38],
		 showpart = columns[39],
		 showrole = columns[40],
		 maxname = columns[41],
		 bannername = columns[42],
		 }
		 table.insert(configData,row)
		 configIdx[row.C_ID]=#configData
		 index = index + 1
		 line = nil
		 columns = nil
	 end
	 lines = nil
end
dictrecruit_config.Load()
----------以pb方式加载配置表---end




---@return table<number,dictrecruit_config_cell>
function dictrecruit_config.GetConfigData() return configData end
---@return dictrecruit_config_cell
function dictrecruit_config.GetById(id)
	 if id == nil or configIdx[id]== nil or configData[configIdx[id]] == nil then
		 return nil
	 end
	 return configData[configIdx[id]]
end








----@@@SelfDefine@@@----
local __NewConfigData = {}
function dictrecruit_config.AnalyseConfig(id)
	for k, v in pairs(configData) do
		if __NewConfigData[v.serverid]==nil then
			__NewConfigData[v.serverid]={}
		end
		__NewConfigData[v.serverid][v.recruitid]=v
	end
end
function dictrecruit_config.GetDataBuyServerIdAndRecruitid(serverid,id)
	local result=nil
	if __NewConfigData[serverid] then
		if __NewConfigData[serverid][id] then
			result=__NewConfigData[serverid][id]
		end
	end
	if result==nil then
		result=__NewConfigData[0][id]
	end
	return result
end
----@@@--------@@@----




----%%%FieldSelfDefine%%%----
dictrecruit_config.AnalyseConfig()
----%%%-------------%%%----








return dictrecruit_config
