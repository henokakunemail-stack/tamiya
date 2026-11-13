



---@class dicttempletstring_config




dicttempletstring_config = {}
---@type table<number,dicttempletstring_config_cell>
local configData = {}
local configIdx = {}




----------以pb方式加载配置表---start
--[[
assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/dicttempletstring')), '')
local bytes = mono.LoadBytes('dicttempletstring')
local cfg = assert(Dll_PB.decode('dicttempletstring_config', bytes))
for i = 1, #cfg.configData do
	 local id = cfg.configData[i].C_ID
	 configData[id] = cfg.configData[i]
end
--]]
----------以txt方式加载配置表---end




----------以txt方式加载配置表---start
local configName = 'dicttempletstring_key.txt'
local configName_chs = 'dicttempletstring_chs.txt'
local configName_cht = 'dicttempletstring_cht.txt'
local configName_en = 'dicttempletstring_en.txt'
local configName_tai = 'dicttempletstring_tai.txt'
local configName_ind = 'dicttempletstring_ind.txt'
local configName_pt_BR = 'dicttempletstring_pt_BR.txt'
local configName_kr = 'dicttempletstring_kr.txt'
function dicttempletstring_config.Load()
	 local content = loadConfig(configName)
	 local linesString = nil
	 local lines = stringSplit(content, '\n')
	 content=nil
	 local len = #lines
	 local languageType =  CS.Horizon.Game.Language.LanguageSwitchManager.Get():GetCurLanguage()
	 if languageType== LanguageType.CHS then local content = loadConfig(configName_chs) linesString = stringSplit(content, '\n') end
	 if languageType== LanguageType.CHT then local content = loadConfig(configName_cht) linesString = stringSplit(content, '\n') end
	 if languageType== LanguageType.EN then local content = loadConfig(configName_en) linesString = stringSplit(content, '\n') end
	 if languageType== LanguageType.THAI then local content = loadConfig(configName_tai) linesString = stringSplit(content, '\n') end
	 if languageType== LanguageType.IDA then local content = loadConfig(configName_ind) linesString = stringSplit(content, '\n') end
	 if languageType== LanguageType.PT_BR then local content = loadConfig(configName_pt_BR) linesString = stringSplit(content, '\n') end
	 if languageType== LanguageType.KR then local content = loadConfig(configName_kr) linesString = stringSplit(content, '\n') end
	 if linesString==nil then return end
	 local index = 4
	 while index <= len - 1 do
		 local line = lines[index]
		 local lineString = linesString[index]
		 local columns = stringSplit(line, '\t')
		 local contentString = stringSplit(lineString, '\t')
		 local row = {
		 C_ID = columns[1],
		 text=contentString[1]
		 }
		 table.insert(configData,row)
		 configIdx[row.C_ID]=#configData
		 index = index + 1
		 line = nil
		 columns = nil
		 lineString = nil
		 contentString = nil
	 end
	 lines = nil
	 linesString = nil
end
dicttempletstring_config.Load()
----------以pb方式加载配置表---end




---@return table<number,dicttempletstring_config_cell>
function dicttempletstring_config.GetConfigData() return configData end
---@return dicttempletstring_config_cell
function dicttempletstring_config.GetById(id)
	 if id == nil or configIdx[id]== nil or configData[configIdx[id]] == nil then
		 return nil
	 end
	 return configData[configIdx[id]]
end








----@@@SelfDefine@@@----
function dicttempletstring_config.AnalyseConfig(id)
----@@@SkipInLuaCfg@@@----
--	for k, v in pairs(configData) do
--		configData[k]=StringConfigField(v)
--	end
----@@@EndSkipInLuaCfg@@@----
end
function dicttempletstring_config.ReLoad()
	configData = nil
	configIdx = nil
	configData = {}
	configIdx = {}
	dicttempletstring_config.Load()
end


----@@@--------@@@----




----%%%FieldSelfDefine%%%----
dicttempletstring_config.AnalyseConfig()
----%%%-------------%%%----








return dicttempletstring_config
