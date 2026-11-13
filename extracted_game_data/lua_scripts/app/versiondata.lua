


---@class VersionData @版本信息 比如 10%.1%.10 version 是整个字符串 剩下的三个分别对应三个数字
VersionData = class("VersionData")

function VersionData:initialize()
    self.Version = ""
    self.Version_1 = -99
    self.Version_2 = -99
    self.Version_3 = -99
end

----@param value  string @10.2.333
function VersionData:SetData(value)
    if value == nil or value=="" then
        print("---   版本号异常为空")
        return
    end
    if type(value) ~= "string" then
        print("---   版本号异常",value)
        return
    end

    local tempvalue = string.gsub(value, "%.",'|')
    local datas = HotfixHelper:StringSplitToNumber(tempvalue, '|')
    if #datas ~= 3 then
        print("---   版本号格式错误",value)
        return
    end

    self.Version = value
    self.Version_1 = datas[1]
    self.Version_2 = datas[2]
    self.Version_3 = datas[3]
end

----版本比较 大版本 中版本 小版本
---@param data VersionData
function VersionData:CompareLatest(data)
    if data == nil then
        return self
    end
    if data.Version == "" then
        return self
    end

    if self.Version_1 > data.Version_1 then
        return self
    end

    if self.Version_2 > data.Version_2 then
        return self
    end

    if self.Version_3 > data.Version_3 then
        return self
    end

    return data
end
----版本比较，看当前版本是不是最新的
----@param data VersionData
function VersionData:IsLater(data)
    if data == nil then return true end
    if data.Version == "" then return true end
    if self.Version_1 > data.Version_1 then return true end
    if self.Version_2 > data.Version_2 then return true end
    if self.Version_3 > data.Version_3 then return true end
    return false
end
----版本比较，看当前版本是不是大版本更新
----@param data VersionData
function VersionData:IsLaterPkg(data)
    if data == nil then return false end
    if data.Version == "" then return false end   -- 没有产生热更 上一个版本也没有热更过   不考虑资源替换
    if self.Version_1 > data.Version_1 then return true end
    return false
end

----把版本写到本地缓存中
function VersionData:Save()
    local path = HotfixHelper:GetLocalVersionPath()
    print("---   版本号保存到本地，path = ", path)
    HotfixHelper:WriteFileString(path, self.Version)
end
----返回当前版本 10_1_10
function VersionData:GetVersionFolderName()
    return self.Version_1.."_"..self.Version_2.."_"..self.Version_3
end