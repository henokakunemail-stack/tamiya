--⏰
---@class SelfChallengeOtherGameListView : ViewBase
SelfChallengeOtherGameListView = class("SelfChallengeOtherGameListView", ViewBase)
function SelfChallengeOtherGameListView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "SelfChallengeOtherGameListViewAction")
end
local _SelectCURIndex=-1
function SelfChallengeOtherGameListView:Awake()
    CommonHelper:HButtonSetCallback("BtnBack",self.gameObject,function ()
        UIManager:Get():CloseView()
    end)

    CommonHelper:HButtonSetCallback("BtnFilter",self.gameObject,function ()
        UIManager:Get():OpenPopup("SelfChallengeFilterView",CanvasType.MainCanvas,"SelfChallengeFilterView")
    end)

    CommonHelper:HButtonSetCallback("BtnEnter",self.gameObject,function ()
        ---@type SelfChallengeData
        local data=SelfChallengeDataManager:Get():GetOtherGameData()[_SelectCURIndex]
        if data~=nil then
            if data.curLevel>data.lvNum then
                CommonTipsHelper:Get():ShowCenterTips("已通关无法重复")
            --elseif data.subDay>0 then
            --        CommonTipsHelper:Get():ShowCenterTips("该赛事已经结束无法参加")
            else
                SelfChallengeSubsystem:Get():SendGetSelfChallengeInfo(data.id)
            end
        else
            CommonTipsHelper:Get():ShowCenterTips("请选择要参加的挑战赛")
        end
    end)

    self.MoreScrollView=self:GetChildWight("MoreRowScrollView_V",typeof(MoreRowScrollView))

end

function SelfChallengeOtherGameListView:OnOpen()

end
local _Data=nil
function SelfChallengeOtherGameListView:SetData()
    _SelectCURIndex=-1
    _Data=SelfChallengeDataManager:Get():GetOtherGameData()
    table.sort(_Data,function(a, b) return a.curLevel>b.curLevel end)
    CommonHelper:InitMoreRowScrollView(self.MoreScrollView,#_Data,1,function  (index, itemObj,scroll)
      UINotify:Get():SendNotification(UINotifyEvent.SelfChallengeOtherGameListUpdateScrollView,{index,itemObj,scroll})
    end)
end

function SelfChallengeOtherGameListView:UpdateScrollItem(index,itemObj,scroll)
    local data=_Data[index+1]
    CommonHelper:SetText("racename",itemObj,data.name)
    CommonHelper:SetText("playername",itemObj,data.masterName)
    CommonHelper:SetText("chapterType",itemObj,CommonHelper:GetTrackTypeById(data.trackType))
    if data.curLevel==0 then
        CommonHelper:SetText("chapterNum",itemObj,string.format("未参加"))
    elseif data.curLevel<=data.lvNum then
        CommonHelper:SetText("chapterNum",itemObj,string.format("%d/%d",data.curLevel,data.lvNum))
    else
        CommonHelper:SetText("chapterNum",itemObj,string.format("已通关"))
    end
        CommonHelper:GetComponentSetImage("chapterDifficulty",itemObj,CommonHelper:GetSelfChallengeDifferentIcon(data.difficulty),UIModuleID.SelfChallenge)
        if data.subDay>0 then
            CommonHelper:SetText("subTime",itemObj,string.format("已结束%d天",data.subDay))
        else
            CommonHelper:SetText("subTime",itemObj,string.format("剩余%d天",-data.subDay))
        end


        local data= SelfChallengeDataManager:Get():GetSelfChallengeDataByTicket(data.tickets)
        local component=UIUtil.GetChild("PartOrArtcleComponent",itemObj)
        local  group=CommonHelper:GetRewardByDropId(data.holdReward)
        local param=Param_PartOrArticleParam()
        param.moduleId=UIModuleID.SelfChallenge
        param.count=group[1].num
        param.id=group[1].id
        param.showcount=false
        param.showname=false
        CommonHelper:SetPartOrArticleGroup(component,param)

        --CommonHelper:SetText("subTime",itemObj,"44444 ⏰ 555555")
        CommonHelper:HButtonSetCallback("ItemBtn",itemObj,function (data)
            _SelectCURIndex=data.intData+1
            CommonHelper:MoreRowView_RefreshCurList(self.MoreScrollView,false)
        end,index)
        CommonHelper:HButtonSetCallback("BtnShare",itemObj,function (data)

        end)
        CommonHelper:SetGameObjectActive("select",itemObj,_SelectCURIndex-1==index)
    end

function SelfChallengeOtherGameListView:FilterDone(_SelectLVType,_SelectLVNum,_SelectState)
    local filterData={}
    for k, v in pairs(SelfChallengeDataManager:Get():GetOtherGameData()) do
        if _SelectLVType==0 or _SelectLVType==v.trackType then
            if _SelectLVNum==0 or _SelectLVNum==v.lvNum then
                if _SelectState==0 then
                    table.insert(filterData,v)
                elseif _SelectState==SelfChallengeLVState.NoJoin then
                    if v.curLevel==0 then
                        table.insert(filterData,v)
                    end
                elseif _SelectState==SelfChallengeLVState.Gameing then
                    if v.curLevel>0 and v.curLevel<=v.lvNum then
                        table.insert(filterData,v)
                    end
                elseif _SelectState==SelfChallengeLVState.IsDone then
                    if v.curLevel>v.lvNum then
                        table.insert(filterData,v)
                    end
                end
            end
        end
    end

    --for k, v in pairs(SelfChallengeDataManager:Get():GetOtherGameData()) do
    --    if _SelectLVNum==0 or _SelectLVNum==v.lvNum then
    --        table.insert(filterData,v)
    --    end
    --end

    --for k, v in pairs(SelfChallengeDataManager:Get():GetOtherGameData()) do
    --    if _SelectState==0 then
    --        table.insert(filterData,v)
    --    elseif _SelectState==SelfChallengeLVState.NoJoin then
    --        if v.curLevel==0 then
    --            table.insert(filterData,v)
    --        end
    --    elseif _SelectState==SelfChallengeLVState.Gameing then
    --        if v.curLevel>0 and v.curLevel<=v.lvNum then
    --            table.insert(filterData,v)
    --        end
    --    elseif _SelectState==SelfChallengeLVState.IsDone then
    --        if v.curLevel>v.lvNum then
    --            table.insert(filterData,v)
    --        end
    --    end
    --end
    _Data=filterData
    table.sort(_Data,function(a, b) return a.curLevel>b.curLevel end)
    _SelectCURIndex=0
    CommonHelper:InitMoreRowScrollView(self.MoreScrollView,#_Data,1,function  (index, itemObj,scroll)
        UINotify:Get():SendNotification(UINotifyEvent.SelfChallengeOtherGameListUpdateScrollView,{index,itemObj,scroll})
    end)
end
function SelfChallengeOtherGameListView:OnClose()

end


