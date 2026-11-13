---@class BuyGoldTipsView:ViewBase
BuyGoldTipsView = class("BuyGoldTipsView", ViewBase)

function BuyGoldTipsView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "BuyGoldTipsAction")
end

function BuyGoldTipsView:Awake()
    CommonHelper:HButtonSetCallback("BgBtn", self.gameObject, function(param)
        UIManager:Get():HidePersistentView("BuyGoldTipsView")
    end)

    CommonHelper:HButtonSetCallback("BtnClose", self.gameObject, function(param)
        UIManager:Get():HidePersistentView("BuyGoldTipsView")
    end)

    self.probabilitySVC = UIUtil.GetTypeChildWightInputPath("probabilitySVC", self.gameObject, typeof(MoreRowScrollView))
end

function BuyGoldTipsView:OnOpen()
    BuyGoldDataManager:Get():SetBuyGoldTipsData()

    CommonHelper:SetText("titleItem/img1/###Text", self.gameObject, CommonHelper:GetTempStr_Default(TemplateStringID.BuyGoldTipsItem1))
    CommonHelper:SetText("titleItem/img2/###Text", self.gameObject, CommonHelper:GetTempStr_Default(TemplateStringID.BuyGoldTipsItem2))
    CommonHelper:SetText("titleItem/img3/###Text", self.gameObject, CommonHelper:GetTempStr_Default(TemplateStringID.BuyGoldTipsItem3))
    CommonHelper:SetText("titleItem/img4/###Text", self.gameObject, CommonHelper:GetTempStr_Default(TemplateStringID.BuyGoldTipsItem3))
    CommonHelper:SetText("titleItem/img5/###Text", self.gameObject, CommonHelper:GetTempStr_Default(TemplateStringID.BuyGoldTipsItem3))

    CommonHelper:SetText("###title", self.gameObject, CommonHelper:GetTempStr_Default(TemplateStringID.BuyGoldTipsTitle))
    CommonHelper:SetText("###title_s", self.gameObject, CommonHelper:GetTempStr_Default(TemplateStringID.BuyGoldTipsTitle1))
end

function BuyGoldTipsView:ShowTips()
    local tipsData, keysData = BuyGoldDataManager:Get():GetBuyGoldTipsData()

    CommonHelper:InitMoreRowScrollView(self.probabilitySVC, #keysData, 1, function(itemIndex, itemChild, scroll)
        local _key = keysData[itemIndex + 1]
        for i = 1, 5 do
            local _bool = true and tipsData[_key][i] ~= nil or false
            if i == 1 then
                CommonHelper:SetText("img" .. i .. "/###Text", itemChild, tipsData[_key][i])
            elseif i ~= 1 and _bool then
                CommonHelper:SetText("img" .. i .. "/###Text", itemChild, tostring(math.ceil(tipsData[_key][i] / 10)) .. "%")
            else
                CommonHelper:SetText("img" .. i .. "/###Text", itemChild, "-")
            end
        end
    end)

end
