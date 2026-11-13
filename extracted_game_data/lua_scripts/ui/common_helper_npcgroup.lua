


---------------------------------------------------填充部件item
---@class Param_NPCGroup
Param_NPCGroup = class("Param_NPCGroup")
function Param_NPCGroup:initialize()
    self.moduleId = nil
    self.npcId = nil
    self.showname = true
    self.showBtn = true
end

---@param param Param_NPCGroup
function CommonHelper:SetNpcGroup(gameObject, param)
    if param == nil then return end
    ---@type npc_config_cell
    local npcCfg=CommonHelper:GetTableDataByID(ConfigNames.npc_config,param.npcId)
    if npcCfg==nil then
        return
    end

    if npcCfg then
        local hero_config= CommonHelper:GetTableDataByID(ConfigNames.hero_config,npcCfg.hero)
        CommonHelper:GetComponentSetUITexture("icon",gameObject,hero_config.icon..".png",param.moduleId)
    end
    CommonHelper:SetGameObjectActive("namebg",gameObject,param.showname)
    if param.showname then
        local carData=CommonHelper:GetTableDataByID(ConfigNames.car_config,npcCfg.suits)
        CommonHelper:SetText("###name",gameObject,CommonHelper:GetTempStr_Default(carData.name))
    end

    --{{{
    --self.moduleId = nil
    --self.carId=nil
    --self.npcId = nil
    --self.Num = 1
    --self.showname = true
    --self.showBtn = true
    --self.lock=false
    --self.add=false
    --self.npcIcon = nil
    --self.carIcon = nil
    --self.name = ""
    --self.use=false
    --self.quality = 1
    --self.BtnName = nil
    --if param.moduleId == nil then param.moduleId = UIModuleID.None end
    --
    --local  image=CommonHelper:GetSelfChallengeNpcIcon(param.quality)
    --CommonHelper:GetComponentSetImage("quality",gameObject,image,param.moduleId)
    --
    --local gray=UIUtil.GetChild("gray",gameObject)
    --local lock=UIUtil.GetChild("lock",gameObject)
    --local BtnAdd=UIUtil.GetChild("BtnAdd",gameObject)
    --if  param.add then
    --    gray:SetActive(true)
    --    lock:SetActive(false)
    --    BtnAdd:SetActive(true)
    --elseif param.lock then
    --    gray:SetActive(true)
    --    lock:SetActive(true)
    --    BtnAdd:SetActive(false)
    --else
    --    gray:SetActive(false)
    --    lock:SetActive(false)
    --    BtnAdd:SetActive(false)
    --    if param.npcIcon~=nil then
    --    CommonHelper:GetComponentSetUITexture("icon",gameObject,param.npcIcon,param.moduleId)
    --    end
    --    if param.carIcon~=nil then
    --    CommonHelper:GetComponentSetUITexture("caricon",gameObject,param.carIcon,param.moduleId)
    --    end
    --    if param.Num~=nil then
    --    CommonHelper:SetText("carNum",gameObject,param.Num)
    --    end
    --    if param.name~=nil then
    --    CommonHelper:SetText("name",gameObject,param.name)
    --    end
    --end
    --
    --local BtnItem=UIUtil.GetChild("NpcBtnItem",gameObject)
    --BtnItem:SetActive(param.showBtn)
    --
    --if param.BtnName~=nil then
    --    CommonHelper:SetText("text",BtnItem,param.BtnName)
    --end
    --
    --local use=UIUtil.GetChild("use",gameObject)
    --use:SetActive(param.use)
    --}}}
end
---------------------------------------------------