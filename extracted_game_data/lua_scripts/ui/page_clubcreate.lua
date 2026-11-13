---@class PageClubCreate
PageClubCreate = class("PageClubCreate")

function PageClubCreate:initialize(parent)
    self.parent = parent

    self:Page_CacheBaseData()

    self:InitBtnFunc()
end

function PageClubCreate:Page_CacheBaseData()
    self.clubNotificationInput = UIUtil.GetTypeChildWightByParent("ClubNotificationInput", self.parent, typeof(InputField))
    self.clubLevelInput = UIUtil.GetTypeChildWightByParent("ClubLevelInput", self.parent, typeof(InputField))
    --self.headListScroll = UIUtil.GetTypeChildWightByParent("HeadListScroll", self.parent, typeof(MoreRowScrollView))
    --self.allBadge = CommonHelper:GetHeadIconsByType(HeadIconType.ClubIcon, HeadIconAttrType.Head)

    --self.TrackView = UIUtil.GetTypeChildWightByParent("TrackScrollView", self.parent, typeof(FilmScrollView))

    self.clubJoinType = ClubJoinType.FreeJoin

    CommonHelper:InputFieldSetValue(self.clubNotificationInput, CommonHelper:GetTempStr_Default(TemplateStringID.ClubNotifyLimit,4,40))
end

function PageClubCreate:InitBtnFunc()

    CommonHelper:HButtonSetCallback("BtnClose", self.parent, function(param)
        UIManager:Get():CloseView()
    end)

    CommonHelper:HButtonSetCallback("CancelBtn", self.parent, function(param)
        UIManager:Get():CloseView()
    end)

    self.ClubApproveTog = CommonHelper:HButtonSetCallback("ClubApproveTog", self.parent, function(param)
        self.clubJoinType = self.clubJoinType == ClubJoinType.NeedAudit and ClubJoinType.FreeJoin or ClubJoinType.NeedAudit
        CommonHelper:SetToggleState(self.ClubApproveTog, self.clubJoinType == ClubJoinType.NeedAudit, false)
    end)
end

function PageClubCreate:Page_InitViewInfo(curSelectId)
    self.curSelectId = curSelectId
    self:SetHeadListView()
end



function PageClubCreate:SetHeadListView()
    local UpdateFunc = function(dataIndex, itemObj, scroll)
        local GrayImage = UIUtil.GetTypeChildWightByParent("GrayImage", itemObj, typeof(Image))
        local iconData = self.allBadge[dataIndex + 1]
        CommonHelper:GetComponentSetUITexture("HeadIcon", itemObj, iconData.icon .. ".png", UIModuleID.Club)

    end
    CommonHelper:FilmView_Init(self.TrackView, #self.allBadge, UpdateFunc)
end

function PageClubCreate:GetCurSelectId()
    local idx=CommonHelper:FilmView_GetCurItem(self.TrackView)
    return self.allBadge[idx+1].id
end









