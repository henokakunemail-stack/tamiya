---@class SettingView : ViewBase
SettingView = class("SettingView", ViewBase)

-- View必加
function SettingView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "SettingViewAction")
end

function SettingView:Awake()

    self.SettingView = self:GetChild("root")

    CommonHelper:HButtonSetCallback("BtnBack",self.gameObject,function(data)
        UIManager:Get():CloseView()
    end)
    CommonHelper:HButtonSetCallback("BtnGameRepair", self.gameObject, function()
        local boxFunc = function()
            local ret = MessageBoxHelp:Get():OpenBox_OKCancel(nil, CommonHelper:GetTempStr_Default(TemplateStringID.GameRepair))
            if ret == MessageBoxHelp.BtnType.OK then
                HotfixHelper:ClearLocalPatch()
                HotfixHelper:ApplicationQuit()
            end
        end
        MessageBoxHelp.Get():StartCoroutineBox(boxFunc)
    end)
end



function SettingView:OnOpen()
    self:OpenSettingView(nil)
end

function SettingView:OnClose()
    if   self.PageSettingObj then
        self.PageSettingObj:SaveSetting()
    end
end

--{{{  设置面板
function SettingView:OpenSettingView(param)

    if self.PageSetting == nil then
       -- PrefabCacheMgr:Get():SwapPrefabAsync("Page_PlayerinfoSetting.prefab", nil, nil, function(data, obj)
            self.PageSetting = self:GetChild("Page_PlayerinfoSetting")
            UIUtil.SetParentTransform(self.SettingView,self.PageSetting,true,true)
            self.PageSettingObj = PagePlayerInfoSetting()
            self.PageSettingObj:SetData(self.PageSetting)
            self.PageSettingObj:SettingViewSetData(param)
       -- end)
    else
        self.PageSettingObj:SettingViewSetData(param)
    end
end
--}}}



