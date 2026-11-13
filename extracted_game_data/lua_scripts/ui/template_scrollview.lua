
local __demoData = {}


---@class Template_ScrollView : ViewBase
Template_ScrollView = class("Template_ScrollView", ViewBase)

-- View必加
function Template_ScrollView:initialize()
    ViewBase.initialize(self)
end

function Template_ScrollView:Awake()
    print("start")

    CommonHelper:HButtonSetCallback("BtnClose",self.gameObject, function (hbtn)
        UIManager:Get():CloseView()
    end)

    local input = self:GetChild("InputField")
    local inputNum = self:GetChildWightByParent("Text",input,typeof(Text))

    ----------------------------------------------------------------------单列纵向
    local Group1 = self:GetChild("Group1")
    local levelmap = UIUtil.GetTypeChildWightByParent("LevelMapScrollView", Group1, typeof(LevelMapScrollView))
    CommonHelper:HButtonSetCallback("BtnCreate",Group1, function (hbtn)
        local data = self:CreateTestLevelMapData()
        CommonHelper:LevelMapView_Init(levelmap, data, false,function(dataIndex, itemObj, scroll)
            --print("---      更新item :    dataIndex = " ,dataIndex,"   itemObj = ", itemObj)
            CommonHelper:SetText("Text",itemObj,"i_"..dataIndex)
        end)
    end)
    CommonHelper:HButtonSetCallback("BtnRefresh",Group1, function (hbtn)
        CommonHelper:LevelMapView_Refresh(levelmap)
    end)
    CommonHelper:HButtonSetCallback("BtnMove",Group1, function (hbtn)
        CommonHelper:LevelMapView_MoveToItem(levelmap, tonumber(inputNum.text))
    end)
    ----------------------------------------------------------------------
    ----------------------------------------------------------------------带标题和不带标题共存V
    local Group2 = self:GetChild("Group2")
    local MoreRowScrollViewTittle1 = UIUtil.GetTypeChildWightByParent("TitleScrollView", Group2, typeof(MoreRowScrollViewTittle))
    CommonHelper:HButtonSetCallback("BtnCreate",Group2, function (hbtn)
        local data=self:CreateTittleData()
        CommonHelper:MoreRowTitle_Init(MoreRowScrollViewTittle1, data, 4,function(tittle,tittleIdx,itemObj, type,index,scroll)
            if type==TittleItemType.Title then
                CommonHelper:SetText("Text",itemObj,tittle.."_"..tittleIdx)
            end
            if type==TittleItemType.Item then
                CommonHelper:SetText("Text",itemObj,"i_"..index)
            end
        end)
    end)
    CommonHelper:HButtonSetCallback("BtnRefresh",Group2, function (hbtn)
        CommonHelper:MoreRowTitle_Refresh(MoreRowScrollViewTittle1)
    end)
    CommonHelper:HButtonSetCallback("BtnMove",Group2, function (hbtn)
        CommonHelper:MoreRowTitle_MoveToItem(MoreRowScrollViewTittle1, tonumber(inputNum.text))
    end)
    ----------------------------------------------------------------------
    --{{{带标题和不带标题共存H
    local Group3 = self:GetChild("Group3")
    local MoreRowScrollViewTittle2 = UIUtil.GetTypeChildWightByParent("TitleScrollView", Group3, typeof(MoreRowScrollViewTittle))
    CommonHelper:HButtonSetCallback("BtnCreate",Group3, function (hbtn)
        local data=self:CreateTittleData()
        CommonHelper:MoreRowTitle_Init(MoreRowScrollViewTittle2, data, 4,function(tittle,tittleIdx,itemObj, type,index,scroll)
            --print("---      更新item :    dataIndex = " ,dataIndex,"   itemObj = ", itemObj)
            if type==TittleItemType.Title then
                CommonHelper:SetText("Text",itemObj,tittle.."_"..tittleIdx)
            end
            if type==TittleItemType.Item then
                CommonHelper:SetText("Text",itemObj,"i_"..index)
            end
        end)
    end)
    CommonHelper:HButtonSetCallback("BtnRefresh",Group3, function (hbtn)
        CommonHelper:MoreRowTitle_Refresh(MoreRowScrollViewTittle2)
    end)
    CommonHelper:HButtonSetCallback("BtnMove",Group3, function (hbtn)
        CommonHelper:MoreRowTitle_MoveToItem(MoreRowScrollViewTittle2, tonumber(inputNum.text))
    end)
    --}}}



end
function Template_ScrollView:OnOpen()

end

local  tile=150
function Template_ScrollView:CreateTestLevelMapData()
    local result = {}
    local d1 = LevelMapScrollViewNode()
    d1.id = 1
    d1.pos = Vector2(tile*0,tile*00)
    d1.linePoints = {}
    table.insert(result, d1)

    local d2 = LevelMapScrollViewNode()
    d2.id = 2
    d2.pos = Vector2(tile*2,tile*1)
    d2.linePoints = {{Vector2(tile*2,0)}}
    table.insert(result, d2)

    local d3 = LevelMapScrollViewNode()
    d3.id = 3
    d3.pos = Vector2(tile*2,tile*0)
    d3.linePoints = {{Vector2(tile*0,tile*0)}}
    table.insert(result, d3)

    local d4 = LevelMapScrollViewNode()
    d4.id = 4
    d4.pos = Vector2(tile*2,tile*-1)
    d4.linePoints = {{Vector2(tile*2,tile*0)}}
    table.insert(result, d4)

    local d5 = LevelMapScrollViewNode()
    d5.id = 5
    d5.pos = Vector2(tile*4,tile*-1)
    d5.linePoints = {{Vector2(tile*2,tile*-1)}}
    table.insert(result, d5)
    --
    local d6 = LevelMapScrollViewNode()
    d6.id = 6
    d6.pos = Vector2(tile*6,tile*0)
    d6.linePoints = {{Vector2(tile*4,tile*-1), Vector2(tile*4.5,tile*0)}, {Vector2(tile*2,tile*1), Vector2(tile*6.5,tile*1)}}
    table.insert(result, d6)

    local d7 = LevelMapScrollViewNode()
    d7.id = 7
    d7.pos = Vector2(tile*8,tile*0)
    d7.linePoints = {{Vector2(tile*6,tile*0)}}
    table.insert(result, d7)
    --
    local d8 = LevelMapScrollViewNode()
    d8.id = 8
    d8.pos = Vector2(tile*10,tile*1)
    d8.linePoints = {{Vector2(tile*8,tile*0), Vector2(tile*10.5,tile*0)}}
    table.insert(result, d8)

    local d9 = LevelMapScrollViewNode()
    d9.id = 9
    d9.pos = Vector2(tile*14,tile*-1)
    d9.linePoints = {{Vector2(tile*10,tile*1), Vector2(tile*12.5,tile*1), Vector2(tile*12.5,tile*-1)}}
    table.insert(result, d9)

    return result
end
--25+12
function Template_ScrollView:CreateTittleData()
    local result = {}
    for i = 1, 20 do
        local d1 = MoreRowScrollViewTittleGroup()
        d1.tittle = "TITTLE"..i
        d1.totle = math.random(4,20)
        d1.groupIndex=i
        table.insert(result, d1)
    end
    return result
end