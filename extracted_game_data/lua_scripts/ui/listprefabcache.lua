

---@class  ListPrefabCache
ListPrefabCache = class("ListPrefabCache")

function ListPrefabCache:initialize()
    self.__CacheList = {}
end

--------------------------------------------------两个方法配对使用
function ListPrefabCache:RecycleToCache(item)
    if item == nil then return end

    local isContain = false
    for i = 1, #self.__CacheList do
        if self.__CacheList[i]:GetInstanceID() == item:GetInstanceID()  then
            isContain = true
        end
    end

    if isContain ~= true then
        table.insert(self.__CacheList, item)
        UIUtil.SetParentGameObject(monoUIManager:GetCanvasNameByType(CanvasType.CacheCanvas), item)
    end
end

function ListPrefabCache:GetFromCacheWithoutIndex(template, parent, isLastSibling)
    local item
    if #self.__CacheList > 0 then
        item = self.__CacheList[1]
        table.remove(self.__CacheList, 1)
    else
        item = UIUtil.InstantiateGameObject(template)
        item:SetActive(true)
    end

    if parent ~= nil then
        UIUtil.SetParentGameObject(parent, item)
    end

    if isLastSibling == true then
        item.transform:SetAsLastSibling()
    end

    return item
end
--------------------------------------------------




--------------------------------------------------
function ListPrefabCache:GetFromCache(index, template, parent,immediateShow, isLastSibling)
    local item
    if #self.__CacheList >= index then
        item = self.__CacheList[index]
    else
        item = UIUtil.InstantiateGameObject(template)
        table.insert(self.__CacheList, item)
    end

    if immediateShow or true then
        if item.activeSelf ~= true then
            item:SetActive(true)
        end
    end

    if parent ~= nil then
        UIUtil.SetParentGameObject(parent, item)
    end

    if isLastSibling then
        item.transform:SetAsLastSibling()
    end

    return item
end

function ListPrefabCache:ClearCacheGO(count)
    for i = count, #self.__CacheList do
        self.__CacheList[i]:SetActive(false)
    end
end
--------------------------------------------------