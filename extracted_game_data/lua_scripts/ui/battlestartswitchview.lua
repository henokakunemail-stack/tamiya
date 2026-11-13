---@class BattleStartSwitchView : ViewBase
BattleStartSwitchView = class("BattleStartSwitchView", ViewBase)

function BattleStartSwitchView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "BattleStartSwitchViewAction")
end

function BattleStartSwitchView:Awake()
    self. BtnSkip = CommonHelper:HButtonSetCallback("BtnSwitch", self.gameObject, function()
        CommonHelper:SetHButtonClick(self.BtnSkip,false,false)
        local selfCarBuilderId=BattleDyDataManager:Get():GetSelfCarData():GetCarBuildId()
        local carBuilder= CarBuilderManager:Get():GetCarBuilder(selfCarBuilderId)
        carBuilder:BuilderChassisSwitchFx()
        CS.LuaHelper.Get():SetNormalSpeed(0)
        cs_coroutine.start(function()
            coroutine.yield(CS.UnityEngine.WaitForSeconds(0.2))
            CommonHelper:Audio_PlayAudio("voice_1004.wav", AudioType.VOICE, false, 1, 0)
            --CS.Horizon.Game.ShowLayer.EntityManager:Get():Resume()

            CS.LuaHelper.Get():SetNormalSpeed(15)
            coroutine.yield(CS.UnityEngine.WaitForSeconds(2))
            self:ResetCarTrans()
            carBuilder:ReleaseChassisSwitchFx()
            carBuilder:ReleaseTips()
            monoRaceManager:ResumeSwitchOnStatus()
        end)

    end)
end

function BattleStartSwitchView:SetSwitchData(carTrans, anchorTrans)
    CommonHelper:SetHButtonClick(self.BtnSkip,true,false)
    self:SetCarSwitchTrans(carTrans, anchorTrans)
end

function BattleStartSwitchView:SetCarSwitchTrans(carTrans, anchorTrans)
    local selfCarBuilderId=BattleDyDataManager:Get():GetSelfCarData():GetCarBuildId()
    ---@type CarBuilder
    local carBuilder= CarBuilderManager:Get():GetCarBuilder(selfCarBuilderId)
    carBuilder:BuilderChassisSwitchTips()
    if carTrans ~= nil then
        self.carOldPosition = carTrans.localPosition
        self.carOldRotation = carTrans.localRotation
        self.carOldScale = carTrans.localScale
        self.carParent = carTrans.parent
        self.carTrans = carTrans
        self.anchorTrans = anchorTrans

        local newPos =carTrans.position + anchorTrans.forward * 2 + anchorTrans.up * 5

        carTrans.position = newPos
        carTrans.localRotation = anchorTrans.rotation * Quaternion.Euler(-90, 180, 0)

        CSCameraManager.Get().Fov =60
        CSCameraManager.Get():Reset()
        CSCameraManager.Get().transform.position =carTrans.position + anchorTrans.forward * -3 +Vector3(0,-0.3,0)
        CSCameraManager.Get().transform:LookAt(newPos)
    end
end

function BattleStartSwitchView:ResetCarTrans()
    if self.carTrans ~= nil then
        self.carTrans.parent = self.carParent
        self.carTrans.localPosition = self.carOldPosition
        self.carTrans.localRotation = self.carOldRotation
        self.carTrans.localScale = self.carOldScale
    end
end

function BattleStartSwitchView:OnOpen()

end
function BattleStartSwitchView:OnClose()

end
function BattleStartSwitchView:OnAutoClose()

end

function BattleStartSwitchView:OnBackKey()

end

