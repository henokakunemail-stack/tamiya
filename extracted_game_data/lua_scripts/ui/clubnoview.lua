---@class ClubNoView : ViewBase
ClubNoView = class("ClubNoView", ViewBase)

function ClubNoView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "ClubNoViewAction")
end

function ClubNoView:Awake()
    self:CacheData()
    self:CacheCreateData()
    self:CacheListData()

    self:InitBtnFunc()
    self:InitCreateBtnFunc()
    self:InitListBtnFunc()
end

function ClubNoView:CacheData()
    self.ListCG = UIUtil.GetTypeChildWightByParent("ClubListCG", self.gameObject, typeof(CanvasGroup))
    self.CreateCG = UIUtil.GetTypeChildWightByParent("ClubCreateCG", self.gameObject, typeof(CanvasGroup))
    self.ListTG = UIUtil.GetGameobjectComponent(self.ListCG.gameObject, typeof(FXUITweenMoreGroup))

    self.togIdx = nil
end

function ClubNoView:OnOpen()
    self:InitTogState(true, false, 1, function()
        self:InitListViewInfo()
    end)
end

function ClubNoView:ReOpen()
    self:InitTogState(true, false, 1, function()
        self:InitListViewInfo()
    end)
end

function ClubNoView:InitBtnFunc()
    self.TogJoin = CommonHelper:HButtonSetCallback("TogJoin", self.gameObject, function(param)
        self:InitTogState(true, false, 1, function()
            self:InitListViewInfo()
        end)
    end)

    self.TogCreate = CommonHelper:HButtonSetCallback("TogCreate", self.gameObject, function(param)
        self:InitTogState(false, true, 2, function()
            self:InitCreateInfo()
            CommonHelper:TMG_PlayAllTweenByName("ClubCreateCG", self.gameObject)
        end)
    end)

    CommonHelper:HButtonSetCallback("BtnBack", self.gameObject, function(param)
        UIManager:Get():CloseView()
    end)
    CommonHelper:HButtonSetCallback("BtnHelp", self.gameObject, function(param)
        CommonHelper:ShowHelpView(PageDetailType.Club)
    end)
end

function ClubNoView:InitTogState(TogList, TogCreate, togIdx, func)
    if self.togIdx ~= togIdx then
        CommonHelper:SetToggleState(self.TogJoin, TogList)
        CommonHelper:SetToggleState(self.TogCreate, TogCreate)

        UIUtil.ShowCanvasGroup(self.ListCG, TogList)
        UIUtil.ShowCanvasGroup(self.CreateCG, TogCreate)
        CommonHelper:SetGameObjectActive("ClubCreateGo", self.gameObject, TogCreate)

        if func then
            func()
        end

        self.togIdx = togIdx
    end
end

function ClubNoView:OnClose()
    self.togIdx = nil
end
