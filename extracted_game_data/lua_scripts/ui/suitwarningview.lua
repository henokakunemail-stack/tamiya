


---@class SuitWarningView : ViewBase
SuitWarningView = class("SuitWarningView", ViewBase)

function SuitWarningView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "SuitWarningViewAction")
end

function SuitWarningView:Awake()
    self.TitleGroup = UIUtil.GetChild("TitleCompoentWhite_2", self.gameObject)
    self.BgGroup = UIUtil.GetChild("WindowBgWhite_1", self.gameObject)

    self.BtnSure = CommonHelper:HButtonSetCallback("BtnSure",self.gameObject,function (hbtn)
        self:OnClickBtn_Sure()
    end)
    self.BtnCancel = CommonHelper:HButtonSetCallback("BtnCancel",self.gameObject,function (hbtn)
        UIManager:Get():ClosePopup()
    end)

    self.ScrollView = UIUtil.GetTypeChildWightInputPath("MoreRowScrollView_V", self.gameObject, typeof(MoreRowScrollView))

    self.SuitIdx = -1
    self.CarIdx = -1
end

function SuitWarningView:OnOpen()
    self.SuitIdx = -1
    self.CarIdx = -1
end

function SuitWarningView:OnClose()
    CommonHelper:ReleasePool(UIModuleID.SuitWarning)
end

function SuitWarningView:SetData(uicolor, suitidx, caridx, parts)
    self.SuitIdx = suitidx
    self.CarIdx = caridx

    CommonHelper:SetColorSystem_Btn(self.BtnSure.gameObject, uicolor)
    CommonHelper:SetColorSystem_Btn(self.BtnCancel.gameObject, uicolor)
    CommonHelper:SetColorSystem_Title2(self.TitleGroup, uicolor)
    CommonHelper:SetColorSystem_WindowBg1(self.BgGroup, uicolor)

    ---@type table<number, ArticleCell>
    self.PartList = parts
    CommonHelper:InitMoreRowScrollView(self.ScrollView, #parts, 4,function(dataIndex, itemObj, scroll)
        self:UpdateScrollView(dataIndex, itemObj)
    end)
end


function SuitWarningView:UpdateScrollView(dataIndex, itemObj)
    local data = self.PartList[dataIndex + 1]

    local obj = UIUtil.GetChild("PartCompoent",itemObj)
    local param = Param_PartGroup()
    param.partId = data:GetPartConfig().C_ID
    param.star = data:GetStar()
    param.moduleId = UIModuleID.SuitWarning
    param.quality = data:GetPartQuality()
    param.carIdx = data:GetCarId()
    CommonHelper:SetPartGroup(obj, param)
end

function SuitWarningView:OnClickBtn_Sure()
    UIManager:Get():ClosePopup()
end