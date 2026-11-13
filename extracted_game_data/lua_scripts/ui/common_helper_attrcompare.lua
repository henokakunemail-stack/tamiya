


---@class PartAttrCompareData
PartAttrCompareData = class("PartAttrCompareData")
function PartAttrCompareData:initialize()
    self.Type = -1
    self.AttrValueA = 0
    self.AttrValueB = 0
    self.ShowValueA = ""
    self.ShowValueB = ""
    self.ShowValueC = ""
end


function CommonHelper:PartAttrShowValueEqualZero(value)--true:==0   false:!=0
    return math.abs(value) < 0.001
end

--
-----@param articleA ArticleCell
-----@param articleB ArticleCell
-----@return table<number, PartAttrCompareData>
--function CommonHelper:PartAttrCompare_Article(articleA, articleB)
--    ---@type table<number, PartAttrCompareData>
--    local templist = {}
--
--    if articleA then
--        local list = articleA:GetPartAttrList()
--        for i = 1, #list do
--            local attr = list[i]
--            local key = attr.type
--            if templist[key] == nil then templist[key] = PartAttrCompareData() end
--            templist[key].Type = attr.type
--            templist[key].AttrValueA = attr.value
--            templist[key].ShowValueA = CommonHelper:GetShowArrtValue(attr.type, attr.value, 3)
--        end
--    end
--
--    if articleB then
--        local list = articleB:GetPartAttrList()
--        for i = 1, #list do
--            local attr = list[i]
--            local key = attr.type
--            if templist[key] == nil then templist[key] = PartAttrCompareData() end
--            templist[key].Type = attr.type
--            templist[key].AttrValueB = attr.value
--            templist[key].ShowValueB = CommonHelper:GetShowArrtValue(attr.type, attr.value, 3)
--
--            local delta = attr.value - templist[key].AttrValueA
--            local temp = CommonHelper:GetShowArrtValue(attr.type, delta, 3)
--            if delta >= 0 then
--                templist[key].ShowValueC = CommonHelper:GetTempStr_Default(TemplateStringID.PartReformSucceedAddFormat, temp)
--            else
--                templist[key].ShowValueC = CommonHelper:GetTempStr_Default(TemplateStringID.PartReformSucceedSubtractFormat, temp)
--            end
--        end
--    end
--
--    local result = {}
--    for k,v in pairs(templist) do
--        if CommonHelper:PartAttrShowValueEqualZero(v.AttrValueA) and v.ShowValueB == "" then
--
--        elseif CommonHelper:PartAttrShowValueEqualZero(v.AttrValueA) and CommonHelper:PartAttrShowValueEqualZero(v.AttrValueB) then
--
--        else
--            table.insert(result, v)
--        end
--    end
--
--    return result
--end