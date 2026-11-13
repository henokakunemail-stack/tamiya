



---@class encyclopedia_config




encyclopedia_config = {}
---@type table<number,encyclopedia_config_cell>
local configData = {}
local configIdx = {}




----------以pb方式加载配置表---start
--[[
assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/encyclopedia')), '')
local bytes = mono.LoadBytes('encyclopedia')
local cfg = assert(Dll_PB.decode('encyclopedia_config', bytes))
for i = 1, #cfg.configData do
	 local id = cfg.configData[i].C_ID
	 configData[id] = cfg.configData[i]
end
--]]
----------以txt方式加载配置表---end




----------以txt方式加载配置表---start
local configName = 'encyclopedia.txt'
function encyclopedia_config.Load()
	 local content = loadConfig(configName)
	 local lines = stringSplit(content, '\n')
	 local len = #lines
	 local index = 4
	 while index <= len - 1 do
		 local line = lines[index]
		 local columns = stringSplit(line, '\t')
		 local row = {
		 C_ID = ConvertToNumber(configName, 'C_ID', columns[1]),
		 page = ConvertToNumber(configName, 'page', columns[2]),
		 pageName = columns[3],
		 type = ConvertToNumber(configName, 'type', columns[4]),
		 typeName = columns[5],
		 name = columns[6],
		 desc = columns[7],
		 icon = columns[8],
		 detail = columns[9],
		 }
		 table.insert(configData,row)
		 configIdx[row.C_ID]=#configData
		 index = index + 1
		 line = nil
		 columns = nil
	 end
	 lines = nil
end
encyclopedia_config.Load()
----------以pb方式加载配置表---end




---@return table<number,encyclopedia_config_cell>
function encyclopedia_config.GetConfigData() return configData end
---@return encyclopedia_config_cell
function encyclopedia_config.GetById(id)
	 if id == nil or configIdx[id]== nil or configData[configIdx[id]] == nil then
		 return nil
	 end
	 return configData[configIdx[id]]
end








----@@@SelfDefine@@@----
local partsIntro = {}
local attriMain = {}
local attriSecondary = {}
local errorMsg = {}
local trackSegInfo = {}
function encyclopedia_config.Classify()
	for id, data in pairs(configData) do
		if data.page == 1 then
			table.insert(partsIntro, data)
		end if data.page == 4 then
			table.insert(errorMsg, data)
	    end if data.page == 6 then
			table.insert(trackSegInfo, data)
		elseif data.page == 2 then
			if data.type == 1 then
				table.insert(attriMain, data)
			elseif data.type == 2 then
				table.insert(attriSecondary, data)
			end
		end
	end
end

function encyclopedia_config.GetPartsIntro()
	return partsIntro
end

function encyclopedia_config.GetAttriMain()
	return attriMain
end

function encyclopedia_config.GetAttriSecondary()
	return attriSecondary
end
function encyclopedia_config.GetErrorMsg()
	return errorMsg
end
function encyclopedia_config.GetTrackSegMsg()
	return trackSegInfo
end

----@@@--------@@@----




----%%%FieldSelfDefine%%%----
encyclopedia_config.Classify()
----%%%-------------%%%----








return encyclopedia_config
