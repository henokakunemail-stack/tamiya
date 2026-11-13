---@class FirstBuyData FirstBuyData
FirstBuyData = class("FirstBuyData")


function FirstBuyData:initialize()
    self.actType = -1
    self.Actfirstcharge = -1
end

function FirstBuyData:SetData(data)
    self.actType = data.actType
    self.Actfirstcharge = data.Actfirstcharge
end

---@type  SC_UserFirstGift