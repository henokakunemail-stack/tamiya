---@class FoundListView : ViewBase
FoundListView = class("FoundListView", ViewBase)
function FoundListView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "FoundListViewAction")
end

function FoundListView:Awake()
    CommonHelper:HButtonSetCallback("BtnClose",self.gameObject,function(data)
        UIManager:Get():ClosePopup()
    end)
    CommonHelper:HButtonSetCallback("BtnClose2",self.gameObject,function(data)
        UIManager:Get():ClosePopup()
    end)
    CommonHelper:HButtonSetCallback("BtnActivity",self.gameObject,function(data)
        FoundListManager:Get():GetFoundInfo(UserFoundType.SeasonOrder)

    end)
    CommonHelper:HButtonSetCallback("BtnCarGad",self.gameObject,function(data)
        FoundListManager:Get():GetFoundInfo(UserFoundType.CarGad)
    end)
    CommonHelper:HButtonSetCallback("BtnStory",self.gameObject,function(data)
        FoundListManager:Get():GetFoundInfo(UserFoundType.Story)
    end)
    CommonHelper:HButtonSetCallback("BtnLevel",self.gameObject,function(data)
        FoundListManager:Get():GetFoundInfo(UserFoundType.Level)
    end)
end

function FoundListView:OnOpen()

end

function FoundListView:OnClose()

end

