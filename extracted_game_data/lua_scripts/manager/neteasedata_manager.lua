---@class NetEasePdtInfo@商品信息
NetEasePdtInfo = class("NetEasePdtInfo")

function NetEasePdtInfo:initialize()
    self.priceCurrencyCode = "" --币种，CNY 是人民币
    self.title = "" --在苹果 iTunes Connect 后台配置的商品的标题
    self.priceAmountMicros = "" --价格 x 10^6, 1000000 = 1 元
    self.productId = "" --商品 id
    self.price = "" --价格，跟安卓统一，前面第一个字母是当地币种的符号，如"$" "￥"
    self.description = "" --在苹果 iTunesConnect 后台配置的商品的描述
end

---@class NetEaseDataManager
NetEaseDataManager = class("NetEaseDataManager")
function NetEaseDataManager:Get()
    if self._instance == nil then
        self._instance = NetEaseDataManager()
    end
    return self._instance
end

function NetEaseDataManager:initialize()
    ---@type SauthReturn
    self.sauthReturn = nil
    ---@type LogInfo
    self.logInfo = nil

    self.caid = ""

    self.isLogin = false--是否已经登陆过游戏，如果登陆过，在登出的时候，就不用重新加载配置，如果没有登陆过，就加载配置

    self.fpsInterval = 60--fps的时间间隔，每60秒抓一次fps
    self.timerId = -1--fps的倒计时ID
    self.timeCount = 0--倒计时的count

    self.aasTimerId = -1--未成年防沉迷倒计时Id
    self.aasEndTime = -1--未成年防沉迷最终时间

    self.pone_tutorialBeginTime = 0--新手引导开始时间
    self.pone_tutorialBeginLv = 0--新手引导开始等级

    self.detect_loginBeginTime = 0--登录开始时间
    self.detect_Interval = 1800--抓包时间半个小时
    self.detect_loginSuccessTime = 0--登录开始时间，用来抓包计时
    self.detect_countDownID = -1--登录之后开始计时的ID
    self.detect_timeId = -1--抓包ID
    self.detect_randomTime = -1--登录开始之后的随机时间

    self.aas_kickedInterval = -1--如果是未成年，晚上九点踢人，从登录到晚上九点的时间间隔


    CacheClearTrigger:Get():RegisterEvent(self, self.Clear)
end

---@param sauthReturn SauthReturn
function NetEaseDataManager:SetSauthReturnData(sauthReturn)
    self.sauthReturn = sauthReturn
end

---@param unisdkLoginJson Unisdk_login_json
function NetEaseDataManager:UpdateSauthReturnData(unisdkLoginJson)
    self.sauthReturn.username = unisdkLoginJson.username
    self.sauthReturn.aid = unisdkLoginJson.aid

    if unisdkLoginJson ~= nil then
        self.sauthReturn.realname_msg = Dll_JSON.encode(unisdkLoginJson.realname_msg)
    end
end

---@return  SauthReturn
function NetEaseDataManager:GetSauthReturnData()
    return self.sauthReturn
end

function NetEaseDataManager:SetLogInfoCaid(caid)
    self.caid = caid
end
function NetEaseDataManager:GetLogInfoCaid()
    return self.caid
end

---@param logInfo LogInfo
function NetEaseDataManager:SetLogInfoData(logInfo)
    self.logInfo = logInfo
end
---@return  LogInfo
function NetEaseDataManager:GetLogInfoData()
    return self.logInfo
end

---@return SdkEnterData
function NetEaseDataManager:GetEnterData()
    ---@type SdkEnterData
    local msg = {}

    msg. realNameMsg = ""
    msg. sauthLoginType = ""
    msg. aasMsg = ""
    msg. logInfoTab = nil
    if SDKHelper:Get():ChickNetEaseSdk() then
        local sauthReturn = self:GetSauthReturnData()

        if sauthReturn ~= nil then
            if sauthReturn.realname_msg ~= nil then
                msg.realNameMsg = sauthReturn.realname_msg
            end
            if sauthReturn.aas_msg ~= nil then
                msg.aasMsg = sauthReturn.aas_msg
            end
            msg.sauthLoginType = sauthReturn.login_type
        end

        msg.logInfoTab = self:GetLogInfoData()
        print("给服务端发送的初始信息-----------lua" .. Dll_JSON.encode(msg.logInfoTab))
        print("给服务端发送的初始信息-----------lua总的消息：" .. Dll_JSON.encode(msg))
    end
    return msg
end

---@param isLogin boolean @是否已经登录过游戏
function NetEaseDataManager:SetIsLogin(isLogin)
    self.isLogin = isLogin
    print("------self.isLogin:   " .. tostring(isLogin))
    --end
end
---@return  boolean
function NetEaseDataManager:GetIsLogin()
    return self.isLogin
end

function NetEaseDataManager:SetFpsTimerCount(count)
    self.timeCount = count
end
function NetEaseDataManager:GetFpsTimerCount()
    return self.timeCount
end

function NetEaseDataManager:SetFpsTimerId(id)
    self.timerId = id
end
function NetEaseDataManager:GetFpsTimerId()
    return self.timerId
end

function NetEaseDataManager:GetFpsTimerInterval()
    return self.fpsInterval
end

function NetEaseDataManager:GetDetectTimerInterval()
    return self.detect_Interval
end

function NetEaseDataManager:SetPoneTutorialParam(beginTime, beginLv)
    self.pone_tutorialBeginTime = beginTime
    self.pone_tutorialBeginLv = beginLv
end
function NetEaseDataManager:GetPoneTutorialParam()
    return self.pone_tutorialBeginTime, self.pone_tutorialBeginLv
end

function NetEaseDataManager:SetDetectLoginTime(beginTime)
    self.detect_loginBeginTime = beginTime
end
function NetEaseDataManager:GetDetectLoginTime()
    return self.detect_loginBeginTime
end

function NetEaseDataManager:SetDetectLoginSuccessTime(beginTime)
    self.detect_loginSuccessTime = beginTime
end
function NetEaseDataManager:GetDetectLoginSuccessTime()
    return self.detect_loginSuccessTime
end

function NetEaseDataManager:SetDetectCountDownId(countDownId)
    self.detect_countDownID = countDownId
end
function NetEaseDataManager:GetDetectCountDownId()
    return self.detect_countDownID
end

function NetEaseDataManager:SetDetectTimeId(timeId)
    self.detect_timeId = timeId
end
function NetEaseDataManager:GetDetectTimeId()
    return self.detect_timeId
end

function NetEaseDataManager:SetDetectRandomTime(time)
    self.detect_randomTime = time
end
function NetEaseDataManager:GetDetectRandomTime()
    return self.detect_randomTime
end

----开始未成年倒计时
function NetEaseDataManager:StartAasCount()
    if SDKHelper:Get():ChickNetEaseSdk() then
        if self.sauthReturn ~= nil and self.sauthReturn.aas_ban ~= nil then
            if tonumber(self.sauthReturn.aas_ban.ban) == 0 then
                self:SetAasCountTime()
                if self.aasEndTime - CommonHelper:ConvertDateTimeToInt(CommonHelper:GetNowTime()) > 0 then
                    self:StopTimer()
                    self.aasTimerId = TimerManager:Get():CreateTimerLoop(1, function()
                        if CommonHelper:ConvertDateTimeToInt(CommonHelper:GetNowTime()) >= self.aasEndTime then
                            CommonHelper:LoginTipPop(CommonHelper:GetTempStr_Default(TemplateStringID.LoginTips_1030), CommonHelper:GetTempStr_Default(TemplateStringID.SDKTips_1),function()
                                LoginFuncHelper:LoginOut_GameBackToLogin_Combine(true, true,nil,true)
                            end)
                            self:StopTimer()
                        end
                    end)
                end
            end
        end
    end
end

----当aas_ban>=1 是 弹出提示
function NetEaseDataManager:BanLogin()
    if SDKHelper:Get():ChickNetEaseSdk() then
        if self.sauthReturn ~= nil and self.sauthReturn.aas_ban ~= nil then
            if tonumber(self.sauthReturn.aas_ban.ban) >=1 then
                CommonTipsHelper:ShowCenterTips(tostring(self.sauthReturn.aas_ban.ban_msg))
            end
        end
    end
end

function NetEaseDataManager:SetAasCountTime()
    --self.aasEndTime = CommonHelper:ConvertDateTimeToInt(CommonHelper:GetNowTime()) + SDKManager:Get():GetAasLeftTime() + 1
end

function NetEaseDataManager:StopTimer()
    if self.aasTimerId ~= -1 then
        TimerManager:Get():StopTimer(self.aasTimerId)
        self.aasTimerId = -1
    end
end

function NetEaseDataManager:Clear()
    self.sauthReturn = nil
    self.logInfo = nil
    self.timerId = -1
    self.detect_countDownID = -1
    self.detect_timeId = -1
end