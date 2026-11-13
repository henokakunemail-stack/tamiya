---@class ReturnOldPlayerView : ViewBase
ReturnOldPlayerView = class("ReturnOldPlayerView", ViewBase)

function ReturnOldPlayerView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "ReturnOldPlayerViewAction")
end

function ReturnOldPlayerView:Awake()
    self.cmpTimerID = 0

    self.SignIn_CG = self:GetChildWightByParent("Page_ReturnOldPlayerSignView", self.gameObject, typeof(CanvasGroup))
    self.TaskIn_CG = self:GetChildWightByParent("Page_ReturnOldPlayerTaskView", self.gameObject, typeof(CanvasGroup))
    self.BoxIn_CG = self:GetChildWightByParent("Page_ReturnOldPlayerBoxView", self.gameObject, typeof(CanvasGroup))

    self.pageSignIn = Page_ReturnOldPlayerSignView(self.SignIn_CG.gameObject)
    self.pageTaskIn = Page_ReturnOldPlayerTaskView(self.TaskIn_CG.gameObject)
    self.pageBoxIn = Page_ReturnOldPlayerBoxView(self.BoxIn_CG.gameObject)

    self.ChooseBtnSVC = UIUtil.GetTypeChildWightByParent("ChooseBtnSVC", self.gameObject, typeof(MoreRowScrollView))

    CommonHelper:HButtonSetCallback("BtnClose", self.gameObject, function(data)
        UIManager:Get():ClosePopup()
    end)

end

local _selectID = 1
function ReturnOldPlayerView:OnOpen()

    _selectID = 1
    self:InitChooseData()
end

function ReturnOldPlayerView:InitChooseData()
    local calcName = CommonHelper:GetTableDataByID(ConfigNames.dictcalc_config, CommonCfgKey.ReturnOldPlayerBtnName)
    local btnName = stringSplit(calcName.varval, ':')

    local UpdateFunc = function(dataIndex, itemObj, scroll)

        CommonHelper:SetGameObjectActive("choose", itemObj, _selectID == dataIndex + 1)
        CommonHelper:SetGameObjectActive("common", itemObj, _selectID ~= dataIndex + 1)

        CommonHelper:SetText("choose/###Text", itemObj, CommonHelper:GetTempStr_Default(btnName[dataIndex + 1]))
        CommonHelper:SetText("common/###Text", itemObj, CommonHelper:GetTempStr_Default(btnName[dataIndex + 1]))

        CommonHelper:HButtonSetCallback("ItemBtn", itemObj, function(data)
            if dataIndex + 1 == ReturnOldPlayer.SignIn then
                ReturnOldPlayerSubsystem:Get():SendMsg_ReturnBackSignInfo()
            end
            if dataIndex + 1 == ReturnOldPlayer.Track then
                TaskSubsystem:Get():SendMsg_GetTaskList(TaskType.ReturnOldPlayer)
            end
            if dataIndex + 1 == ReturnOldPlayer.Charge then
                local cfg = CommonHelper:GetTableDataByID(ConfigNames.dictcalc_config, CommonCfgKey.ReturnOldPlayerGiftData)
                ActivitySubsystem:Get():SendMsg_GetActivity(cfg.varval)
            end
            _selectID = dataIndex + 1
            --
            UINotify:Get():SendNotification(UINotifyEvent.ReturnOldPlayer_RefreshChooseBtn)
        end)

    end

    CommonHelper:InitMoreRowScrollView(self.ChooseBtnSVC, #btnName, 1, UpdateFunc, true)

    CommonHelper:SetText("titleBG/###Text", self.gameObject,
            string.format(CommonHelper:GetTempStr_Default(TemplateStringID.ReturnOldPlayerOverTime),
                    os.date("%Y-%m-%d %H:%M:%S", ReturnOldPlayerDataManager:Get():GetReturnTime())))
end

function ReturnOldPlayerView:InitSignData()
    UIUtil.ShowCanvasGroup(self.SignIn_CG, true)
    UIUtil.ShowCanvasGroup(self.TaskIn_CG, false)
    UIUtil.ShowCanvasGroup(self.BoxIn_CG, false)

    CommonHelper:GetComponentSetUITexture("pageBG", self.gameObject, "return_sign_bottom.png", UIModuleID.ReturnOldPlayer)

    self.pageSignIn:RefreshSignInInfo()
end

function ReturnOldPlayerView:InitTaskData()
    UIUtil.ShowCanvasGroup(self.SignIn_CG, false)
    UIUtil.ShowCanvasGroup(self.TaskIn_CG, true)
    UIUtil.ShowCanvasGroup(self.BoxIn_CG, false)

    CommonHelper:GetComponentSetUITexture("pageBG", self.gameObject, "return_train_bottom.png", UIModuleID.ReturnOldPlayer)

    self.pageTaskIn:RefreshTaskInInfo()
end

function ReturnOldPlayerView:InitBoxData(msg)
    UIUtil.ShowCanvasGroup(self.SignIn_CG, false)
    UIUtil.ShowCanvasGroup(self.TaskIn_CG, false)
    UIUtil.ShowCanvasGroup(self.BoxIn_CG, true)

    CommonHelper:GetComponentSetUITexture("pageBG", self.gameObject, "return_gift_bottom.png", UIModuleID.ReturnOldPlayer)

    self.pageBoxIn:RefreshBoxInInfo(msg)
end

function ReturnOldPlayerView:SetLastObjState(msg)

end

function ReturnOldPlayerView:OnClear()
    self.SignIn_CG = nil
    self.TaskIn_CG = nil
    self.BoxIn_CG = nil

    self.pageSignIn = nil
    self.pageTaskIn = nil
    self.pageBoxIn = nil

    self.ChooseBtnSVC = nil

end

function ReturnOldPlayerView:OnClose()
    self:OnClear()
    CommonHelper:ReleasePool(UIModuleID.ReturnOldPlayer)
end