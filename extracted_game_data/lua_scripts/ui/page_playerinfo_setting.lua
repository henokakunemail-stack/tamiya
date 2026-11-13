---@class PagePlayerInfoSetting
PagePlayerInfoSetting = class("PagePlayerInfoSetting")
function PagePlayerInfoSetting:initialize()

end

local _CurSettingView = nil
local SettingType = {
    TogFrameSetting = 1,
    TogAudioSetting = 2,
    TogPullSetting = 3,
    TogLanguageSetting = 5,
    TogGameSetting = 6,
    TogRedeem = 4,
    TogGarage = 7,
}
local _BgmOffOrOn = -1 --背景音乐
local _SoundEffectOffOrOn = -1 --音效
local _BattleBgmOffOrOn = -1 --战斗音乐
local _BgmValue = -1 --音效
local _SoundEffectValue = -1 --音效
local _BattleBgmValue = -1 --战斗音效
local _PowerSaving = -1  --省电模式
local _PictureQuality = -1 --画质
local _SystemPush = -1  --推送
local _PostSetting = -1 --帧率
local _DefaultPictureQuality = -1
local _LanguageType = -1
local _GameTrackCheck = -1
local _GameBrakeSetting= -1
local _Garage201_Show = -1



local _AntiAliasing = -1 --抗锯齿
local _ScreenEffect = -1 --屏幕点击
function PagePlayerInfoSetting:SetData(root)
    self.Root = root
    self:SettingViewAwake()
    self:SetClientVersion()
end
local DebugCount = 0
function PagePlayerInfoSetting:SettingViewAwake()
    self.FrameSettingView = UIUtil.GetTypeChildWightByParent("settingviews/FrameSettingView", self.Root, typeof(CanvasGroup))
    self.AudioSettingView = UIUtil.GetTypeChildWightByParent("settingviews/AudioSettingView", self.Root, typeof(CanvasGroup))
    self.PullSettingView = UIUtil.GetTypeChildWightByParent("settingviews/PullSettingView", self.Root, typeof(CanvasGroup))
    self.RedeemView = UIUtil.GetTypeChildWightByParent("settingviews/RedeemView", self.Root, typeof(CanvasGroup))
    self.LanguageSettingView = UIUtil.GetTypeChildWightByParent("settingviews/LanguageSettingView", self.Root, typeof(CanvasGroup))
    self.GameSettingView = UIUtil.GetTypeChildWightByParent("settingviews/GameSettingView", self.Root, typeof(CanvasGroup))
    self.GarageSettingView = UIUtil.GetTypeChildWightByParent("settingviews/GarageSettingView", self.Root, typeof(CanvasGroup))
    self.TweenGroup = UIUtil.GetTypeChildWightByParent("TweenGroup", self.Root, typeof(FXUITweenMoreGroup))

    self.TogFrameSetting = CommonHelper:HButtonSetCallback("TogFrameSetting", self.Root, function(data)
        if _CurSettingView ~= SettingType.TogFrameSetting then
            _CurSettingView = SettingType.TogFrameSetting
            self:PlayerSettingViewUpdateTog()
            CommonHelper:TMG_PlayAllTween(self.TweenGroup)
        end
    end)
    self.TogAudioSetting = CommonHelper:HButtonSetCallback("TogAudioSetting", self.Root, function(data)
        if _CurSettingView ~= SettingType.TogAudioSetting then
            _CurSettingView = SettingType.TogAudioSetting
            self:PlayerSettingViewUpdateTog()
            CommonHelper:TMG_PlayAllTween(self.TweenGroup)
        end
    end)

    self.TogPullSetting = CommonHelper:HButtonSetCallback("TogPullSetting", self.Root, function(data)
        if _CurSettingView ~= SettingType.TogPullSetting then
            _CurSettingView = SettingType.TogPullSetting
            self:PlayerSettingViewUpdateTog()
            CommonHelper:TMG_PlayAllTween(self.TweenGroup)
        end
    end)
    self.TogGameSetting = CommonHelper:HButtonSetCallback("TogGameSetting", self.Root, function(data)
        if _CurSettingView ~= SettingType.TogGameSetting then
            _CurSettingView = SettingType.TogGameSetting
            self:PlayerSettingViewUpdateTog()
            CommonHelper:TMG_PlayAllTween(self.TweenGroup)
        end
    end)
    self.TogRedeem = CommonHelper:HButtonSetCallback("TogRedeem", self.Root, function(data)
        if _CurSettingView ~= SettingType.TogRedeem then
            _CurSettingView = SettingType.TogRedeem
            self:PlayerSettingViewUpdateTog()
        end
    end)
    self.TogGarage = CommonHelper:HButtonSetCallback("TogGarage", self.Root, function(data)
        if _CurSettingView ~= SettingType.TogGarage then
            _CurSettingView = SettingType.TogGarage
            self:PlayerSettingViewUpdateTog()
        end
    end)
    self.TogLanguage = CommonHelper:HButtonSetCallback("TogLanguageSetting", self.Root, function(data)
        if _CurSettingView ~= SettingType.TogLanguageSetting then
            _CurSettingView = SettingType.TogLanguageSetting
            self:PlayerSettingViewUpdateTog()
            CommonHelper:TMG_PlayAllTween(self.TweenGroup)
        end
    end)
    CommonHelper:SetGameObjectActive("TogLanguageSetting",self.Root,HVersionManager:GetServerFunctionIsFlag(CdnFunctionKey.LangeSetting))
    CommonHelper:SetHButtonClick(self.TogRedeem,HVersionManager:GetServerFunctionIsFlag(CdnFunctionKey.RedeemCode),true)
    self.BtnDebug = CommonHelper:HButtonSetCallback("BtnDebug", self.Root, function(data)
        DebugCount = DebugCount + 1
        if DebugCount > 6 then
            CommonHelper:SetHButtonClick(self.TogRedeem,true,true)
        end
    end)
    --用户登出
    CommonHelper:HButtonSetCallback("BtnLogout", self.Root, function(param)
        LoginFuncHelper:LoginOut_GameBackToLogin_Combine(true, true, nil, true)
    end)
    --用户销毁
    self.BtnAccountDeletion = CommonHelper:HButtonSetCallback("BtnAccountDeletion", self.Root, function(param)
        local boxFunc = function()
            local IsUserGuest = UnifySDKManager:Get():IAccount():IsUserGuest()
            local ret
            if IsUserGuest then
                MessageBoxHelp:Get():OpenBox_OK(nil,CommonHelper:GetTempStr_Default(TemplateStringID.PagePlayerInfoSettingDestroyAccountIsGuestTip))
            else
                ret = MessageBoxHelp:Get():OpenBox_OKCancel(nil,CommonHelper:GetTempStr_Default(TemplateStringID.PagePlayerInfoSettingDestroyAccount))
                if ret == MessageBoxHelp.BtnType.OK then
                    if SDKHelper:Get():ChickGoogleSdk() or SDKHelper:Get():ChickUltraSdk() then
                        UnifySDKManager:Get():IAccount():AccountDeletion()
                    end
                end
            end
        end
        MessageBoxHelp.Get():StartCoroutineBox(boxFunc)
        --LoginFuncHelper:LoginOut_GameBackToLogin_Combine(true, true, nil, true)
    end)

    --账号绑定
    self.BtnAccountBind = CommonHelper:HButtonSetCallback("BtnAccountBind", self.Root, function(param)
        --SDKManager:Get():Quick_BindUser("13")
        logError("       --账号绑定       ")
    end)
    --安卓不显示销毁

    CommonHelper:SetGameObjectActive("BtnAccountDeletionParent", self.Root, HotfixHelper.IsAndroidPlatform() == false and not SDKHelper:Get():ChickSdkType(SDKChannelNames.IsUseQuickSDKChina))
    CommonHelper:SetGameObjectActive("TweenTemp_Integrated", self.Root, GameProperties.AreaType==AreaType.AreaTypeCN)

    CommonHelper:SetGameObjectActive("BtnAccountBindParent",self.Root,false)--关闭 账号绑定  使用客服中心绑定

    --东南亚不显示客服中心
    CommonHelper:SetGameObjectActive("BtnService", self.Root,false )
    CommonHelper:SetGameObjectActive("Togser", self.Root,SDKHelper:Get():ChickUltraSdk())

    --用户协议
    CommonHelper:HButtonSetCallback("BtnUserArg", self.Root, function(param)
        --SDKManager:Get():OpenUserAuth(true)
    end)
    --客服中心
    CommonHelper:HButtonSetCallback("BtnService", self.Root, function(param)
        --SDKManager:Get():StartGmBridge(true)
        UnifySDKManager:Get():IAccount():ShowUserCenter()
    end)
    self.BtnFBService= CommonHelper:HButtonSetCallback("BtnFBService", self.Root, function(param)
        --SDKManager:Get():StartGmBridge(true)
       LoginSubSystem:Get():SendMsg_GetFbServiceUrl(function(data)
           local data=Dll_JSON.decode(data)
           CS.UnityEngine.Application.OpenURL(data.fbservice)
       end)
    end)
  self.BtnIntegrated= CommonHelper:HButtonSetCallback("BtnIntegrated", self.Root, function(param)
      CS.UnityEngine.Application.OpenURL("https://beian.miit.gov.cn/")
    end)
   CommonHelper:HButtonSetCallback("BtnDisCord", self.Root, function(param)
        --SDKManager:Get():StartGmBridge(true)
       LoginSubSystem:Get():SendMsg_GetFbServiceUrl(function(data)
           local data=Dll_JSON.decode(data)
           CS.UnityEngine.Application.OpenURL(data.discard)
       end)
    end)
   CommonHelper:HButtonSetCallback("BtnTiktok", self.Root, function(param)
        --SDKManager:Get():StartGmBridge(true)
       LoginSubSystem:Get():SendMsg_GetFbServiceUrl(function(data)
           local data=Dll_JSON.decode(data)
           CS.UnityEngine.Application.OpenURL(data.tiktok)
       end)
    end)
    if GameProperties.AreaType==AreaType.AreaTypeKR then
        CommonHelper:SetGameObjectActive("TweenTemp_Scale (4)", self.Root,false)
        CommonHelper:SetGameObjectActive("TweenTemp_Scale (2)", self.Root,false)
    end
    --问卷调查
    CommonHelper:HButtonSetCallback("BtnSurvey", self.Root, function(param)
        SurveySubsystem:Get():SendMsg_SurveyInfo()
    end)
    self:TogRedeemViewAwake()
    self:TogPullSettingViewAwake()
    self:TogAudioViewAwake()
    self:TogFrameViewAwake()
    self:TogLanguageSettingViewAwake()
    self:TogGameSettingViewAwake()
    self:TogGarageSettingViewAwake()
end

function PagePlayerInfoSetting:SettingViewSetData(param)
    self:SettingViewInit()
    _CurSettingView = SettingType.TogFrameSetting
    self:PlayerSettingViewUpdateTog()
end
function PagePlayerInfoSetting:SettingViewInit()
    _BgmOffOrOn = PlayerPrefsHelper:GetValue_BgmOffOrOn()
    _SoundEffectOffOrOn = PlayerPrefsHelper:GetValue_SoundEffectOffOrOn()
    _BgmValue = PlayerPrefsHelper:GetValue_BgmValue()
    _SoundEffectValue = PlayerPrefsHelper:GetValue_SoundEffectValue()
    _BattleBgmValue = PlayerPrefsHelper:GetValue_BattleBgmValue()
    _BattleBgmOffOrOn = PlayerPrefsHelper:GetValue_BattleBgmOffOrOn()

    self:SetAudioState()
    _SystemPush = PlayerPrefsHelper:GetValue_SystemPush()
    self:SetSystemPushState()
    --if PlayerPrefs.HasKey("PictureQuality") then _PictureQuality = PlayerPrefs.GetInt("PictureQuality") else _PictureQuality=1 end
    _PictureQuality = mono.GetQualityLevel()
    _DefaultPictureQuality = _PictureQuality
    self:SetPictureQualityState()
    --if PlayerPrefs.HasKey("IsPostEnable") then _PostSetting = PlayerPrefs.GetInt("IsPostEnable") else _PostSetting=1 end
    _PostSetting = mono.IsEnablePost()
    self:SetFPSSettingState()
    _PowerSaving = PlayerPrefsHelper:GetValue_PowerSaving()
    if _PowerSaving == -1 then
        _PowerSaving = mono.GetDefaultPowerSaving()
    end
    self:SetPowerSavingState()

    _LanguageType=ClientDataManager:Get().LanguageType
    self:SetLanguageSettingState()

    _GameTrackCheck=PlayerPrefsHelper:GetValue_GameTrackCheck()
    _GameBrakeSetting=PlayerPrefsHelper:GetValue_GameBrakeSetting()
    self:SetGameSettingState()

    _Garage201_Show=PlayerPrefsHelper:GetValue_Car_GrooveIDShow(PartGrooveID.RearWing)
    self:SetGarageSettingState()
    -- mono.GetServerQualityLevel()
end
--{{{兑换码
function PagePlayerInfoSetting:TogRedeemViewAwake()
    self.RedeemViewObj = UIUtil.GetChild("settingviews/RedeemView", self.Root)
    local RedeemCodeInputField = UIUtil.GetTypeChildWightByParent("RedeemCodeInputField", self.RedeemViewObj, typeof(InputField))
    CommonHelper:HButtonSetCallback("SubmitBtn", self.RedeemViewObj, function(param)
        local text = RedeemCodeInputField.text
        if CommonHelper:IsNullOrEmpty(text) then
            CommonTipsHelper:Get():ShowCenterTips(ClientDataManager:Get():GetTemplateString(TemplateStringID.SettingRedeemCodeCanNotNull))
        else
            local isWhite= CS.UnityEngine.PlayerPrefs.GetInt("GameProperties_FE",0)==1
            if isWhite then
                local  strs=stringSplit(text,"=")
                if strs[1]=="ip" then
                    PlayerPrefs.SetString("White_Ip", strs[2])
                    PlayerPrefs.Save()
                    CommonTipsHelper:Get():ShowCenterTips("设置IP成功")
                    return
                end
                if text=="清理地址" then
                    PlayerPrefs.SetString("White_Ip", "")
                    PlayerPrefs.Save()
                    CommonTipsHelper:Get():ShowCenterTips("清理ip成功")
                    return
                end
            end
            if text == "debug20test01" then
                local debugView = PlayerPrefsHelper:GetValue_IsDebug()
                PlayerPrefs.SetInt("GameProperties_FE", 1)
                PlayerPrefs.Save()
                MonoHelper.AddExceptionEvent()
                CommonTipsHelper:Get():ShowCenterTips("客户端白名单")
                ---UIManager:OpenPopup("DebugView", CanvasType.MainCanvas, "DebugView")
                ---PlayerPrefsHelper:SetValue_IsDebug("true")
            elseif text == "DebugShow=false" then
                PlayerPrefsHelper:SetValue_IsDebug("false")
            elseif text == "GetPhoneGameid2001" then
                HotfixHelper:GetPhoneNumberIp(function(result)
                    CommonHelper:WriteClipboart(result)
                end)
            else
                PlayerInfoSubsystem:Get():SendMsg_UseCode(text)
            end
            --CommonTipsHelper:Get():ShowCenterTips(ClientDataManager:Get():GetTemplateString(TemplateStringID.SettingRedeemCodeHasUsed))
        end
    end)
end
--}}}
--{{{系统推送
function PagePlayerInfoSetting:TogPullSettingViewAwake()
    self.SystemPush = UIUtil.GetChild("settingviews/PullSettingView", self.Root)
    self. SystemPushOffToggle = CommonHelper:HButtonSetCallback("PullOffNo/Low", self.SystemPush, function(param)
        _SystemPush = 0
        self:SetSystemPushState()
    end)
    self. SystemPushOnToggle = CommonHelper:HButtonSetCallback("PullOffNo/High", self.SystemPush, function(param)
        _SystemPush = 1
        self:SetSystemPushState()
    end)
end
--系统推送
function PagePlayerInfoSetting:SetSystemPushState()
    CommonHelper:SetToggleState(self.SystemPushOffToggle, _SystemPush == 0)
    CommonHelper:SetToggleState(self.SystemPushOnToggle, _SystemPush == 1)
end
--}}}
--{{{语言设置
function PagePlayerInfoSetting:TogLanguageSettingViewAwake()
    self.LanguageSet = UIUtil.GetChild("settingviews/LanguageSettingView", self.Root)
    self. Language1 = CommonHelper:HButtonSetCallback("languagesetting/Low1", self.LanguageSet, function(param)
        if _LanguageType~=LanguageType.CHS then
            self:OnChangeLanguageSetting(function()
                _LanguageType = 1
                ClientDataManager:Get().LanguageType=LanguageType.CHS
                GameProperties.languageType=LanguageType.CHS
                GameProperties.Language="zh_cn_lang"
                PlayerPrefsHelper:SetValue_LanguageType(_LanguageType)
                self:SetLanguageSettingState()
            end,LanguageType.CHS)
        end

    end)
    self. Language2 = CommonHelper:HButtonSetCallback("languagesetting/Low2", self.LanguageSet, function(param)
        if _LanguageType~=LanguageType.CHT then
            self:OnChangeLanguageSetting(function()
                _LanguageType = LanguageType.CHT
                ClientDataManager:Get().LanguageType=LanguageType.CHT
                GameProperties.languageType=LanguageType.CHT
                GameProperties.Language="zh_tw_lang"
                PlayerPrefsHelper:SetValue_LanguageType(_LanguageType)
                self:SetLanguageSettingState()
            end,LanguageType.CHT)
        end

    end)
    self. Language3 = CommonHelper:HButtonSetCallback("languagesetting/Low3", self.LanguageSet, function(param)
        if _LanguageType~=LanguageType.EN then
            self:OnChangeLanguageSetting(function()
                _LanguageType = LanguageType.EN
                ClientDataManager:Get().LanguageType=LanguageType.EN
                GameProperties.languageType=LanguageType.EN
                GameProperties.Language="en_us_lang"
                PlayerPrefsHelper:SetValue_LanguageType(_LanguageType)
                self:SetLanguageSettingState()
            end,LanguageType.EN)
        end
    end)
    self. Language4 = CommonHelper:HButtonSetCallback("languagesetting/Low4", self.LanguageSet, function(param)
        if _LanguageType~=LanguageType.THAI then
            self:OnChangeLanguageSetting(function()
                _LanguageType = LanguageType.THAI
                ClientDataManager:Get().LanguageType=LanguageType.THAI
                GameProperties.languageType=LanguageType.THAI
                GameProperties.Language="ta_tai_lang"
                PlayerPrefsHelper:SetValue_LanguageType(_LanguageType)
                self:SetLanguageSettingState()
            end,LanguageType.THAI)
        end
    end)
    self. Language5 = CommonHelper:HButtonSetCallback("languagesetting/Low5", self.LanguageSet, function(param)
        if _LanguageType~=LanguageType.IDA then
            self:OnChangeLanguageSetting(function()
                _LanguageType = LanguageType.IDA
                ClientDataManager:Get().LanguageType=LanguageType.IDA
                GameProperties.languageType=LanguageType.IDA
                GameProperties.Language="ida_bm_lang"
                PlayerPrefsHelper:SetValue_LanguageType(_LanguageType)
                self:SetLanguageSettingState()
            end,LanguageType.IDA)
        end
    end)
    self. Language6 = CommonHelper:HButtonSetCallback("languagesetting/Low6", self.LanguageSet, function(param)
        if _LanguageType~=LanguageType.PT_BR then
            self:OnChangeLanguageSetting(function()
                _LanguageType = LanguageType.PT_BR
                ClientDataManager:Get().LanguageType=LanguageType.PT_BR
                GameProperties.languageType=LanguageType.PT_BR
                GameProperties.Language="pt_br_lang"
                PlayerPrefsHelper:SetValue_LanguageType(_LanguageType)
                self:SetLanguageSettingState()
            end,LanguageType.PT_BR)
        end
    end)
    self. Language7 = CommonHelper:HButtonSetCallback("languagesetting/Low7", self.LanguageSet, function(param)
        if _LanguageType~=LanguageType.KR then
            self:OnChangeLanguageSetting(function()
                _LanguageType = LanguageType.KR
                ClientDataManager:Get().LanguageType=LanguageType.KR
                GameProperties.languageType=LanguageType.KR
                GameProperties.Language="rok_kr_lang"
                PlayerPrefsHelper:SetValue_LanguageType(_LanguageType)
                self:SetLanguageSettingState()
            end,LanguageType.KR)
        end
    end)

end
function PagePlayerInfoSetting:OnChangeLanguageSetting(func,type)
    local boxfunc = function()
        local language=""
        if type==LanguageType.CHS then
            language=CommonHelper:GetTempStr_Default(TemplateStringID.LanguageSettingChs)
        elseif type==LanguageType.CHT then
            language=CommonHelper:GetTempStr_Default(TemplateStringID.LanguageSettingCht)
        elseif type==LanguageType.EN then
            language=CommonHelper:GetTempStr_Default(TemplateStringID.LanguageSettingEn)
        elseif type==LanguageType.THAI then
            language=CommonHelper:GetTempStr_Default(TemplateStringID.LanguageSettingThai)
        elseif type==LanguageType.IDA then
            language=CommonHelper:GetTempStr_Default(TemplateStringID.LanguageSettingIDA)
        elseif type==LanguageType.PT_BR then
            language=CommonHelper:GetTempStr_Default(TemplateStringID.LanguageSettingPT_BR)
        elseif type==LanguageType.KR then
            language=CommonHelper:GetTempStr_Default(TemplateStringID.LanguageSettingKR)
        end
        local ret, tog = MessageBoxHelp:Get():OpenBox_OKCancel(UIColor.Blue,CommonHelper:GetTempStr_Default(TemplateStringID.LanguageSettingHit,language))
        if ret == MessageBoxHelp.BtnType.OK then
            func()
            CommonHelper:ApplicationQuit()
        end
        end
    MessageBoxHelp.Get():StartCoroutineBox(boxfunc)
end
--系统推送
function PagePlayerInfoSetting:SetLanguageSettingState()
    CommonHelper:SetToggleState(self.Language1, _LanguageType == 1)
    CommonHelper:SetToggleState(self.Language2, _LanguageType == 2)
    CommonHelper:SetToggleState(self.Language3, _LanguageType == 3)
    CommonHelper:SetToggleState(self.Language4, _LanguageType == 4)
    CommonHelper:SetToggleState(self.Language5, _LanguageType == 5)
    CommonHelper:SetToggleState(self.Language6, _LanguageType == 6)
    CommonHelper:SetToggleState(self.Language7, _LanguageType == 7)
end
--}}}
--{{{战斗设置
function PagePlayerInfoSetting:TogGameSettingViewAwake()
    self.GarageSet = UIUtil.GetChild("settingviews/GameSettingView", self.Root)
    self. GameTrackON1 = CommonHelper:HButtonSetCallback("gamesetting/Low1", self.GarageSet, function(param)
        if _GameTrackCheck~=1 then
            _GameTrackCheck=1
            PlayerPrefsHelper:SetValue_GameTrackCheck(_GameTrackCheck)
            self:SetGameSettingState()
        end
    end)
    self. GameTrackOFF1 = CommonHelper:HButtonSetCallback("gamesetting/Low2", self.GarageSet, function(param)
        if _GameTrackCheck~=0 then
            _GameTrackCheck=0
            PlayerPrefsHelper:SetValue_GameTrackCheck(_GameTrackCheck)
            self:SetGameSettingState()
        end
    end)
   self. GameBreakON1 = CommonHelper:HButtonSetCallback("brakesetting/Low1", self.GarageSet, function(param)
        if _GameBrakeSetting~=1 then
            _GameBrakeSetting=1
            PlayerPrefsHelper:SetValue_GameBrakeSetting(_GameBrakeSetting)
            self:SetGameSettingState()
        end
    end)
    self. GameBreakOFF1 = CommonHelper:HButtonSetCallback("brakesetting/Low2", self.GarageSet, function(param)
        if _GameBrakeSetting~=0 then
            _GameBrakeSetting=0
            PlayerPrefsHelper:SetValue_GameBrakeSetting(_GameBrakeSetting)
            self:SetGameSettingState()
        end
    end)
end
--系统推送
function PagePlayerInfoSetting:SetGameSettingState()
    CommonHelper:SetToggleState(self.GameTrackON1, _GameTrackCheck == 1)
    CommonHelper:SetToggleState(self.GameTrackON1, _GameTrackCheck == 0)
    CommonHelper:SetToggleState(self.GameBreakON1, _GameBrakeSetting == 1)
    CommonHelper:SetToggleState(self.GameBreakOFF1, _GameBrakeSetting == 0)
end
--}}}
--{{{战斗设置
function PagePlayerInfoSetting:TogGarageSettingViewAwake()
    self.GameSet = UIUtil.GetChild("settingviews/GarageSettingView", self.Root)
    self.Garage201_ON1 = CommonHelper:HButtonSetCallback("201/Low1", self.GameSet, function(param)
        if _Garage201_Show~=1 then
            _Garage201_Show=1
            PlayerPrefsHelper:SetValue_Car_GrooveIDShow(PartGrooveID.RearWing,_Garage201_Show)
            self:SetGarageSettingState()
        end
    end)
    self. Garage201_Off1 = CommonHelper:HButtonSetCallback("201/Low2", self.GameSet, function(param)
        if _Garage201_Show~=0 then
            _Garage201_Show=0
            PlayerPrefsHelper:SetValue_Car_GrooveIDShow(PartGrooveID.RearWing,_Garage201_Show)
            self:SetGarageSettingState()
        end
    end)
end

function PagePlayerInfoSetting:SetGarageSettingState()
    CommonHelper:SetToggleState(self.Garage201_ON1, _Garage201_Show == 1)
    CommonHelper:SetToggleState(self.Garage201_Off1, _Garage201_Show == 0)
end
--}}}
--{{{音乐
function PagePlayerInfoSetting:TogAudioViewAwake()
    self.AudioSettingViewObj = UIUtil.GetChild("settingviews/AudioSettingView", self.Root)
    self.TogBgmOff = CommonHelper:HButtonSetCallback("BGMOffNo/Low", self.AudioSettingViewObj, function(data)
        _BgmOffOrOn = 0
        _BgmValue = 0
        self:SetAudioState(_BgmValue)
        CSLuaHelper.SetAudioVolumeByAudioType(AudioType.BGM, 0)
    end)
    self.TogBgmON = CommonHelper:HButtonSetCallback("BGMOffNo/High", self.AudioSettingViewObj, function(data)
        _BgmOffOrOn = 1
        _BgmValue = 1
        self:SetAudioState(_BgmValue)
    end)
    self.BattleBgmOff = CommonHelper:HButtonSetCallback("BattleBgmOffNo/Low", self.AudioSettingViewObj, function(data)
        _BattleBgmOffOrOn = 0
        _BattleBgmValue = 0
        self:SetAudioState(_BattleBgmValue)
    end)
    self.BatlleBgmON = CommonHelper:HButtonSetCallback("BattleBgmOffNo/High", self.AudioSettingViewObj, function(data)
        _BattleBgmOffOrOn = 1
        _BattleBgmValue = 1
        self:SetAudioState(_BattleBgmValue)
    end)
    self.SoundEffectOFF = CommonHelper:HButtonSetCallback("SoundEffectOffNo/Low", self.AudioSettingViewObj, function(data)
        _SoundEffectOffOrOn = 0
        _SoundEffectValue = 0
        CSLuaHelper.SetAudioVolumeByAudioType(AudioType.SFX, 0)
        CSLuaHelper.SetAudioVolumeByAudioType(AudioType.UI, 0)
        self:SetAudioState(_SoundEffectOffOrOn)
    end)
    self.SoundEffectON = CommonHelper:HButtonSetCallback("SoundEffectOffNo/High", self.AudioSettingViewObj, function(data)
        _SoundEffectOffOrOn = 1
        _SoundEffectValue = 1
        self:SetAudioState(_SoundEffectOffOrOn)
    end)
    self.BattleBGMSlider = CommonHelper:SliderValueChangeCallback("BattleBgmSlider", self.AudioSettingViewObj, function(value)
        if _BattleBgmOffOrOn ~= 0 then
            _BattleBgmValue = value
            self:SetAudioState(value)
        end

    end)
    self.BGMSlider = CommonHelper:SliderValueChangeCallback("BGMSlider", self.AudioSettingViewObj, function(value)
        if _BgmOffOrOn ~= 0 then
            CSLuaHelper.SetAudioVolumeByAudioType(AudioType.BGM, value)
            _BgmValue = value
            self:SetAudioState(value)
        end

    end)
    self.SoundEffectSlider = CommonHelper:SliderValueChangeCallback("SoundEffectSlider", self.AudioSettingViewObj, function(value)
        if _SoundEffectOffOrOn ~= 0 then
            CSLuaHelper.SetAudioVolumeByAudioType(AudioType.SFX, value)
            CSLuaHelper.SetAudioVolumeByAudioType(AudioType.UI, value)
            _SoundEffectValue = value
            self:SetAudioState(_SoundEffectValue)
        end
    end)
end

function PagePlayerInfoSetting:SetAudioState()
    CommonHelper:SetToggleState(self.TogBgmOff, _BgmOffOrOn <= 0)
    CommonHelper:SetToggleState(self.TogBgmON, _BgmOffOrOn > 0)
    CommonHelper:SetToggleState(self.SoundEffectOFF, _SoundEffectOffOrOn <= 0)
    CommonHelper:SetToggleState(self.SoundEffectON, _SoundEffectOffOrOn > 0)
    CommonHelper:SetToggleState(self.BattleBgmOff, _BattleBgmOffOrOn <= 0)
    CommonHelper:SetToggleState(self.BatlleBgmON, _BattleBgmOffOrOn > 0)
    CommonHelper:SetSlider("BGMSlider", self.AudioSettingViewObj, _BgmValue)
    CommonHelper:SetSlider("SoundEffectSlider", self.AudioSettingViewObj, _SoundEffectValue)
    CommonHelper:SetSlider("BattleBgmSlider", self.AudioSettingViewObj, _BattleBgmValue)
    PlayerPrefsHelper:SetValue_BattleBgmOffOrOn(_BattleBgmOffOrOn)
    PlayerPrefsHelper:SetValue_BattleBgmValue(_BattleBgmValue)
end
--}}}
--{{{画面
function PagePlayerInfoSetting:TogFrameViewAwake()
    self.FrameSettingObj = UIUtil.GetChild("settingviews/FrameSettingView", self.Root)

    self. PictureQualityLowToggle = CommonHelper:HButtonSetCallback("FrameSettingGroup/Low", self.FrameSettingObj, function(param)
        _PictureQuality = 1
        mono.SetQualityLevel(1)
        --print("SetQualityLevel "..0)
        self:SetPictureQualityState()
    end)
    self. PictureQualityMiddleToggle = CommonHelper:HButtonSetCallback("FrameSettingGroup/Middle", self.FrameSettingObj, function(param)
        _PictureQuality = 2
        mono.SetQualityLevel(2)
        print("SetQualityLevel " .. 1)

        self:SetPictureQualityState()
    end)
    self. PictureQualityHighToggle = CommonHelper:HButtonSetCallback("FrameSettingGroup/High", self.FrameSettingObj, function(param)
        _PictureQuality = 3
        mono.SetQualityLevel(3)
        print("SetQualityLevel " .. 2)

        self:SetPictureQualityState()
    end)

    self. PowerSavingOffToggle = CommonHelper:HButtonSetCallback(" PowerSavingOffNo/Low", self.FrameSettingObj, function(param)
        _PowerSaving = 0
        mono.TurnOnLowFPS()
        self:SetPowerSavingState()
    end)
    self. PowerSavingOnToggle = CommonHelper:HButtonSetCallback(" PowerSavingOffNo/High", self.FrameSettingObj, function(param)
        _PowerSaving = 1
        mono.TurnOnHighFPS()
        self:SetPowerSavingState()
    end)

    self. TogFpsLow = CommonHelper:HButtonSetCallback("FpsOffNo/Low", self.FrameSettingObj, function(param)
        _PostSetting = 0
        mono.TurnOffPost()
        self:SetFPSSettingState()
    end)
    self. TogFpsHigh = CommonHelper:HButtonSetCallback("FpsOffNo/High", self.FrameSettingObj, function(param)
        _PostSetting = 1
        mono.TurnOnPost()
        self:SetFPSSettingState()
    end)
end
--0关 1开 0低1中2高
--画质
function PagePlayerInfoSetting:SetPictureQualityState()
    CommonHelper:SetToggleState(self.PictureQualityLowToggle, _PictureQuality == 1)
    CommonHelper:SetToggleState(self.PictureQualityMiddleToggle, _PictureQuality == 2)
    CommonHelper:SetToggleState(self.PictureQualityHighToggle, _PictureQuality == 3)
end
--省电模式
function PagePlayerInfoSetting:SetPowerSavingState()
    CommonHelper:SetToggleState(self.PowerSavingOffToggle, _PowerSaving == 0)
    CommonHelper:SetToggleState(self.PowerSavingOnToggle, _PowerSaving == 1)
end

--帧率模式
function PagePlayerInfoSetting:SetFPSSettingState()
    -- CommonHelper:SetHButtonClick( self.TogFpsHigh,mono.GetServerQualityLevel()~=1 or mono.GetServerQualityLevel()~=4)
    CommonHelper:SetToggleState(self.TogFpsLow, _PostSetting == 0)
    CommonHelper:SetToggleState(self.TogFpsHigh, _PostSetting == 1)
end

----屏幕点击
--function PagePlayerInfoSetting:SetScreenEffectState()
--    CommonHelper:SetToggleState(self.ScreenEffectOffToggle,_ScreenEffect==0)
--    CommonHelper:SetToggleState(self.ScreenEffectOnToggle,_ScreenEffect==1)
--end
----抗锯齿
--function PagePlayerInfoSetting:SetAntiAliasingState()
--    CommonHelper:SetToggleState(self.AntiAliasingOffToggle,_AntiAliasing==0)
--    CommonHelper:SetToggleState(self.AntiAliasingOnToggle,_AntiAliasing==1)
--end
--}}}

function PagePlayerInfoSetting:PlayerSettingViewUpdateTog()
    CommonHelper:SetToggleState(self.TogFrameSetting, _CurSettingView == SettingType.TogFrameSetting)
    CommonHelper:SetToggleState(self.TogAudioSetting, _CurSettingView == SettingType.TogAudioSetting)
    CommonHelper:SetToggleState(self.TogPullSetting, _CurSettingView == SettingType.TogPullSetting)
    CommonHelper:SetToggleState(self.TogLanguage, _CurSettingView == SettingType.TogLanguageSetting)
    CommonHelper:SetToggleState(self.TogGameSetting, _CurSettingView == SettingType.TogGameSetting)
    CommonHelper:SetToggleState(self.TogRedeem, _CurSettingView == SettingType.TogRedeem)
    CommonHelper:SetToggleState(self.TogGarage, _CurSettingView == SettingType.TogGarage)
    CommonHelper:SetGameObjectActive("settingviews/FrameSettingView", self.root, _CurSettingView == SettingType.TogFrameSetting)
    CommonHelper:SetGameObjectActive("settingviews/AudioSettingView", self.root, _CurSettingView == SettingType.TogAudioSetting)
    CommonHelper:SetGameObjectActive("settingviews/PullSettingView", self.root, _CurSettingView == SettingType.TogPullSetting)
    CommonHelper:SetGameObjectActive("settingviews/RedeemView", self.root, _CurSettingView == SettingType.TogRedeem)
    CommonHelper:SetGameObjectActive("settingviews/GameSettingView", self.root, _CurSettingView == SettingType.TogGameSetting)
    CommonHelper:SetGameObjectActive("settingviews/LanguageSettingView", self.root, _CurSettingView == SettingType.TogLanguageSetting)
    CommonHelper:SetGameObjectActive("settingviews/GarageSettingView", self.root, _CurSettingView == SettingType.TogGarage)
    UIUtil.ShowCanvasGroup(self.FrameSettingView, _CurSettingView == SettingType.TogFrameSetting)
    UIUtil.ShowCanvasGroup(self.AudioSettingView, _CurSettingView == SettingType.TogAudioSetting)
    UIUtil.ShowCanvasGroup(self.PullSettingView, _CurSettingView == SettingType.TogPullSetting)
    UIUtil.ShowCanvasGroup(self.RedeemView, _CurSettingView == SettingType.TogRedeem)
    UIUtil.ShowCanvasGroup(self.LanguageSettingView, _CurSettingView == SettingType.TogLanguageSetting)
    UIUtil.ShowCanvasGroup(self.GameSettingView, _CurSettingView == SettingType.TogGameSetting)
    UIUtil.ShowCanvasGroup(self.GarageSettingView, _CurSettingView == SettingType.TogGarage)

    if _CurSettingView == SettingType.TogRedeem then
        CommonHelper:GetComponentSetUITexture("redeembannner", self.Root, "uitex_sucai_code_bg_1.png", UIModuleID.PlayerInfo)
    end
end

function PagePlayerInfoSetting:SaveSetting()
    --if _DefaultPictureQuality~=_PictureQuality then
    --    local boxFunc = function()
    --        local ret = MessageBoxHelp:Get():OpenBox_OKCancel(UIColor.Blue, ClientDataManager:Get():GetTemplateString(TemplateStringID.PlayerViewSettingChange), ClientDataManager:Get():GetTemplateString(TemplateStringID.GameWarmPrompt), ClientDataManager:Get():GetTemplateString(TemplateStringID.OK), ClientDataManager:Get():GetTemplateString(TemplateStringID.Cancel), true)
    --        if ret == MessageBoxHelp.BtnType.OK then
    --
    --        end
    --    end
    --    MessageBoxHelp.Get():StartCoroutineBox(boxFunc)
    --end

    if _BgmOffOrOn ~= -1 then
        PlayerPrefsHelper:SetValue_BgmOffOrOn(_BgmOffOrOn)
    end
    if _SoundEffectOffOrOn ~= -1 then
        PlayerPrefsHelper:SetValue_SoundEffectOffOrOn(_SoundEffectOffOrOn)
    end
    if _BgmValue ~= -1 then
        PlayerPrefsHelper:SetValue_BgmValue(_BgmValue)
    end
    if _SoundEffectValue ~= -1 then
        PlayerPrefsHelper:SetValue_SoundEffectValue(_SoundEffectValue)
    end

    -- if _BgmOffOrOn ~=-1 then    PlayerPrefs.SetInt("ScreenEffect", _ScreenEffect)end
    if _SystemPush ~= -1 then
        PlayerPrefsHelper:SetValue_SystemPush(_SystemPush)
    end
    if _PowerSaving ~= -1 then
        PlayerPrefsHelper:SetValue_PowerSaving(_PowerSaving)
    end
    if _PictureQuality ~= -1 then
        PlayerPrefsHelper:SetValue_PictureQuality(_PictureQuality)
    end
    if _PostSetting ~= -1 then
        PlayerPrefsHelper:SetValue_IsPostEnable(mono.IsEnablePost())
    end
    --  if _BgmOffOrOn ~=-1 then PlayerPrefs.SetInt("AntiAliasing", _AntiAliasing)end

end

function PagePlayerInfoSetting:SetClientVersion()
    CommonHelper:SetText("###versiontext", self.Root, string.format(CommonHelper:GetTempStr_Default(TemplateStringID.StrStr), "V ", CommonHelper:GetClientVersion()))

end