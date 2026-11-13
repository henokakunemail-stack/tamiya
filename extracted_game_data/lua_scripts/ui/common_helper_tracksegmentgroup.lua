


---------------------------------------------------填充部件item
---@class Param_TrackSegmentGroup
Param_TrackSegmentGroup = class("Param_TrackSegmentGroup")
function Param_TrackSegmentGroup:initialize()
    self.moduleId = nil
    self.trackSegmentId = nil
    self.count = ""

    self.showname = true
    self.showcount = true

    self.icon = nil
    self.quality = 1
    self.isdirection = false
end

---@param param Param_TrackSegmentGroup
function CommonHelper:SetTrackSegmentGroup(gameObject, param)
    if param == nil then return end

    if param.moduleId == nil then param.moduleId = UIModuleID.None end


        ---@type tracksegement_config_cell
        local tracksegement_config = CommonHelper:GetTableDataByID(ConfigNames.tracksegement_config, param.trackSegmentId)
        if tracksegement_config == nil then return end

    --param.name = ClientDataManager:Get():GetTemplateString(tracksegement_config.name)
    param.name = CommonHelper:GetTempStr_Default(tracksegement_config.name)
    local direction = UIUtil.GetChild("direction",gameObject)
    if direction then
        direction:SetActive(param.isdirection)
    end
    param.icon=tracksegement_config.icon
    if param.icon~=nil then
        CommonHelper:GetComponentSetUITexture("icon", gameObject, param.icon, param.moduleId)
    end

    CommonHelper:SetGameObjectActive("left",gameObject,tracksegement_config.direction==1)
    CommonHelper:SetGameObjectActive("right",gameObject,tracksegement_config.direction==2)
    CommonHelper:SetGameObjectActive("countbg",gameObject,param.showcount)
    if param.showcount and param.count then
        CommonHelper:SetText("###count",gameObject,tostring(param.count))
    else
        CommonHelper:SetText("###count",gameObject,"")
    end


    if param.showname then
        CommonHelper:SetText("###name",gameObject,param.name)
    else
        CommonHelper:SetText("###name",gameObject,"")
    end
end
---------------------------------------------------