


---@class Pre_RaceRuleFightGroup
Pre_RaceRuleFightGroup = class("Pre_RaceRuleFightGroup")

function Pre_RaceRuleFightGroup:initialize()

end

function Pre_RaceRuleFightGroup:Clear()

end


function Pre_RaceRuleFightGroup:SetData(root, data, moduleid, showcup)
    local obj = UIUtil.GetChild("RaceMap", root)
    CommonHelper:SetRaceMapGroup(obj, data, showcup, moduleid)
end