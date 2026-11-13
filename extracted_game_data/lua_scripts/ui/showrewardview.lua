
---@class ShowRewardView : ViewBase
ShowRewardView = class("ShowRewardView", ViewBase)

function ShowRewardView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "ShowRewardViewAction")

    print("---   GetReward 初始化完成")
end

function ShowRewardView:Awake()
    print("---   GetReward awake")


    CommonHelper:HButtonSetCallback("BtnClose",self.gameObject, function ()
        UIManager:Get():HidePersistentView("ShowRewardView")
    end)
    CommonHelper:HButtonSetCallback("fourview/BtnClose2",self.gameObject, function ()
        UIManager:Get():HidePersistentView("ShowRewardView")
    end)
    CommonHelper:HButtonSetCallback("fiveview/BtnClose2",self.gameObject, function ()
        UIManager:Get():HidePersistentView("ShowRewardView")
    end)

    self.ScrollView = UIUtil.GetTypeChildWightByParent("ScrollVerticalMoreRow", self.gameObject, typeof(MoreRowScrollView))

    self.popup=UIUtil.GetTypeChildWightByParent("popup",self.gameObject,typeof(RectTransform))
    self.clickPoint=UIUtil.GetTypeChildWightByParent("clickPoint",self.gameObject,typeof(RectTransform))
    self.RightDown=self:GetChild("RightDown")
    self.LeftDown=self:GetChild("LeftDown")
    self.LeftUp=self:GetChild("LeftUp")
    self.RightUp=self:GetChild("RightUp")
    self.four=self:GetChild("four")
    self.five=self:GetChild("five")
    self.ten=self:GetChild("ten")
end



function ShowRewardView:OnClose()
    CommonHelper:ReleasePool(UIModuleID.ShowReward)
end


function ShowRewardView:SetRewardInfo(rewardData,tittle)


    --   local  mousePosition= mono.GetMousePosition()
    --self.clickPoint.transform.position=Vector3(mousePosition.x,mousePosition.y,0)
    --local  clickQuadrant=mono.GetClickQuadrant()
    --if clickQuadrant==MouseClickQuadrant.LeftDown then
    --       UIUtil.SetParentGameObject(self.LeftUp,self.popup.gameObject)
    --elseif clickQuadrant==MouseClickQuadrant.LeftUp then
    --    UIUtil.SetParentGameObject(self.LeftDown,self.popup.gameObject)
    --elseif clickQuadrant==MouseClickQuadrant.RightDown then
    --    UIUtil.SetParentGameObject(self.RightUp,self.popup.gameObject)
    --elseif clickQuadrant==MouseClickQuadrant.RightUp then
    --    UIUtil.SetParentGameObject(self.RightDown,self.popup.gameObject)
    --end
    local rawCount=0
    local dataCount=#rewardData
    CommonHelper:SetGameObjectActive("fourview",self.gameObject,dataCount<=4)
    CommonHelper:SetGameObjectActive("fiveview",self.gameObject,dataCount>=5)

    if dataCount<=4 then
        rawCount=4
        UIUtil.SetParentGameObject(self.four,self.ScrollView,true,true)
        CommonHelper:SetText("fourview/###title1",self.popup.gameObject,tittle)
    elseif dataCount>=5 and dataCount<=10 then
        rawCount=5
        UIUtil.SetParentGameObject(self.five,self.ScrollView,true,true)
        CommonHelper:SetText("fiveview/###title1",self.popup.gameObject,tittle)
    elseif dataCount>10 then
        rawCount=5
        UIUtil.SetParentGameObject(self.ten,self.ScrollView,true,true)
        CommonHelper:SetText("fiveview/###title1",self.popup.gameObject,tittle)
    end
    CommonHelper:InitMoreRowScrollView( self.ScrollView,dataCount,rawCount,function(dataIndex, itemObj, scroll)
        local param = Param_ItemArticleParam()
        param.count=rewardData[dataIndex+1].num
        CommonHelper:SetItemComGroup(itemObj, UIModuleID.ShowReward, rewardData[dataIndex+1].id, param, function(data)
            CommonHelper:ShowPartInfoByCfgId(data,UIModuleID.ShowReward)
        end,rewardData[dataIndex+1].id)
    end)
end