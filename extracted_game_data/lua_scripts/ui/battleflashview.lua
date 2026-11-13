---@class BattleFlashView : ViewBase
BattleFlashView = class("BattleFlashView", ViewBase)

function BattleFlashView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "BattleFlashViewAction")
end

function BattleFlashView:Awake()
    self. battleSkillFlash=self:GetChild("Bottom/BattleSkillFlash")
end



function BattleFlashView:SetSkillUI(carId,skillId)
        skillId=103100104
        local holderId=CommonHelper:GetTableDataByID(ConfigNames.car_config,carId).holder
        local heroData=CommonHelper:GetTableDataByID(ConfigNames.hero_config,holderId)
        local carHolderNameId=heroData.name
        local carHolderName=ClientDataManager:Get():GetTemplateString(carHolderNameId)
        local carHolderPicName=car.picture
        local carHolderImage=self:GetChildWightByParent("Bg/CarHolderImageMask/CarHolderRawImage",self. battleSkillFlash,typeof(RawImage))
        CommonHelper:SetUITexture(carHolderImage,carHolderPicName.."png",UIModuleID.Battle)
        CommonHelper:SetText("Bg/CarHolderRawImage/CarHolderNameText",self. battleSkillFlash,carHolderName)
end


function BattleFlashView:OnOpen()
    --CommonHelper:HButtonSetCallback("BgBtn",self.gameObject,function()
    --    UIManager:Get():CloseView()
    --end)
end

function BattleFlashView:OnDisable()
    --AssetsManager:Unload(self.asset)
end
function BattleFlashView:OnClose()
   CommonHelper:ReleasePool(UIModuleID.BattleFlash)
end
