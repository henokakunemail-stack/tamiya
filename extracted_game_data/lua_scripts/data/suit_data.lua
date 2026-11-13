


---@class SuitData
SuitData = class("SuitData")
function SuitData:initialize()
    self.Idx = -1
    self.IsLock = false
    self.Name = ""
    ---@type table<number, number>
    self.Parts = {} --物品的唯一ID
    ---@type CarData
    self.CarData = nil
end

---@param msg SC_CarPlanInfo
function SuitData:SetBaseData(msg)
    self.Idx = msg.idx
    self.IsLock = false
    self.Name = msg.name
    self.Parts = msg.parts

    self:SetDefaultName()
end

---@param msg SC_GetCarPlanDetailRes
function SuitData:SetDetailData(msg)
    self.Parts = msg.parts
    self.CarData = CarData()
    self.CarData:InitSuitData(msg)
end

function SuitData:CheckGrooveBlank(grooveid)
    local node = self.CarData.assembleMgr:GetNodeByGrooveID(grooveid)
    return node:GetBagId() == -1
end

function SuitData:SetName(name)
    self.Name = name
    self:SetDefaultName()
end

function SuitData:GetIdx()
    return self.Idx
end

function SuitData:GetName()
    return self.Name
end

function SuitData:GetLock()
    return self.IsLock
end

function SuitData:GetParts()
    return self.Parts
end

---@return CarData
function SuitData:GetCarData()
    return self.CarData
end

function SuitData:IsBlank()
    local result = true
    for i = 1, #self.Parts do
        if self.Parts[i] > 0 then
            result = false
            break
        end
    end
    return result
end


function SuitData:SetDefaultName()
    if self.Name == "" then self.Name = "第"..(self.Idx + 1).."号方案" end
end

---@param msg table<number,SC_Tuple2_64>
function SuitData:UpdateParts(msg)
    for i = 1, #msg do
        local grooveId = msg[i].num1
        local bagid = msg[i].num2
        local idx = AssembleHelper:GrooveIDToMsgIdx(grooveId)
        self.Parts[idx] = bagid
    end
end