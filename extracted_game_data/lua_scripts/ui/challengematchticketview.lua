---@class ChallengeMatchTicketView:ViewBase
ChallengeMatchTicketView = class("ChallengeMatchTicketView", ViewBase)

function ChallengeMatchTicketView:initialize()
    ViewBase.initialize(self)
    self.ticketDatas = {}
end

local SelectTicketID = 1

function ChallengeMatchTicketView:Awake()
    self.TicketSVC = self:GetChildWight("TicketSVC", typeof(MoreRowScrollView))

    CommonHelper:HButtonSetCallback("Btnconfirm", self.gameObject, function(data)
        if SelectTicketID ~= 1 then
            UINotify:Get():SendNotification(UINotifyEvent.ChallengeMatchCreate_RefreshChooseTicket, SelectTicketID)
        end
        UIManager:Get():ClosePopup()
    end)

    --任意处关闭
    CommonHelper:HButtonSetCallback("BgBtn", self.gameObject, function(param)
        UIManager:Get():ClosePopup()
    end)

end

function ChallengeMatchTicketView:OnOpen()
    self.ticketDatas = {}
    ---@type dictbattleaward_config
    local dictbattleaward_config = ClientDataManager:Get():GetDataTable(ConfigNames.dictbattleaward_config)
    local ticketData = dictbattleaward_config.GetTicketData()

    for i, v in pairs(ticketData) do
        local _num = KnapsackDataManager:Get():GetArticleCountByCfgid(v)
        if _num > 0 then
            table.insert(self.ticketDatas, { v, _num })
        end
    end

    SelectTicketID = 1

    if #self.ticketDatas > 0 then
        SelectTicketID = self.ticketDatas[1][1]
    end

    self:SetTicketSVC()
end

function ChallengeMatchTicketView:SetTicketSVC()
    if #self.ticketDatas == 0 then
        CommonHelper:SetGameObjectActive("NoShowText", self.gameObject, true)
        CommonHelper:SetGameObjectActive("TicketSVC", self.gameObject, false)
    else
        CommonHelper:SetGameObjectActive("NoShowText", self.gameObject, false)
        CommonHelper:SetGameObjectActive("TicketSVC", self.gameObject, true)
        local UpdateItemFunc = function(ItemIndex, itemObjH, scroll)
            local obj = UIUtil.GetChild("ItemCom_118", itemObjH)
            local param = Param_ItemArticleParam()
            param.count = self.ticketDatas[ItemIndex + 1][2]
            CommonHelper:SetItemComGroup(obj, UIModuleID.ChallengeMatchCreate, self.ticketDatas[ItemIndex + 1][1], param)

            if SelectTicketID == self.ticketDatas[ItemIndex + 1][1] then
                CommonHelper:SetGameObjectActive("select", itemObjH, true)
            else
                CommonHelper:SetGameObjectActive("select", itemObjH, false)
            end

            CommonHelper:HButtonSetCallback("clickBtn", itemObjH, function(data)
                SelectTicketID = self.ticketDatas[ItemIndex + 1][1]
                self:SetTicketSVC()
            end)

        end

        CommonHelper:InitMoreRowScrollView(self.TicketSVC, #self.ticketDatas, 1, UpdateItemFunc, true)
    end

end

function ChallengeMatchTicketView:OnClose()
    CommonHelper:ReleasePool(UIModuleID.ChallengeMatchTicket)
end



