

--车库右侧，涂装入口

---@class PageGarageGrid
PageGarageGrid = class("PageGarageGrid")

function PageGarageGrid:initialize()
    self.SelectIdx = -1
    ---@type CarData
    self.CarData = nil
end

---@param cardata CarData
function PageGarageGrid:SetData(root,cardata, funback, funcsure)
    self.SelectIdx = -1
    self.CarData = cardata

    CommonHelper:HButtonSetCallback("BtnBack",root,function (hbtn)
        if funback then funback() end
    end)

    CommonHelper:HButtonSetCallback("BtnSure",root,function (hbtn)
        if self.SelectIdx > -1 then
            local state = self.CarData:GetLightweight(true)[self.SelectIdx]
            if not state then
                if funcsure then funcsure(self.SelectIdx) end
            else
                CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.GarageNotGrid))
            end
        else
            CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.GarageNotSelectHole))
        end
    end)


    ---@type table<number,number>
    local HoleCfg = cardata:GetShellPartCfg().NewShellHole
    self.ScrollView = UIUtil.GetTypeChildWightByParent("MoreRowScrollView_V", root, typeof(MoreRowScrollView))
    CommonHelper:InitMoreRowScrollView(self.ScrollView, #HoleCfg, 1,function(dataIndex, itemObj, scroll)
        local data = HoleCfg[dataIndex + 1]
        if data == nil then return end

        local gridlist = cardata:GetShellGridList(true)
        local gridid = gridlist[dataIndex + 1]

        local state = cardata:GetLightweight(true)[dataIndex+1]
        CommonHelper:SetGameObjectActive("state1", itemObj, state)
        CommonHelper:SetGameObjectActive("state2", itemObj, not state and gridid ==2)
        CommonHelper:SetGameObjectActive("state3", itemObj, not state and gridid~=2 )
        CommonHelper:SetText("###name", itemObj, CommonHelper:GetTempStr_Default(TemplateStringID.PartHoldNameFormat, dataIndex + 1))

        CommonHelper:SetGameObjectActive("select", itemObj, self.SelectIdx == dataIndex)

        CommonHelper:HButtonSetCallback("BtnItem",itemObj,function (hbtn)
            self.SelectIdx = dataIndex
            --CommonHelper:MoreRowView_RefreshCurList(self.ScrollView, false)


            local state = self.CarData:GetLightweight(true)[self.SelectIdx+1]
            if not state then
                if funcsure then funcsure(self.SelectIdx) end
            else
                CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.GarageNotGrid))
            end


        end)
    end)
end