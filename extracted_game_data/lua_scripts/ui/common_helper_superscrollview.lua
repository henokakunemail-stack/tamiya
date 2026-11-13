function CommonHelper:InitSuperScrollListView(superListView, itemTotalCount, onGetItemByIndex)
    if superListView == nil then
        return
    end
    superListView:InitListView(itemTotalCount, onGetItemByIndex)

    LuaRelevance:Get():AddSuperScrollView(superListView)
end

function CommonHelper:IsInitSuperScroll(superListView)
    if superListView == nil then
        return
    end
    return superListView.ListViewInited
end

function CommonHelper:RefreshItemByItemIndex(superListView, index)
    if superListView == nil then
        return
    end
    superListView:RefreshItemByItemIndex(index)
end

function CommonHelper:RefreshAllShownItem(superListView)
    if superListView == nil then
        return
    end
    superListView:RefreshAllShownItem()
end

function CommonHelper:MovePanelToItemIndex(superListView, scrollView, index, isBottom)
    if superListView == nil then
        return
    end
    superListView:MovePanelToItemIndex(index, 0)

    isBottom = isBottom or true

    if isBottom then
        scrollView.verticalNormalizedPosition = 0
    end
end

function CommonHelper:SetListItemCount(superListView, itemCount)
    if superListView == nil then
        return
    end
    superListView:SetListItemCount(itemCount, false)
end

function CommonHelper:GetShownItemByIndex(superListView, index)
    if superListView == nil then
        return
    end
    return superListView:GetShownItemByIndex(index)
end

function CommonHelper:GetShownItemByItemIndex(superListView, index)
    if superListView == nil then
        return
    end
    return superListView:GetShownItemByItemIndex(index)
end

function CommonHelper:InitScrollEvent(scrollView, func)
    scrollView.onValueChanged:AddListener(func);
end


----------------childList---------------------

---@class TreeItemData
TreeItemData = class("TreeItemData")

function TreeItemData:initialize()
    self.titleData = -1
    self.childData = {}
end

function TreeItemData:SetData(titleData, childData)
    self.titleData = titleData
    self.childData = childData
end
function TreeItemData:GetChildDataByIdx(idx)
    return self.childData[idx]
end

---@param data table<number,TreeItemData>
---@param expandIdx number @是否展开第一项,默认为true
---@param isExpandAll boolean @是否展开所有，默认为false
function CommonHelper:InitTreeItemList(superListView, data, TitleRefreshFunc, ChildRefreshFunc, expandIdx, isExpandAll)

    local mTreeItemCountMgr, totalCount = self:AddTreeItem(data, expandIdx, isExpandAll)

    local funcUpdate = function(loopListView2, index)
        if index < 0 then
            return
        end

        local countData = mTreeItemCountMgr:QueryTreeItemByTotalIndex(index)
        if countData == nil then
            return
        end

        local treeItemIndex = countData.mTreeItemIndex
        local treeViewItemData = data[treeItemIndex + 1]

        local LoopListViewItem2 = nil
        if countData:IsChild(index) == false then

            LoopListViewItem2 = loopListView2:NewListViewItem("title")

            if TitleRefreshFunc ~= nil then
                TitleRefreshFunc(LoopListViewItem2.gameObject, treeViewItemData, index, mTreeItemCountMgr)
            end
        else
            local childIndex = countData:GetChildIndex(index)
            local itemData = treeViewItemData.childData[childIndex + 1]
            if itemData == nil then
                return
            end
            LoopListViewItem2 = loopListView2:NewListViewItem("child")

            if ChildRefreshFunc ~= nil then
                ChildRefreshFunc(LoopListViewItem2.gameObject, itemData)
            end
        end
        return LoopListViewItem2
    end
    self:InitSuperScrollListView(superListView, totalCount, funcUpdate)

    CommonHelper:RefreshAllShownItem(superListView)
end

function CommonHelper:OnTitleBtnClick(loopListView2, index, mTreeItemCountMgr)
    mTreeItemCountMgr:ToggleItemExpand(index)
    CommonHelper:SetListItemCount(loopListView2, mTreeItemCountMgr:GetTotalItemAndChildCount())
    CommonHelper:RefreshAllShownItem(loopListView2)
end

---@param data table<number,TreeItemData>
---@param expandIdx number @是否展开第一项,默认为true
---@param isExpandAll boolean @是否展开所有，默认为false
function CommonHelper:AddTreeItem(data, expandIdx, isExpandAll)
    isExpandAll = isExpandAll or false

    local mTreeItemCountMgr = TreeViewItemCountMgr()

    for i = 1, #data do
        if isExpandAll then
            mTreeItemCountMgr:AddTreeItem(#data[i].childData, false)
        else
            if expandIdx and i == expandIdx then
                mTreeItemCountMgr:AddTreeItem(#data[i].childData, true)
            else
                mTreeItemCountMgr:AddTreeItem(#data[i].childData, false)
            end
        end
    end

    local count = mTreeItemCountMgr:GetTotalItemAndChildCount()
    return mTreeItemCountMgr, count
end

