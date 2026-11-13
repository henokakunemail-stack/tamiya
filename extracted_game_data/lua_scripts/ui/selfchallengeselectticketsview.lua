
---@class SelfChallengeSelectTicketsView : ViewBase
SelfChallengeSelectTicketsView = class("SelfChallengeSelectTicketsView", ViewBase)
function SelfChallengeSelectTicketsView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "SelfChallengeSelectTicketsViewAction")
end
local _UseIndex=0
local _Data=nil
function SelfChallengeSelectTicketsView:Awake()
   CommonHelper:HButtonSetCallback("BtnClose",self.gameObject,function (data)
       UIManager:Get():ClosePopup()
   end)
    CommonHelper:HButtonSetCallback("BtnEnter",self.gameObject,function (data)
        if _UseIndex+1==0 or _UseIndex==nil then
           CommonTipsHelper:Get():ShowCenterTips("请选择挑战劵")
           return
        end
        UINotify:Get():SendNotification(UINotifyEvent.SelfChallengeCreateSelectTicketsBack,_UseIndex+1)

       UIManager:Get():ClosePopup()
   end)
    self.ScrollView=self:GetChildWight("MoreRowScrollView_V",typeof(MoreRowScrollView))
end

function SelfChallengeSelectTicketsView:SetData()
    _Data=SelfChallengeDataManager:Get():GetTicketsList()
    CommonHelper:InitMoreRowScrollView(self.ScrollView, #_Data, 4,function(dataIndex, itemObj, scroll)
        self:UpdateItem(dataIndex, itemObj, scroll)
    end)
end

function SelfChallengeSelectTicketsView:UpdateItem(dataIndex, itemObj, scroll)
    -----@type article_config_cell
    local cfg= CommonHelper:GetTableDataByID(ConfigNames.article_config,_Data[dataIndex+1].articleId)

    local param=Param_ArticleGroup()
    param.moduleId = UIModuleID.SelfChallenge
    param.articleId = cfg.id
    param.count = 1

    param.showname = false
    param.showcount = false

    param.icon = cfg.icon..".png"
    param.name = cfg.name
    param.quality = _Data[dataIndex+1].difficulty
    param.isGray=false
    param.isFragment = false
    CommonHelper:SetArticleGroup(itemObj,param)

    local diffImg=CommonHelper:GetSelfChallengeDifferentIcon(_Data[dataIndex+1].difficulty)

    CommonHelper:GetComponentSetImage("difficulty",itemObj,diffImg,UIModuleID.SelfChallenge)

    CommonHelper:HButtonSetCallback("ItemBtn",itemObj,function ()
          _UseIndex=dataIndex
          CommonHelper:MoreRowView_RefreshCurList(scroll,false)
    end)
    local use=self:GetChildByParent("use",itemObj)
    use:SetActive(_UseIndex==dataIndex)
end
function SelfChallengeSelectTicketsView:OnOpen()
    self:SetData()
end

function SelfChallengeSelectTicketsView:OnClose()

end


