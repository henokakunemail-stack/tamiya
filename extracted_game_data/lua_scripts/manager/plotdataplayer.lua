


---@class PlotDataPlayer
PlotDataPlayer = class("PlotDataPlayer")

function PlotDataPlayer:initialize()
    self.ID = -1
    ---@type plotplayer_config_cell
    self.Cfg = nil
    self.Name = ""
    ---@type hero_config_cell
    self.HeroCfg = nil
end

function PlotDataPlayer:SetData(id)
    self.ID = id

    ---@type plotplayer_config_cell
    local cfg = CommonHelper:GetTableDataByID(ConfigNames.plotplayer_config, id)
    if cfg == nil then return end

    self.Cfg = cfg
    if cfg.type == 3 then
        self.Name = PlayerDataManager:Get():GetPlayerName()
        self.Icon=CommonHelper:GetPlayerIconById(PlayerDataManager:Get():GetPlayerIcon())
    else
        self.Name = CommonHelper:GetTempStr_Default(cfg.name)
        self.Icon=cfg.icon
    end

    if cfg.type == 4 then
        self.HeroCfg = CommonHelper:GetTableDataByID(ConfigNames.hero_config, cfg.heroid)
    end
end

function PlotDataPlayer:GetName() if self.Cfg.type==3 then return PlayerDataManager:Get():GetPlayerName() end return self.Name end
function PlotDataPlayer:GetID() return self.ID end

---@return rawimagesize_config_cell
function PlotDataPlayer:GetHalfPic(idx)
    --if self.HeroCfg then
        --local id = -1
        --if idx == 1 then id = self.HeroCfg.normalpicture end
        --if idx == 2 then id = self.HeroCfg.smallpicture end
        --if idx == 3 then id = self.HeroCfg.confusepicture end
        --if idx == 4 then id = self.HeroCfg.angrypicture end
        --if idx == 5 then id = self.HeroCfg.shockpicture end

        return CommonHelper:GetTableDataByID(ConfigNames.rawimagesize_config, idx)
   -- end
   -- return nil
end

function PlotDataPlayer:GetMiniIcon()
    if CommonHelper:IsNullOrEmpty(self.Icon) then
        return ""
    end
    if self.Cfg.type==3 then return CommonHelper:GetPlayerIconById(PlayerDataManager:Get():GetPlayerIcon()) end
    return self.Icon
end