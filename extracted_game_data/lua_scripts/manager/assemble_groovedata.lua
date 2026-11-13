


---@class AssembleGrooveData
AssembleGrooveData = class("AssembleGrooveData")

---@param tab table<1:PartGrooveID,2:AssembleNode>
function AssembleGrooveData:initialize(tab)
    ---@type PartGrooveID
    self.GrooveID = tab[1]

    ---@type AssembleNode
    self.Node = tab[2]

    self.Enable = false
end


function AssembleGrooveData:SetGrooveState(enable)
    self.Enable = enable
end
