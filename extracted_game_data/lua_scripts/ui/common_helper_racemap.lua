



---@param param RaceDataFightGroup
function CommonHelper:SetRaceMapGroup(root, param, showcup, moduleid)
    for i = 1, 5 do CommonHelper:SetGameObjectActive("LeftLine"..i,root, false) end
    for i = 1, 5 do CommonHelper:SetGameObjectActive("LeftGroup"..i,root, false) end
    for i = 1, 3 do CommonHelper:SetGameObjectActive("RightLine"..i,root, false) end
    for i = 1, 3 do CommonHelper:SetGameObjectActive("RightGroup"..i,root, false) end
    CommonHelper:SetGameObjectActive("winercup", root, false)


    if root == nil or param == nil then return end

    local list = param:GetPlayerList()
    local leftcount = param:GetJoinCount()
    local leftobj = nil
    for i = 1, 5 do
        CommonHelper:SetGameObjectActive("LeftLine"..i,root, i == leftcount)
        local temp = CommonHelper:SetGameObjectActive("LeftGroup"..i,root, i == leftcount)
        if i == leftcount then
            leftobj = temp
        end
    end
    for i = 1, leftcount do
        local data = list[i]
        local obj = UIUtil.GetChild("player"..i, leftobj)
        if data then
            CommonHelper:SetText("playername", obj, data:GetName())
            CommonHelper:GetComponentSetUITexture("RawIcon",obj,CommonHelper:GetPlayerIconById(data:GetIcon()), moduleid)
        end
    end


    local winlist = param:GetWinerList()
    local rightcount = param:GetWinerCount()
    local rightobj = nil
    for i = 1, 3 do
        CommonHelper:SetGameObjectActive("RightLine"..i,root, i == rightcount)
        local temp = CommonHelper:SetGameObjectActive("RightGroup"..i,root, i == rightcount)
        if i == rightcount then
            rightobj = temp
        end
    end
    for i = 1, rightcount do
        local data = winlist[i]
        local obj = UIUtil.GetChild("player"..i, rightobj)

        local winname =  "未产生"
        local icon = "uitex_sucai_bg_unknow.png"
        if data then
            winname = data:GetName()
            icon = CommonHelper:GetPlayerIconById(data:GetIcon())
        end
        CommonHelper:SetText("playername", obj, winname)
        CommonHelper:GetComponentSetUITexture("RawIcon",obj,icon, moduleid)
    end

    CommonHelper:SetGameObjectActive("winercup", root, showcup)

end

