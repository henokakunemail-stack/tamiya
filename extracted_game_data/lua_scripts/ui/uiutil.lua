
---@class UIUtil
UIUtil = {}

function UIUtil.GetChilds(object)
    -- body
    return CS.UIUtil.GetChilds(object)
end

function UIUtil.GetGameobjectComponent(object, ctype)
    -- body
    if CommonHelper:GameObjectIsNull(object) then return end
    return CS.UIUtil.GetGameobjectComponent(object, ctype)
end
function UIUtil.GetGameobjectComponentsInChild(object, ctype)
    -- body
    if CommonHelper:GameObjectIsNull(object) then return end
    local result = {}
    UIUtil.CollectComponentsInChildren(object, ctype, result)
    return result
end

--- 递归收集子对象中的组件
function UIUtil.CollectComponentsInChildren(object, ctype, result)
    if CommonHelper:GameObjectIsNull(object) then return end
    local transform = object.transform
    local childCount = transform.childCount
    for i = 0, childCount - 1 do
        local child = transform:GetChild(i).gameObject
        local component = UIUtil.GetGameobjectComponent(child, ctype)
        if not CommonHelper:GameObjectIsNull(component) then
            table.insert(result, component)
        end
        -- 递归遍历子对象的子对象
        UIUtil.CollectComponentsInChildren(child, ctype, result)
    end
end

function UIUtil:AddGameobjectComponent(obj, type)
    return obj:AddComponent(type)
end

function UIUtil.GetChild(controlName, parent, isDirectChild )
    -- body
    if controlName == nil or parent == nil or parent==-1 then print("---   error:UIUtil.GetChild   controlName = ",controlName,"   parent = ",parent) return end
    return CS.UIUtil.GetChild(controlName, parent, isDirectChild or false)
end

function UIUtil.GetTypeChildWightByParent( controlName, parent, ctype, isDirectChild )
    -- body
    if CommonHelper:GameObjectIsNull(parent) then return nil end
    return CS.UIUtil.GetTypeChildWightByParent(controlName, parent, ctype, isDirectChild or false)
end

function UIUtil.SetLabel( parentObj, controlName, content, charLimit )
    -- body
    return CS.UIUtil.SetLabel(parentObj, controlName, content, charLimit)
end

function UIUtil.GetChildInputPath(path, parent, isDirectChild )
    local result = parent
    local points = stringSplit(path,'/')
    for i = 1, #points do
        result = UIUtil.GetChild(points[i], result, isDirectChild)
        if result == nil then
            break;
        end
    end
    return result;
end
function UIUtil.GetTypeChildWightInputPath(path, parent, ctype, isDirectChild )
    local result = UIUtil.GetChildInputPath(path, parent,isDirectChild)
    if result ~= nil then
        result = UIUtil.GetGameobjectComponent(result, ctype)
    end
    return result;
end


--------设置canvasgroup是否可见
function UIUtil.ShowCanvasGroup(canvasGroup, show)
    if canvasGroup then
        canvasGroup.alpha = show and 1 or 0
        canvasGroup.blocksRaycasts = show
        canvasGroup.interactable = show
    end
end
function UIUtil.ShowCanvasGroupByName(name,parent, show)
    local canvasGroup = UIUtil.GetTypeChildWightInputPath(name, parent, typeof(CanvasGroup))
    UIUtil.ShowCanvasGroup(canvasGroup, show)
end
------设置CanvasGroup Alphe 值 是否接受点击
function UIUtil.SetCanvasGroupAlpha(name,parent,value,raycast)
    local canvasGroup = UIUtil.GetTypeChildWightInputPath(name, parent, typeof(CanvasGroup))
    canvasGroup.alpha=value
    canvasGroup.blocksRaycasts = raycast
    canvasGroup.interactable = raycast
end

function UIUtil.IsCanvasGroupShow(canvasGroup)
    return canvasGroup.alpha ==1
end

--------实例化gameobject
function UIUtil.InstantiateGameObject(gameobject )
    -- body
    return CS.UIUtil.InstantiateGameObject(gameobject)
end

--------实例化获取Text文本实际宽度
function UIUtil.GetTextWidth(text)
   return text.preferredWidth
end
--------实例化获取Text文本实际高
function UIUtil.GetTextHeight(text)
  return  text.preferredHeight
end
function UIUtil.SetUIWidth(image, value)
    CS.Horizon.Util.SetWidth(UIUtil.GetRectTransform(image),value)
end
function UIUtil.SetUIHeight(image, value)
    CS.Horizon.Util.SetHeight(UIUtil.GetRectTransform(image),value)
end
function UIUtil.GetUIWidth(image)
  return  CS.Horizon.Util.GetWidth(UIUtil.GetRectTransform(image))
end
function UIUtil.GetUIHeight(image)
    return  CS.Horizon.Util.GetHeight(UIUtil.GetRectTransform(image))
end

function UIUtil.GetRectTransform(image)
    if image then
        local rect = UIUtil.GetGameobjectComponent(image.gameObject, typeof(RectTransform))
        return rect
    end
end

function UIUtil.SetDoText(text,value,duration)
    CS.UIUtil.SetDoText(text,value,duration)
end

--------setparent
function UIUtil.SetParentGameObject(parent, child, isreset, isresetui)
    if child == nil or parent == nil or CommonHelper:GameObjectIsNull(child) or CommonHelper:GameObjectIsNull(parent) then
        return
    end
    if isreset == nil then isreset = true end
    if isresetui == nil then isresetui = false end
    UIUtil.SetParentTransform(parent.transform, child.transform, isreset, isresetui)
end
function UIUtil.SetParentTransform(parent, child, isreset, isresetui)
    if isreset == nil then isreset = true end
    if child == nil or parent==nil  then return end
    child.transform:SetParent(parent.transform)
    if isreset then
        child.transform.localPosition=Vector3.zero
        child.transform.localScale=Vector3.one
        child.transform.localRotation=Quaternion.identity
    end

    if isresetui then
        local rect = UIUtil.GetGameobjectComponent(child.gameObject, typeof(RectTransform))
        if rect then
            rect.offsetMax = Vector2.zero
            rect.offsetMin = Vector2.zero
        end
    end
end

--------16进制颜色码转换
function UIUtil:HexToColor(string)
    return CS.UIUtil.HexToColor(string)
end

--------16进制颜色码转换
function UIUtil:HexToColorRGB(string)
    return CS.UIUtil.HexToColorRGB(string)
end

--{{{LocalPositionY
function UIUtil:HButtonLocalPositionY(btn, value)
    if btn then
        local mLocalPos = btn.transform.localPosition
        mLocalPos.y = value
        btn.transform.localPosition=mLocalPos
    end
end
function UIUtil:TextLocalPositionY(text, value)
    if text then
        local mLocalPos = text.transform.localPosition
        mLocalPos.y = value
        text.transform.localPosition=mLocalPos
    end
end
function UIUtil:GameobjectLocalPositionY(obj, value)
    if obj then
        local mLocalPos = obj.transform.localPosition
        mLocalPos.y = value
        obj.transform.localPosition=mLocalPos
    end
end
--}}}


--{{{LocalPositionX
function UIUtil:HButtonLocalPositionX(btn, value)
    if btn then
        local mLocalPos = btn.transform.localPosition
        mLocalPos.x = value
        btn.transform.localPosition=mLocalPos
    end
end
function UIUtil:GameobjectLocalPositionX(obj, value)
    if obj then
       local mLocalPos = obj.transform.localPosition
        mLocalPos.x = value
        obj.transform.localPosition=mLocalPos
    end
end
--}}}


--{{{LocalPosition
function UIUtil:GameobjectLocalPosition(obj, value)
    if obj then
        obj.transform.localPosition=value
    end
end
--}}}
--{{{LocalPosition
---@param value LuaVector3
function UIUtil:GameobjectLocalPositionLuaVector3(obj, value)
    CS.UIUtil.GameObjectLocalPosition(obj,value:GetData())
end
--}}}

--{{{RawImage接口
function UIUtil:RawImage_ColorAlpha(image, value)
    if image then
        --image:ColorAlpha(value)
    end
end
function UIUtil:RawImage_SetSize(image, resname)
    if image then
        ---@type rawimagesize_config
        local tab = ClientDataManager:GetDataTable(ConfigNames.rawimagesize_config)
        ---@type rawimagesize_config_cell
        local cfg = tab.GetDataByName(resname)
        if cfg then
            UIUtil.SetUIWidth(image,cfg.NewWidth)
            UIUtil.SetUIHeight(image,cfg.NewHeight)
        end
    end
end
--}}}