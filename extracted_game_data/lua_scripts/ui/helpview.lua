


---@class HelpView : ViewBase
HelpView = class("HelpView", ViewBase)

function HelpView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "HelpViewAction")
end

function HelpView:Awake()
    CommonHelper:HButtonSetCallback("BtnClose",self.gameObject,function (hbtn)
        UIManager:Get():ClosePopup()
    end)
    CommonHelper:HButtonSetCallback("BtnCloseMask2",self.gameObject,function (hbtn)
        UIManager:Get():ClosePopup()
    end)

end

function HelpView:OnOpen()

end

function HelpView:OnClose()

end

function HelpView:SetData(type,title,style)
    if style==nil then style = HelpStyleType.Default end
    self:SetBG(style)
    ---@type pagedetails_config_cell
    local cfg = CommonHelper:GetTableDataByID(ConfigNames.pagedetails_config, type)
    if cfg then
        if title == nil then title = CommonHelper:GetTempStr_Default(cfg.title) end
        local des = CommonHelper:GetTempStr_Default(cfg.desc)

        if style == HelpStyleType.Default then
            CommonHelper:SetText("###title1", self.gameObject, title)
            --CommonHelper:SetText("desc", self.gameObject, des)

            CommonHelper:SetNewLineText("###desc",self.gameObject,des)
        else
            if style==HelpStyleType.BlueStyle then
                if self.PageBlueStyleView == nil then
                    self.PageBlueStyleView = Page_OtherStyleView(UIUtil.GetChild("PageBlueStyle",self.gameObject))
                end
                self.PageBlueStyleView:SetData(title,des)
            elseif  style==HelpStyleType.YellowStyle  then
                if self.PageYellowStyleView == nil then
                    self.PageYellowStyleView = Page_OtherStyleView(UIUtil.GetChild("PageYellowStyle",self.gameObject))
                end
                self.PageYellowStyleView:SetData(title,des)
            end
        end
    else
        ---IllustrateHandbook  图鉴会走到这里
        ---@type
        local des =CommonHelper:GetTempStr_Default(type)
        if title ~= nil then title = CommonHelper:GetTempStr_Default(title) end
        if title ~= nil then
            CommonHelper:SetText("###title1", self.gameObject, title)
        end
        CommonHelper:SetNewLineText("###desc",self.gameObject,des)
    end
    --des = string.gsub(des, "-n", "\n")
    --des = string.gsub(des, " ", "\u{00A0}")

end

function HelpView:SetBG(style)
    CommonHelper:SetGameObjectActive("DefaultBG",self.gameObject,style==HelpStyleType.Default)
    CommonHelper:SetGameObjectActive("PageBlueStyle",self.gameObject,style==HelpStyleType.BlueStyle)
    CommonHelper:SetGameObjectActive("PageYellowStyle",self.gameObject,style==HelpStyleType.YellowStyle)
end