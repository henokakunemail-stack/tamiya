


---@class AssembleClientData
AssembleClientData = class("AssembleClientData")


function AssembleClientData:initialize(tab)
    ---@type PartGrooveID
    self.GrooveID = tab[1]
    ---@type AssembleNode
    self.Node = tab[2]



    ---@type AssembleSiftData
    self.FitterData = nil

    ---@type table<number, AssembleNode>
    self.OpenList = {} --支持端口开启的配件


end

function AssembleClientData:SetFitterData()
    local bagid = self.Node:GetBagId()
    local article = KnapsackDataManager:Get():GetArticleByID(bagid)
    local hublimit = AssembleHelper:PartCalculate_HubLimit(self.Node)
    self.FitterData = AssembleHelper:Fitter(self.Node, article, hublimit)

    self:CalibrateServerData_Port()
end

function AssembleClientData:ClearOpenList()
    self.OpenList = {}
end

---@param node AssembleNode
function AssembleClientData:AddOpenPart(node)
    table.insert(self.OpenList, node)
end

--{{{校验服务器数据正确性_配件与槽位端口是否匹配
function AssembleClientData:CalibrateServerData_Port()
    if self.FitterData and self.FitterData:IsFail() then
        logError("---   error:组装异常，前后端数据不一致，配件与槽位不匹配   grooveid = ",self.Node:GetGrooveId())
    end

end
--}}}

--{{{校验服务器数据正确性_槽位是否开启
function AssembleClientData:CalibrateServerData_Enable()
    local server = self.Node:GetGrooveState()
    local client = AssembleHelper:Check_StaticNode(self.Node:GetGrooveId()) or (#self.OpenList > 0)
    if server ~= client then
        logError("---   error:组装异常，前后端数据不一致，槽位开启状态不匹配   grooveid = ",self.Node:GetGrooveId(), server, client)
    end
end
--}}}
