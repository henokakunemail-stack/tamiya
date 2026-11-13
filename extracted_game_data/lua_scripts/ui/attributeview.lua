


---@class AttributeView:ViewBase
AttributeView = class("AttributeView", ViewBase)

function AttributeView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "AttributeViewAction")
end

function AttributeView:Awake()
    CommonHelper:HButtonSetCallback("BtnCloseMask",self.gameObject,function (data)
        UIManager:Get():ClosePopup()
    end)

end

function AttributeView:OnOpen()

end

function AttributeView:OnClose()

end

function AttributeView:SetData(type)

    CommonHelper:SetText("attrname",self.gameObject, CommonHelper:GetAttrName(type))
    CommonHelper:SetText("attrdes",self.gameObject, CommonHelper:GetAttrDesc(type))

end
