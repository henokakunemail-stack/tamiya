

local __CurCellID
local __AddNum = 0

---@class ArticleInfoUseView : ViewBase
ArticleInfoUseView = class("ArticleInfoUseView", ViewBase)

function ArticleInfoUseView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "ArticleInfoUseViewAction")



end

function ArticleInfoUseView:Awake()
    CommonHelper:HButtonSetCallback("BtnClose",self.gameObject,function (hbtn)
        UIManager:Get():ClosePopup()
    end)
    self.BtnUse = CommonHelper:HButtonSetCallback("BtnUse",self.gameObject,function (hbtn)
        if __CurCellID ~= -1 then
            KnapsackSubsystem:Get():SendMsg_UseArticle(__CurCellID, __AddNum)
        end
    end)

    CommonHelper:HButtonSetCallback("BtnAdd1",self.gameObject,function (hbtn)
        UINotify:Get():SendNotification(UINotifyEvent.ArticleInfoUseView_SetCount, 1)
    end)

    CommonHelper:HButtonSetCallback("BtnAdd10",self.gameObject,function (hbtn)
        UINotify:Get():SendNotification(UINotifyEvent.ArticleInfoUseView_SetCount, 10)
    end)

    CommonHelper:HButtonSetCallback("BtnRemove1",self.gameObject,function (hbtn)
        UINotify:Get():SendNotification(UINotifyEvent.ArticleInfoUseView_SetCount, -1)
    end)

    CommonHelper:HButtonSetCallback("BtnRemove10",self.gameObject,function (hbtn)
        UINotify:Get():SendNotification(UINotifyEvent.ArticleInfoUseView_SetCount, -10)
    end)

    CommonHelper:HButtonSetCallback("BtnMax",self.gameObject,function (hbtn)
        UINotify:Get():SendNotification(UINotifyEvent.ArticleInfoUseView_SetCount)
    end)

    self.Input = UIUtil.GetTypeChildWightInputPath("Input56", self.gameObject, typeof(InputField))
end

function ArticleInfoUseView:OnOpen()

end

function ArticleInfoUseView:OnClose()
    __CurCellID = -1
    __AddNum = 0
    CommonHelper:ReleasePool(UIModuleID.ArticleInfo)
end

function ArticleInfoUseView:OnAutoClose()
    __CurCellID = -1
    __AddNum = 0
    CommonHelper:ReleasePool(UIModuleID.ArticleInfo)
end

function ArticleInfoUseView:SetData(cellid)
    local data = KnapsackDataManager:Get():GetArticleByCellID(cellid)
    if data and data:GetArticleConfig() then
        __CurCellID = cellid

        ---@type parttype_config
        local cfg = ClientDataManager:GetDataTable(ConfigNames.parttype_config)
        local title = ClientDataManager:GetTemplateString(cfg.GetDataByType2(data:GetArticleConfig().type,data:GetArticleConfig().school))

        CommonHelper:SetText("TitleCompoentGreen_2/title1",self.gameObject,ClientDataManager:Get():GetTemplateString(data:GetArticleConfig().name))

        CommonHelper:SetText("articledes",self.gameObject,ClientDataManager:Get():GetTemplateString(data:GetArticleConfig().description))

        CommonHelper:SetText("typename",self.gameObject,title)

        CommonHelper:SetText("havenum",self.gameObject,tostring(data:GetCount()))

        --local iconRaw = UIUtil.GetTypeChildWightByParent("articleIcon", self.gameObject, typeof(RawImage))
        --CommonHelper:SetUITexture(iconRaw,  data:GetArticleConfig().NewIcon, UIModuleID.ArticleInfo)

        CommonHelper:GetComponentSetUITexture("articleIcon",self.gameObject,data:GetArticleConfig().NewIcon,UIModuleID.ArticleInfo)
    end

    self:AutoSelect()
end

function ArticleInfoUseView:OnClickBtn_Num(num)
    if num == nil then
        local data = KnapsackDataManager:Get():GetArticleByCellID(__CurCellID)
        if data then
            __AddNum = data:GetCount()
        end
    else
        local data = KnapsackDataManager:Get():GetArticleByCellID(__CurCellID)
        __AddNum = __AddNum + num
        if __AddNum < 0 then __AddNum = 0 end
        if __AddNum > data:GetCount() then __AddNum = data:GetCount() end
    end

    CommonHelper:SetInputFieldText("Input56",self.gameObject,tostring(__AddNum))
end

function ArticleInfoUseView:AutoSelect()
    self:OnClickBtn_Num(1)
end


