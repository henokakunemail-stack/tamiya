



function CommonHelper:SetSkillGroup(gameObject, skillid, moduleid)
    --print("---   000000 ", gameObject, skillid, moduleid)
    if gameObject == nil or skillid == nil then return end

    ---@type skill_config_cell
    local data =  CommonHelper:GetTableDataByID(ConfigNames.skill_config, skillid)
    if data == nil then return end

    moduleid = moduleid or UIModuleID.None

    local icon = UIUtil.GetTypeChildWightByParent("RawImage", gameObject, typeof(RawImage))
    CommonHelper:SetUITexture(icon, string.format("%s.png",data.icon), moduleid)

end