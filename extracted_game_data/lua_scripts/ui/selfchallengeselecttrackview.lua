
---@class SelfChallengeSelectTrackView : ViewBase
SelfChallengeSelectTrackView = class("SelfChallengeSelectTrackView", ViewBase)
function SelfChallengeSelectTrackView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "SelfChallengeSelectTrackViewAction")
end
local _UseIndex=0
function SelfChallengeSelectTrackView:Awake()
    CommonHelper:HButtonSetCallback("BgBtn",self.gameObject,function (data)
        UIManager:Get():ClosePopup()
    end)
   CommonHelper:HButtonSetCallback("BtCancel",self.gameObject,function (data)
        UIManager:Get():ClosePopup()
    end)
   CommonHelper:HButtonSetCallback("BtnEnter",self.gameObject,function (data)
        UIManager:Get():ClosePopup()
       UINotify:Get():SendNotification(UINotifyEvent.SelfChallengeSelectTrackBack,_UseIndex+1)
    end)
    self.ScrollView=self:GetChildWight("MoreRowScrollView_V",typeof(MoreRowScrollView))

end

function SelfChallengeSelectTrackView:OnOpen()

end
local data=nil
function SelfChallengeSelectTrackView:SetData()
    ---@type SelfChallengeData
    data=SelfChallengeDataManager:Get():GetSelfChallengeData(SelfChallengeDataManager:Get().SelectId)
    if data then
        CommonHelper:InitMoreRowScrollView(self.ScrollView, #data:GetTracks(), 2,function(dataIndex, itemObj, scroll)
            self:UpdateItem(dataIndex, itemObj, scroll)
        end)
    end
end

function SelfChallengeSelectTrackView:UpdateItem(dataIndex, itemObj, scroll)

    local trackId= data:GetTracks()[dataIndex+1]
    local trackData=CommonHelper:GetRacetrackData(trackId)
    CommonHelper:GetComponentSetTrackIconByData("trackIcon",itemObj,trackData,UIModuleID.SelfChallenge)
    CommonHelper:SetText("name",itemObj,trackData:GetName())
    CommonHelper:HButtonSetCallback("ItemBtn",itemObj,function ()
        _UseIndex=dataIndex
        CommonHelper:MoreRowView_RefreshCurList(scroll,false)
    end)
    local use=self:GetChildByParent("use",itemObj)
    use:SetActive(_UseIndex==dataIndex)

    CommonHelper:SetGameObjectActive("Dot (1)",itemObj,dataIndex %2==0)
end

function SelfChallengeSelectTrackView:OnClose()

end


