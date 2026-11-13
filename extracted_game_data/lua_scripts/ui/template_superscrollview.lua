---@class Template_SuperScrollView : ViewBase
Template_SuperScrollView = class("Template_SuperScrollView", ViewBase)

-- View必加
function Template_SuperScrollView:initialize()
    ViewBase.initialize(self)
end

function Template_SuperScrollView:Awake()
    print("start")

    self.data = self:CreateData()

    self.superListView = self:GetChildWight("SuperList", typeof(LoopListView2))

    CommonHelper:HButtonSetCallback("BtnClose", self.gameObject, function(hbtn)
        UIManager:Get():CloseView()
    end)

end

function Template_SuperScrollView:OnOpen()

    ---前两个值刷新title数据，会用到，后两个如果title不用点击则用不到
    ---@param treeItemData TreeItemData
    local OnRefreshTitleFunc = function(parent, treeItemData, dataIdx, treeItemCountMgr)

        CommonHelper:SetText("Text", parent, treeItemData.titleData)

        ---如果title不需要有折叠功能,就不用执行这一步
        CommonHelper:HButtonSetCallback("titleBtn", parent, function()
            print("-------->ToggleItemExpand")
            CommonHelper:OnTitleBtnClick(self.superListView, dataIdx, treeItemCountMgr)
        end)
    end

    ---@param itemData @childData 自己定义的
    local OnRefreshChildFunc = function(parent, itemData)
        CommonHelper:SetText("Text", parent, itemData)

        CommonHelper:HButtonSetCallback("childBtn", parent, function()
            print("-------->OnChildBtnClick")

        end)
    end

    CommonHelper:InitTreeItemList(self.superListView, self.data, OnRefreshTitleFunc, OnRefreshChildFunc,1)
end

---@return table<number,TreeItemData>
function Template_SuperScrollView:CreateData()
    local data = {}

    local titleCount, childCount = 10, 5

    for i = 1, titleCount do
        local treeItemData = TreeItemData()

        local titleData = "titleData" .. i
        local childData = {}
        for j = 1, childCount do
            table.insert(childData, "childData" .. j)
        end
        treeItemData:SetData(titleData, childData)

        table.insert(data, treeItemData)
    end
    return data
end
