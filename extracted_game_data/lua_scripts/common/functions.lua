

local tableToString = function(...)
	local arg={...}
	local str = ""
	for i,v in ipairs(arg) do
		if v then
			if type(v) == "string" then
				str = str..v.."\t"
			else
				str = str..tostring(v).."\t"
			end
		else
			str = str.."nil\t"
		end
	end
	return str
end


function log(...)
    --mono.LogDebug(tableToString(...))
	print(...)
end

function logError(...)
	mono.LogError(tableToString(...))
end

function logWarn(...)
	mono.LogWarning(tableToString(...))
end

function loadConfig(configName)
	return mono.LoadTxt(configName)
end
function loadSqlData(configName,filds,func)
	mono.LoadSqlData(configName,filds,func)
end

---- 字符串分割 返回table 数组
--function stringSplit( srcStr, split )
--	local res = {}
--	local iterator = string.gmatch(srcStr,split)
--	for v in iterator do
--		local pos = string.find(srcStr,v)
--		res[#res + 1] = string.sub(srcStr,1,pos-1)
--		srcStr = string.sub(srcStr,pos + 1,#srcStr)
--	end
--	res[#res + 1] = srcStr
--	return res
--end
function string_SplitRex(str, delimiter)
	if str == nil or str == '' or delimiter == nil then
		return nil
	end
	local result = {}
	local match=string.gmatch(str,delimiter)
	local start=1
	for v in match do
		local s,e,temp=string.find(str,v)
		local sub=string.sub(str,start,(s-start))
		str=string.sub(str,e+1)
		table.insert(result,sub)
    end
	if #str>0 then
		table.insert(result,str)
	end
	return result
end
---"asdasd{1}asdasd{2}asdasd{3}dasdas"
function StringFormat(srcStr,...)
  local args={...}
  local result=string_SplitRex(srcStr,"{%d+}")
	if #result~=#args+1 then
		logError("字符串和参数不匹配")
		return
	end
  local formatStr=""
	for i = 1, #args do
       formatStr=formatStr..result[i]..args[i]
	end
	formatStr=formatStr..result[#args+1]
    return formatStr
end
function ConvertToNumber(configName, field, value)
	local result = tonumber(value)
	if result ~= nil then
		return result
	else
		logError("Config Load Error :"..configName.." 字段 :"..field.." 内容:"..(value or "nil").."---不是数字")
		return 0
	end
end

function isLoadAssetFinish( assets )
	local length = #assets
	local progress = 0

	for i, v in pairs(assets) do
		if not v.isDone then
			return false
		end

		progress = progress + v.progress
	end

	return true, progress / length
end

---- 字符串分割  输入字符串和分隔符，返回number数组
--function stringSplitToNumber( srcStr, split )
--	local res = stringSplit(srcStr, split)
--	for i = 1, #res do
--		res[i] = tonumber(res[i])
--	end
--	return res
--end


-- 字符串分割 返回table 数组
function stringSplit_InputTable( srcStr, tab )
	local res = {}
	for i = 1, #tab do
		if tab[i] ~= '|' then
			string.gsub(srcStr,tab[i],'|')
		end

	end
	res = stringSplit(srcStr, '|')
	return res
end

-- 字符串分割 返回table 数组
function stringSplitToNumber_InputTable( srcStr, tab )
	local res = stringSplit_InputTable(srcStr, tab)
	for i = 1, #res do
		res[i] = tonumber(res[i])
	end
	return res
end

function GameObjectIsNull(unity_object)
	if unity_object == nil then
		return true
	end
	return CS.UIUtil.IsNull(unity_object)
end

function StringTrim(s)
	return (string.gsub(s, "^%s*(.-)%s*$", "%1"))
end




local stringSplit_count = 0
local stringSplit_startidx = 1
local stringSplit_endidx = 1
local stringSplit_dataidx = 1
function stringSplit( srcStr, split )
	stringSplit_count = #srcStr
	stringSplit_startidx = 1
	stringSplit_endidx = 1
	stringSplit_dataidx = 1

	local res = {}
	for i = 1, stringSplit_count do
		local char = string.sub(srcStr, i, i)
		if char == split then
			stringSplit_endidx = i - 1
			res[stringSplit_dataidx] = string.sub(srcStr, stringSplit_startidx, stringSplit_endidx)
			stringSplit_startidx = i + 1
			stringSplit_endidx = i + 1
			stringSplit_dataidx = stringSplit_dataidx + 1
		end
	end
	res[stringSplit_dataidx] = string.sub(srcStr, stringSplit_startidx, stringSplit_count)

	return res
end

function StringConfigField(value)
	local row = {}
	local languageType = LanguageSwitchManager.Get():GetCurLanguage()
	row.C_ID = value.C_ID
	if languageType==LanguageType.CHS then
		row.chs = value.chs
	end
	if languageType==LanguageType.CHT then
		row.cht =  value.cht
	end
	if languageType==LanguageType.EN then
		row.en =  value.en
	end
	if languageType==LanguageType.THAI then
		row.tai =  value.tai
	end
	if languageType==LanguageType.IDA  then
		row.ind =  value.ind
	end
	if languageType==LanguageType.PT_BR  then
		row.pt_BR =  value.pt_BR
	end
	if languageType==LanguageType.KR  then
		row.kr =  value.kr
	end
	value=nil
	return row
end








local stringSplitToNumber_count = 0
local stringSplitToNumber_startidx = 1
local stringSplitToNumber_endidx = 1
local stringSplitToNumber_dataidx = 1

-- 字符串分割  输入字符串和分隔符，返回number数组
function stringSplitToNumber( srcStr, split )
	if srcStr==nil then
		assert(srcStr,"字符串为空"..debug.traceback()) return
	end
	stringSplitToNumber_count = #srcStr
	stringSplitToNumber_startidx = 1
	stringSplitToNumber_endidx = 1
	stringSplitToNumber_dataidx = 1

	local res = {}
	try(function()
		for i = 1, stringSplitToNumber_count do
			local char = string.sub(srcStr, i, i)
			if char == split then
				stringSplitToNumber_endidx = i - 1
				res[stringSplitToNumber_dataidx] = tonumber( string.sub(srcStr, stringSplitToNumber_startidx, stringSplitToNumber_endidx) )
				stringSplitToNumber_startidx = i + 1
				stringSplitToNumber_endidx = i + 1
				stringSplitToNumber_dataidx = stringSplitToNumber_dataidx + 1
			end
		end

		res[stringSplitToNumber_dataidx] = tonumber(string.sub(srcStr, stringSplitToNumber_startidx, stringSplitToNumber_count))
	end).catch(function(error)
		log("解析报错",debug.traceback())
	end)
	return res
end


function getStringLength(inputstr)
	if not inputstr or type(inputstr) ~= "string" or #inputstr <= 0 then
		return nil
	end
	local length = 0  -- 字符的个数
	local i = 1
	while true do
		local curByte = string.byte(inputstr, i)
		local byteCount = 1
		local charLen=0
		if curByte > 239 then
			byteCount = 4  -- 4字节字符
			charLen=4
		elseif curByte > 223 then
			byteCount = 3  -- 汉字
			charLen=2
		elseif curByte > 128 then
			byteCount = 2  -- 双字节字符
			charLen=1
		else
			charLen=1
			byteCount = 1  -- 单字节字符
		end
		-- local char = string.sub(inputstr, i, i + byteCount - 1)
		-- print(char)  -- 打印单个字符
		i = i + byteCount
		length = length + charLen
		if i > #inputstr then
			break
		end
	end
	return length
end
function getStringTrueLength(inputstr)
	if not inputstr or type(inputstr) ~= "string" or #inputstr <= 0 then
		return nil
	end
	local result={}
	local length = 0  -- 字符的个数
	local i = 1
	while true do
		local curByte = string.byte(inputstr, i)
		local byteCount = 1
		local charLen=0
		if curByte > 239 then
			byteCount = 4  -- 4字节字符
			charLen=1
		elseif curByte > 223 then
			byteCount = 3  -- 汉字
			charLen=1
		elseif curByte > 128 then
			byteCount = 2  -- 双字节字符
			charLen=1
		else
			charLen=1
			byteCount = 1  -- 单字节字符
		end
		 local char = string.sub(inputstr, i, i + byteCount - 1)
		table.insert(result,char)
		-- print(char)  -- 打印单个字符
		i = i + byteCount
		length = length + charLen
		if i > #inputstr then
			break
		end
	end
	return length,result
end
