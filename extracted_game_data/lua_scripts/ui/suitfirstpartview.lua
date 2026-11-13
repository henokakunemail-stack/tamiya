


---@class SuitFirstPartViewParam
SuitFirstPartViewParam = class("SuitFirstPartViewParam")

function SuitFirstPartViewParam:initialize()
    self.PartType = PartType.Error
    ---@type SuitData
    self.Suit = nil
    self.TipsInfo = ""
    self.Func = nil
    self.FuncClass = nil
    self.FuncParam = nil
end



---@class SuitFirstPartView : ViewBase
SuitFirstPartView = class("SuitFirstPartView", ViewBase)

function SuitFirstPartView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "SuitFirstPartViewAction")
end

function SuitFirstPartView:Awake()

    CommonHelper:HButtonSetCallback("BtnSure",self.gameObject,function (hbtn)
        self:OnClickBtn_Sure()
    end)
    CommonHelper:HButtonSetCallback("BtnCancel",self.gameObject,function (hbtn)
        UIManager:Get():ClosePopup()
    end)

    self.ScrollView = UIUtil.GetTypeChildWightInputPath("MoreRowScrollView_V", self.gameObject, typeof(MoreRowScrollView))

    ---@type table<number, ArticleCell>
    self.PartList = {}
    ---@type SuitFirstPartViewParam
    self.Param = nil
    self.SelectIdx = -1
    ---@type ArticleCell
    self.SelectArticle = nil
end

function SuitFirstPartView:OnOpen()
    self.PartList = {}
    self.Param = nil
    self.SelectIdx = -1
    self.SelectArticle = nil
end

function SuitFirstPartView:OnClose()
    CommonHelper:ReleasePool(UIModuleID.SuitFirstPart)
end

---@param param SuitFirstPartViewParam
function SuitFirstPartView:SetData(param)
    self.SelectIdx = -1
    self.SelectArticle = nil
    self.Param = param

    ---@type table<number, ArticleCell>
    self.PartList = KnapsackDataManager:Get():GetEquipmentsByType(param.PartType)
    CommonHelper:InitMoreRowScrollView(self.ScrollView, #self.PartList, 4,function(dataIndex, itemObj, scroll)
        self:UpdateScrollView(dataIndex, itemObj)
    end)

    CommonHelper:SetText("tipsinfo", self.gameObject, self.Param.TipsInfo)
end


function SuitFirstPartView:UpdateScrollView(dataIndex, itemObj)
    local data = self.PartList[dataIndex + 1]

    local obj = UIUtil.GetChild("PartCompoent",itemObj)
    local param = Param_PartGroup()
    param.partId = data:GetPartConfig().C_ID
    param.star = data:GetStar()
    param.moduleId = UIModuleID.SuitFirstPart
    param.quality = data:GetPartQuality()
    param.carIdx = data:GetCarId()
    CommonHelper:SetPartGroup(obj, param)

    CommonHelper:SetGameObjectActive("select", itemObj, self.SelectIdx == dataIndex)

    CommonHelper:HButtonSetCallback("ItemBtn",itemObj,function (hbtn)
        self:ClickScrollItem(hbtn.intData)
    end, dataIndex)
end

function SuitFirstPartView:ClickScrollItem(dataIndex)
    self.SelectArticle = self.PartList[dataIndex + 1]
    self.SelectIdx = dataIndex
    CommonHelper:MoreRowView_RefreshCurList(self.ScrollView, false)
end

function SuitFirstPartView:OnClickBtn_Sure()
    if self.SelectArticle then
        local grooveid = PartGrooveID.Error
        if self.Param.PartType == PartType.Shell then grooveid = PartGrooveID.Shell end
        if self.Param.PartType == PartType.Chassis then grooveid = PartGrooveID.Chassis end
        SuitSubsystem:Get():SendMsg_AddPart(self.Param.Suit:GetIdx(), self.SelectArticle:GetID(), grooveid)
        if self.Param.Func then
            if self.Param.FuncClass then
                self.Param.Func(self.Param.FuncClass, self.Param.Suit, self.Param.FuncParam)
            else
                self.Param.Func(self.Param.Suit, self.Param.FuncParam)
            end
        end
    else
        CommonTipsHelper:ShowCenterTips(ClientDataManager:Get():GetTemplateString(TemplateStringID.SuitFirstPartViewNotSelect))
    end

end