

--车库右侧，车架子

---@class PageGaragePartmap
PageGaragePartmap = class("PageGaragePartmap")

function PageGaragePartmap:initialize()
    self.CarData = nil
    self.Func = nil
end

---@param cardata CarData
function PageGaragePartmap:SetData(root, cardata,isresetPos, func)
    self.CarData = cardata
    self.Func = func

    self.ObjMap = UIUtil.GetChild("Pre_GarageAssembleMap", root)
    self.AssembleMap = PreGarageAssembleMap()
    self.AssembleMap:SetDataByCarData(UIModuleID.Garage, self.ObjMap, cardata, nil,isresetPos, function(grooveid)
        self:OnClickPartItem(grooveid)
    end,KnapsackDataManager:Get().PartKnapsack)

end

function PageGaragePartmap:OnClickPartItem(grooveid)
    local node = self.CarData.assembleMgr:GetNodeByGrooveID(grooveid)
    if node:GetGrooveState()~=GrooveState.Lock then
        if self.Func then
            self.Func(grooveid)
        end
    else
        ---@type grooveid_config_cell
        local cfg=CommonHelper:GetTableDataByID(ConfigNames.grooveid_config,grooveid)
        CommonTipsHelper:Get():ShowCenterTips(ClientDataManager:Get():GetTemplateString(cfg.notice))
    end
end

function PageGaragePartmap:UpdateMsg()

end