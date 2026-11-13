---@class AnalysisItemsData
---@field  articleItems
---@field  currency


---@class CommonHelper
CommonHelper = {}

---------------------------------------------------获得奖励
function CommonHelper:OpenLoading(IsAutoClose, evt, param)
    mono.AudioListenerPause(true)
    UIManager:Get():ShowPersistentView("LoadingView", CanvasType.LoadingCanvas, "LoadingView", false, true)
    UINotify:Get():SendNotification(UINotifyEvent.LoadingView_IsAutoClose, IsAutoClose)
    UINotify:Get():SendNotification(UINotifyEvent.LoadingView_SetFinishEvt, { evt, param })
    QuickTa:Get():TrackEvent(TrackEventNames.Openloading, nil,TrackEventType.First,AnalysisType.Openloading)
end
function CommonHelper:CloseLoading()
    mono.AudioListenerPause(false)
    --UIManager:Get():CloseAllViews()
    UIManager:Get():HidePersistentView("LoadingView")
    --UIManager:Get():CloseView()
end
---------------------------------------------------


---------------------------------------------------查看车信息
function CommonHelper:ShowCarInfoByMsg(msgData, keepShowPrevious)
    --UIManager:Get():OpenPopup("CarInfoView", CanvasType.MainCanvas, "CarInfoView", keepShowPrevious or false)
    --if msgData then
    --    UINotify:Get():SendNotification(UINotifyEvent.CarInfoView_SetMsgData, msgData)
    --end
end
function CommonHelper:ShowCarInfoByCarReviewData(msgData, keepShowPrevious)
    UIManager:Get():OpenPopup("MiniCarInfoView", CanvasType.FrontCanvas, "MiniCarInfoView", keepShowPrevious or false)
    UINotify:Get():SendNotification(UINotifyEvent.MiniCarInfoViewSetData, msgData)

end
--function CommonHelper:ShowCarInfoByNPC(npcid, keepShowPrevious)
--    --输入npcid
--    ---@type npc_config_cell
--    local cfg = CommonHelper:GetTableDataByID(ConfigNames.npc_config, npcid)
--    if cfg then
--        CommonHelper:ShowCarInfoBySuit(cfg.suits, keepShowPrevious)
--    end
--end
--function CommonHelper:ShowCarInfoBySuit(suitid, keepShowPrevious)
--    -- 输入套装id
--    UIManager:Get():OpenPopup("CarInfoView", CanvasType.MainCanvas, "CarInfoView", keepShowPrevious or false)
--    UINotify:Get():SendNotification(UINotifyEvent.CarInfoView_SetCfgData, suitid)
--end
---------------------------------------------------


---------------------------------------------------获得奖励
---@param items SC_SomeDown
function CommonHelper:ShowGetReward(items, keepShowPrevious, closeFun,getRewardType)
    CommonHelper:PlaySfxByGetRewardType(getRewardType or GetRewardType.GetReward)
    if UIManager:Get():IsPopViewShow("GetRewardView")==false then
        UIManager:Get():OpenPopup("GetRewardView", CanvasType.FrontCanvas, "GetRewardView", keepShowPrevious or false)
    end
    UINotify:Get():SendNotification(UINotifyEvent.OpenGetRewardView, items)
    UINotify:Get():SendNotification(UINotifyEvent.CloseGetRewardFun, closeFun)
end
---@param msg SC_OpenPackage  or OpenOptionalBox
function CommonHelper:UserGetReward(msg, keepShowPrevious, closeFun,getRewardType)
    if msg.curConsume then
        KnapsackDataManager:Get():UpdatePropByConsume(msg.curConsume)
    end
    if msg.downlist then
        CommonHelper:ShowGetRewardDataBySomeDown(msg.downlist, keepShowPrevious, closeFun,getRewardType)
    else
        if closeFun then
            closeFun()
        end
    end


end
---@param msg SC_SomeDown
function CommonHelper:ShowGetRewardDataBySomeDown(msg, keepShowPrevious, closeFun,getRewardType)
    if msg then
        KnapsackDataManager:Get():AddPropAndPartBySomeDown(msg)
        local result = CommonHelper:GetRewardDataBySomeDown(msg)
        if #result > 0 then
            CommonHelper:ShowGetRewardByRewardData(result, keepShowPrevious, closeFun,getRewardType)
            return true
        else
            if closeFun then
                closeFun()
            end
            return false
        end
    else
        if closeFun then
            closeFun()
        end
        return false
    end
    return false
end
---@param msg SC_SomeDown
---@return RewardData[]
function CommonHelper:GetRewardDataBySomeDown(msg)
    local result = {}
    if msg.downProps then
        for i = 1, #msg.downProps do
            if CommonHelper:GetRewardFilter(msg.downProps[i].propid) then
                local temp = RewardData()
                temp:SetDataIdNum(msg.downProps[i].propid, msg.downProps[i].alterNum)
                table.insert(result, temp)
            end
        end
    end
    if msg.partViewId then
        for i = 1, #msg.partViewId do
            local temp = RewardData()
            local partIdx=0
            if msg.downParts[i] then partIdx=msg.downParts[i].partinx end
            temp:SetDataIdNum(msg.partViewId[i], 1,partIdx)
            table.insert(result, temp)
        end
    end
    if msg.downExp then
        local temp = RewardData()
        temp:SetDataIdNum(CurrencyType.Exp, msg.downExp.curexp)
    end
    if msg.downFurniture then
        for i = 1, #msg.downFurniture do
            local temp = RewardData()
            temp:SetDataIdNum(msg.downFurniture[i].furnitureId, 1)
            table.insert(result, temp)
        end
    end
    return result
end
function CommonHelper:SendAdJustToken(eventName,token)
    if token ~= nil and token ~= "" then
        local data = CustomEventData()
        data.eventName = token      --  这块传 adjustToken
        data.customParam = eventName
        print("AdJust打点发送",eventName,token)
        UnifySDKEventSystem:Publish(data);
    end
end

function CommonHelper:GetRewardFilter(id)
    local result = true
    local filterIds = stringSplitToNumber(CommonHelper:GetDictCalcData(CommonCfgKey.GetRewardFilterIds, true), ":")
    for i = 1, #filterIds do
        if id == filterIds[i] then
            result = false
            break
        end
    end
    return result
end
---@param rewardData table<number,RewardData>
function CommonHelper:ShowGetRewardByRewardData(rewardData, keepShowPrevious, closeFun,getRewardType)
    CommonHelper:PlaySfxByGetRewardType(getRewardType or GetRewardType.GetReward)
    if UIManager:Get():IsPopViewShow("GetRewardView")==false then
        UIManager:Get():OpenPopup("GetRewardView", CanvasType.FrontCanvas, "GetRewardView", keepShowPrevious or false)
    end
    UINotify:Get():SendNotification(UINotifyEvent.OpenGetRewardView_RewardData, rewardData)
    UINotify:Get():SendNotification(UINotifyEvent.CloseGetRewardFun, closeFun)
end
---------------------------------------------------
---------------------------------------------------打开页面详情
function CommonHelper:ShowHelpView(type, title, style, keepShowPrevious)
    if type == nil then
        return
    end

    UIManager:Get():OpenPopup("HelpView", CanvasType.TopCanvas, "HelpView", keepShowPrevious)
    UINotify:Get():SendNotification(UINotifyEvent.HelpView_SetData, { type, title, style })
end
---------------------------------------------------

---------------------------------------------------物品信息
--function CommonHelper:ShowArticleInfoByCellid(colortype, cellid)
--    UIManager:Get():OpenPopup("ArticleInfoView", CanvasType.MainCanvas, "ArticleInfoView")
--    UINotify:Get():SendNotification(UINotifyEvent.ArticleInfoView_SetDataByCellid, { colortype, cellid })
--end
function CommonHelper:ShowArticleInfoByCfg(colortype, cfg)
    --UIManager:Get():OpenPopup("ArticleInfoView", CanvasType.MainCanvas, "ArticleInfoView")
    --UINotify:Get():SendNotification(UINotifyEvent.ArticleInfoView_SetDataByCfg, { colortype, cfg })
end
--function CommonHelper:ShowPartInfoByArticleData(colortype, articleData)
--    UIManager:Get():OpenPopup("PartInfoView", CanvasType.MainCanvas, "PartInfoView")
--    UINotify:Get():SendNotification(UINotifyEvent.PartInfoView_SetArticleData, { colortype, articleData })
--end
--function CommonHelper:ShowPartInfoByCfg(colortype, cfg, composeids)
--    UIManager:Get():OpenPopup("PartInfoView", CanvasType.MainCanvas, "PartInfoView")
--    UINotify:Get():SendNotification(UINotifyEvent.PartInfoView_SetData, { colortype, cfg, composeids })
--end

function CommonHelper:ShowPartInfoByCfgId(id, uiModuleID, isShowQuick,Reform,articleCell)
    if isShowQuick==nil then isShowQuick=false  end
    UIManager:Get():OpenPopup("ArticleInfoView", CanvasType.TopCanvas, "ArticleInfoView", true)
    UINotify:Get():SendNotification(UINotifyEvent.ArticleInfoView_SetDataByCfg, { id, uiModuleID, isShowQuick,Reform,articleCell })
end
function CommonHelper:ShowTrackFeatureByCfgId(id)
    UIManager:Get():OpenPopup("ArticleInfoView", CanvasType.TopCanvas, "ArticleInfoView", true)
    UINotify:Get():SendNotification(UINotifyEvent.TrackSegmentFeatureView_SetDataByCfg, id)
end

function CommonHelper:ShowTrackSegmentInfoByCfg(cfg, count)
    UIManager:Get():OpenPopup("ArticleInfoView", CanvasType.MainCanvas, "ArticleInfoView")
    UINotify:Get():SendNotification(UINotifyEvent.TrackSegmentInfoView_SetData, { cfg, count })
end
function CommonHelper:ShowArticleSelectCountView(ModuleID,data,max,min,default,func,funccancel)
    UIManager:Get():OpenPopup("ArticleCountSelectView",CanvasType.FrontCanvas,"ArticleCountSelectView")
    UINotify:Get():SendNotification(UINotifyEvent.ArticleCountSelectView_SetData, {ModuleID,data,max,min,default,func,funccancel})
end


--function CommonHelper:ShowBagArticleInfo(cellid)
--    local data = KnapsackDataManager:Get():GetArticleByCellID(cellid)
--    if data:IsPart() then
--        UIManager:Get():OpenPopup("ArticleInfoPartView", CanvasType.MainCanvas, "ArticleInfoPartView")
--        UINotify:Get():SendNotification(UINotifyEvent.ArticleInfoPartView_SetData, { cellid, data:GetPartComposeIds() })
--    else
--        if data:GetArticleConfig().useType == 1 then
--            CommonHelper:ShowArticleInfoByCellid(UIColor.Green, cellid)
--        end
--        if data:GetArticleConfig().useType == 2 then
--            UIManager:Get():OpenPopup("ArticleInfoUseView", CanvasType.MainCanvas, "ArticleInfoUseView")
--            UINotify:Get():SendNotification(UINotifyEvent.ArticleInfoUseView_SetData, cellid)
--        end
--    end
--
--
--end
---------------------------------------------------

---------------------------------------------------设置UI image  RawImage
function CommonHelper:GetComponentSetImage(objName, parent, fileName, moduleId)
    local image = UIUtil.GetTypeChildWightByParent(objName, parent, typeof(Image))
    if image then
        CommonHelper:SetImage(image, fileName, moduleId)
    end
    return image
end
function CommonHelper:SetImage(image, fileName, moduleId)
    if fileName == nil or fileName == "" then
        fileName = "common_bg_default_white_dt"
    end
    UITextureManager:SetImage(image, fileName, moduleId)
end

function CommonHelper:ImageSetNativeSize(image)
    if image then
        image:SetNativeSize()
    end
end

----fileName 要加上.png
function CommonHelper:GetComponentSetUITexture(objName, parent, fileName, moduleId, isAsync, isGray, defaultTex)
    if fileName == nil or fileName == "" or type(fileName) ~= "string" then
        fileName = "uitex_sucai_default.png"
        logError("GetComponentSetUITexture----filename格式错误，filename", fileName)
    else
        local s, e = string.find(fileName, ".png")
        if e == nil or e ~= #fileName then
            logError("GetComponentSetUITexture----没有找到该图片，该图片的名字是", fileName)
            fileName = "uitex_sucai_default.png"
        end
    end

    local rawimage = UIUtil.GetTypeChildWightByParent(objName, parent, typeof(RawImage))
    if rawimage then
        CommonHelper:SetUITexture(rawimage, fileName, moduleId, isAsync, isGray, defaultTex)
    end
    return rawimage
end
function CommonHelper:GetComponentSetUIMaterialTexture(objName, parent,fileName, moduleId, isAsync, isGray, defaultTex,propertieName)
    if fileName == nil or fileName == "" or type(fileName) ~= "string" then
        fileName = "uitex_sucai_default.png"
        logError("GetComponentSetUIMaterialTexture----filename格式错误，filename", fileName)
    else
        local s, e = string.find(fileName, ".png")
        if e == nil or e ~= #fileName then
            logError("GetComponentSetUIMaterialTexture----没有找到该图片，该图片的名字是", fileName)
            fileName = "uitex_sucai_default.png"
        end
    end

    local rawimage = UIUtil.GetTypeChildWightByParent(objName, parent, typeof(RawImage))
    if rawimage then
        CommonHelper:SetUIMaterialTexture(rawimage, propertieName,fileName, moduleId, isAsync, isGray, defaultTex)
    end
    return rawimage
end

function CommonHelper:GetComponentSetUITextureByTexture(objName, parent, Texture)

    local rawimage = UIUtil.GetTypeChildWightByParent(objName, parent, typeof(RawImage))
    if rawimage then
        rawimage.texture = Texture
    end
    return rawimage
end
----fileName 要加上.png
function CommonHelper:GetComponentSetUIFreedomRawImage(objName, parent, fileName, moduleId)
    if fileName ~= nil or type(fileName) == "string" or fileName ~= "" then
        local s, e = string.find(fileName, ".png")
        if e == nil or e ~= #fileName then
            logError("GetComponentSetUITexture----没有找到该图片，该图片的名字是：" .. fileName)
            fileName = "uitex_sucai_default.png"
        end
    else
        fileName = "uitex_sucai_default.png"
        logError("GetComponentSetUITexture----没有找到该图片")
    end

    local rawimage = UIUtil.GetTypeChildWightByParent(objName, parent, typeof(UIFreedomRawImage))
    if rawimage then
        CommonHelper:SetUITexture(rawimage, fileName, moduleId)
    end
    return rawimage
end


local _DefaultText = nil
function CommonHelper:SetUITexture(rawImage, texName, poolId, isAsync, isGray, defaultTex)
    if _DefaultText == nil then
        local asset = AssetsManager.Load("uitex_sucai_default.png", typeof(CS.UnityEngine.Texture))
        _DefaultText = asset.asset
    end
    if CommonHelper:GameObjectIsNull(rawImage) then return end
    UITextureManager:SetUITexture(rawImage, texName, poolId, isAsync or false, isGray or false, defaultTex or _DefaultText)
end
local _DefaultText = nil
function CommonHelper:SetUIMaterialTexture(rawImage, propertieName,texName, poolId, isAsync, isGray, defaultTex)
    if _DefaultText == nil then
        local asset = AssetsManager.Load("uitex_sucai_default.png", typeof(CS.UnityEngine.Texture))
        _DefaultText = asset.asset
    end
    if CommonHelper:GameObjectIsNull(rawImage) then return end
    UITextureManager:SetUIMaterialTexture(rawImage,propertieName or "_Main_Tex", texName, poolId, isAsync or false, isGray or false, defaultTex or _DefaultText)
end

--function CommonHelper:SetUI3DIcon(rawImage, texName, partId)
--
--
--end

--function CommonHelper:SetRenderTexture(rawImage, pos, rot)
--    UITextureManager:SetRenderTexture(rawImage, pos, rot)
--end

---@param moduleId UIModuleID
function CommonHelper:ReleasePool(moduleId)
    UITextureManager:ReleasePool(moduleId)
end

function CommonHelper:SetRawimageRenderTexture(objName, parent)
    local rawimage = UIUtil.GetTypeChildWightByParent(objName, parent, typeof(RawImage))
    if rawimage then
        rawimage.texture = UIManager:Get():GetSecondBaseCameraRT()
    end
end
---------------------------------------------------



---------------------------------------------------获取车类型名字
function CommonHelper:GetCarTypeName(type)
    local key = "CarTypeName" .. type
    return ClientDataManager:Get():GetTemplateString(key)
end
---------------------------------------------------

---------------------------------------------------获取配件类型名字
---@param type1 GoodsType1
---@param type2 GoodsType2
---@param type3 GoodsType3
function CommonHelper:GetGoodsTypeName(type1, type2, type3)
    ---@type goodstype_config
    local tab = ClientDataManager:Get():GetDataTable(ConfigNames.goodstype_config)
    if type1 == nil then
        return ""
    elseif type2 == nil then
        return CommonHelper:GetTempStr_Default(tab.GetDataType1(type1))
    elseif type3 == nil then
        return CommonHelper:GetTempStr_Default(tab.GetDataType2(type1, type2))
    else
        return CommonHelper:GetTempStr_Default(tab.GetDataType3(type1, type2, type3))
    end
end
---@param type1 GoodsType1
---@param type2 GoodsType2
function CommonHelper:GetGoodsTypeIcon(type1, type2, type3)
    ---@type goodstype_config
    local tab = ClientDataManager:Get():GetDataTable(ConfigNames.goodstype_config)
    if type2 == -1 then
        return "common_togicon_part_0_dt"
    end
    if type1 == nil then
        return ""
    elseif type2 == nil then
        return tab.GetDataType1Icon(type1)
    elseif type3 == nil then
        return tab.GetDataType2Icon(type1, type2)
    else
        return tab.GetDataType3Icon(type1, type2,type3)
    end
end


---------------------------------------------------

--{{{获取属性名字
function CommonHelper:GetAttrName(type)
    ---@type attrtype_config_cell
    local cfg = CommonHelper:GetTableDataByID(ConfigNames.attrtype_config, type)
    if cfg then
        return ClientDataManager:Get():GetTemplateString(cfg.attrname)
    else
        return "默认属性名称"
    end

end
--}}}
--{{{获取属性描述
function CommonHelper:GetAttrDesc(type)
    ---@type attrtype_config_cell
    local cfg = CommonHelper:GetTableDataByID(ConfigNames.attrtype_config, type)
    if cfg then
        return ClientDataManager:Get():GetTemplateString(cfg.desc)
    else
        return "默认属性名称"
    end

end
--}}}
--{{{属性值，展示
function CommonHelper:GetAttrValue(type, value)
    ---@type attrtype_config_cell
    local cfg = CommonHelper:GetTableDataByID(ConfigNames.attrtype_config, type)
    if cfg == nil then
        return tostring(value)
    end

    value = value * cfg.showradio
    return string.format(cfg.format, value)
end
--}}}
--{{{属性值，展示
function CommonHelper:GetAttrShowValue(type, value)
    ---@type attrtype_config_cell
    local cfg = CommonHelper:GetTableDataByID(ConfigNames.attrtype_config, type)
    if cfg == nil then
        return tostring(value)
    end
    return string.format(cfg.format, value)
end
--}}}
--{{{属性特性的区间等级
---@param cfg attrfeature_config_cell
function CommonHelper:GetAttrFeatureLV(cfg, value)
    local result = 0
    if cfg then
        for i = 1, #cfg.NewInterval - 1 do
            local a = cfg.NewInterval[i]
            local b = cfg.NewInterval[i + 1]
            if (value >= a and value < b) or (value <= a and value > b) then
                result = i
                break
            end
        end
    end
    return result
end
--}}}
--{{{属性的区间等级
---@param cfg attrtype_config_cell
function CommonHelper:GetAttrLV(cfg, value)
    local result = 0
    if cfg then
        for i = 1, #cfg.NewInterval - 1 do
            local a = cfg.NewInterval[i]
            local b = cfg.NewInterval[i + 1]
            if (value >= a and value < b) or (value <= a and value > b) then
                result = i
                break
            end
        end
    end
    return result
end
--}}}
---------------------------------------------------设置button可否点击
function CommonHelper:SetHButtonClick(button, isclick, isApplyActive)
    if button then
        button.targetGraphic.raycastTarget = isclick
        if isApplyActive or false then
            button.gameObject:SetActive(isclick)
        end
    end
end
function CommonHelper:SetHButtonEnable(button, enable)
    --设置button状态
    if button then
        button:SetEnable(enable)
    end
end
---------------------------------------------------

---------------------------------------------------设置ToggleState
function CommonHelper:SetToggleState(toggle, state, isIgnorRaycaset)
    if toggle==nil then return end
    toggle:SetToggleState(state, isIgnorRaycaset or false)
end

function CommonHelper:GetToggleState(toggle)
    return toggle._isSelect
end
---------------------------------------------------

---------------------------------------------------查找button，设置回调方法和回调参数
function CommonHelper:HButtonSetCallback(objName, parent, func, paramInt, paramStr, paramLong)
    local btn = UIUtil.GetTypeChildWightInputPath(objName, parent, typeof(HButton))
    if btn then
        btn.intData = paramInt
        btn.longData = paramLong
        btn.stringData = paramStr
        btn:AddOnClickFunction(function(btn)
            CommonHelper:SetBtnDelayClick(btn, 0.2, false)
            func(btn)
        end)
        LuaRelevance:Get():AddBtn(btn)
    end
    return btn
end

function CommonHelper:DragObjectSetCallback(objName, parent, beginfunc, endfun, paramInt, paramStr, paramLong)
    local btn = UIUtil.GetTypeChildWightInputPath(objName, parent, typeof(DragObject))
    if btn then
        btn.intData = paramInt
        btn.longData = paramLong
        btn.stringData = paramStr
        btn:SetOnDragBeginFunc(function(eventData,btn)
            beginfunc(eventData,btn)
        end)
        btn:SetOnDragEndFunc(function(eventData,btn)
            endfun(eventData,btn)
        end)
    end
    return btn
end
function CommonHelper:OnTriggerObjectSetCallback(objName, parent, enterfunc, exitfun, stayfun, paramInt, paramStr, paramLong)
    local btn = UIUtil.GetTypeChildWightInputPath(objName, parent, typeof(Collision2D))
    if btn then
        btn.intData = paramInt
        btn.longData = paramLong
        btn.stringData = paramStr
        btn:SetOneTriggerEnter(function(btn)
            enterfunc(btn)
        end)
        btn:SetOneTriggerStay(function(btn)
            stayfun(btn)
        end)
        btn:SetOneTriggerExit(function(btn)
            exitfun(btn)
        end)
    end
    return btn
end
---------------------------------------------------
function CommonHelper:HLongButtonSetCallback(objName, parent, clickFunc, longClickFunc, paramInt, paramStr, paramLong)
    local btn = UIUtil.GetTypeChildWightInputPath(objName, parent, typeof(HLongButton))
    if btn then
        btn.intData = paramInt
        btn.longData = paramLong
        btn.stringData = paramStr
        btn.onClickAction = clickFunc
        btn.onLongTimeClickAction = longClickFunc
    end
    return btn
end

---------------------------------------------------查找text，设置text内容
function CommonHelper:SetText(objName, parent, string)
    local text = UIUtil.GetTypeChildWightInputPath(objName, parent, typeof(Text))
    if text then
        CommonHelper:Text_EnableBitFit(text)
        text.text = string
    end
    return text
end

function CommonHelper:SetTextMesh(objName, parent, str,isuseautolinebreak)
    local text = UIUtil.GetTypeChildWightByParent(objName, parent, typeof(TextMeshProUGUI))
    if text then
        isuseautolinebreak = isuseautolinebreak==nil and true or isuseautolinebreak
        if isuseautolinebreak then
            text.text=str
        else
            local s = string.gsub(str, " ", "▓")--\u2593
            s = string.gsub(s, " ", "▓")
            s = string.gsub(s, "▓", " ")
            str ="<nobr>"..s.."</nobr>"
            text.text=str
        end
    end
   -- LanguageSwitchManager.Get():SetTextMeshProFont(text)
    return text
end
function CommonHelper:SetTextMeshLinkClick(objName, parent)
    local text = UIUtil.GetTypeChildWightByParent(objName, parent, typeof(TextMeshProUGUI))
    CommonHelper:HButtonSetCallback(objName, parent, function(data)
        local  mousePosition= mono.GetMousePosition()
        local linkIndex = CS.TMPro.TMP_TextUtilities.FindIntersectingLink(text, Vector3(mousePosition.x,mousePosition.y,0), CSCameraManager.Get()._UICamera) --UI相机
        if linkIndex > -1 then
            local linkInfo = text.textInfo.linkInfo[linkIndex]
            log(linkInfo:GetLinkText())
            log(linkInfo:GetLinkID())
            CS.UnityEngine.Application.OpenURL(linkInfo:GetLinkID())
        end
    end)
    return text
end

function CommonHelper:SetNewLineTextMesh(objName, parent, str,isuseautolinebreak)
    local text = UIUtil.GetTypeChildWightInputPath(objName, parent, typeof(TextMeshProUGUI))
    if text then
        isuseautolinebreak = isuseautolinebreak==nil and true or isuseautolinebreak
        if isuseautolinebreak then
            text.text=str
        else
            local s = string.gsub(str, " ", "▓")
            s = string.gsub(s, " ", "▓")
            str ="<nobr>"..s.."</nobr>"
        end
        MonoHelper.SetNewlineText(text, str)
    end
    return text
end

function CommonHelper:SetMesh_Text(objName, parent, string)
    cs_coroutine.start(function()
        coroutine.yield()
        mono.SetMesh_Text(objName, parent, string)
    end)
end

function CommonHelper:SetTextByGo(text, string)
    if text then
        CommonHelper:Text_EnableBitFit(text)
        text.text = string
    end
    return text
end

function CommonHelper:SetDoText(objName, parent, string, duration)
    local text = UIUtil.GetTypeChildWightInputPath(objName, parent, typeof(Text))
    if text then
        CommonHelper:Text_EnableBitFit(text)
        text.text = ""
        UIUtil.SetDoText(text, string, duration)
    end
    return text
end

function CommonHelper:SetXTextText(objName, parent, string)
    local text = UIUtil.GetTypeChildWightInputPath(objName, parent, typeof(XText))
    if text then
        text.text = string
    end
    return text
end
function CommonHelper:SetTMP_TextText(objName, parent, string)
    local text = UIUtil.GetTypeChildWightInputPath(objName, parent, typeof(CS.TMPro.TextMeshPro))
    if text then
        text.text = string
    end
    return text
end

function CommonHelper:SetNewLineText(objName, parent, string)
    local text = UIUtil.GetTypeChildWightInputPath(objName, parent, typeof(Text))
    if text and string then
        CommonHelper:Text_EnableBitFit(text)
        MonoHelper.SetNewlineText(text, string)
    end
    return text
end
function CommonHelper:SetTextColor(text, string)
    if text == nil then
        return
    end
    text.color = UIUtil:HexToColorRGB(string)
end
function CommonHelper:SetTextSize(text, size)
    if text == nil then
        return
    end
    text.fontSize = size
end
function CommonHelper:SetTextColorRGBA(text, string)
    if text == nil then
        return
    end
    text.color = UIUtil:HexToColor(string)
end

function CommonHelper:SetTextColorByName(objName, parent, string)
    local text = UIUtil.GetTypeChildWightInputPath(objName, parent, typeof(Text))
    if text == nil then
        return
    end
    text.color = UIUtil:HexToColorRGB(string)
end

function CommonHelper:SetTextQualityColor(quality, text)
    if text == nil or quality == nil then
        return
    end

    local table = {
        "51ff51",
        "3dcfff",
        "a918ec",
        "fac137",
        "eb2121",
    }
    if table[quality] == nil then
        print("---   error:SetTextQualityColor   quality = ", quality)
        text.color = UIUtil:HexToColorRGB("ffffff")
    else
        text.color = UIUtil:HexToColorRGB(table[quality])
    end
end
---------------------------------------------------


---------------------------------------------------文本输入框
function CommonHelper:SetInputFieldText(objName, parent, string)
    local input = UIUtil.GetTypeChildWightInputPath(objName, parent, typeof(InputField))
    if input then
        CommonHelper:Text_EnableBitFitByParent(input.gameObject)
        input.text = string
    end
    return input
end

function CommonHelper:SetInputFieldTextByGo(input, string)
    if input then
        CommonHelper:Text_EnableBitFitByParent(input.gameObject)
        input.text = string
    end
    return input
end

function CommonHelper:SetInputFieldCharacterLimit(objName, parent, limit)
    local input = UIUtil.GetTypeChildWightInputPath(objName, parent, typeof(InputField))
    if input then
        CommonHelper:Text_EnableBitFitByParent(input.gameObject)
        input.characterLimit = limit
    end
    return input
end
function CommonHelper:GetInputFieldText(objName, parent)
    local input = UIUtil.GetTypeChildWightInputPath(objName, parent, typeof(InputField))
    if input then
        CommonHelper:Text_EnableBitFitByParent(input.gameObject)
        return input.text
    end
    return ""
end
function CommonHelper:SetInputFieldOnValueChanged(objName, parent, func)
    local input = UIUtil.GetTypeChildWightInputPath(objName, parent, typeof(InputField))
    if input then
        CommonHelper:InputFieldOnValueChanged(input, func)
    end
    return input
end
function CommonHelper:InputFieldRemoveAllListener(objName, parent)
    local input = UIUtil.GetTypeChildWightInputPath(objName, parent, typeof(InputField))
    if input then
        input.onValueChanged:RemoveAllListeners()
        input.onValueChanged:Invoke()
    end
    return input
end
function CommonHelper:InputFieldSetDefaultText(objName, parent, string)
    local com = UIUtil.GetTypeChildWightInputPath(objName, parent, typeof(InputFieldSetDefaultText))
    if com then
        CommonHelper:Text_EnableBitFitByParent(com)
        com:SetValue(string)
    end
    return com
end
function CommonHelper:InputFieldSetValue(input, string)
    if input then
        CommonHelper:Text_EnableBitFitByParent(input.gameObject)
        input.text = string
    end
end
function CommonHelper:InputFieldGetValue(input)
    if input then
        return input.text
    end
    return ""
end

function CommonHelper:InputFieldGetCharacterValue(input)
    if input then
        return input.characterLimit
    end
    return ""
end

function CommonHelper:InputFieldSetCharacterValue(input, characterLimit)
    if input then
        CommonHelper:Text_EnableBitFitByParent(input.gameObject)
        input.characterLimit = characterLimit
    end
end

----输入框注册onValueChanged
function CommonHelper:InputFieldOnValueChanged(inputFiled, onValueChangedFunc)
    if inputFiled ~= nil then
        inputFiled.onValueChanged:AddListener(onValueChangedFunc)
    end
end

----输入框注册onEndEdit
function CommonHelper:InputFieldOnEndEdit(inputFiled, onEndEditFunc)
    if inputFiled ~= nil then
        inputFiled.onEndEdit:AddListener(onEndEditFunc)

        LuaRelevance:Get():AddInput(inputFiled)
    end
end

----输入框注册onSelect
function CommonHelper:InputFieldOnSelect(inputFiled, onSelectFunc)
    if inputFiled ~= nil then
        inputFiled.onSelect:AddListener(onSelectFunc)
    end
end

function CommonHelper:InputFieldSetContentType(inputFiled, contentType)
    if inputFiled ~= nil then
        inputFiled.contentType = contentType
    end
end
---------------------------------------------------


---------------------------------------------------查找slider，设置查找slider进度
function CommonHelper:SetSlider(objName, parent, value)
    local slider = UIUtil.GetTypeChildWightInputPath(objName, parent, typeof(Slider))
    if slider then
        slider.value = value
    end
    return slider
end
function CommonHelper:SetSliderAni(objName, parent, value,finish,during)
    local slider =  UIUtil.GetTypeChildWightInputPath(objName, parent, typeof(CSSliderAni))
    if slider then
        slider:Play(value)
        slider:SetFinshCallback(finish)
        slider.during=during or slider.during
    else
        if finish then
            finish()
        end
    end
    return slider
end

function CommonHelper:SliderValueChangeCallback(objName, parent, fun)
    local slider = UIUtil.GetTypeChildWightInputPath(objName, parent, typeof(Slider))
    if slider then
        slider.onValueChanged:AddListener(function(value)
            fun(value)
        end)

        LuaRelevance:Get():AddSlider(slider)
    end
    return slider
end

function CommonHelper:GetSliderValue(slider)
    if slider then
        return slider.value
    end
    return 0
end
function CommonHelper:SetSliderValue(slider, value)
    if slider then
        slider.value = value
    end
end
---------------------------------------------------


---------------------------------------------------设置image填充进度
function CommonHelper:SetImageFillAmount(objName, parent, value)
    local image = UIUtil.GetTypeChildWightInputPath(objName, parent, typeof(Image))
    if image and type(value) == "number" then
        image.fillAmount = value
    end
    return image
end
function CommonHelper:SetFillBg(objName, parent, fillvalue, rectvalue)
    local fillbg = UIUtil.GetTypeChildWightInputPath(objName, parent, typeof(FillRawImage))
    if fillbg then
        fillbg.rectValue = rectvalue
        fillbg.FillValue = fillvalue
    end
    return fillbg
end
---------------------------------------------------


---------------------------------------------------傻瓜式获取配置表单条数据
function CommonHelper:GetTableDataByID(tabName, id)
    local table = ClientDataManager:Get():GetDataTable(tabName)
    if table == nil then
        return nil
    end
    return table.GetById(id)
end
---------------------------------------------------

function CommonHelper:GetPictureQuality()
    local textureQua = PlayerPrefsHelper:GetValue_PictureQuality()
    if textureQua == 0 then
        return "省电"
    elseif textureQua == 1 then
        return "平衡"
    else
        return "最优"
    end
end

---------------------------------------------------设置星级组件value
function CommonHelper:SetComponentPartStar(objName, parent, value, maxvalue, space)
    local star = UIUtil.GetTypeChildWightByParent(objName, parent, typeof(CardStar))
    if star then
        if space then
            star:SetStarLayout(value, space)
        end
        star:SetStar(value)
    end
end
function CommonHelper:SetComponentUIParticleSetColor(objName, parent, color)
    local star = UIUtil.GetTypeChildWightInputPath(objName, parent, typeof(UIParticleSetColor))
    if star then
        star:SetColor(color:GetData())
    end
end


function CommonHelper:SetPartStar(objName, parent, value, maxvalue)
    local star = UIUtil.GetTypeChildWightByParent(objName, parent, typeof(CardStar))
    if star then
        if maxvalue == nil then
            maxvalue = 1
        end
        star:SetValue(value, maxvalue)
    end
end
---------------------------------------------------

---------------------------------------------------
function CommonHelper:SetComponentPartGeneration(objName, parent, g_value)
    for i = 2, 4 do
        CommonHelper:SetGameObjectActive(objName .. i, parent, g_value == i)
    end

end
---------------------------------------------------

---------------------------------------------------设置奖杯组件value
function CommonHelper:SetComponentThreeCupState(objName, parent, value)
    local cup = UIUtil.GetTypeChildWightByParent(objName, parent, typeof(ThreeCup))
    if cup then
        cup:SetCupState(value)
    end
end
function CommonHelper:SetComponentThreeCupCount(objName, parent, value)
    local cup = UIUtil.GetTypeChildWightByParent(objName, parent, typeof(ThreeCup))
    if cup then
        cup:SetCupCount(value)
    end
end
---------------------------------------------------

---------------------------------------------------设置星级组件value
function CommonHelper:SetScrollPointLayout(objName, parent, totle, space)
    local point = UIUtil.GetTypeChildWightByParent(objName, parent, typeof(ScrollPoint))
    if point then
        point:SetLayout(totle, space or 50)
    end
end
function CommonHelper:SetScrollPoint(objName, parent, value)
    local point = UIUtil.GetTypeChildWightByParent(objName, parent, typeof(ScrollPoint))
    if point then
        point:SetPoint(value)
    end
end
---------------------------------------------------

---------------------------------------------------
function CommonHelper:InstantiateGameObjectByObject(obj)
    if obj == nil then
        print("---   error:InstantiateGameObjectByObject    obj = nil")
        return nil
    end

    local result = CSUtil.InstantiateGameObjectByObject(obj)
    return result
end
function CommonHelper:InstantiateMaterialByObject(obj)
    if obj == nil then
        print("---   error:InstantiateMaterialByObject    obj = nil")
        return nil
    end

    local result = CSUtil.InstantiateMaterialByObject(obj)
    return result
end

function CommonHelper:InstantiateCubemapByObject(obj)
    if obj == nil then
        print("---   error:InstantiateCubemapByObject    obj = nil")
        return nil
    end

    local result = CSUtil.InstantiateCubemapByObject(obj)
    return result
end


function CommonHelper:GetRootObjectExactMath(name, justRoot)
    if justRoot == nil then
        justRoot = false
    end
    local result = CSUtil.GetRootObjectExactMath(name, justRoot)
    return result
end
---------------------------------------------------


---------------------------------------------------
function CommonHelper:AnalyseChapterId(levelid)
    local level = levelid % 10000
    local chapter = (levelid - level) / 10000
    return math.floor(chapter), math.floor(level)
end

function CommonHelper:AnalyseShowChapterId(levelid)
    local level = levelid % 10000
    local chapter = (levelid - level) / 1000%1000
    return math.floor(chapter), math.floor(level)
end
---------------------------------------------------


---------------------------------------------------
--function CommonHelper:AnalyseCarId(carid)
--    local partgroup = carid % 1000
--    local cartypeid = math.modf((carid - partgroup) / 1000)
--    return cartypeid, partgroup
--end
---------------------------------------------------


---------------------------------------------------
--function CommonHelper:BuildPart(partId)
--    PartBuilder:Get():BuildPartByCfg(partId)
--end
--function CommonHelper:RecyclePart()
--    PartBuilder:Get():DisassembleAll()
--end
---------------------------------------------------


---------------------------------------------------
--function CommonHelper:GetCarBrowseList(type)
--    ---@type car_config
--    local tab = ClientDataManager:Get():GetDataTable(ConfigNames.car_config)
--    local cfgs = tab.GetNewConfigData()
--    local result = {}
--    for k, v in pairs(cfgs) do
--        if type == 0 or v.carType == type then
--            table.insert(result, v)
--        end
--    end
--
--    ---@param a car_config_cell
--    ---@param b car_config_cell
--    local sortfun = function(a, b)
--        local data_a = CarDataManager:Get():GetCarDataByCarID(a.NewID)
--        local data_b = CarDataManager:Get():GetCarDataByCarID(b.NewID)
--        if data_a ~= nil and data_b == nil then
--            return true
--        end
--        if data_a == nil and data_b ~= nil then
--            return false
--        end
--
--        if a.quality > b.quality then
--            return true
--        end
--
--        if a.quality < b.quality then
--            return false
--        end
--
--        if a.id > b.id then
--            return true
--        else
--            return false
--        end
--    end
--    table.sort(result, sortfun)
--    return result
--end
---------------------------------------------------


---------------------------------------------------
---@param items table<number, SC_Tuple2_64_32>
---@return AnalysisItemsData
function CommonHelper:AnalyseSomeDown(items)
    local result = {}
    result.articleItems = {}
    result.currency = {}
    for i = 1, #items do
        local id = items[i].num1
        if CommonHelper:AnalyseArticleID(id) then
            table.insert(result.articleItems, items[i])
        else
            table.insert(result.currency, items[i])
        end
    end
    return result
end
---------------------------------------------------

function CommonHelper:AnalyseArticleID(articleid)
    -- true:物品       false:数值类型的物品
    return articleid > 100
end

--function CommonHelper:SetCarMesh_Default(carid, showcfg, resetTween)
--    if resetTween == nil then
--        resetTween = true
--    end
--    print("---   显示车模型")
--    local param = CarBuilderParam()
--    param.newCarId = carid
--    param.buildType = CarBuilderType.Assemble
--    param.parent = UIManager:Get():GetMeshCanvasRoot()
--    param.finishParam = { carid, showcfg, resetTween }
--
--    param.finishEvt = function(id, obj, param)
--        print("----   SetCarMesh_Default:finish   ", id, obj, param[1])
--        if param[3] then CommonHelper:MeshRoot_PlayTween() end
--    end
--    local result = CarBuilderManager:Get():BuildCar(param)
--
--    local carid = CommonHelper:AnalyseCarId(carid)
--    CommonHelper:SetCarMesh_Cfg(carid, showcfg)
--    return result
--end

--function CommonHelper:RebuildSelfCar(id)
--    local param = CarBuilderParam()
--    CarBuilderManager:Get():ReBuildCar(id, param)
--end


--function CommonHelper:MeshRoot_DisableTween()
--    local root = UIManager:Get():GetMeshCanvasRoot()
--    if root then
--        local tween = UIUtil.GetGameobjectComponent(root, typeof(Tweener))
--        if tween then tween.enabled = false end
--    end
--end
--function CommonHelper:MeshRoot_PlayTween()
--    local root = UIManager:Get():GetMeshCanvasRoot()
--    if root then
--        local tween = TweenRotation.Begin(root, Vector3(0, 0, 0), Vector3(0, 360, 0), 20)
--        tween.style = Style.Loop
--    end
--end

--function CommonHelper:SetCarMesh_Cfg(carid, showcfgid)
--    -----@type car_config_cell
--    --local carcfg = CommonHelper:GetTableDataByID(ConfigNames.car_config, carid)
--    --if carcfg then
--    --    local showid = nil
--    --    if showcfgid == CarShowCfgID.Assemble then
--    --        showid = carcfg.showcfg
--    --    end
--    --    if showcfgid == CarShowCfgID.Appearance then
--    --        showid = carcfg.apshowcfg
--    --    end
--    --
--    --    if showid == nil then
--    --        print("---   Error:SetCarMesh_Cfg   showid = nil,showcfgid = ", showcfgid)
--    --    else
--    --        ---@type carmeshcfg_config_cell
--    --        local carmeshcfg = CommonHelper:GetTableDataByID(ConfigNames.carmeshcfg_config, showid)
--    --        if carmeshcfg then
--    --            ---@type lightgroupcfg_config_cell
--    --            local lightcfg = CommonHelper:GetTableDataByID(ConfigNames.lightgroupcfg_config, carmeshcfg.lightid)
--    --            if lightcfg then
--    --                LightGroupManager:Get():BuildLight(lightcfg.resname)
--    --            end
--    --            ---@type meshcameracfg_config_cell
--    --            local cameracfg = CommonHelper:GetTableDataByID(ConfigNames.meshcameracfg_config, carmeshcfg.cameraid)
--    --            if cameracfg then
--    --                UIManager:Get():SetPostionRotationMeshCamera(cameracfg.NewPos, cameracfg.NewRot)
--    --            end
--    --        end
--    --
--    --    end
--    --
--    --
--    --end
--end


function CommonHelper:GetMaterialOriginalName(mat)
    if mat then
        local name = CSUtil.GetMaterialOriginalName(mat.name)
        return name
    else
        return ""
    end
end

function CommonHelper:SetSliderProgress(sliderComponent, percent, textName, parent)
    sliderComponent.value = percent
    local sliderStr = string.format("%d%%", percent * 100)
    CommonHelper:SetText(textName, parent, sliderStr)
end

----------------------------------------------判断字符串是否只包含空格符号
function CommonHelper:IsOnlySpaceCharacter(str)
    return str ~= nil and string.match(str, "^%s*$")
end

----------------------------------------------获取utf-8格式下字符串的长度
function CommonHelper:IsNullOrEmpty(str)
    return str == nil or str == ''
end

function CommonHelper:GetUtf8StrLen(str)
    if self:IsNullOrEmpty(str) then
        logError("字符串不能为空")
        return -1
    else
        local length = string.len(str)
        local left = length
        local cnt = 0
        local arr = { 0, 0xc0, 0xe0, 0xf0, 0xf8, 0xfc }
        while left ~= 0 do
            local tmp = string.byte(str, -left)
            local i = #arr
            while arr[i] do
                if tmp >= arr[i] then
                    left = left - i
                    break
                end
                i = i - 1
            end
            cnt = cnt + 1
        end
        return cnt
    end
end

function CommonHelper:NumberRounder(number)
    local integer, fraction = math.modf(number)
    if fraction >= 0.5 then
        integer = integer + 1
    end
    return integer
end

function CommonHelper:SendGMMsg(info)
    local reqData = {
        cmd = info,
    }
    local reqBytes = assert(Dll_PB.encode("GmCmdReq", reqData))
    NetManager:Get():Send(15, reqBytes)
end
--function CommonHelper:TestGM()
--    ---@type parts_config
--    local tab = ClientDataManager:Get():GetDataTable(ConfigNames.parts_config)
--    local list = tab.GetConfigData()
--    for k, v in pairs(list) do
--        local cmd = "additem:".. v.id.."@1"
--        CommonHelper:SendGMMsg(cmd)
--    end
--end

function CommonHelper:SetBoxState(name, parent, state)
    local box = UIUtil.GetTypeChildWightInputPath(name, parent, typeof(BoxState))
    if box then
        if state == 0 then
            box:SetNotOpen()
        end
        if state == 1 then
            box:SetCanOpen()
        end
        if state == 2 then
            box:SetHaveOpen()
        end
    end
    return box

end

function CommonHelper:SetBoxStateSlider(name, parent, data, func)
    local boxslider = UIUtil.GetTypeChildWightInputPath(name, parent, typeof(BoxStateSlider))
    if boxslider then
        boxslider:SetDate(data, function(boxSlider, item, index)
            func(item, index, boxSlider)
        end)
        LuaRelevance:Get():AddBoxSlider(boxslider)
    end
    return boxslider
end

function CommonHelper:RefreshBoxStateSlider(boxslider)
    if boxslider then
        boxslider:Refresh()
    end
    return boxslider
end

function CommonHelper:GetReformQuality(quality)
    if quality == 0 then
        return "普通改造"
    end
    if quality == 1 then
        return "高级改造"
    end
    if quality == 2 then
        return "完美改造"
    end
end

---@param cfg PartReformAttrCfg
function CommonHelper:GetReformAttrValue(cfg, reformid, partid, quality, lv)
    --if cfg == nil or reformid == nil or partid == nil or quality == nil or lv == nil then
    --    log("---   error:CommonHelper:GetReformAttrValue", cfg, reformid, partid, quality, lv)
    --    return "0"
    --end
    --
    -----@type PartReformCfg
    --local partreformcfg = 0
    -----@type parts_config_cell
    --local partcfg = CommonHelper:GetTableDataByID(ConfigNames.parts_config, partid)
    --if partcfg then
    --    for i = 1, #partcfg.NewReform do
    --        if partcfg.NewReform[i].reformid == reformid then
    --            partreformcfg = partcfg.NewReform[i]
    --            break
    --        end
    --    end
    --end
    --
    --local result = 0
    --for i = 1, #partreformcfg.attrtype do
    --    local type = partreformcfg.attrtype[i]
    --    local max = partreformcfg.attrmax[i]
    --    if type == cfg.type then
    --        result = max * cfg.formulaParam2[quality] * lv
    --    end
    --end
    --
    --return CommonHelper:GetAttrValue(cfg.type, result)
end

function CommonHelper:SetAttrFeatureIcon(type, value, obj)
    -----@type attrtype_config_cell
    --local cfg = CommonHelper:GetTableDataByID(ConfigNames.attrtype_config, type)
    --if cfg == nil then
    --    return
    --end
    --
    ----上
    --local temp = UIUtil.GetChild("type1", obj)
    --if temp then
    --    temp:SetActive(CommonHelper:GetAttrFeature(type, value) == AttrFeature.TypeUp)
    --end
    --
    ----下
    --temp = UIUtil.GetChild("type2", obj)
    --if temp then
    --    temp:SetActive(CommonHelper:GetAttrFeature(type, value) == AttrFeature.TypeDown)
    --end
    --
    ----平衡
    --temp = UIUtil.GetChild("type3", obj)
    --if temp then
    --    temp:SetActive(CommonHelper:GetAttrFeature(type, value) == AttrFeature.TypeMid)
    --end
    --
    ----特殊
    --temp = UIUtil.GetChild("type4", obj)
    --if temp then
    --    temp:SetActive(CommonHelper:GetAttrFeature(type, value) == AttrFeature.TypeSpecial)
    --end
    --
    --CommonHelper:SetText("value", obj, CommonHelper:GetShowArrtValue(type, value, 3))
    --CommonHelper:HButtonSetCallback("featureBtn", obj, function(data)
    --    --UINotify:Get():SendNotification(UINotifyEvent.OpenAttributeView, { type, value })
    --end)
end

function CommonHelper:SetPartFeature(type, obj)
    local temp = UIUtil.GetChild("type1", obj)
    if temp then
        temp:SetActive(type == PartFeature.Type_1)
    end
    temp = UIUtil.GetChild("type2", obj)
    if temp then
        temp:SetActive(type == PartFeature.Type_2)
    end
    temp = UIUtil.GetChild("type3", obj)
    if temp then
        temp:SetActive(type == PartFeature.Type_3)
    end
    temp = UIUtil.GetChild("type4", obj)
    if temp then
        temp:SetActive(type == PartFeature.Type_4)
    end
    if type == PartFeature.Type_1 then
        CommonHelper:SetText("value", obj, "速度")
    end
    if type == PartFeature.Type_2 then
        CommonHelper:SetText("value", obj, "加速")
    end
    if type == PartFeature.Type_3 then
        CommonHelper:SetText("value", obj, "稳定")
    end
    if type == PartFeature.Type_4 then
        CommonHelper:SetText("value", obj, "耐久")
    end
end


-- 设置Image 或者 是 RawImage 的颜色
function CommonHelper:SetImageColor(Image, color)
    if Image == nil or color == nil then
        return
    end
    Image.color = UIUtil:HexToColorRGB(color)
end
-- 设置Image 或者 是 RawImage 的颜色
function CommonHelper:SetImageColorRGBA(Image, color)
    if Image == nil or color == nil then
        return
    end
    Image.color = UIUtil:HexToColor(color)
end


-- 设置RawImage颜色
local popupWindows = {}
-- 设置面板进入游戏是否需要主动弹出
function CommonHelper:SetWindowsIsPopup(view, toggle)
    if toggle == true then
        table.insert(popupWindows, view)
    end
end
function CommonHelper:SetWindowsPopup()

end

-- 检测玩家是否是新用户
function CommonHelper:CheckPlayerIsNewUser()
    return #CarDataManager:Get():GetCarList() > 0
end
-- 检测玩家是否需要新手引导
function CommonHelper:CheckPlayerIsNewGuide()
    if  PlayerDataManager:Get():GetPlayerLV()>8 and PlayerDataManager:Get():GetGuideStep()<GuideState.GuideNewPlayer then
        return false
    end
    if GuideManager:Get():GetCurGuideStep() ~= nil and GuideManager:Get():GetCurGuideStep() ~= 0 then
        return true
    end
    return GameProperties.NewBieGuide and GuideManager:Get():CheckGuideExit(PlayerDataManager:Get():GetGuideStep())
end
-- 检测玩家是否是本日第一次登陆
function CommonHelper:CheckPlayerIsFirstLogin()
    return PlayerDataManager:Get():GetDailyLoginNum() == 1
end
function CommonHelper:CheckPlayerCurrencyIsEnough(moneyType, num)
    local playerMoney = PlayerDataManager:Get():GetCurrency(moneyType)
    if playerMoney == -1 then
        return false
    end
    return playerMoney >= num
end

----------------------------------------------页签选中排序组件
function CommonHelper:InitTagGroupAutoSort(tagGroupAutoSort, dataCount, funSetup, defaultIndex)
    tagGroupAutoSort:Setup(dataCount, funSetup, defaultIndex)
end
function CommonHelper:TagGroupRePostion(tagGroupAutoSort, index)
    tagGroupAutoSort:RePostion(index)
end

---------------------------------------------根据头像类型获取头像
---@param headIconType HeadIconType
---@param headIconAttrType HeadIconAttrType
---@return table<number,headicon_config_cell>
function CommonHelper:GetHeadIconsByType(headIconType, headIconAttrType)
    ---@type dictheadicon_config
    local headIconCfg = ClientDataManager:Get():GetDataTable(ConfigNames.headicon_config)
    local tempIcons = {}
    if headIconType then
        if not headIconAttrType then
            tempIcons = headIconCfg.GetConfigDataByType(headIconType)
        else
            tempIcons = headIconCfg.GetConfigDataByType(headIconType, headIconAttrType)
        end
    end
    table.sort(tempIcons, function(a, b)
        return a.C_ID < b.C_ID
    end)
    return tempIcons
end
local Fly=nil
local FlyGo=nil
local FlyAsset=nil
----------------------------------------------播放收集金币的特效
function CommonHelper:PlayCollectCurrency(image, flyImageNumberLevel, targetPos, startPos,count,range,func)
    if Fly==nil then
        FlyAsset = AssetsManager.Load("flyimageeffect.prefab", typeof(GameObject))
        FlyGo = CommonHelper:InstantiateGameObjectByObject(FlyAsset.asset)
    end
    CommonHelper:CSGameObjectSetActive(FlyGo,true)
    FlyGo.transform:SetParent(UIManager:Get():GetCanvasByType(CanvasType.FrontCanvas).transform,false)
    if targetPos==nil then targetPos=UIUtil.GetChild("defaulttarget",FlyGo).transform end
    if startPos==nil then startPos=UIUtil.GetChild("defaultstart",FlyGo).transform end
    local defaultStart=UIUtil.GetChild("defaultstart",FlyGo).transform.localPosition
    Fly = FlyGo:GetComponent(typeof(FlyImageEffect))
    Fly:SetCount(count or 18,range or 100)
    Fly:Execute(image, flyImageNumberLevel or FlyImageNumberLevel.middle, startPos.transform, targetPos.transform, function()
           UIUtil.GetChild("defaultstart",FlyGo).transform.localPosition=defaultStart
           CommonHelper:CSGameObjectSetActive(FlyGo,false)
          func()
    end)
end
function CommonHelper:UnloadCollectCurrency()
    if Fly then
        GameObject.DestroyImmediate(Fly)
        GameObject.DestroyImmediate(FlyGo)
        AssetsManager.Unload(FlyAsset)
        FlyGo=nil
        Fly=nil
        FlyAsset=nil
    end
end
local CostPeas=nil
local CostPeasGo=nil
local CostPeasAsset=nil
----------------------------------------------播放飞豆豆特效
function CommonHelper:PlayFlyPeasEffect(startPos, targetPos,is2d,func,durTime)
    if CostPeas==nil then
        CostPeasAsset = AssetsManager.Load("flypeaseffect.prefab", typeof(GameObject))
        CostPeasGo = CommonHelper:InstantiateGameObjectByObject(CostPeasAsset.asset)
    end
    if targetPos==nil then targetPos=UIUtil.GetChild("defaulttarget",FlyGo).transform end
    CostPeas = CostPeasGo:GetComponent(typeof(FlyPeasEffect))
    CostPeas.timeToTarget=durTime or 0.3
    CostPeas:Execute(startPos.transform, targetPos.transform, function()
        if func then
            func()
        end
    end,is2d or true)
end
function CommonHelper:UnloadFlyPeasEffect()
    if CostPeas then
        GameObject.DestroyImmediate(CostPeasGo)
        GameObject.DestroyImmediate(CostPeas)
        AssetsManager.Unload(CostPeasAsset)
         CostPeas=nil
         CostPeasGo=nil
         CostPeasAsset=nil
    end
end

----------------------------------------------------------聊天分享
---@param shareType ShareType
---@param clubChatType ChatType
function CommonHelper:ShareItemToChat(shareType, clubChatType, param)
    if shareType == ShareType.Article then
        CommonHelper:ShareArticleToChat(clubChatType, param, "#EFC744")
    elseif shareType == ShareType.Car then

    elseif shareType == ShareType.PlayBack then
    else
    end
end
------------------------------------------------------聊天分享物品
---@param clubChatType ChatType
---@param param ArticleCell
function CommonHelper:ShareArticleToChat(clubChatType, param)
    if clubChatType == ChatType.Club then
        UIManager:Get():ClosePopup()

        --UINotify:Get():SendNotification(UINotifyEvent.ClubListView_OpenWhichView)
        local partName = ClientDataManager:Get():GetTemplateString(param:GetPartConfig().partname)
        if not param:IsPart() then
            partName = ClientDataManager:Get():GetTemplateString(param:GetArticleConfig().name)
        end
        local ChatShareParam = ChatShareParam()
        ChatShareParam.shareType = ShareType.Article
        ChatShareParam.cellId = param:GetCellID()
        ChatShareParam.shareId = param:GetArticleID()
        ChatShareParam.shareName = partName
        ChatShareParam.chatType = clubChatType
        ShareDataManager:Get():AddShareData(ChatShareParam)
    end
end

---------------------------------------------------过滤昵称
---@return boolean @true 代表通过 false 不通过
function CommonHelper:ReviewNicknameV2(nickName)
    --local resultStr = SDKManager:Get():ReviewNicknameV2(nickName)
    --
    --monoAndroidUtility.DebugLog("ReviewNicknameV2-----返回值:  " .. resultStr)
    --
    --if resultStr == "" then
    --    return true
    --end
    --
    --local isRight = false
    -----@type NetEaseEnvNickName
    --local jsonTab = Dll_JSON.decode(resultStr)
    --
    --local code = tostring(jsonTab.code)
    --if code ~= "202" then
    --    isRight = true;
    --end
    --
    --local isRightStr = isRight == true and "true" or "false"
    --monoAndroidUtility.DebugLog("ReviewNicknameV2-----isRight=：" .. isRightStr)
    --if not isRight then
    --    CommonTipsHelper:ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.BanName))
    --end

    return true
end

---------------------------------------------------过滤发言内容
---如果内容包含敏感字，则返回false和替换后的发言内容
---@return boolean @是否满足
function CommonHelper:ReviewWordsV2(level, channel, content)
    local resultStr = content

    monoAndroidUtility.DebugLog("ReviewWordsV2-----返回值:  " .. resultStr)

    if resultStr == "" then
        return true
    end
    if true then
        return true
    end

    local isRight = false
    ---@type NetEaseEnvNickName
    local jsonTab = Dll_JSON.decode(resultStr)

    local code = tostring(jsonTab.code)
    if code ~= "202" and code ~= "206" and code ~= "207" then
        isRight = true
    end

    if code == "206" then
        return isRight, jsonTab.message
    end
    local isRightStr = isRight == true and "true" or "false"
    monoAndroidUtility.DebugLog("ReviewWordsV2-----isRight=：" .. isRightStr)

    if not isRight then
        CommonTipsHelper:ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.BanContent))
    end
    return isRight
end

-------------------------------------------------文本超链接注册点击事件
---@param lineType XTextLineType
function CommonHelper:RegisterXTextClickEvent(XText, id, action, customInfo, lineType, hyperColor)
    if XText then
        lineType = lineType or XTextLineType.None
        XText:SetHyperData(id, action, customInfo, lineType, hyperColor);
    end
end

function CommonHelper:SetRectSizeDeltaByName(name, parent, x, y)
    local rect = UIUtil.GetTypeChildWightByParent(name, parent, typeof(RectTransform))
    x = x or rect.sizeDelta.x
    y = y or rect.sizeDelta.y
    rect.sizeDelta = Vector2(x, y)
    return rect, rect.sizeDelta
end

function CommonHelper:SetObjRectSizeDelta(go, sizeDelta)
    local rect = UIUtil.GetGameobjectComponent(go, typeof(RectTransform))
    rect.sizeDelta = sizeDelta
    return rect, rect.sizeDelta
end

function CommonHelper:SetRectPosByName(name, parent, x, y)
    local rect = UIUtil.GetTypeChildWightByParent(name, parent, typeof(RectTransform))
    x = x or rect.anchoredPosition.x
    y = y or rect.anchoredPosition.y
    rect.anchoredPosition = Vector2(x, y)
    return rect, rect.anchoredPosition
end

function CommonHelper:SetObjRectPos(obj, x, y)
    local rect = UIUtil.GetGameobjectComponent(obj, typeof(RectTransform))
    x = x or rect.anchoredPosition.x
    y = y or rect.anchoredPosition.y
    rect.anchoredPosition = Vector2(x, y)
    return rect, rect.anchoredPosition
end

function CommonHelper:GetRectPosByName(name, parent)
    local rect = UIUtil.GetTypeChildWightByParent(name, parent, typeof(RectTransform))
    return rect.anchoredPosition, rect
end

function CommonHelper:GetObjRectPos(obj)
    local rect = UIUtil.GetGameobjectComponent(obj, typeof(RectTransform))
    return rect.anchoredPosition, rect
end

---------------------------------------------------设置gameobject显示隐藏
function CommonHelper:SetGameObjectActive(objname, parent, active)
    local obj = UIUtil.GetChildInputPath(objname, parent)
    if obj then
        obj:SetActive(active)
    end
    return obj
end
function CommonHelper:CSGameObjectSetActive(obj, active)
    if not CommonHelper:IsNullOrEmpty(obj) then
        obj:SetActive(active)
    end
end

----------------------------------------------操作系统剪贴板
function CommonHelper:WriteClipboart(value, tottle)
    mono.WriteClipboart(value)
    CommonTipsHelper:ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.WriteClipboardSucceed))
end
function CommonHelper:ReadClipboard()
    return mono.ReadClipboard()
end

---@param rewardData table<number,RewardData>
function CommonHelper:ShowRewardPopup(rewardData, tittle)

    UIManager:Get():ShowPersistentView("ShowRewardView", CanvasType.FrontCanvas, "ShowRewardView")
    UINotify:Get():SendNotification(UINotifyEvent.OpenShowRewardView, { rewardData, tittle })

end

---------------------------------------------------获取货币图标
function CommonHelper:GetCurrencyTypeImage(type)

    local cfg = CommonHelper:GetTableDataByID(ConfigNames.currency_config, type)
    if cfg ~= nil then
        return cfg.icon2
    end
    if type == CurrencyType.Privilege then

    end
    print("---   error:获取image异常，没有资源，GetCurrencyTypeImage   type = ", type)
    return "common_bg_default_white_dt"
end
---------------------------------------------------获取货币名称
---@param type CurrencyType
function CommonHelper:GetCurrencyTypeName(type)

    local cfg = CommonHelper:GetTableDataByID(ConfigNames.currency_config, type)
    if cfg ~= nil then
        -- ClientDataManager:Get():GetTemplateString()
        return ClientDataManager:Get():GetTemplateString(cfg.name)
    end
    if type == CurrencyType.Privilege then
        print("SSSSSSSSSS", cfg.icon2)
    end
    print("---   error:获取image异常，没有资源，GetCurrencyTypeImage   type = ", type)
    return "common_bg_default_white_dt"
end

---@return string,string
function CommonHelper:AnalyseNPCNameAndIconById(npcid)
    local name = ""
    local icon = ""
    ---@type dictnpc_config_cell
    local npccfg = CommonHelper:GetTableDataByID(ConfigNames.dictnpc_config, npcid)
    if npccfg then
        name = CommonHelper:GetTempStr_Default(npccfg.name)

        ---@type hero_config_cell
        local heroCfg = CommonHelper:GetTableDataByID(ConfigNames.hero_config, npccfg.hero)
        if heroCfg then
            icon = heroCfg.NewIcon
        end
    end
    return name, icon
end

function CommonHelper:ConvertStringToByteArray(str, encoding)
    encoding = encoding or "ISO-8859-1"
    local bytes = CS.MonoHelper.ConvertStringToByteArray(str, encoding)
    return bytes
end

function CommonHelper:GetRectSizeData(name, parent)
    local rect = UIUtil.GetTypeChildWightByParent(name, parent, typeof(RectTransform))
    if rect then
        return rect.sizeDelta, rect
    else
        logError("没找到该物体的RectTransform组件")
        return nil
    end
end

function CommonHelper:GetObjSizeData(obj)
    local rect = UIUtil.GetGameobjectComponent(obj, typeof(RectTransform))
    if rect then
        return rect.sizeDelta, rect
    else
        logError("没找到该物体的RectTransform组件")
        return nil
    end
end

function CommonHelper:GetRankString(rank)
    local rankStringList = {
        "第一名",
        "第二名",
        "第三名",
        "第四名",
        "第五名",
    }
    if rankStringList[rank] ~= nil then
        return rankStringList[rank]
    else
        print("输入排名不存在")
        return ""
    end
end
local ShareTime={}
ShareTime[ShareType.ClubInvite]=nil
ShareTime[ShareType.RoomInvite]=nil
ShareTime[ShareType.ChallengeMatchInvite]=nil
local yieldShareTime=30
---房间分享至聊天
---@param shareType ShareType
---@param param table<number,number>@参数是一个table,以key-value形式存储
---@param showPos Vector3 分享界面的显示位置
function CommonHelper:ShareToChat(shareType, param, showPos)
    local boxfunc = function()
        if CommonHelper:CheckPlayerIsNewGuide() then
            self:ConfirmShareToChat(shareType, param, showPos)
        else
            local content = CommonHelper:GetTempStr_Default(TemplateStringID.ShareConfirmTip)
            local ret = nil
            if ShareTime[shareType] ~= nil then
                local subTime = CommonHelper:SubTimeByDateTime(ShareTime[shareType])--
                local day,hour,minute,second=CommonHelper:GetConvertMillSecond(math.abs(subTime))
                second = yieldShareTime - second
                if second > 0 then
                    content = CommonHelper:GetTempStr_Default(TemplateStringID.ShareToChatCD,CommonHelper:GetShareNameByType(shareType))..string.format( CommonHelper:GetTempStr_Default(TemplateStringID.CountdownTip),second)
                    ret = MessageBoxHelp:Get():OpenBox_OK(UIColor.Blue,content , nil, nil, nil, true, false, true)
                else
                    ShareTime[shareType] = nil
                    local ret = MessageBoxHelp:Get():OpenBox_OK(UIColor.Blue,content , nil, nil, nil, true, false, true)
                    if ret == MessageBoxHelp.BtnType.OK then
                        self:ConfirmShareToChat(shareType, param, showPos)
                    end
                end
            else
                local ret = MessageBoxHelp:Get():OpenBox_OK(UIColor.Blue,content , nil, nil, nil, true, false, true)
                if ret == MessageBoxHelp.BtnType.OK then
                    self:ConfirmShareToChat(shareType, param, showPos)
                end
            end
        end
    end
    MessageBoxHelp.Get():StartCoroutineBox(boxfunc)
end

function CommonHelper:ConfirmShareToChat(shareType, param, showPos)
    if ShareTime[shareType]~=nil then
        CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.ShareToChatCD,CommonHelper:GetShareNameByType(shareType)))
        return
    end

    param.shareType = shareType
    local str = Dll_JSON.encode(param)
    ChatSubsystem:Get():SendMsg_ChatData(ChatType.Invite, "", 0,str)
    CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.ShareSuccess))
    --UIManager:Get():OpenPopup("ChatInviteTypeView", CanvasType.MainCanvas, "ChatInviteTypeView")
    --UINotify:Get():SendNotification(UINotifyEvent.ChatShareTypeView_InitViewInfo, { shareType, str, showPos })
    ShareTime[shareType] = CommonHelper:GetNowTime()
end

function CommonHelper:CloseShareInviteView()
    if UIManager:Get():IsPopViewShow("ChatInviteTypeView") then
        UIManager:Get():ClosePopup()
    end
    if UIManager:Get():IsPopViewShow("RaceInviteFriendView") then
        UIManager:Get():ClosePopup()
    end
end

---房间邀请好友
---@param shareType ShareType
function CommonHelper:RoomInvite(shareType)
    UIManager:Get():OpenPopup("RaceInviteFriendView", CanvasType.MainCanvas, "RaceInviteFriendView")
    UINotify:Get():SendNotification(UINotifyEvent.RaceInviteFriendView_InitViewInfo, shareType)
end

----打开房间邀请弹出框，就是别人邀请你，你这边要弹出一个框
function CommonHelper:OpenInvitePopView()
    local isCanShow = InviteDataManager:Get():GetIsCanPop()
    if isCanShow then
        local chatMsgData = InviteDataManager:Get():GetInviteMsgByIdxType(ChatInviteType.RaceRoom, nil)
        if chatMsgData then
            UIManager:Get():OpenPopup("RoomInvitePopView", CanvasType.MainCanvas, "RoomInvitePopView")
            UINotify:Get():SendNotification(UINotifyEvent.RoomInvitePopView_InitViewInfo)
        else
            print("当前没有房间邀请......")
        end
    else
        print("当前没有房间邀请......")
        InviteDataManager:Get():RemoveInviteMsgByIdxType(ChatInviteType.RaceRoom, nil)

    end
end

----初始化聊天界面，比如房间赛里面有聊天
---@param chatType ChatType
---@param sendBtnFunc function @这个是聊天消息发送按钮的功能，根据不同的系统，发送的消息可能不同
function CommonHelper:InitChatViewData(chatType, parent, uiModuleID, sendBtnFunc)
    local chatViewPrefab = UIUtil.GetChild("ChatViewData", parent)
    local chatViewData = ChatViewData()
    chatViewData:InitData(chatViewPrefab, uiModuleID, sendBtnFunc)
    chatViewData:InitTogState(chatType)


    return chatViewData
end

----初始化简洁聊天，比如房间里面点解聊天
function CommonHelper:InitQuickChat(chatType, parent, uiModuleID)
    ChatDataManager:Get():SetChatType(chatType)

    local quickChatPrefab = UIUtil.GetChild("Page_QuickChat", parent)
    local pageQuickChat = PageQuickChat()
    pageQuickChat:InitData(chatType, quickChatPrefab, uiModuleID)
    -- 屏蔽聊天
    CommonHelper:SetGameObjectActive("Page_QuickChat", parent, false)
    return pageQuickChat
end

----初始化简洁聊天，比如主界面聊天
function CommonHelper:InitMainChat(chatType, parent, uiModuleID)
    local mainChatPrefab = UIUtil.GetChild("Page_MainChat", parent)
    local pageMainChat = PageMainChat()
    pageMainChat:InitData(chatType, mainChatPrefab, uiModuleID)
    return pageMainChat
end

----初始化单个类型的聊天,带头像的
function CommonHelper:InitSingleChannelChat(chatType, parent, uiModuleID)
    local singleChannelChatPrefab = UIUtil.GetChild("Page_SingleChannelChat", parent)
    local singleChannelChat = PageSingleChannelChat()
    singleChannelChat:InitData(chatType, singleChannelChatPrefab, uiModuleID, parent)
    return singleChannelChat
end

----初始化单个类型的聊天，不带头像的，比如房间赛聊天
function CommonHelper:InitSingleChannelChat_2(chatType, parent, uiModuleID, idColorTab)
    local singleChannelChat2Prefab = UIUtil.GetChild("Page_SingleChannelChat_2", parent)
    local singleChannelChat_2 = PageSingleChannelChat_2()
    singleChannelChat_2:InitData(chatType, singleChannelChat2Prefab, uiModuleID, idColorTab)
    -- 屏蔽房间赛聊天
    --  CommonHelper:SetGameObjectActive("Page_SingleChannelChat_2",parent, false)
    return singleChannelChat_2
end

---@param cfg parts_config_cell
---@return features_config_cell
function CommonHelper:GetShellFeatureByPartCfg(cfg)
    if cfg then
        ---@type dictpartbase_config_cell
        local partBaseCfg = CommonHelper:GetTableDataByID(ConfigNames.dictpartbase_config, cfg.baseid)
        ---@type carshell_config_cell
        local shellcfg = CommonHelper:GetTableDataByID(ConfigNames.dictpartcell_config, partBaseCfg.NewShellId)
        if shellcfg then
            if #shellcfg.NewFeature > 0 then
                ---@type features_config_cell
                local featurecfg = CommonHelper:GetTableDataByID(ConfigNames.features_config, shellcfg.NewFeature[1])
                return featurecfg
            end
        end
    end
    return nil
end
---@param cfg carshell_config_cell
---@return features_config_cell
function CommonHelper:GetShellFeatureByCarShellCfg(cfg)
    if cfg then
        if #cfg.NewFeature > 0 then
            ---@type features_config_cell
            local featurecfg = CommonHelper:GetTableDataByID(ConfigNames.features_config, cfg.NewFeature[1])
            return featurecfg
        end
    end
    return nil
end

function CommonHelper:SetPlayerIcon(objName, parent, icon, frame, bg, uiModuleID, isOffline)

    local head = UIUtil.GetChild(objName, parent)
    if head then
        if icon ~= nil then
            CommonHelper:GetComponentSetUITexture("icon", head, icon, uiModuleID)
        end
        if frame then
            CommonHelper:GetComponentSetUITexture("iconframe", head, frame, uiModuleID)
        end

        -- CommonHelper:GetComponentSetUITexture("iconbg",head,bg,uiModuleID)
        --CommonHelper:ImageSetGray(head, isOffline)
    end

end
function CommonHelper:SetPlayerIconById(objName, parent, icon, frame, bg, uiModuleID)
    local head = UIUtil.GetChildInputPath(objName, parent)
    if head then
        if icon then
            CommonHelper:GetComponentSetUITexture("icon", head, CommonHelper:GetPlayerIconById(icon), uiModuleID)
        end
        if frame then
            CommonHelper:GetComponentSetUITexture("iconframe", head, CommonHelper:GetPlayerIconById(frame, nil, HeadIconAttrType.Frame), uiModuleID)
        end
        -- CommonHelper:GetComponentSetUITexture("iconbg",head,CommonHelper:GetPlayerIconById(bg),uiModuleID)
    end
end

---@param status ServerStatus
function CommonHelper:SetServerStatus(objName, parent, status)
    local state = UIUtil.GetChildInputPath(objName, parent)
    if state then
        CommonHelper:SetGameObjectActive("serverstate1", state, status == ServerStatus.Normal)
        CommonHelper:SetGameObjectActive("serverstate2", state, status == ServerStatus.Test)
        CommonHelper:SetGameObjectActive("serverstate3", state, status == ServerStatus.Hot)
    end
end

function CommonHelper:ShowAttrInfoView(type)
    UIManager:Get():OpenPopup("AttributeView", CanvasType.FrontCanvas, "AttributeView", true)
    UINotify:Get():SendNotification(UINotifyEvent.AttributeView_SetData, type)
end

---@param type number 1:小尺寸  2:中等尺寸
function CommonHelper:SetRankLvGroup(name, parent, type, score, uimoduleid)
    local obj = UIUtil.GetChild(name, parent)
    if obj then
        local curcfg = CommonHelper:GetRankCfgByScore(score)
        if curcfg then
            if type == 1 then
                CommonHelper:GetComponentSetImage("rankicon", obj, CommonHelper:GetRankLvIconSmall(curcfg.rankidx), uimoduleid)
            end
            if type == 2 then
                CommonHelper:GetComponentSetImage("rankicon", obj, CommonHelper:GetRankLvIconNormal(curcfg.rankidx), uimoduleid)
            end

            for i = 1, 5 do
                CommonHelper:SetGameObjectActive("star" .. i, obj, curcfg.star == i)
            end
        end
    end
end
function CommonHelper:GetVersion_1()
   local table=stringSplit(CommonHelper:GetClientVersion(),".")
    return table[1]
end

function CommonHelper:GetClientVersion(func)
    if  GameProperties.HotfixEnable then
        return HVersionManager.tempServerVersion
    else
        return "9999.9999.9999"
    end
end
function CommonHelper:GetClientPkeVersion()
    if   GameProperties.HotfixEnable then
        local pkgverison="" if HVersionManager.TempPkgVersion ~=nil and HVersionManager.TempPkgVersion~="" then pkgverison=HVersionManager.TempPkgVersion end
        return pkgverison
    else
        return "9999.9999.9999"
    end
end

--打开升级界面，在所有界面关闭的时候，如果可能升级，就调用这个
function CommonHelper:OpenLevelUpView()
    local result = PlayerLevelUpDataManager:Get():GetIsUpgrade()
    if result then
        PopupManager:Get():AddRallyPopup(function()
            UIManager:Get():OpenPopup("PlayerLevelUpView", CanvasType.TopCanvas, "PlayerLevelUpView", true)
            UINotify:Get():SendNotification(UINotifyEvent.PlayerLevelUpView_InitViewInfo)

        end)
    end
    return result
end
---@type
function CommonHelper:CheckPlayerLevelUp(level)
    PlayerLevelUpDataManager:Get():SetIsUpgrade(true)
    PlayerLevelUpDataManager:Get():SetOldData(PlayerDataManager:Get():GetPlayerLV(), PlayerDataManager:Get():GetPlayerEXP(), PlayerDataManager:Get():GetPlayerStamina())
    if level == 2 then
        UnlockDataManager:Get():AddUnlockId(GameFunction.Survey)
    end
    UnlockDataManager:Get():UpdateLockData()
    UnlockDataManager:Get():UpdateLockUIData()
    UnifySDKHelper:Purchase_SubmitRoleInfo(PurchaseRoleInfoData_SubmitType.UpdateRole)
    UnifySDKHelper:SetLevelUpToken(PlayerDataManager:Get():GetPlayerLV())
    --QuickTa:Get():TrackEvent(TrackEventNames.LvUp, QuickTaData:GetLevelup(
    --        PlayerDataManager:Get():GetPlayerLV(),
    --        level,
    --        PlayerDataManager:Get():GetPlayerEXP()
    --))
end

function CommonHelper:CheckUnLockFunctionGuide()
    local unlockTable = UnlockDataManager:Get():GetUnlockByLevelID(PlayerDataManager:Get():GetPlayerLV())--这是解锁的表
    local funcId = {}
    if unlockTable ~= nil then
        for funcIdKey, funcIdKeyValue in pairs(unlockTable) do
            table.insert(funcId, funcIdKeyValue)
        end
    end
    local guideId = -1
    if #funcId > 0 then
        for i = 1, #funcId do
            ---@type functionlist_config_cell
            local cfg = nil
            if ClientDataManager:Get().IsConfig2 then
                cfg = CommonHelper:GetTableDataByID(ConfigNames.functionlist2_config, funcId[i])
            else
                cfg = CommonHelper:GetTableDataByID(ConfigNames.functionlist_config, funcId[i])
            end
            if cfg.newbieguideId ~= -1 and guideId == -1 then
                guideId = cfg.newbieguideId
            end
        end
    end
    return guideId ~= -1
end

function CommonHelper:CameraPortUIFit(name, parent)
    local com = UIUtil.GetTypeChildWightInputPath(name, parent, typeof(CS.Horizon.UI.Control.CameraPortUIFit))
    if com then
        return com:GetPort()
    end
end

----设置UI shader中的bool属性，keyName是shader中的Keyword Name
function CommonHelper:SetShaderBoolValue(name, parent, keyName, isEnable)
    local com = UIUtil.GetTypeChildWightByParent(name, parent, typeof(RawImage))
    if com then
        local material = com.material

        --print("----当前是否开着----", material:IsKeywordEnabled(keyName) == true)
        if material then
            if isEnable then
                material:EnableKeyword(keyName)
            else
                material:DisableKeyword(keyName)
            end
        end
    end
end

----解锁功能，第一个参数是解锁的ID，第二个参数是 解锁后的回调
---@param unlockIds table<number,UnlockID>
function CommonHelper:SetUnlockFunc(unlockIds, func,lockfunc)

    local IsUnLock = false

    for i = 1, #unlockIds do
        if UnlockDataManager:Get():IsUnLock(unlockIds[i]) then
            IsUnLock = true
            break
        end
    end
    if not CS.GameProperties:Get().NewBieGuide then
        IsUnLock = true
    end
    if IsUnLock then
        func()
    elseif lockfunc~=nil then
        lockfunc()
    else
        ---@type functionlist_config_cell
            local cell = nil
            if ClientDataManager:Get().IsConfig2 then
                cell = CommonHelper:GetTableDataByID(ConfigNames.functionlist2_config, unlockIds[1])
            else
                cell = CommonHelper:GetTableDataByID(ConfigNames.functionlist_config, unlockIds[1])
            end
            if cell then
                local level= CommonHelper:GetUnlockLevelByFunId(unlockIds[1])
                if level == -1 then
                    CommonTipsHelper:ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.LevelUnlock))
                else
                    CommonTipsHelper:ShowCenterTips(string.format(CommonHelper:GetTempStr_Default(TemplateStringID.LevelUp), level))
                end
            else
                func()
            end
    end
end
function CommonHelper:GetUnlockLevelByFunId(unlockId)
    local cfg=nil
        if ClientDataManager:Get().IsConfig2 then
             cfg= ClientDataManager:Get():GetDataTable(ConfigNames.escalate2_config)
        else
             cfg= ClientDataManager:Get():GetDataTable(ConfigNames.escalate_config)
        end
    local level= cfg.GetLevelByUnlockId(unlockId)
    if level==nil then
        level=1
    end
    return level
end

----起名字或者修改名字 都是中英文字符 不包括特殊字符
---@param rightFunc function @满足条件后的回调
function CommonHelper:RegexName(name, rightFunc)
    local regex = CSRegex('[`　~!@#$%^&*()\\-+={}\\[\\]:;\'",.<>/?￥%…（）_+|《》『』【】‘；："”“’。，、？\\s\\\\+]')
    local isRight = regex:IsMatch(name)
    if isRight then
        local boxfunc = function()
            local text=CommonHelper:GetTempStr_Default(TemplateStringID.NameHasSpecialCharacter)
            local ret = MessageBoxHelp:Get():OpenBox_OK(UIColor.Blue, text, CommonHelper:GetTempStr_Default(TemplateStringID.GameWarmPrompt), nil, nil, false, false, true)
            if ret == MessageBoxHelp.BtnType.OK then

            end
        end
        MessageBoxHelp.Get():StartCoroutineBox(boxfunc)
    else
        if rightFunc then
            rightFunc()
        end
    end
end

function CommonHelper:ApplicationQuit()
    log("杀死进程")
    CS.UnityEngine.Application.Quit()
end

function CommonHelper:TenToSecond(num, defaultStr)
    --数字转二进制
    local str = ""
    local tmp = num
    while (tmp > 0) do
        if (tmp % 2 == 1) then
            str = str .. "1"
        else
            str = str .. "0"
        end

        tmp = math.modf(tmp / 2)
    end
    str = string.reverse(str)
    if defaultStr ~= nil then
        defaultStr = string.sub(defaultStr, #str + 1)
        str = defaultStr .. str
    end
    return str
end

function CommonHelper:RegisterBtnOnPointUp(btn, onPointUpFunc)
    if btn ~= nil and onPointUpFunc ~= nil then
        btn.onPointUp = onPointUpFunc
        LuaRelevance:Get():AddBtn(btn)
    end
end

function CommonHelper:RegisterBtnOnPointDown(btn, onPointDownFunc)
    if btn ~= nil and onPointDownFunc ~= nil then
        btn.onPointDown = onPointDownFunc
        LuaRelevance:Get():AddBtn(btn)
    end
end

function CommonHelper:LoginTipPop(content, okBtnName, okBtnFunc, cancelBtnName, cancelBtnFunc)
    local boxFunc = function()
        local ret = nil
        if cancelBtnName ~= nil then
            ret = MessageBoxHelp:Get():OpenBox_OKCancel(nil, content, nil, okBtnName, cancelBtnName)
        else
            ret = MessageBoxHelp:Get():OpenBox_OK(nil, content, nil, okBtnName)
        end
        if ret == MessageBoxHelp.BtnType.OK and okBtnFunc ~= nil then
            okBtnFunc()
        elseif ret == MessageBoxHelp.BtnType.Cancel and cancelBtnFunc ~= nil then
            cancelBtnFunc()
        end
    end
    MessageBoxHelp.Get():StartCoroutineBox(boxFunc)
end

---@param kickedType KickedType
function CommonHelper:GetKickTipsByKickType(kickedType)
    if kickedType == KickedType.KickSingleOne or kickedType == KickedType.SingleKick then
        return CommonHelper:GetTempStr_Default(TemplateStringID.LoginTips_1010)
    elseif kickedType == KickedType.MaintainBackToMain then
        return CommonHelper:GetTempStr_Default(TemplateStringID.LoginTips_1012)
    elseif kickedType == KickedType.UpdateExit then
        return CommonHelper:GetTempStr_Default(TemplateStringID.LoginTips_1013)
    elseif kickedType == KickedType.UpdateGoStore then
        return CommonHelper:GetTempStr_Default(TemplateStringID.LoginTips_1012)
    end
end

function CommonHelper:ImageChangeSize(name, parent)
    local imgChangeSize = UIUtil.GetTypeChildWightByParent(name, parent, typeof(ImageChangeSize))
    if imgChangeSize then
        imgChangeSize:ChangeSize()
    end
end

function CommonHelper:ImageChangeSizeByGo(go)
    local imgChangeSize = UIUtil.GetGameobjectComponent(go, typeof(ImageChangeSize))
    if imgChangeSize then
        imgChangeSize:ChangeSize()
    end
end

---@return partsreformfactor_config_cell
function CommonHelper:GetPartReformPerfactCfg(goodstype2, goodstype3)
    ---@type partsreformfactor_config
    local tab = ClientDataManager:Get():GetDataTable(ConfigNames.partsreformfactor_config)
    local cfg = tab.GetDataByType(goodstype2, goodstype3)
    return cfg
end

---@return reformagain_config_cell
function CommonHelper:GetPartReformReplaceCfg(goodstype2)
    ---@type reformagain_config
    local tab = ClientDataManager:Get():GetDataTable(ConfigNames.reformagain_config)
    local cfg = tab.GetDataByType(goodstype2)
    return cfg
end

-- 打开说明书
---@param page EncyclopediaPage
function CommonHelper:OpenEncyclopedia(page)
    UIManager:Get():OpenPopup("EncyclopediaView", CanvasType.MainCanvas, "EncyclopediaView")
    if page == nil or page == EncyclopediaPage.Parts then
        UINotify:Get():SendNotification(UINotifyEvent.EncyclopediaView_ChoosePage, EncyclopediaPage.Parts)
        return
    end
    UINotify:Get():SendNotification(UINotifyEvent.EncyclopediaView_ChoosePage, EncyclopediaPage.Attribute)
end

---@param type GarageTipsTpye
function CommonHelper:ShowGarageTipsView(type, id, value)
    UIManager:Get():OpenPopup("GarageTipsView", CanvasType.TopCanvas, "GarageTipsView",true,false)
    UINotify:Get():SendNotification(UINotifyEvent.GarageTipsView_SetData, { type, id, value })
end

function CommonHelper:SetBtnDelayClick(btn, delayTime, isEnable)
    if btn ~= nil then
        delayTime = delayTime or 0.3
        isEnable = isEnable or false

        if isEnable then
            btn:EnableQuickClick()
        else
            btn:DelayQuickClick(delayTime)
        end
    end
end

---@return article_config_cell
function CommonHelper:GetCarIdxArticleCfg()
    local result
    ---@type dictcalc_config_cell
    local cfg = CommonHelper:GetTableDataByID(ConfigNames.dictcalc_config, GlobalValueKey.CaridxArticleCfgID)
    if cfg then
        result = CommonHelper:GetTableDataByID(ConfigNames.article_config, tonumber(cfg.varval))
    end

    if result == nil then
        log("---   error:CommonHelper:GetCarIdxArticleCfg()   cfg = nil")
    end
    return result
end

---@return article_config_cell
function CommonHelper:GetPowerArticleCfg()
    local result
    ---@type dictcalc_config_cell
    local cfg = CommonHelper:GetTableDataByID(ConfigNames.dictcalc_config, GlobalValueKey.PowerArticleCfgID)
    if cfg then
        result = CommonHelper:GetTableDataByID(ConfigNames.article_config, tonumber(cfg.varval))
    end

    if result == nil then
        log("---   error:CommonHelper:GetPowerArticleCfg()   cfg = nil")
    end
    return result
end


---根据排名获取排位赛奖励的积分
function CommonHelper:GetRankScoreByRank(rank)
    ---@type dictcalc_config_cell
    local cell = CommonHelper:GetTableDataByID(ConfigNames.dictcalc_config, CommonCfgKey.RaceRankScore)
    local scoreStr = stringSplit(cell.varval, ",")
    if #scoreStr > 0 then
        return scoreStr[rank]
    end
end
function CommonHelper:GetRandomName()
    ---@type playername_config
    local playername_config = ClientDataManager:Get():GetDataTable(ConfigNames.playername_config)
    local count = 0
    for k, v in pairs(playername_config.GetConfigData()) do
        count = count + 1
    end
    local surnname = playername_config.GetById(math.random(1, count)).surname
    local name = playername_config.GetById(math.random(1, count)).name
    return CommonHelper:GetTempStr_Default(TemplateStringID.PlayerNameFormat, surnname, name)
end
function CommonHelper:ShowCurrencyNoEnough(key)
    CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.PropNoEnough, CommonHelper:GetPartOrArticleName(key)))
end

function CommonHelper:ShowNoticeMsg(type)
    if NoticeDataManager:Get():IsCanPopNotice() then
        if not UIManager:Get():IsPersistentViewShow("PlayRollView") then
            UIManager:Get():ShowPersistentView("PlayRollView", CanvasType.TopCanvas, "PlayRollView", false, true)
        end
        if type == NoticeType.SystemNotice then
            UINotify:Get():SendNotification(UINotifyEvent.TopLeftInfoView_UpdateRollText_System)
        elseif type == NoticeType.PlayerNotice then
            UINotify:Get():SendNotification(UINotifyEvent.TopLeftInfoView_UpdateRollText_Player)
        end
    end
end
function CommonHelper:GetTrackTypeNameByNumber(type)
    if type == TrackSegmentNumbers.Three then
        return CommonHelper:GetTempStr_Default(TemplateStringID.TrackSegmentThree)
    end
    if type == TrackSegmentNumbers.Five then
        return CommonHelper:GetTempStr_Default(TemplateStringID.TrackSegmentFive)
    end
end

function CommonHelper:Contains(table, element)
    for _, value in pairs(table) do
        if value == element then
            return true
        end
    end
    return false
end
function CommonHelper:GetRankByNum(rank)
    if rank == 1 then
        return CommonHelper:GetTempStr_Default(TemplateStringID.Rank1)
    end
    if rank == 2 then
        return CommonHelper:GetTempStr_Default(TemplateStringID.Rank2)
    end
    if rank == 3 then
        return CommonHelper:GetTempStr_Default(TemplateStringID.Rank3)
    end
end

function CommonHelper:PlayerVideo(name, endFunc, auidoName, onPlayFun, isSkip)
    name=monoVideoMgr:GetVideoPath(name)
    monoVideoMgr.videoEnd = endFunc
    monoVideoMgr.onVideoPlay = onPlayFun
    if isSkip==nil then isSkip=false end
    monoVideoMgr:PlayVideo(name, auidoName, isSkip)
end
function CommonHelper:GetDictCalcData(id, isString)
    local cfg = CommonHelper:GetTableDataByID(ConfigNames.dictcalc_config, id)
    if isString then
        if cfg then
            return cfg.varval
        end
        return ""
    else
        if cfg then
            return tonumber(cfg.varval)
        end
        return 0
    end
end
function CommonHelper:FloatRound(value, position)
    return math.floor(value * position + 0.5) / position
end


function CommonHelper:GetRaceTopStateByState(state)
    local table = {}
    table[RaceTopState.Select32] = TemplateStringID.RaceTopSelect32
    table[RaceTopState.Select16] = TemplateStringID.RaceTopSelect16
    table[RaceTopState.Select8] = TemplateStringID.RaceTopSelect8
    table[RaceTopState.Select4] = TemplateStringID.RaceTopSelect4
    table[RaceTopState.Select2] = TemplateStringID.RaceTopSelect2
    table[RaceTopState.Race32] = TemplateStringID.RaceTopRace32
    table[RaceTopState.Race16] = TemplateStringID.RaceTopRace16
    table[RaceTopState.Race8] = TemplateStringID.RaceTopRace8
    table[RaceTopState.Race4] = TemplateStringID.RaceTopRace4
    table[RaceTopState.Race2] = TemplateStringID.RaceTopRace2
    table[RaceTopState.RaceTop1] = TemplateStringID.RaceTopSelect1
    table[RaceTopState.Settlement] = TemplateStringID.RaceTopSettlement
    return table[state]
end



function CommonHelper:ProfilerTimeSample(name, func)
    CS.UnityEngine.Profiling.Profiler.BeginSample(name)
    func()
    CS.UnityEngine.Profiling.Profiler.EndSample()
end
function CommonHelper:ProfilerTimeSample2(name, func)
    CS.UnityEngine.Profiling.Profiler.BeginSample(name)
    func()
    CS.UnityEngine.Profiling.Profiler.EndSample()
end

function CommonHelper:OpenBuyDirectView(id, maxcount, keepShowPrevious, exid)
    UIManager:Get():OpenPopup("BuyDirectView", CanvasType.FrontCanvas, "BuyDirectView", keepShowPrevious)
    --UINotify:Get():SendNotification(UINotifyEvent.BuyDirectViewSetData, { id, maxcount })
    UINotify:Get():SendNotification(UINotifyEvent.BuyDirectViewSetData, { id, maxcount, exid })
end

function CommonHelper:OpenRecruitGoView(propID, coinID, count, keepShowPrevious)
    UIManager:Get():OpenPopup("RecruitGoView", CanvasType.FrontCanvas, "RecruitGoView", keepShowPrevious)
    UINotify:Get():SendNotification(UINotifyEvent.RecruitGoViewSetData, { propID, coinID, count })
end

function CommonHelper:NewRecruitGoView(PropID, CoinID, _Count, ChargeFunc, ExchangeFunc)
    local MoneyIfEnough = ChargeTipsDataManager:Get():GetMoneyIfEnough(PropID, CoinID, _Count)
    local priceNum = UserDirectManager:Get():GetDataByID(PropID, CoinID)

    if priceNum and MoneyIfEnough > 0 and priceNum.ifalert == 0 then
        ChargeTipsDataManager:Get():SetChargeStateNeedNum(MoneyIfEnough)
        CommonSubsystem:Get():SendMsg_ShowCharge()
    elseif MoneyIfEnough <= 0 and priceNum.ifalert == 0 then
        local needCount = _Count - KnapsackDataManager:Get():GetArticleCountByCfgid(PropID)
        CommonSubsystem:Get():SendMsg_BuyDirect(PropID, needCount, CoinID)
    else
        CommonHelper:OpenRecruitGoView(PropID, CoinID, _Count, true)
    end

    if ChargeFunc then

    end

    if ExchangeFunc then

    end

end


function CommonHelper:PlayPopupVideoByUrl(closeFunc)
    LoginSubSystem:Get():SendMsg_GetPlayVideoUrl(function(json)
        local data = Dll_JSON.decode(json)
        local videourl = ""
        if data.isNet then
            videourl = data.videourl
        else
            videourl = CS.AppPath.StreamingAssetsPath .. "/Movie" .. "/" .. data.videoName
        end
        UIManager:Get():OpenPopup("FullscreenVideoPlayeBuyUrlrView", CanvasType.FrontCanvas, "VideoPlayForUrlView")
        UINotify:Get():SendNotification(UINotifyEvent.VideoPlayer_Play, { videourl, data.time,1,closeFunc })
    end)
end
function CommonHelper:PlayViewVideoByUrl(closeFunc)
    LoginSubSystem:Get():SendMsg_GetPlaySignInVideoUrl(function(json)
        local data = Dll_JSON.decode(json)
        local videourl = ""
        if data.isNet  then
            videourl = data.videourl
        else
            videourl = CS.AppPath.StreamingAssetsPath .. "/Movie" .. "/" .. data.videoName
        end
        UIManager:Get():OpenPopup("FullscreenVideoPlayeBuyUrlrView", CanvasType.FrontCanvas, "VideoPlayForUrlView")
        UINotify:Get():SendNotification(UINotifyEvent.VideoPlayer_Play, { videourl, data.time,2,closeFunc })
    end)
end
function CommonHelper:ShowRankingListReward(type, keepShowPrevious, lastViewRemove)
    UIManager:Get():OpenPopup("RankingListRewardView", CanvasType.FrontCanvas, "RankingListRewardView", keepShowPrevious, lastViewRemove)
    UINotify:Get():SendNotification(UINotifyEvent.RankListRewardView_SetData, type)
end

function CommonHelper:ShowRaceStateView(type,keepShowPrevious, lastViewRemove)
    UIManager:Get():OpenPopup("RaceStateView",CanvasType.FrontCanvas,"RaceStateView",keepShowPrevious, lastViewRemove)
    UINotify:Get():SendNotification(UINotifyEvent.RaceState_SetData,type)
end
---东南亚10 港澳台0
function CommonHelper:GetChargeCfgByAreaAndItemId(itemid)
    local area = 10
    area = GameProperties.AreaType
    local cfg = ClientDataManager:Get():GetDataTable(ConfigNames.dictcharge_config)
    return cfg.GetDataByAreaAndItemId(area, itemid)
end

function CommonHelper:GetChargeCfgByAreaAndInnerId(InnerId)
    local area = 10
    area = GameProperties.AreaType
    local cfg = ClientDataManager:Get():GetDataTable(ConfigNames.dictcharge_config)
    return cfg.GetDataByAreaAndInnerId(area, InnerId)
end

function CommonHelper:GetChargeCfgByAreaAndInnerIdIos(InnerId)
    local area = 10
    area = GameProperties.AreaType
    local cfg = ClientDataManager:Get():GetDataTable(ConfigNames.dictcharge_config)
    return cfg.GetDataByAreaAndInnerIdIos(area, InnerId)
end
function CommonHelper:GetChargeCfgByAreaAndInnerId2(InnerId)
    local area = 10
    area = GameProperties.AreaType
    local cfg = ClientDataManager:Get():GetDataTable(ConfigNames.dictcharge_config)
    return cfg.GetDataByAreaAndInnerId2(area, InnerId)
end

function CommonHelper:GetChargeCfgByAreaAndInnerIdIos2(InnerId)
    local area = 10
    area = GameProperties.AreaType
    local cfg = ClientDataManager:Get():GetDataTable(ConfigNames.dictcharge_config)
    return cfg.GetDataByAreaAndInnerIdIos2(area, InnerId)
end

function CommonHelper:GetChargeDataByArea()
    local area = 10
    area = GameProperties.AreaType
    local cfg = ClientDataManager:Get():GetDataTable(ConfigNames.dictcharge_config)
    return cfg.GetDataByArea(area)
end

local ChargeType = 0
-- 1为测试巴西支付
function CommonHelper:GetSetChargeType(type)
    if type ~= nil then
        ChargeType = type
    end
    return ChargeType
end
function CommonHelper:CheckItemIdsEx(itemId)
    ---@type dictcharge_config_cell
    local cfg= CommonHelper:GetChargeCfgByAreaAndItemId(itemId)
    local key=CommonHelper:GetDictCalcData(CommonCfgKey.TokenExchange)
    return HVersionManager:GetServerFunctionIsFlag(CdnFunctionKey.TokenExchange) and cfg.chargenum~=0 and cfg.exnum>0 and PlayerDataManager:Get():CheckCurrencyEnough(key,cfg.exnum,false),cfg.exnum,cfg.name
end
--新充值方法
function CommonHelper:ChargeMoneyByID(_dataID, _dataStr)
    local flag,num,name=CommonHelper:CheckItemIdsEx(tonumber(_dataID))
    if flag then
        local  key=CommonHelper:GetDictCalcData(CommonCfgKey.TokenExchange)
        if HVersionManager:GetServerFunctionIsFlag(CdnFunctionKey.TokenExchange) and PlayerDataManager:Get():CheckCurrencyEnough(key,num,false) then
            local type,article= CommonHelper:GetPropTypeById(key)
            local boxFunc = function()
                local tips=CommonHelper:GetTempStr_Default(TemplateStringID.TokenExchangeMessage,CommonHelper:GetTempStr_Default(article.name),num)
                local ret = MessageBoxHelp:Get():OpenBox_OKCancel(UIColor.Blue, tips, CommonHelper:GetTempStr_Default(TemplateStringID.RaceTrotEnter_Tittle), CommonHelper:GetTempStr_Default(TemplateStringID.OK), CommonHelper:GetTempStr_Default(TemplateStringID.Cancel), true)
                if ret == MessageBoxHelp.BtnType.OK then
                    ActivitySubsystem:Get():SendMsg_Token_ExchangeCoin(_dataID, _dataStr)
                else

                end
            end
            MessageBoxHelp.Get():StartCoroutineBox(boxFunc)
        else
            if SDKHelper:Get():ChickSdk() then
                PlayerDataManager:Get():CheckPlayerBindData(function()
                    ActivitySubsystem:Get():SendMsg_Purchase_Quick_Pre(_dataID, _dataStr)
                end)
            else
                --没有使用sdk
                ActivitySubsystem:Get():SendMsg_Purchase_Editor_Pre(_dataID, _dataStr, ChargeType)
            end
        end
    else
        if SDKHelper:Get():ChickSdk() then
            PlayerDataManager:Get():CheckPlayerBindData(function()
                ActivitySubsystem:Get():SendMsg_Purchase_Quick_Pre(_dataID, _dataStr)
            end)
        else
            --没有使用sdk
            ActivitySubsystem:Get():SendMsg_Purchase_Editor_Pre(_dataID, _dataStr, ChargeType)
        end
    end

end
function CommonHelper:SetBtnIsRmbOrToken(Btn,chargeCfg)
    local key=CommonHelper:GetDictCalcData(CommonCfgKey.TokenExchange)
    if HVersionManager:GetServerFunctionIsFlag(CdnFunctionKey.TokenExchange) and  chargeCfg and chargeCfg.chargenum>0 and PlayerDataManager:Get():CheckCurrencyEnough(key,chargeCfg.exnum,false) then
        if chargeCfg and chargeCfg.exnum and chargeCfg.exnum>0 then
            CommonHelper:SetGameObjectActive("###priceText",Btn.gameObject,chargeCfg.exnum==0)
            CommonHelper:SetGameObjectActive("moneycost",Btn.gameObject,chargeCfg.exnum>0)
            CommonHelper:SetText("###moneyText",Btn.gameObject,chargeCfg.exnum)
            CommonHelper:SetTextMesh("###moneyText",Btn.gameObject,chargeCfg.exnum)
        else
            CommonHelper:SetGameObjectActive("###priceText",Btn.gameObject,true)
            CommonHelper:SetGameObjectActive("moneycost",Btn.gameObject,false)
		   if chargeCfg.chargenum<=0 then
             CommonHelper:SetText("###priceText", Btn.gameObject, CommonHelper:GetTempStr_Default(TemplateStringID.StrengthActivityFree))
             CommonHelper:SetTextMesh("###priceText", Btn.gameObject, CommonHelper:GetTempStr_Default(TemplateStringID.StrengthActivityFree))
           else
            CommonHelper:SetText("###priceText",Btn.gameObject,chargeCfg.pricename)
            CommonHelper:SetTextMesh("###priceText",Btn.gameObject,chargeCfg.pricename)
           end
        end
    else
        CommonHelper:SetGameObjectActive("###priceText",Btn.gameObject,true)
        CommonHelper:SetGameObjectActive("moneycost",Btn.gameObject,false)
        if chargeCfg.chargenum<=0 then
            CommonHelper:SetText("###priceText", Btn.gameObject, CommonHelper:GetTempStr_Default(TemplateStringID.StrengthActivityFree))
            CommonHelper:SetTextMesh("###priceText", Btn.gameObject, CommonHelper:GetTempStr_Default(TemplateStringID.StrengthActivityFree))
        else
            CommonHelper:SetText("###priceText",Btn.gameObject,chargeCfg.pricename)
            CommonHelper:SetTextMesh("###priceText",Btn.gameObject,chargeCfg.pricename)
        end
    end
end
function CommonHelper:SetBtnTextMeshIsRmbOrToken(Btn,chargeCfg)
    local key=CommonHelper:GetDictCalcData(CommonCfgKey.TokenExchange)
    if HVersionManager:GetServerFunctionIsFlag(CdnFunctionKey.TokenExchange) and  chargeCfg and chargeCfg.chargenum>0 and PlayerDataManager:Get():CheckCurrencyEnough(key,chargeCfg.exnum,false) then
        if chargeCfg and chargeCfg.exnum and chargeCfg.exnum>0 then
            CommonHelper:SetGameObjectActive("###priceText",Btn.gameObject,chargeCfg.exnum==0)
            CommonHelper:SetGameObjectActive("moneycost",Btn.gameObject,chargeCfg.exnum>0)
            CommonHelper:SetText("###moneyText",Btn.gameObject,chargeCfg.exnum)
        else
            CommonHelper:SetGameObjectActive("###priceText",Btn.gameObject,true)
            CommonHelper:SetTextMesh("###priceText",Btn.gameObject,chargeCfg.pricename)
            CommonHelper:SetGameObjectActive("moneycost",Btn.gameObject,false)
        end
    else
        CommonHelper:SetGameObjectActive("###priceText",Btn.gameObject,true)
        CommonHelper:SetGameObjectActive("moneycost",Btn.gameObject,false)
        if chargeCfg.chargenum<=0 then
            CommonHelper:SetTextMesh("###priceText", Btn.gameObject, CommonHelper:GetTempStr_Default(TemplateStringID.StrengthActivityFree))
        else
            CommonHelper:SetTextMesh("###priceText",Btn.gameObject,chargeCfg.pricename)
        end
    end
end

function CommonHelper:GetMainMenuViewName()
    if MainCitySceneValue == SceneChangeID.MainCity_Interaction then
        return MainMenuName.InteractionMainMenuView
    else
        return MainMenuName.MainMenuView
    end
end


function CommonHelper:IsRectTransformOverlap(rect1, rect2)
    local rect1MinX = rect1.position.x - rect1.rect.width / 2
    local rect1MaxX = rect1.position.x + rect1.rect.width / 2
    local rect1MinY = rect1.position.y - rect1.rect.height / 2
    local rect1MaxY = rect1.position.y + rect1.rect.height / 2

    local rect2MinX = rect2.position.x - rect2.rect.width / 2
    local rect2MaxX = rect2.position.x + rect2.rect.width / 2
    local rect2MinY = rect2.position.y - rect2.rect.height / 2
    local rect2MaxY = rect2.position.y + rect2.rect.height / 2

    local notOverlap = rect1MaxX <= rect2MinX or rect2MaxX <= rect1MinX or rect1MaxY <= rect2MinY or rect2MaxY <= rect1MinY

    return notOverlap
end
local LockThree = { 3, 4, 5 }
local LockTwo = { 4, 5 }
local LockOne = { 5 }

function CommonHelper:GetLockCarListByNum(num)
    if num == 1 then
        return nil
    end
    if num == 2 then
        return LockThree
    end
    if num == 3 then
        return LockTwo
    end
    if num == 4 then
        return LockOne
    end
    if num == 5 then
        return nil
    end
end
function CommonHelper:GetWordRect(rectTransform)
    local sizeDelta = rectTransform.sizeDelta
    local rectTransformWidth = sizeDelta.x * rectTransform.lossyScale.x
    local rectTransformHeight = sizeDelta.y * rectTransform.lossyScale.y

    local position = rectTransform.position
    return Rect(position.x + rectTransformWidth * rectTransform.pivot.x, position.y - rectTransformHeight * rectTransform.pivot.y, rectTransformWidth, rectTransformHeight)
end
function CommonHelper:GameObjectIsNull(go)
    return CS.UIUtil.IsNull(go)
end
function CommonHelper:IsOpenMini4wdRuleView(type,func)
    if CommonHelper:CheckPlayerIsNewGuide() then
        if func then
            func(true)
        end
        return
    end
   local value= PlayerPrefsHelper:GetValue_Mini4wdRuleViewOpen(type)
    if not value then
        UIManager:Get():ShowPersistentView("Mini4wdRuleView",CanvasType.FrontCanvas,"Mini4wdRuleView")
        UINotify:Get():SendNotification(UINotifyEvent.Mini4wdRuleView_SetData,{type,func})
    else
        if func then
            func(value)
        end
    end
end
function CommonHelper:CheckMini4wdRule(type,func)
    local value= PlayerPrefsHelper:GetValue_Mini4wdRuleViewOpen(type)
    if CommonHelper:CheckPlayerIsNewGuide() then
        if func then
            func(true)
        end
        return
    end
    if not value then
        local boxFunc = function()
            local tips=CommonHelper:GetTempStr_Default(TemplateStringID.NoRaceRoomCreate)
            local ret = MessageBoxHelp:Get():OpenBox_OKCancel(UIColor.Blue, tips, CommonHelper:GetTempStr_Default(TemplateStringID.RaceTrotEnter_Tittle), CommonHelper:GetTempStr_Default(TemplateStringID.OK), CommonHelper:GetTempStr_Default(TemplateStringID.Cancel), true)
            if ret == MessageBoxHelp.BtnType.OK then
                CommonHelper:IsOpenMini4wdRuleView(type)
            end
        end
        MessageBoxHelp.Get():StartCoroutineBox(boxFunc)
    else
        if func then
            func(value)
        end
    end
end
function CommonHelper:Set3D_TextGroup(textname,str,go)
    if textname and str and go then
        local length, texts=getStringTrueLength(str)
        for i = 1, #textname do
            if  texts and texts[i] then
                CommonHelper:SetGameObjectActive(textname[i],go,true)
                CommonHelper:SetMesh_Text(textname[i], go, texts[i])
            else
                CommonHelper:SetGameObjectActive(textname[i],go,false)
            end
        end
    end
end
function CommonHelper:Phone_Vibrate()
    CS.UnityEngine.Handheld.Vibrate()
end
function CommonHelper:Text_EnableBitFit(text)
    local isandroid = HotfixHelper:IsAndroidPlatform()
    if not isandroid then
        LanguageSwitchManager.Get():SetTextFont(text)
    else
        if text.resizeTextForBestFit==false then
            text.resizeTextForBestFit = true
            local size=text.fontSize
            text.resizeTextMaxSize = size
            text.resizeTextMinSize = size - 8
            LanguageSwitchManager.Get():SetTextFont(text)
        end
    end
end
function CommonHelper:Text_EnableBitFitByParent(parent)
    if parent then
        local isandroid = HotfixHelper:IsAndroidPlatform()
        if not isandroid then
        else
            local texts = parent:GetComponentsInChildren(typeof(CS.UnityEngine.UI.Text))
            for i = 0, texts.Length-1 do
                CommonHelper:Text_EnableBitFit(texts[i])
            end
        end
    end
end


function CommonHelper:MeshProText_EnableBitFit(text)
    if text then
        if text.autoSizeTextContainer==false then
            text.autoSizeTextContainer = true
            local size=text.fontSize
            text.fontSize = size
            text.fontSize = size - 8
            LanguageSwitchManager.Get():SetTextFont(text)

        end
    end
end

function CommonHelper:SetBetterOutlineColor(objName, parent,color)
    local outline = UIUtil.GetTypeChildWightByParent(objName, parent, typeof(BetterOutline))
    if outline then
        if CommonHelper:IsNullOrEmpty(color) or color=="0" or color=="-1" then return end
       local color = UIUtil:HexToColorRGB(color)
        if color then
            outline.effectColor=color
        end
    end
end
function CommonHelper:SetInputLimitInputNum(input, min,max,func)
    input.onValueChanged:RemoveAllListeners()
    input.onValueChanged:AddListener(function(str)
        if CommonHelper:IsNullOrEmpty(str) then
            return
        end
        local result = tonumber(str)
        if result then
            if result >= max then
                result =max
            end
            if result <= min then
                result =min
            end
            func(result)
        end
    end)
end