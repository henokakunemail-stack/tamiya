



---@class act_bussiness_config




act_bussiness_config = {}
---@type table<number,act_bussiness_config_cell>
local configData = {}
local configIdx = {}




----------以pb方式加载配置表---start
--[[
assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/act_bussiness')), '')
local bytes = mono.LoadBytes('act_bussiness')
local cfg = assert(Dll_PB.decode('act_bussiness_config', bytes))
for i = 1, #cfg.configData do
	 local id = cfg.configData[i].C_ID
	 configData[id] = cfg.configData[i]
end
--]]
----------以txt方式加载配置表---end




----------以txt方式加载配置表---start
local configName = 'act_bussiness.txt'
function act_bussiness_config.Load()
	 local content = loadConfig(configName)
	 local lines = stringSplit(content, '\n')
	 local len = #lines
	 local index = 4
	 while index <= len - 1 do
		 local line = lines[index]
		 local columns = stringSplit(line, '\t')
		 local row = {
		 C_ID = ConvertToNumber(configName, 'C_ID', columns[1]),
		 acttype = ConvertToNumber(configName, 'acttype', columns[2]),
		 begintime = ConvertToNumber(configName, 'begintime', columns[3]),
		 endtime = ConvertToNumber(configName, 'endtime', columns[4]),
		 actstyle = ConvertToNumber(configName, 'actstyle', columns[5]),
		 itemids = columns[6],
		 finishgift = columns[7],
		 timeflag = ConvertToNumber(configName, 'timeflag', columns[8]),
		 bday = ConvertToNumber(configName, 'bday', columns[9]),
		 eday = ConvertToNumber(configName, 'eday', columns[10]),
		 btime = columns[11],
		 etime = columns[12],
		 orderseq = ConvertToNumber(configName, 'orderseq', columns[13]),
		 actbg = columns[14],
		 actname = columns[15],
		 }
		 table.insert(configData,row)
		 configIdx[row.C_ID]=#configData
		 index = index + 1
		 line = nil
		 columns = nil
	 end
	 lines = nil
end
act_bussiness_config.Load()
----------以pb方式加载配置表---end




---@return table<number,act_bussiness_config_cell>
function act_bussiness_config.GetConfigData() return configData end
---@return act_bussiness_config_cell
function act_bussiness_config.GetById(id)
	 if id == nil or configIdx[id]== nil or configData[configIdx[id]] == nil then
		 return nil
	 end
	 return configData[configIdx[id]]
end








----@@@SelfDefine@@@----
function act_bussiness_config.GetTypeByID(ID)
	for i, v in pairs(configData) do
		if v.C_ID == ID then
			return v.actstyle
		end
	end
end
----@@@--------@@@----




----%%%FieldSelfDefine%%%----

----%%%-------------%%%----








return act_bussiness_config
