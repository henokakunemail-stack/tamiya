---@class PageGarageMotorAdjust
PageGarageMotorAdjust = class("PageGarageMotorAdjust")

function PageGarageMotorAdjust:initialize()

end

---@param data ArticleCell
function PageGarageMotorAdjust:SetData(root, data, funback,funcsure)
    CommonHelper:HButtonSetCallback("BtnBack",root,function (hbtn)
        if funback then funback() end
    end)
    CommonHelper:HButtonSetCallback("BtnSure",root,function (hbtn)
        if funcsure then funcsure() end
    end)
    self.PartData=data
    self.PartCfg=self.PartData:GetPartConfig()
    self.Root=root
    local partobj = UIUtil.GetChild("ItemPartGarage", root)
    if self.PartData then
        local param = Param_ItemPartParam()
        param.quality = self.PartData:GetPartQuality()
        param.star = self.PartData:GetStar()
        param.lv = self.PartData:GetPartLV()
        param.using = self.PartData:GetCarId()
        param.lock = self.PartData:GetPartLock()
        param.awaken=self.PartData:GetAwaken()
        param.generation=self.PartData:GetGeneration()
        param.downType=self.PartData:GetPartDownType()
        param.source = self.PartData:GetPartSource()
        param.expireTime = self.PartData:GetPartExpTime()
        CommonHelper:SetItemPartGroup(partobj, UIModuleID.Garage, self.PartCfg.C_ID, ItemPartUIType.Normal, param)
    end
end