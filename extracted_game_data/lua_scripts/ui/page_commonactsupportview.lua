---@field GetDataTimeString  fun(param:self):string @可选重写 获取活动持续时间
---@field GetDataTime fun(param:self):number
---@field GetUIModuleID fun(param:self):string
---@field gameObject  CS.UnityEngine.GameObject
---@field actConfig  act_bussiness_config_cell
---@class Page_CommonActSupportView
Page_CommonActSupportView = class("Page_CommonActSupportView", Page_CommonActViewBase)

local triggerBool = false
function Page_CommonActSupportView:GetPageName()
    return "Page_CommonActSupportView"
end

function Page_CommonActSupportView:initialize()

end

function Page_CommonActSupportView:OnAwake()
    self.dragItemObj = UIUtil.GetChild("DragItem", self.gameObject)
    self.ShowSVC = UIUtil.GetTypeChildWightByParent("ShowSVC", self.gameObject, typeof(MoreRowScrollView))
    self.SelectSVC = UIUtil.GetTypeChildWightByParent("SelectSVC", self.gameObject, typeof(MoreRowScrollView))

    ReturnOldPlayerDataManager:Get():InitSelectSupportData()
    self.SelectData = ReturnOldPlayerDataManager:Get():GetReBackSupportSelectData()
    self.selectLength = self:GetSelectDataLength(self.SelectData)

    CommonHelper:HButtonSetCallback("BtnHelp", self.gameObject, function(param)
        CommonHelper:ShowHelpView(PageDetailType.Support, nil, nil, true)
    end)

end

function Page_CommonActSupportView:OnOpen()
    CommonHelper:SetText("time/###time", self.gameObject, self:GetDataTimeString())
    MonoHelper:TurnOnPhysics()
    self.DragSupportID = -1

    if self.supportTimerID ~= 0 then
        TimerManager:Get():StopTimer(self.supportTimerID)
    end

    self.supportTimerID = TimerManager:Get():CreateTimerLoop(1, function()
        self:RefreshSupportData()
    end, nil, true)

end

function Page_CommonActSupportView:RequestOpen()
    --print("--526, --请求回归支援列表  ---  ***  ---")
    CommonFestivalSubSystem:Get():SendMsg_ReBackSupport()
end

function Page_CommonActSupportView:RefreshSupportData()

    self:RefreshSupportShowData()
    self:RefreshSupportSelectData()
end

function Page_CommonActSupportView:RefreshSupportShowData()
    self.ShowData = ReturnOldPlayerDataManager:Get():GetReBackSupportData()

    for i = 1, 3 do
        local itemObj=UIUtil.GetChild("RowItem"..i, self.gameObject)
        local _itemShow = self.ShowData[i]
        if _itemShow.supportPart ~= -1 then
            local iconName = CommonHelper:GetTableDataByID(ConfigNames.parts_config, _itemShow.supportPart.partid)
            CommonHelper:GetComponentSetUITexture("ItemPart", itemObj, iconName.icon, UIModuleID.CommonFestival)
            CommonHelper:SetPartStar("PartStar", itemObj, _itemShow.supportPart.curstar, 5)
            CommonHelper:SetPartStar("PartStarAwaken", itemObj, _itemShow.supportPart.curstar, 5)
            --设置配件等级
            CommonHelper:SetText("###lv", itemObj,
                    CommonHelper:GetTempStr_Default(TemplateStringID.ItemPartLvFormat, _itemShow.supportPart.curlevel))

            --设置配件特征角标icon
            CommonHelper:GetComponentSetImage("###flag", itemObj, CommonHelper:GetTrackFeatureIcon(iconName.sign), UIModuleID.CommonFestival)
        end

        local _nowTime = CommonHelper:ConvertDateTimeToInt(CommonHelper:GetNowTime())
        local unlockTimeStr, freshTimeStr = self:InitSupportTime(_itemShow.unlockTime, _itemShow.freshTime, _nowTime)

        CommonHelper:SetGameObjectActive("dark", itemObj, _nowTime < _itemShow.unlockTime)
        CommonHelper:SetGameObjectActive("light", itemObj, _nowTime > _itemShow.unlockTime)
        CommonHelper:SetGameObjectActive("BtnLock", itemObj, _nowTime < _itemShow.unlockTime)
        CommonHelper:SetGameObjectActive("ItemPart", itemObj, _itemShow.supportPart ~= -1)
        CommonHelper:SetGameObjectActive("ItemPartBG", itemObj, _itemShow.supportPart == -1)
        CommonHelper:SetGameObjectActive("BtnAdd", itemObj, _nowTime > _itemShow.unlockTime and _itemShow.supportPart == -1)

        if _nowTime < _itemShow.unlockTime then
            CommonHelper:SetText("###darktxt", itemObj,
                    string.format(CommonHelper:GetTempStr_Default(TemplateStringID.ReturnSupportOverTime), unlockTimeStr)) --.hour, unlockTimeStr.hour, unlockTimeStr.minute, unlockTimeStr.second))
        else
            CommonHelper:SetText("###lighttxt", itemObj,
                    string.format(CommonHelper:GetTempStr_Default(TemplateStringID.ReturnOldPlayerRefreshTime), freshTimeStr)) --.hour, freshTimeStr.minute, freshTimeStr.second))
        end
        --local obj = UIUtil.GetChildInputPath("BtnTrigger", itemObj)
        --local colliaion2d= UIUtil.GetTypeChildWightInputPath("BtnTrigger", itemObj, typeof(Collision2D))
        ----local rigidbody2d= UIUtil.GetTypeChildWightInputPath("BtnTrigger", itemObj, typeof(CS.UnityEngine.Rigidbody2D))
        ----local boxcollider2d= UIUtil.GetTypeChildWightInputPath("BtnTrigger", itemObj, typeof(CS.UnityEngine.BoxCollider2D))
        ----if  rigidbody2d~=nil  then
        ----    GameObject.Destroy(rigidbody2d)
        ----    rigidbody2d=nil
        ----end
        ----if  boxcollider2d~=nil  then
        ----    GameObject.Destroy(boxcollider2d)
        ----    boxcollider2d=nil
        ----end
        ----
        ----if rigidbody2d==nil then
        ----    obj:AddComponent(typeof(CS.UnityEngine.Rigidbody2D))
        ----end
        ----if boxcollider2d==nil then
        ----    boxcollider2d=obj:AddComponent(typeof(CS.UnityEngine.BoxCollider2D))
        ----    boxcollider2d.size=Vector2(452.08,221.1566)
        ----    boxcollider2d.offset=Vector2(-3.089478,-18.53894)
        ----    boxcollider2d.isTrigger=true
        ----end
        --if colliaion2d==nil then
        --    obj:AddComponent(typeof(Collision2D))
        --end
        ----CommonHelper:OnTriggerObjectSetCallback("BtnTrigger", itemObj,
        ----        function(other, hbtn)
        ----        end,
        ----        function(other, hbtn)
        ----            if triggerBool == false then
        ----                --print("退出    退出   -----", 0)
        ----                self.boxVacancy = 0
        ----            end
        ----        end,
        ----        function(other, hbtn)
        ----            --print("停留    停留   *****", dataIndex + 1)
        ----            self:SetBoxVacancy(dataIndex + 1)
        ----        end)
    end


end

function Page_CommonActSupportView:RefreshSupportSelectData()
    CommonHelper:InitMoreRowScrollView(self.SelectSVC, self.selectLength, 2, function(dataIndex, itemObj, scroll)
        local _itemData = self.SelectData[dataIndex + 1]
        local bool_choose = ReturnOldPlayerDataManager:Get():GetSupportChooseDataState(_itemData.partid)
        CommonHelper:SetGameObjectActive("BtnDragItem", itemObj, bool_choose)
        local obj = UIUtil.GetChild("ItemPart_138", itemObj)
        local param = Param_ItemPartParam()
        param.star = _itemData.initstar
        param.lv = _itemData.initlev
        param.awaken = _itemData.breakflag
        param.lock = bool_choose and 0 or 1
        CommonHelper:SetItemPartGroup(obj, UIModuleID.CommonFestival, _itemData.partid, ItemPartUIType.Normal, param)

        local DragParent = UIUtil.GetChild("custom", itemObj)
        local DragObj = UIUtil.GetChild("BtnDragItem", itemObj)
        local ItemObj_Position = obj.transform.localPosition

        local BtnDragItem = CommonHelper:DragObjectSetCallback("BtnDragItem", itemObj, function(eventData,hbtn)
            if self.DragSupportID ~= -1 then
               return
            end
            self.boxVacancy = 0
            local cfg = CommonHelper:GetTableDataByID(ConfigNames.parts_config, hbtn.intData)
            CommonHelper:GetComponentSetUITexture("dragIcon", self.dragItemObj, cfg.icon, UIModuleID.CommonFestival)
            UIUtil.SetParentGameObject(self.gameObject, DragObj, false, false)
            UIUtil.SetParentGameObject(DragObj, self.dragItemObj, true, true)
            CommonHelper:CSGameObjectSetActive(self.dragItemObj, true)
            self.DragSupportID = hbtn.intData

        end, function(eventData,hbtn)
            self:OnDragEnd()
            self:IfInAnArea()
            UIUtil.SetParentGameObject(DragParent, DragObj, true, false)
            DragObj.transform.localPosition = ItemObj_Position
            CommonHelper:CSGameObjectSetActive(self.dragItemObj, false)
        end,_itemData.partid)

        CommonHelper:HButtonSetCallback("BtnDragItem", itemObj, function(data)
            if BtnDragItem.OnDraging == false then
                CommonHelper:ShowPartInfoByCfgId(data.intData, UIModuleID.CommonFestival)
            end
        end,_itemData.partid)


    end, false, false, false)

end
function Page_CommonActSupportView:OnDragEnd()
    for i = 1, 3 do
       local obj=UIUtil.GetChild("RowItem"..i, self.gameObject)
        obj=UIUtil.GetChild("BtnTrigger", obj)
        local temp= UIUtil.GetGameobjectComponent(obj, typeof(RectTransform))
        local tempDrag= UIUtil.GetGameobjectComponent(self.dragItemObj.transform.parent.gameObject, typeof(RectTransform))
        local flag= CommonHelper:GetWordRect(temp):Overlaps(CommonHelper:GetWordRect(tempDrag))
        if flag then
            self:SetBoxVacancy(i)
        end
    end
end




function Page_CommonActSupportView:IfInAnArea()
    --print(" self.boxVacancy ----", self.boxVacancy)
    if self.boxVacancy > 0 then
        triggerBool = true
        local boxFunc = function()
            local iconName = CommonHelper:GetTableDataByID(ConfigNames.parts_config, self.DragSupportID)
            local _OKText = string.format(CommonHelper:GetTempStr_Default(TemplateStringID.ReturnOldPlayerSupport), CommonHelper:GetTempStr_Default(iconName.partname))
            local ret = MessageBoxHelp:Get():OpenBox_OKCancel(UIColor.Blue, _OKText)
            if ret == MessageBoxHelp.BtnType.OK then
                triggerBool = false
                --print("--528, --请求支援 P2=槽位loc P3=配件id", self.boxVacancy, self.DragSupportID)
                CommonFestivalSubSystem:Get():SendMsg_SupportPart(self.boxVacancy, self.DragSupportID)
                self.DragSupportID = -1
            end
            if ret == MessageBoxHelp.BtnType.Cancel then
                triggerBool = false
                self.boxVacancy = 0
            end
        end
        MessageBoxHelp.Get():StartCoroutineBox(boxFunc)
    else
        self.DragSupportID = -1
    end
end

function Page_CommonActSupportView:SetBoxVacancy(_vacancy)
    self.boxVacancy = _vacancy
end

function Page_CommonActSupportView:InitSupportTime(unlockTime, freshTime, nowTime)
    local _unlockTime = unlockTime - nowTime
    local _freshTime = freshTime - nowTime

    local unlockTimeStr = ""
    local freshTimeStr = ""
    local DownTime = CommonHelper:GetTempStr_Default(TemplateStringID.CommonCountDownTime)
    local DownTimeSecond = CommonHelper:GetTempStr_Default(TemplateStringID.CommonCountDownTimeSecond)

    ---
    local _unlockDay = math.modf(_unlockTime / TimeSecond_Day)
    local _unlockHour = math.modf((_unlockTime - (_unlockDay * TimeSecond_Day)) / TimeSecond_Hour)
    local _unlockMinute = math.modf((_unlockTime - (_unlockDay * TimeSecond_Day) - (_unlockHour * TimeSecond_Hour)) / TimeSecond_Minute)
    local _unlockSecond = _unlockTime - (_unlockDay * TimeSecond_Day) - (_unlockHour * TimeSecond_Hour) - (_unlockMinute * TimeSecond_Minute)
    ---
    local _freshDay = math.modf(_freshTime / TimeSecond_Day)
    local _freshHour = math.modf((_freshTime - (_freshDay * TimeSecond_Day)) / TimeSecond_Hour)
    local _freshMinute = math.modf((_freshTime - (_freshDay * TimeSecond_Day) - (_freshHour * TimeSecond_Hour)) / TimeSecond_Minute)
    local _freshSecond = _freshTime - (_freshDay * TimeSecond_Day) - (_freshHour * TimeSecond_Hour) - (_freshMinute * TimeSecond_Minute)

    if _unlockTime / TimeSecond_Day > 1 then
        unlockTimeStr = string.format(DownTime, _unlockDay, _unlockHour, _unlockMinute)
    else
        unlockTimeStr = string.format(DownTimeSecond, _unlockHour, _unlockMinute, _unlockSecond)
    end

    if _freshTime / TimeSecond_Day > 1 then
        freshTimeStr = string.format(DownTime, _freshDay, _freshHour, _freshMinute)
    else
        freshTimeStr = string.format(DownTimeSecond, _freshHour, _freshMinute, _freshSecond)
    end

    return unlockTimeStr, freshTimeStr
end

function Page_CommonActSupportView:GetSelectDataLength(_data)
    local _num = 0
    for i, v in pairs(_data) do
        _num = _num + 1
    end
    return _num
end

function Page_CommonActSupportView:OnClose()
    MonoHelper:TurnOffPhysics()
    --GameObject.Destroy(self.Awake2D)
    if self.supportTimerID ~= 0 then
        TimerManager:Get():StopTimer(self.supportTimerID)
    end
end