

--车库右侧，车架子

---@class PageRaceAssembleGaragePartmap
PageRaceAssembleGaragePartmap = class("PageRaceAssembleGaragePartmap")

function PageRaceAssembleGaragePartmap:initialize()
    self.CarData = nil
    self.Func = nil
end

---@param cardata CarReviewData
---@param KnapsackData KnapsackData
function PageRaceAssembleGaragePartmap:SetData(root, cardata,isresetPos, func,KnapsackData)
    self.CarData = cardata
    self.Func = func

    self.ObjMap = UIUtil.GetChild("Pre_GarageAssembleMap", root)
    self.AssembleMap = PreGarageAssembleMap()
    self.AssembleMap:SetDataByCarData(UIModuleID.AssembleGarage, self.ObjMap, cardata, nil,isresetPos, function(grooveid)
        self:OnClickPartItem(grooveid)
    end,KnapsackData)

end

function PageRaceAssembleGaragePartmap:OnClickPartItem(grooveid)
    local node = self.CarData.assembleMgr:GetNodeByGrooveID(grooveid)
    if node:GetGrooveState()~=GrooveState.Lock then
        if self.Func then
            self.Func(grooveid)
        end
    else
        CommonTipsHelper:Get():ShowCenterTips(ClientDataManager:Get():GetTemplateString(TemplateStringID.AssembleGrooveEnable))
    end
end

function PageRaceAssembleGaragePartmap:UpdateMsg()

end