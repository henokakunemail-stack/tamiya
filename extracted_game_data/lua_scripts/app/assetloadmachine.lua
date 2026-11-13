---@class AssetLoadMachine @加载资源
AssetLoadMachine = class("AssetLoadMachine")
function AssetLoadMachine:initialize()
    ---@type table<number, AssetData> @已经从网络上下载完的资源
    self.FinishAssetList = {}
    ---@type table<string, AssetData>@正在等待下载的资源 key 是fileName
    self.WaitingList = {}

    ---@type table<string, AssetData>@需要重新加载的资源 @key 是fileName
    self.ReloadList = {}
    ---@type table<string, CS.HttpHelper2>@需要重新加载的资源 @key 是fileName
    self.HttpHelperList = {}

    self.Working = false

    self.Max = 0--最大的资源数量
    self.FinishCount = 0--完成的资源数量

    self.FinishMemory = 0--加载完的资源内存B
    self.FinishMemoryKB = 0--加载完的资源内存KB
    self.FinishMemoryMB = 0--加载完的资源内存MB

    self.FileMemory = 0--要加载的资源的大小B
    self.FileMemoryMB = 0--要加载的资源的大小MB

    self.LoadFinish = nil--加载完之后的回调
    self.LoadStep = 0
    self.downLoadCoroutine = nil
    self.progressIndex = 0
end

---@param list table<number,AssetData>
function AssetLoadMachine:Start(list, finish)
    if self.Working then
        print("---   error:下载器正在运行中...")
        self:SdkLogLoadFail(-1001)
        return
    end

    if list == nil then
        print("---   error:下载器接收空数据...")
        self:SdkLogLoadFail(-1002)
        return
    end
    print("---   开始下载热更资源...", #list, CS.UnityEngine.Time.realtimeSinceStartup)

    self:ClearCache()

    self:SetData(list)

    self.Working = true

    self.LoadFinish = finish

    self:SdkLogStartLoad()
    print("---   开始下载热更资源222...", #list, CS.UnityEngine.Time.realtimeSinceStartup)
    self:StartLoad()
    print("---   开始下载热更资源333...", #list, CS.UnityEngine.Time.realtimeSinceStartup)
end

----设置要加载的资源信息，包括waitingList{}、 要加载的资源的大小 fileMemory
---@param list table<number,AssetData>
function AssetLoadMachine:SetData(list)
    self.Max = #list

    self.FinishCount = 0
    self.FinishMemory = 0

    self.FileMemory = 0
    self.FileMemoryMB = 0
    self.DownloadFinish=false
    self.WaitingList = {}
    for i = 1, #list do
        self.WaitingList[list[i].FileName] = list[i]
        self.FileMemory = self.FileMemory + list[i].Size
    end

    self.FileMemoryMB = self.FileMemory / 1024 / 1024

    HotfixHelper:TrackAppStart("HotFix_Start",self.FileMemory,nil,false,AnalysisType.start_update)
    --self:CaculateFileMemory()
end

--function AssetLoadMachine:CaculateFileMemory()
--    local memory = 0
--    for k, v in pairs(self.WaitingList) do
--        if v then
--            memory = memory + v.Size
--        end
--    end
--
--    self.FileMemory = memory
--    self.FileMemoryMB = memory / 1024 / 1024
--end

function AssetLoadMachine:ReStartLoad()
    --[[if self.DownloadFinish then
        return
    end
    self:ClearCoroutine()

    for k, v in pairs(self.HttpHelperList) do
        HotfixHelper:HttpAbort(v)
    end

    HotfixHelper:HttpQuit()
    self.HttpHelperList={}

    self:StartLoadList()]]
end

----如果有资源更新，就开始加载资源，
function AssetLoadMachine:StartLoad()
    self.ReloadList = {}
    self:UpdateViewProgress()
    self:SetTipText("")
    if self.Max > 0 then
        self:StartLoadList()
    else
        VersionManager:Get():SaveLatestVersion()
    end
end

function AssetLoadMachine:StartLoadList()

    self.downLoadCoroutine = cs_coroutine.start(function()
        local loadIndex = 0
        coroutine.yield()

        for fileName, assetData in pairs(self.WaitingList) do
            self:LoadOne(assetData)
            coroutine.yield()
            if(loadIndex < 20) then
                coroutine.yield()
            elseif(loadIndex >= 20 and loadIndex < 200) then
                if(loadIndex % 5 == 0) then
                    coroutine.yield()
                end
            else
                if(loadIndex % 50 == 0) then
                    coroutine.yield()
                end
            end

            loadIndex = loadIndex + 1
        end
        print("LoadOneFinish ", CS.UnityEngine.Time.realtimeSinceStartup)
        coroutine.yield()
        self.downLoadCoroutine = nil
    end)
end
----加载单个资源，每一个资源都是一个url,只不过路径结尾是该资源的名字，加载完之后写入本地
---@param assetdata AssetData
function AssetLoadMachine:LoadOne(assetdata)

    --{{{ 模拟网络延迟下载
    --local filepath = assetdata.FileName
    --local url = VersionManager:Get():GetAssetPath().."/"..filepath
    --CS.MonoHelper.SendHttpPostRequest(url, function(data)
    --    local test = CS.UnrealM.ActionSequenceHandle()
    --    test:Looper(3, function()
    --        test:StopSequence()
    --        self:LoadCallBack(data, filepath)
    --    end)
    --end)
    --}}}

    local filename = assetdata.FileName
    local fileversion = assetdata.Version

    local url = HotfixHelper:GetAssetUrl(filename, fileversion)

    --[[local  http=HotfixHelper:SendHttpGetRequest2(url,
            function(data)
                self:LoadCallBack(data, filename)
            end,
            function(data)
                self:LoadError(data, assetdata)
            end) ]]

    local  http=HotfixHelper:SendHttpGetRequestSaveAtCSharp(url,filename,
            function(data)
                self:LoadCallBack(data, filename)
            end,
            function(data)
                self:LoadError(data, assetdata)
            end)
    self.HttpHelperList[filename]=http
end

----下载完的回调，把资源写到本地，比如下载下来一个ui.pb 把它写到本地，
function AssetLoadMachine:LoadCallBack(data, filename)
    --self:WriteAsset(data, filename)

    self:UpdateIdx(filename,AssetDataSaveType.Normal)

    self:UpdateViewProgress()--这个时候已经结束了，结束了就进游戏了 资源并没有更新

    self:SdkLogLoadProcess()

    self:CheckLoadFinish()
end

function AssetLoadMachine:LoadError(error, assetdata)
    print("---   LoadError：   error = ", error, assetdata.FileName)


    self:CheckReLoad(error, assetdata)

    self:SdkLogLoadFail(error,assetdata)
end

---@param assetdata AssetData
function AssetLoadMachine:CheckReLoad(error, assetdata)
    if error~=404 then
        if error~=5 then
            if self.ReloadList[assetdata.FileName] == nil then
                self.ReloadList[assetdata.FileName] = assetdata
            end
            self:ClearCoroutine()
            for k, v in pairs(self.HttpHelperList) do
                HotfixHelper:HttpAbort(v)
            end

            HotfixHelper:HttpQuit()
            self.HttpHelperList={}
            --if #self.ReloadList > 1 then
            --    table.insert(self.ReloadList, assetdata)
            --else
            HotfixMsgBoxHelper:Get():OpenMsgBox(HotfixHelper:GetStringById(HotfixString.NetError), function()

                HotfixHelper:HttpQuit()
                local indexCount = 0
                for item, v in pairs(self.WaitingList) do
                    indexCount = indexCount + 1
                end

                self:StartLoadList()
                print("继续下载，连接数量", indexCount)
                --for filename, assetData in pairs(self.WaitingList) do
                --    self:LoadOne(assetData)
                --end
            end, function()
                HotfixHelper:ApplicationQuit()
            end)
        end
    else
        self:UpdateIdx(assetdata.FileName,AssetDataSaveType.Error)
        self:UpdateViewProgress()
        self:SdkLogLoadProcess()
        self:CheckLoadFinish()
    end
    --end
end

function AssetLoadMachine:WriteAsset(data, filepath)
    local path = HotfixHelper:GetLocalAssetPath(filepath)
    HotfixHelper:WriteFileBytes(path, data)
end

----更新下载资源的大小
function AssetLoadMachine:UpdateIdx(filename,saveType)
    local assetData = self.WaitingList[filename]

    self.ReloadList[filename] = nil
    self.HttpHelperList[filename]=nil
    if assetData then
        assetData.SaveType=saveType
        table.insert(self.FinishAssetList, assetData)
        self.WaitingList[filename] = nil
        self.FinishCount = self.FinishCount + 1
        self.FinishMemory = self.FinishMemory + assetData.Size
        self.FinishMemoryMB = self.FinishMemory / 1024 / 1024
        self.FinishMemoryKB = self.FinishMemory / 1024

    else
        print("---   error:UpdateIdx()   assetdata = nil, filename = ", filename)
    end


end


----更新热更UI的进度
function AssetLoadMachine:UpdateViewProgress()

    if self.progressIndex % 20 == 0 then
        print("UpdateViewProgress ", CS.UnityEngine.Time.realtimeSinceStartup)
    end

    self.progressIndex = self.progressIndex  +1

    VersionManager:Get():UpdateProcess(self.FinishMemoryMB, self.FileMemoryMB)
end
function AssetLoadMachine:SetTipText(tips)
    VersionManager:Get():SetTipText(tips)
end

----检查是不是最后一个
function AssetLoadMachine:CheckLoadFinish()
    if self.WaitingList == nil then
        print("---   error:AssetLoadMachine   self.WaitingList = nil")
        self:SdkLogLoadFail(-1003)
        return
    end

    local isFinish = true

    for k, v in pairs(self.WaitingList) do
        isFinish = false
        break
    end
    if isFinish then
        if self.FinishCount ~= self.Max then
            print("---   error:资源更新异常，下载计数与下载总数不一致", self.FinishCount, self.Max)
        end
        cs_coroutine.start(function()
            coroutine.yield()
            self:End()
        end)
    end
end

function AssetLoadMachine:ClearCache()
    self.FinishAssetList = {}
    self.WaitingList = {}
    self.HttpHelperList={}
    self.Working = false
    self.Max = 0
    self.FinishCount = 0
    self.FinishMemory = 0
    self.FileMemoryMB = 0
    self.LoadFinish = nil
    self.LoadStep = 0
end

function AssetLoadMachine:End()
    --self:SdkLogLoadFinish()
    if self.LoadFinish then
        self.LoadFinish()
    end
    self:ClearCache()
end

---@return table<number, AssetData>
function AssetLoadMachine:GetFinishAssetList()
    return self.FinishAssetList
end

function AssetLoadMachine:SdkLogStartLoad()
    --CS.NetEasePOneFunc:Get():UpdateLog(
    --        0,
    --        "update asset",
    --        VersionManager:Get():GetVersion(),
    --        VersionManager:Get():GetAssetPath(),
    --        1000,
    --        0,
    --        0,
    --        0)
    --
    --CS.NetEaseDetect:Get():SetDetectBeginTime()
end
function AssetLoadMachine:SdkLogLoadFinish()
   -- local total = self.FileMemoryMB
   --
   -- local deviceModel=CSSystemInfo.deviceModel
   -- local log =string.format("%s-%s-%s-%s-%s",tostring(deviceModel),tostring(VersionManager:Get():GetVersion()),tostring(self.FinishCount),tostring(total)
   -- ,tostring(CS.ServerTime:Get():ConvertDateTimeInt(CS.ServerTime:Get():ServerTimeNow()) - CS.NetEaseDetect:Get():GetDetectBeginTime()))
   -- --LoginSubSystem:SendMsg_LogCat(log)
   --
   -- CS.NetEasePOneFunc:Get():UpdateLog(
   --         1,
   --         "update asset",
   --         VersionManager:Get():GetVersion(),
   --         VersionManager:Get():GetAssetPath(),
   --         1001,
   --         total,
   --         total,
   --         self.Max)
   --
   -- local speed = math.floor(self.FinishMemoryKB / (CS.ServerTime:Get():ConvertDateTimeInt(CS.ServerTime:Get():ServerTimeNow()) - CS.NetEaseDetect:Get():GetDetectBeginTime()))
   -- local log2 =string.format("%s-%s-%s-%s-%s",tostring(deviceModel),tostring(VersionManager:Get():GetVersion()),tostring(self.FinishCount),tostring(self.FinishMemoryKB)
   -- ,tostring(CS.ServerTime:Get():ConvertDateTimeInt(CS.ServerTime:Get():ServerTimeNow()) - CS.NetEaseDetect:Get():GetDetectBeginTime()))
   ---- LoginSubSystem:SendMsg_LogCat(log2)
   --
   -- CS.NetEaseDetect:Get():PatchLoadSuccess(
   --         VersionManager:Get():GetAssetPath(),
   --         "-1",
   --         "-1",
   --         "update asset finish",
   --         tostring(self.FinishCount),
   --         VersionManager:Get():GetVersion(),
   --         speed,
   --         math.floor(self.FinishMemoryKB),
   --         CS.ServerTime:Get():ConvertDateTimeInt(CS.ServerTime:Get():ServerTimeNow()) - CS.NetEaseDetect:Get():GetDetectBeginTime(),
   --         true,
   --         "-1",
   --         false
   -- )
end
---@param assetdata AssetData
function AssetLoadMachine:SdkLogLoadFail(errorcode,assetdata)

    local loadTime=CS.ServerTime:Get():ConvertDateTimeInt(CS.ServerTime:Get():ServerTimeNow()) - assetdata.BeginTime
    HotfixHelper:TrackHotFixHttpError(assetdata.FileName,errorcode, assetdata.Version,VersionManager:Get():GetAssetPath(),self.FinishMemoryMB,assetdata.Size,self.Max,loadTime)
   -- local total = self.FileMemoryMB
   -- CS.NetEasePOneFunc:Get():UpdateLog(
   --         -1,
   --         "update asset",
   --         VersionManager:Get():GetVersion(),
   --         VersionManager:Get():GetAssetPath(),
   --         errorcode,
   --         self.FinishMemoryMB,
   --         total,
   --         self.Max)
   --
   -- local speed = math.floor(self.FinishMemoryKB / (CS.ServerTime:Get():ConvertDateTimeInt(CS.ServerTime:Get():ServerTimeNow()) - CS.NetEaseDetect:Get():GetDetectBeginTime()))
   -- local deviceModel=CSSystemInfo.deviceModel
   -- local log =string.format("%s-%s-%s-%s",tostring(deviceModel),tostring(VersionManager:Get():GetVersion()),tostring(self.FinishCount),tostring(self.FinishMemoryKB)
   -- ,tostring(CS.ServerTime:Get():ConvertDateTimeInt(CS.ServerTime:Get():ServerTimeNow()) - CS.NetEaseDetect:Get():GetDetectBeginTime()))
   ---- LoginSubSystem:SendMsg_LogCat(log)
   -- CS.NetEaseDetect:Get():PatchLoadFail(
   --         VersionManager:Get():GetAssetPath(),
   --         "-1",
   --         "-1",
   --         "update asset fail",
   --         tostring(self.FinishCount),
   --         VersionManager:Get():GetVersion(),
   --         speed,
   --         math.floor(self.FinishMemoryKB),
   --         CS.ServerTime:Get():ConvertDateTimeInt(CS.ServerTime:Get():ServerTimeNow()) - CS.NetEaseDetect:Get():GetDetectBeginTime(),
   --         true,
   --         "-1",
   --         false
   -- )
end

function AssetLoadMachine:SdkLogLoadProcess()

    --local temp1, temp2 = math.modf(self.FinishMemoryMB / 10)
    --if temp1 > 0 and self.LoadStep ~= temp1 then
    --    print("---   SdkLogLoadProcess   self.FinishCount = ", self.FinishCount, "------self.FinishMemory = ", self.FinishMemory)
    --    local finish = self.FinishMemoryMB
    --    local total = self.FileMemoryMB
    --    local deviceModel=CSSystemInfo.deviceModel
    --    local log =string.format("%s-%s-%s",tostring(deviceModel),tostring(VersionManager:Get():GetVersion()),tostring(self.FinishCount),tostring(self.FinishMemory))
    --    --LoginSubSystem:SendMsg_LogCat(log)
    --    CS.NetEasePOneFunc:Get():DownloadLog(
    --            VersionManager:Get():GetVersion(),
    --            VersionManager:Get():GetAssetPath(),
    --            0,
    --            finish,
    --            total,
    --            self.Max)
    --
    --    self.LoadStep = temp1
    --end

end


function AssetLoadMachine:ClearOnApplicationPause()

end

function AssetLoadMachine:ClearCoroutine()
    if self.downLoadCoroutine ~= nil then
        cs_coroutine.stop(self.downLoadCoroutine)
        print("AssetLoadMachine:Clear 清理协程")
    end
end