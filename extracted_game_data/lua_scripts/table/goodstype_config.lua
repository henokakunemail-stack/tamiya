



---@class goodstype_config




goodstype_config = {}
---@type table<number,goodstype_config_cell>
local configData = {}
local configIdx = {}




----------以pb方式加载配置表---start
--[[
assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/goodstype')), '')
local bytes = mono.LoadBytes('goodstype')
local cfg = assert(Dll_PB.decode('goodstype_config', bytes))
for i = 1, #cfg.configData do
	 local id = cfg.configData[i].C_ID
	 configData[id] = cfg.configData[i]
end
--]]
----------以txt方式加载配置表---end




----------以txt方式加载配置表---start
local configName = 'goodstype.txt'
function goodstype_config.Load()
	 local content = loadConfig(configName)
	 local lines = stringSplit(content, '\n')
	 local len = #lines
	 local index = 4
	 while index <= len - 1 do
		 local line = lines[index]
		 local columns = stringSplit(line, '\t')
		 local row = {
		 C_ID = ConvertToNumber(configName, 'C_ID', columns[1]),
		 type1 = ConvertToNumber(configName, 'type1', columns[2]),
		 typename1 = columns[3],
		 type2 = ConvertToNumber(configName, 'type2', columns[4]),
		 icon = columns[5],
		 typename2 = columns[6],
		 type3 = ConvertToNumber(configName, 'type3', columns[7]),
		 typename3 = columns[8],
		 }
		 table.insert(configData,row)
		 configIdx[row.C_ID]=#configData
		 index = index + 1
		 line = nil
		 columns = nil
	 end
	 lines = nil
end
goodstype_config.Load()
----------以pb方式加载配置表---end




---@return table<number,goodstype_config_cell>
function goodstype_config.GetConfigData() return configData end
---@return goodstype_config_cell
function goodstype_config.GetById(id)
	 if id == nil or configIdx[id]== nil or configData[configIdx[id]] == nil then
		 return nil
	 end
	 return configData[configIdx[id]]
end








----@@@SelfDefine@@@----
function goodstype_config.GetDataType3(type1,type2,type3)
	for k,v in pairs(configData) do
		if v.type1 == type1 and v.type2 == type2 and v.type3 == type3 then
			return v.typename3
		end
	end
	return ""
end


function goodstype_config.GetDataType2(type1,type2)
	for k,v in pairs(configData) do
		if v.type1 == type1 and v.type2 == type2  then
			return v.typename2
		end
	end
	return ""
end

function goodstype_config.GetDataType1(type1)
	for k,v in pairs(configData) do
		if v.type1 == type1 then
			return v.typename1
		end
	end
	return ""
end

---@return table<number,goodstype_config_cell>
function goodstype_config.GetListType2(type1)
	local result={}
	for k,v in pairs(configData) do
		if v.type1 == type1 then
			local flag=false
			for i = 1, #result do
				if result[i].type2==v.type2 then
					flag=true
					break
				end
			end
			if not flag then
				table.insert(result,v)
			end
		end
	end
	return result
end
---@return table<number,goodstype_config_cell>
function goodstype_config.GetListType3(type1,type2)
	local result={}
	for k,v in pairs(configData) do
		if v.type1 == type1 and v.type2==type2 then
			local flag=false
			for i = 1, #result do
				if result[i].type3==v.type3 then
					flag=true
					break
				end
			end
			if not flag then
				table.insert(result,v)
			end
		end
	end
	return result
end

---@return table<number,goodstype_config_cell>
function goodstype_config.GetDataType2Icon(type1,type2)
	for k,v in pairs(configData) do
		if v.type1 == type1 and v.type2 == type2  then
			return v.icon
		end
	end
	return ""
end
---@return table<number,goodstype_config_cell>
function goodstype_config.GetDataType3Icon(type1,type2,type3)
	for k,v in pairs(configData) do
		if v.type1 == type1 and v.type2 == type2 and v.type3==type3 then
			return v.icon
		end
	end
	return ""
end

----@@@--------@@@----




----%%%FieldSelfDefine%%%----

----%%%-------------%%%----








return goodstype_config
