



local __instance
---@class SuitDataManager
SuitDataManager = class("SuitDataManager")
function SuitDataManager:initialize()
    ---@type table<number, SuitData>
    self.SuitList = nil
end
---@return SuitDataManager
function SuitDataManager:Get()
    if __instance == nil then
        __instance = SuitDataManager()
    end
    return __instance
end

---@param msg SC_GetAllCarPlanRes
function SuitDataManager:SetList(msg)
    self.SuitList = {}
    for i = 1, #msg.plans do
        local data = SuitData()
        data:SetBaseData(msg.plans[i])
        table.insert(self.SuitList, data)
    end
end

---@param msg SC_GetCarPlanDetailRes
function SuitDataManager:SetSuitDetail(msg)
    if msg == nil then return end
    for i = 1, #self.SuitList do
        local temp = self.SuitList[i]
        if temp:GetIdx() == msg.idx then
            temp:SetDetailData(msg)
            break
        end
    end
end

---@return SuitData
function SuitDataManager:GetSuit(idx)
    for i = 1, #self.SuitList do
        local temp = self.SuitList[i]
        if temp:GetIdx() == idx then
            return temp
        end
    end
    return nil
end



---@return table<number, SuitData>
function SuitDataManager:GetSuitList()
    return self.SuitList
end

function SuitDataManager:SetSuitName(idx, name)
    for i = 1, #self.SuitList do
        local temp = self.SuitList[i]
        if temp:GetIdx() == idx then
            temp:SetName(name)
            break
        end
    end
end

---@param msg SC_GetCarPlanDetailRes
function SuitDataManager:TryOpenTransformView(msg)
    local data = SuitDataManager:Get():GetSuit(msg.idx)
    if data:CheckGrooveBlank(PartGrooveID.Shell) then
        self:FirstSelectShell(data)
        return
    end
    if data:CheckGrooveBlank(PartGrooveID.Chassis) then
        self:FirstSelectChassis(data)
        return
    end
    self:OpenTrasformView(data)
end

---@param data SuitData
function SuitDataManager:FirstSelectShell(data, param)
    UIManager:Get():OpenPopup("SuitFirstPartView", CanvasType.FrontCanvas, "SuitFirstPartView")
    local param = SuitFirstPartViewParam()
    param.PartType = PartType.Shell
    param.Suit = data
    param.TipsInfo = ClientDataManager:Get():GetTemplateString(TemplateStringID.SuitFirstSelectShell)
    param.Func = self.FirstSelectChassis
    param.FuncClass = self
    UINotify:Get():SendNotification(UINotifyEvent.SuitFirstPartView_SetData, param)
end

---@param data SuitData
function SuitDataManager:FirstSelectChassis(data, param)
    UIManager:Get():OpenPopup("SuitFirstPartView", CanvasType.FrontCanvas, "SuitFirstPartView")
    local param = SuitFirstPartViewParam()
    param.PartType = PartType.Chassis
    param.Suit = data
    param.TipsInfo = ClientDataManager:Get():GetTemplateString(TemplateStringID.SuitFirstSelectChassis)
    param.Func = self.FirstSelectFinish
    param.FuncClass = self
    param.FuncParam = true
    UINotify:Get():SendNotification(UINotifyEvent.SuitFirstPartView_SetData, param)
end

---@param data SuitData
function SuitDataManager:FirstSelectFinish(data, isclose)
    if isclose then UIManager:Get():ClosePopup() end
    SuitSubsystem:Get():SendMsg_GetDetail(data:GetIdx())
end

---@param data SuitData
function SuitDataManager:OpenTrasformView(data)
    --UIManager:Get():OpenView("TransformView",CanvasType.MainCanvas,"TransformView")
    --local param = TransformViewParam()
    --param.Type = TransformUIFlag.Suit
    --param.SuitIdx = data:GetIdx()
    --param.CarData = data:GetCarData()
    --UINotify:Get():SendNotification(UINotifyEvent.TransformView_SetData, param)
    --CommonHelper:PlayScreenEffectUIMask(1.5)
end