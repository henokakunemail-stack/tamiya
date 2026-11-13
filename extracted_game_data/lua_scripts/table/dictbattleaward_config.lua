



---@class dictbattleaward_config




dictbattleaward_config = {}
---@type table<number,dictbattleaward_config_cell>
local configData = {}
local configIdx = {}




----------以pb方式加载配置表---start
--[[
assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/dictbattleaward')), '')
local bytes = mono.LoadBytes('dictbattleaward')
local cfg = assert(Dll_PB.decode('dictbattleaward_config', bytes))
for i = 1, #cfg.configData do
	 local id = cfg.configData[i].C_ID
	 configData[id] = cfg.configData[i]
end
--]]
----------以txt方式加载配置表---end




----------以txt方式加载配置表---start
local configName = 'dictbattleaward.txt'
function dictbattleaward_config.Load()
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
		 speedfrom = ConvertToNumber(configName, 'speedfrom', columns[3]),
		 speedto = ConvertToNumber(configName, 'speedto', columns[4]),
		 awardids = columns[5],
		 awardnums = columns[6],
		 jackpottype = columns[7],
		 jackpotper = ConvertToNumber(configName, 'jackpotper', columns[8]),
		 }
		 table.insert(configData,row)
		 configIdx[row.C_ID]=#configData
		 index = index + 1
		 line = nil
		 columns = nil
	 end
	 lines = nil
end
dictbattleaward_config.Load()
----------以pb方式加载配置表---end




---@return table<number,dictbattleaward_config_cell>
function dictbattleaward_config.GetConfigData() return configData end
---@return dictbattleaward_config_cell
function dictbattleaward_config.GetById(id)
	 if id == nil or configIdx[id]== nil or configData[configIdx[id]] == nil then
		 return nil
	 end
	 return configData[configIdx[id]]
end








----@@@SelfDefine@@@----
function dictbattleaward_config.GetDataByAwardID(awardID)
    local awardIDData = {}

    for i, v in pairs(configData) do
        if v.awardid == awardID then
            table.insert(awardIDData, v)
        end
    end

    table.sort(awardIDData, function(a, b)
        return a.speedto < b.speedto
    end)

    return awardIDData
end

function dictbattleaward_config.GetFirstDataByAwardID(awardID)
	for i, v in pairs(configData) do
		if v.awardid == awardID and v.speedfrom == 1 then
			return v
		end
	end

	return nil
end

function dictbattleaward_config.GetTicketData()
	local data={}

	for i, v in pairs(configData) do
		if CommonHelper:Contains(data, v.awardid) then
		else
			table.insert(data,v.awardid)
		end
	end

	return data
end
local _NewConfigData={}
function dictbattleaward_config.AnalyseConfig()

	for i, v in pairs(configData) do
		if _NewConfigData[v.awardid]==nil then
			_NewConfigData[v.awardid]={}
		end
		table.insert(_NewConfigData[v.awardid],v)
	end

end

function dictbattleaward_config.GetTableDataByAwardIdAndRank(awardid,rank)
	local awardTab=_NewConfigData[awardid]
	for k, v in pairs(awardTab) do
		if rank <= v.speedto and rank>=v.speedfrom then
			return v
		end
	end
	return nil
end

function dictbattleaward_config.GetTableDataByAwardId(awardid)
	local awardTab=_NewConfigData[awardid]

	return awardTab
end




----@@@--------@@@----




----%%%FieldSelfDefine%%%----
dictbattleaward_config.AnalyseConfig()
----%%%-------------%%%----








return dictbattleaward_config
