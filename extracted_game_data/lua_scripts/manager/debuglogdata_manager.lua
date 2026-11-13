---@class DebugLogDataManager
DebugLogDataManager =class("DebugLogDataManager")
function DebugLogDataManager:Get()
    if self._instance==nil then
        self._instance=DebugLogDataManager()
    end
    return self._instance
end
function DebugLogDataManager:initialize()
    self.LogDic={}
    self.isReSign=false
    self.selectIp=GameProperties.LoginUrl
    self.IpList={
        "192.168.1.101:11003",
        "111.229.19.127:11003",
        "106.2.38.142:11003",
        "10.4.15.247:11003",
        "192.168.1.45:11003",
        "192.168.1.35:11003",
        "106.2.39.21:11003",
        "192.168.1.39:11003",
    }
end

function DebugLogDataManager:InterLog(logType,string)
    --if self.LogDic[logType]==nil then
    --      self.LogDic[logType]={}
    --end

    if logType==DebugLogType.Exception then
        --UIManager:Get():OpenPopup("DebugView",CanvasType.TopCanvas,"DebugView")
        --UINotify:Get():SendNotification(UINotifyEvent.DebugViewShowLogView,string)
    end
   -- table.insert(self.LogDic[logType],string)
end
---@param logType DebugLogType
function DebugLogDataManager:GetLogListByType(logType)
    if self.LogDic[logType]~=nil then
        return self.LogDic[logType]
    end
    return {}
end

---@param isReSign boolean
function DebugLogDataManager:SetIsReSign(isReSign)
    if isReSign~=self.isReSign then
        self.isReSign=isReSign
    end
end
local ClickTable1={false,false,false,false,false,false,false}
local ClickTable2={false,false,false,false,false,false,false}
local _Index=1
function DebugLogDataManager:ClickLogBtn(type)
    if type==1 then
        if _Index==1 or (_Index>1 and ClickTable2[_Index-1]) then
            ClickTable1[_Index]=true
            if _Index==1 then
                self.coroutine= cs_coroutine.start(function()
                    coroutine.yield(CS.UnityEngine.WaitForSeconds(8))
                    ClickTable1={false,false,false,false,false,false,false}
                    ClickTable2={false,false,false,false,false,false,false}
                    _Index=1
                end)
            end
        else
            _Index=1
            ClickTable1={false,false,false,false,false,false,false}
            ClickTable2={false,false,false,false,false,false,false}
        end
    end
    if type==2 then
        if ClickTable1[_Index] then
            ClickTable2[_Index]=true
            _Index=_Index+1
            if _Index==7 then
                _Index=1
                ClickTable1={false,false,false,false,false,false,false}
                ClickTable2={false,false,false,false,false,false,false}
                CommonTipsHelper:Get():ShowCenterTips("打开成功")
                PlayerPrefs.SetInt("GameProperties_FE", 1)
                PlayerPrefs.Save()
                MonoHelper.AddExceptionEvent()
            end
        else
            _Index=1
            ClickTable1={false,false,false,false,false,false,false}
            ClickTable2={false,false,false,false,false,false,false}
        end
    end
end

function DebugLogDataManager:SetIp(idx,ip)
    if idx~=nil then
        self.selectIp=self.IpList[idx]
    end
    if idx>#self.IpList and ip~=nil then
        self.selectIp=string.format("%s:21000")
    end
end
