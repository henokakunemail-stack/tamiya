




---@class PreGarageCarIdx
PreGarageCarIdx = class("PreGarageCarIdx")
function PreGarageCarIdx:initialize()

    self.Root = nil
    self.UIModuleID = UIModuleID.None
    self.IsSelectBlank = true--是否可以选择不完整车辆，true可以选
    self.IsUseKey = true--是否可以使用道具开启车位，true可以开启，false不可以开启
    self.FunClickPos = nil
    self.SelectIdx = -1

end

function PreGarageCarIdx:SetData(root, uimoduleid,autoselect, selectblank,isusekey, funclickpos,lockcaridx)
    if root == nil then return end
    if selectblank == nil then selectblank = true end
    if isusekey == nil then isusekey = false end
    if autoselect == nil then autoselect = 1 end
    if lockcaridx == nil then lockcaridx = {} end


    self.Root = root
    self.UIModuleID = uimoduleid
    self.IsSelectBlank = selectblank
    self.IsUseKey = isusekey
    self.FunClickPos = funclickpos
    self.LockCarIdx=lockcaridx

    self.Togs = {}

    for i = 1, 5 do
        local posobj = UIUtil.GetChild("Pos"..i, self.Root)

        CommonHelper:HButtonSetCallback("BtnAdd",posobj,function (hbtn)
            local boxFunc = function()
                local str = CommonHelper:GetTempStr_Default( TemplateStringID.CarIdxGroupOpenPos)
                local ret = MessageBoxHelp:Get():OpenBox_OKCancel(UIColor.Orange, str)
                if ret == MessageBoxHelp.BtnType.OK then
                    local data = CommonHelper:GetCarIdxArticleCfg()
                    if data and PlayerDataManager:Get():CheckCurrencyEnough(data.C_ID,1,false) then
                        AssembleSubsystem:Get():SendMsg_UseGarageKay(data.C_ID)
                    else
                        CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.CarKeyEnough))
                    end
                end
            end
            MessageBoxHelp.Get():StartCoroutineBox(boxFunc)
        end)

        CommonHelper:HButtonSetCallback("BtnLock",posobj,function (hbtn)
            CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.CarIdxGroupLock))
        end)

        local tog = CommonHelper:HButtonSetCallback("BtnPos",posobj,function (hbtn)
            self:OnClickTogPos(i, true, false)
        end)
        table.insert(self.Togs, tog)
    end

    self:SetBtnGroup()

    self:OnClickTogPos(autoselect, false, true)
end

function PreGarageCarIdx:SetBtnGroup()
    local temp = false
    for i = 1, 5 do
        local posobj = UIUtil.GetChild("Pos"..i, self.Root)
        local cardata = CarDataManager:Get():GetCarDataByIndex(i)

        local addstate = false
        if cardata.LockState==ParkingLotState.UnOpen and temp == false then
            temp = true
            addstate = true
        end

        local tempbool = addstate and self.IsUseKey
        CommonHelper:SetGameObjectActive("lock", posobj, (cardata.LockState~=ParkingLotState.Open  and (not tempbool)) or  self:IsLock(cardata:GetID()))
        CommonHelper:SetGameObjectActive("open", posobj, cardata .LockState==ParkingLotState.Open and not self:IsLock(cardata:GetID()))
        CommonHelper:SetGameObjectActive("add", posobj, tempbool)
    end

end
function PreGarageCarIdx:IsLock(idx)
    for k, v in pairs(self.LockCarIdx) do
        if idx==v then
            return true
        end
    end
    return false
end
function PreGarageCarIdx:OnClickTogPos(idx, ischeck, isautoselect)
    if self.IsSelectBlank == false then
        local cardata = CarDataManager:Get():GetCarDataByIndex(idx)
        if cardata.LockState ~=ParkingLotState.Open then
            log("---   error:PreGarageCarIdx()   cardata = nil,idx:",idx)
        else
            CarDataManager:Get():CheckCarCompleteness(cardata:GetID())
        end
        return
    end

    if ischeck and self.SelectIdx == idx then
        return
    end

    for i = 1, #self.Togs do
        CommonHelper:SetToggleState(self.Togs[i], i == idx)
    end
    self.SelectIdx = idx
    local cardata = CarDataManager:Get():GetCarDataByIndex(idx)
    if cardata:GetShellCfg() then
        CommonHelper:GetComponentSetUITexture("carname", self.Root, cardata:GetShellCfg().carNameIcon, self.UIModuleID)
    end

    CommonHelper:PlayCarBuildFinishRandom()
    if self.FunClickPos then self.FunClickPos(cardata, isautoselect) end
end

---@return CarData
function PreGarageCarIdx:GetCurCarData()
    local cardata = CarDataManager:Get():GetCarDataByIndex(self.SelectIdx)
    return cardata
end

function PreGarageCarIdx:UpdateMsg()
    self:SetBtnGroup()

    local cardata = CarDataManager:Get():GetCarDataByIndex(self.SelectIdx)

    if cardata:GetShellCfg() then
        CommonHelper:GetComponentSetUITexture("carname", self.Root, cardata:GetShellCfg().carNameIcon, self.UIModuleID)
    end

end