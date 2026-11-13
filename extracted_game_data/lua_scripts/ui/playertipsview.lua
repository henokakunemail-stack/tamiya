---@class PlayerTipsViewParam
PlayerTipsViewParam = class("PlayerTipsViewParam")
function PlayerTipsViewParam:initialize()
    self.UIColor = UIColor.Blue
    self.Value =""
    self.TitleName =""
    self.PlayerId = 0
    self.Func = nil
    self.FuncClass = nil
    self.FuncParam = nil
end


---@class PlayerTipsView:ViewBase
PlayerTipsView = class("PlayerTipsView", ViewBase)

function PlayerTipsView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "PlayerTipsViewAction")
end

function PlayerTipsView:Awake()
    CommonHelper:HButtonSetCallback("BtnCloseMask1", self.gameObject, function()
      UIManager:Get():ClosePopup()
    end)
end
function PlayerTipsView:OnClose()

end
function PlayerTipsView:OnOpen()

end
---@param param PlayerTipsViewParam
function PlayerTipsView:SetData(param)
      CommonHelper:SetDoText("###tips",self.gameObject,param.Value,1.2)
      CommonHelper:SetText("###tittle",self.gameObject,param.TitleName)
      -----@type rawimagesize_config_cell
      --local cfg= CommonHelper:GetTableDataByID(ConfigNames.rawimagesize_config,param.PlayerId)
      --CommonHelper:GetComponentSetUITexture("playericon",self.gameObject,cfg.name)
end

