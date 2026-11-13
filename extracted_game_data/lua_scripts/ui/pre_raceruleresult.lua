


---@class Pre_RaceRuleResult
Pre_RaceRuleResult = class("Pre_RaceRuleResult")
function Pre_RaceRuleResult:initialize()

end

function Pre_RaceRuleResult:ClearData()

end

---@param winer RaceDataPlayer
function Pre_RaceRuleResult:SetData(root, identity, scoretips, winer)
    local temp = (identity == RaceRulePlayerIdentity.Joiner)
    local joinerobj = CommonHelper:SetGameObjectActive("JoinerGroup", root,temp )
    local otherobj = CommonHelper:SetGameObjectActive("OtherGroup", root, not temp)

    CommonHelper:SetText("scorevalue", joinerobj, scoretips)
    local iswin = false
    if winer and winer:GetPlayerID() == PlayerDataManager:Get():GetPlayerRID() then iswin = true end
    CommonHelper:SetGameObjectActive("succeedflag", joinerobj, iswin)
    CommonHelper:SetGameObjectActive("faildflag", joinerobj, not iswin)

    if winer then
        CommonHelper:SetText("winername", otherobj, winer:GetName())
        CommonHelper:SetText("scorevalue", otherobj, tostring(winer:GetTimeValue()))
    end
end