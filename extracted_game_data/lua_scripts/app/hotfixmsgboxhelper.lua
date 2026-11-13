---@class MsgBoxType
MsgBoxType = {
    Both = 0,
    Ensure = 1,
    Cancel = 2,
}

---@class HotfixMsgBoxData  @热更弹框
HotfixMsgBoxData = class("HotfixMsgBoxData")
function HotfixMsgBoxData:initialize()
    self.DesTex = ""
    self.FuncSure = nil
    self.FuncCancel = nil
    self.BtnNameSure = HotfixHelper:GetStringById(HotfixString.MsgEnsure)
    self.BtnNameCancel = HotfixHelper:GetStringById(HotfixString.MsgCancel)
    self.MsgBoxType = MsgBoxType.Both
end

---@class HotfixMsgBoxHelper
HotfixMsgBoxHelper = class("HotfixMsgBoxHelper")
function HotfixMsgBoxHelper:initialize()
    ---@type table<number, HotfixMsgBoxData>
    self.DataList = {}
    self.BoxObj = nil
end

---@return HotfixMsgBoxHelper
function HotfixMsgBoxHelper:Get()
    if self._instance == nil then
        self._instance = HotfixMsgBoxHelper()
    end
    return self._instance
end

----从asset update 面板里面获取到msg box 弹框go
function HotfixMsgBoxHelper:Init(root)
    self.BoxObj = HotfixHelper:SetGameObjectActive("MsgBox", root, false)
    self.DataList = {}
end

---@param msgBoxType MsgBoxType
function HotfixMsgBoxHelper:OpenMsgBox(tips, funcsure, funcCancel, namesure, namecancel, msgBoxType)
    local data = HotfixMsgBoxData()
    data.DesTex = tips
    data.FuncSure = funcsure
    data.FuncCancel = funcCancel
    data.BtnNameSure = namesure and namesure or data.BtnNameSure
    data.BtnNameCancel = namecancel and namecancel or data.BtnNameCancel
    data.MsgBoxType = msgBoxType and msgBoxType or data.MsgBoxType
    table.insert(self.DataList, data)

    self:SetUI(data)
end

---@param data HotfixMsgBoxData
function HotfixMsgBoxHelper:SetUI(data)
    self:SetActive(true)

    HotfixHelper:SetText("###DesTex", self.BoxObj, data.DesTex)

    self.btnEnsure = HotfixHelper:HButtonSetCallback("BtnSure", self.BoxObj, function(btn)
        self:CloseMsgBox()
        if data.FuncSure then
            data.FuncSure()
        end
    end)

    self.btnCancel = HotfixHelper:HButtonSetCallback("BtnCancel", self.BoxObj, function(btn)
        if data.FuncCancel then
            data.FuncCancel()
        end
    end)
    HotfixHelper:SetText("###text", self.btnEnsure.gameObject, data.BtnNameSure)
    HotfixHelper:SetText("###text", self.btnCancel.gameObject, data.BtnNameCancel)

    HotfixHelper:SetGameObjectActiveByGo(self.btnEnsure.gameObject, data.MsgBoxType == MsgBoxType.Ensure or data.MsgBoxType == MsgBoxType.Both)
    HotfixHelper:SetGameObjectActiveByGo(self.btnCancel.gameObject, data.MsgBoxType == MsgBoxType.Cancel or data.MsgBoxType == MsgBoxType.Both)

end

function HotfixMsgBoxHelper:CloseMsgBox()
    --if #self.DataList > 0 then
    --    table.remove(self.DataList)
    --    if #self.DataList > 0 then
    --        self:SetUI(self.DataList[#self.DataList])
    --    else
    --        self:SetActive(false)
    --    end
    --else
    self.DataList = {}
    self:SetActive(false)
    --end
end

function HotfixMsgBoxHelper:SetActive(active)
    if self.BoxObj then
        self.BoxObj:SetActive(active)
    end
end
