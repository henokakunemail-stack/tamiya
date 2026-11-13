

--车库右侧，车架子

---@class PageGuideGaragePartmap
PageGuideGaragePartmap = class("PageGuideGaragePartmap")

function PageGuideGaragePartmap:initialize()
    self.CarData = nil
    self.Func = nil
end

---@param cardata CarReviewData
function PageGuideGaragePartmap:SetData(root, cardata,isresetPos, func)
    self.CarData = cardata
    self.Func = func

    self.ObjMap = UIUtil.GetChild("Pre_GarageAssembleMap", root)
    self.AssembleMap = PreGarageAssembleMap()
    self.AssembleMap:SetDataByCarReview(UIModuleID.GuideGarage, self.ObjMap, cardata, function(grooveid)
        self:OnClickPartItem(grooveid)
    end,nil,isresetPos)

end

function PageGuideGaragePartmap:OnClickPartItem(grooveid)
    local node = self.CarData.assembleMgr:GetNodeByGrooveID(grooveid)
    if node:GetGrooveState()~=GrooveState.Lock then
        if self.Func then
            self.Func(grooveid)
        end
    else
        CommonTipsHelper:Get():ShowCenterTips(ClientDataManager:Get():GetTemplateString(TemplateStringID.AssembleGrooveEnable))
    end
end

function PageGuideGaragePartmap:UpdateMsg()

end