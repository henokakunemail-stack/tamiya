
---@class ArticleInfoViewAction:ViewBaseAction
ArticleInfoViewAction = class("ArticleInfoViewAction",ViewBaseAction)

function ArticleInfoViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function ArticleInfoViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.ArticleInfoView_SetDataByCellid, self.SetDataByCellid)
    self:AddNotificationEvent(UINotifyEvent.ArticleInfoView_SetDataByCfg, self.SetDataByCfg)
    self:AddNotificationEvent(UINotifyEvent.TrackSegmentInfoView_SetData, self.SetTrackSegmentDataByCfg)
    self:AddNotificationEvent(UINotifyEvent.TrackSegmentFeatureView_SetDataByCfg, self.TrackSegmentFeatureView)
end

---@return ArticleInfoView
function ArticleInfoViewAction:View()
    return self.view
end

function ArticleInfoViewAction:SetDataByCellid(node)
    if self:View() then
        self:View():SetDataByCellid(node[1], node[2] )
    end
end
function ArticleInfoViewAction:SetTrackSegmentDataByCfg(node)
    if  self:View() then
        self:View():SetTrackSegmentDataByCfg(node[1],node[2])
    end
end
function ArticleInfoViewAction:SetDataByCfg(node)
    if self:View() then
        self:View():SetDataByCfg( node[1],node[2],node[3],node[4],node[5])
    end
end
function ArticleInfoViewAction:TrackSegmentFeatureView(node)
    if self:View() then
        self:View():TrackSegmentFeatureView(node)
    end
end


return ArticleInfoViewAction()