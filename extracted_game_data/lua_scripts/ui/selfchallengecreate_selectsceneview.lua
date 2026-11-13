
local _GameObject=nil
local _View=nil
local this=nil
local CurSetLv=nil
local NpcIndex=nil
local moreRowScrollView=nil
function SelfChallengeCreateView:SelectSceneOpen(gameObject)
  _GameObject=gameObject
  _View=self.gameObject
  this=self
  print(_GameObject.name)
  print(_View.name)
  CommonHelper:SetText("NpcTips",_View,CommonHelper:GetTempStr_Default(TemplateStringID.SelfChallengeHitSetGameScene))


  CommonHelper:HButtonSetCallback("BtnRandom",_GameObject,function (data)

      local  data=SelfChallengeDataManager:Get():GetSelfChallengeData(SelfChallengeDataManager:Get().SelectId)
      if data~=nil then
          for i, v in pairs(data.needSetLv) do
              local sceneId= math.random(1,#data.scenes)
              local trackId= math.random(1,#data:GetTracks())


              SelfChallengeDataManager:Get()._SelectScenes[v]=data.scenes[sceneId]

              SelfChallengeDataManager:Get()._SelectTracks[v]=data:GetTracks()[trackId]
              local trackData=CommonHelper:GetRacetrackData(data:GetTracks()[trackId])
              for i = 1, trackData.numbers-1 do
                  local npc= math.random(1,#data.trackNpcInfo[trackData.id])
                  if  SelfChallengeDataManager:Get()._SelectNpcs[v]==nil then
                      SelfChallengeDataManager:Get()._SelectNpcs[v]={}
                  end
                  local npcId=data.trackNpcInfo[trackData.id][npc]
                  if SelfChallengeDataManager:Get():CheckNpcIsSelected(v,npcId) then
                      i=i-1
                  else
                      SelfChallengeDataManager:Get()._SelectNpcs[v][i]=npcId
                  end
              end
          end
          CommonHelper:MoreRowView_RefreshCurList(moreRowScrollView,false)
      end
  end)

   moreRowScrollView=self:GetChildWightByParent("MoreRowScrollView_V",_GameObject,typeof(MoreRowScrollView))
  local data=SelfChallengeDataManager:Get():GetSelfChallengeData(SelfChallengeDataManager:Get().SelectId)
  if data~=nil then
    local lvList=data.needSetLv

    CommonHelper:InitMoreRowScrollView(moreRowScrollView,#lvList,1,function (index, itemObj,scroll)
          CommonHelper:SetText("lvtext",itemObj,string.format("困难关%d",lvList[index+1]))
          local lv=lvList[index+1]
          local Scene=SelfChallengeDataManager:Get()._SelectScenes[lv]
          local track=SelfChallengeDataManager:Get()._SelectTracks[lv]
          local Npc=SelfChallengeDataManager:Get()._SelectNpcs[lv]
          local trackData=nil
        ------------------------------------------------------------------------------------------
        local sceneComponent=UIUtil.GetChild("SubheadingScenne",itemObj)
        local selectSceneBtn= CommonHelper:HButtonSetCallback("BtnSelectSceneOrChange",itemObj,function (data)

            CurSetLv=lvList[data.intData+1]
            UIManager:Get():OpenPopup("SelfChallengeSelectSceneView",CanvasType.MainCanvas,"SelfChallengeSelectSceneView")
            UINotify:Get():SendNotification(UINotifyEvent.SelfChallengeSelectSceneOpen)

        end,index)
        if Scene==nil then
            CommonHelper:SetGameObjectActive("nosceneicon",sceneComponent,true)
            CommonHelper:SetText("text",selectSceneBtn.gameObject,"选择")
            CommonHelper:SetText("name",sceneComponent,"")
        else
            CommonHelper:SetGameObjectActive("nosceneicon",sceneComponent,false)
            CommonHelper:SetText("text",selectSceneBtn.gameObject,"更换")

            local  cfg=CommonHelper:GetTableDataByID(ConfigNames.scene_config,Scene)
            CommonHelper:GetComponentSetUITexture("sceneIcon",sceneComponent,cfg.icon,UIModuleID.SelfChallenge)
            local name=ClientDataManager:Get():GetTemplateString(cfg.name)
            CommonHelper:SetText("sceneName",sceneComponent,name)
            --local cfg=CommonHelper:GetTableDataByID(ConfigNames.scene_config,Scene)
            --CommonHelper:SetText("name",sceneComponent,ClientDataManager:Get():GetTemplateString("muchanga aas"))
            --CommonHelper:GetComponentSetUITexture("sceneIcon",sceneComponent,cfg.icon..".png")
        end
        ---------------------------------------------------------------------------------------------------------------------------------------------------
        local trackComponent=UIUtil.GetChild("SubheadingTrack",itemObj)

        local  selectTrack=CommonHelper:HButtonSetCallback("BtnSelectTrackOrChange",itemObj,function (data)

            CurSetLv=lvList[data.intData+1]
            UIManager:Get():OpenPopup("SelfChallengeSelectTrackView",CanvasType.MainCanvas,"SelfChallengeSelectTrackView")
            UINotify:Get():SendNotification(UINotifyEvent.SelfChallengeSelectTrackOpen)

        end,index)

        if track==nil then
            CommonHelper:SetGameObjectActive("nosceneicon",trackComponent,true)
            CommonHelper:SetText("text",selectTrack.gameObject,"选择")
            CommonHelper:SetText("name",sceneComponent,"")
        else
            CommonHelper:SetGameObjectActive("nosceneicon",trackComponent,false)
            CommonHelper:SetText("text",selectTrack.gameObject,"更换")

            trackData=CommonHelper:GetRacetrackData(track)
            CommonHelper:SetText("trackName",trackComponent,trackData:GetName())
            CommonHelper:GetComponentSetTrackIconByData("trackIcon",trackComponent,trackData,UIModuleID.SelfChallenge)
        end
        ---------------------------------------------------------------------------------------------------------------------------------------------------
        local NpcComponent1=UIUtil.GetChild("NpcComponent1",itemObj)
        local NpcComponent2=UIUtil.GetChild("NpcComponent2",itemObj)
        local NpcComponent3=UIUtil.GetChild("NpcComponent3",itemObj)
        local NpcComponent4=UIUtil.GetChild("NpcComponent4",itemObj)
        local param1=Param_NPCGroup()
        param1.moduleId=UIModuleID.SelfChallenge
        param1.use=false
        param1.lock=false
        param1.add=true
        param1.showBtn=true
        param1.BtnName="选择"
        local param2=Param_NPCGroup()
        param2.moduleId=UIModuleID.SelfChallenge
        param2.use=false
        param2.lock=false
        param2.add=true
        param2.showBtn=true
        param2.BtnName="选择"
        local param3=Param_NPCGroup()
        param3.moduleId=UIModuleID.SelfChallenge
        param3.use=false
        param3.lock=false
        param3.add=true
        param3.showBtn=true
        param3.BtnName="选择"
        local param4=Param_NPCGroup()
        param4.moduleId=UIModuleID.SelfChallenge
        param4.use=false
        param4.lock=false
        param4.add=true
        param4.showBtn=true
        param4.BtnName="选择"
        if Npc~=nil then
            local Npc1=Npc[1]
            if Npc1 ~=nil then
               local cfg=CommonHelper:GetTableDataByID(ConfigNames.npc_config,Npc1)
                if cfg~=nil then
                    local hero= CommonHelper:GetTableDataByID(ConfigNames.hero_config,cfg.hero)
                    param1.carId=cfg.carId
                    param1.npcId=cfg.npcId
                    param1.npcIcon=hero.picture..".png"
                    param1.quality=cfg.quality
                    param1.name=cfg.name
                    param1.add=false
                    param1.lock=false
                    param1.BtnName="更换"
                end
            end
            local Npc2=Npc[2]
            if Npc2 ~=nil then
                local cfg=CommonHelper:GetTableDataByID(ConfigNames.npc_config,Npc2)
                if cfg~=nil then
                    local hero= CommonHelper:GetTableDataByID(ConfigNames.hero_config,cfg.hero)
                    param2.carId=cfg.carId
                    param2.npcId=cfg.npcId
                    param2.quality=cfg.quality
                    param2.npcIcon=hero.picture..".png"
                    param2.name=cfg.name
                    param2.add=false
                    param2.lock=false
                    param2.BtnName="更换"
                end
            end
            local Npc3=Npc[3]
            if Npc3 ~=nil then
                local cfg=CommonHelper:GetTableDataByID(ConfigNames.npc_config,Npc3)
                if cfg~=nil then
                    local hero= CommonHelper:GetTableDataByID(ConfigNames.hero_config,cfg.hero)
                    param3.carId=cfg.carId
                    param3.npcId=cfg.npcId
                    param3.quality=cfg.quality
                    param3.npcIcon=hero.picture..".png"
                    param3.name=cfg.name
                    param3.add=false
                    param3.lock=false
                    param3.BtnName="更换"
                end
            end
            local Npc4=Npc[4]
            if Npc4 ~=nil then
                local cfg=CommonHelper:GetTableDataByID(ConfigNames.npc_config,Npc4)
                if cfg~=nil then
                    local hero= CommonHelper:GetTableDataByID(ConfigNames.hero_config,cfg.hero)
                    param4.carId=cfg.carId
                    param4.npcId=cfg.npcId
                    param4.quality=cfg.quality
                    param4.npcIcon=hero.picture..".png"
                    param4.name=cfg.name
                    param4.add=false
                    param4.lock=false
                    param4.BtnName="更换"
                end
            end
        end
        if trackData~=nil then
            print(trackData.numbers)
            if trackData.numbers==3 then
                param3.lock=true
                param3.add=false
                param3.showBtn=false
                param4.lock=true
                param4.add=false
                param4.showBtn=false
            end
        end
        CommonHelper:SetNpcGroup(NpcComponent1,param1)
        CommonHelper:SetNpcGroup(NpcComponent2,param2)
        CommonHelper:SetNpcGroup(NpcComponent3,param3)
        CommonHelper:SetNpcGroup(NpcComponent4,param4)
        CommonHelper:HButtonSetCallback("NpcBtnItem",NpcComponent1,function (data)

            CurSetLv=lvList[data.intData+1]
            NpcIndex=1
            local setTrack=SelfChallengeDataManager:Get()._SelectTracks[CurSetLv]
            SelfChallengeCreateView:OpenSelectNpcView(setTrack,CurSetLv)

        end,index)

        CommonHelper:HButtonSetCallback("NpcBtnItem",NpcComponent2,function (data)

            CurSetLv=lvList[data.intData+1]
            NpcIndex=2
            local setTrack=SelfChallengeDataManager:Get()._SelectTracks[CurSetLv]
            SelfChallengeCreateView:OpenSelectNpcView(setTrack,CurSetLv)
        end,index)

        CommonHelper:HButtonSetCallback("NpcBtnItem",NpcComponent3,function (data)

            CurSetLv=lvList[data.intData+1]
            NpcIndex=3
            local setTrack=SelfChallengeDataManager:Get()._SelectTracks[CurSetLv]
            SelfChallengeCreateView:OpenSelectNpcView(setTrack,CurSetLv)
        end,index)

        CommonHelper:HButtonSetCallback("NpcBtnItem",NpcComponent4,function (data)
            CurSetLv=lvList[data.intData+1]
            NpcIndex=4
            local setTrack=SelfChallengeDataManager:Get()._SelectTracks[CurSetLv]
            SelfChallengeCreateView:OpenSelectNpcView(setTrack,CurSetLv)
        end,index)
    end)
  end

end
function SelfChallengeCreateView:OpenSelectNpcView(setTrack,CurSetLv)

    if setTrack==nil then
        CommonTipsHelper:Get():ShowCenterTips("未选择赛道请先选择赛道")
    else
        UIManager:Get():OpenPopup("SelfChallengeSelectNpcView",CanvasType.MainCanvas,"SelfChallengeSelectNpcView")
        UINotify:Get():SendNotification(UINotifyEvent.SelfChallengeSelectNpcOpen,{setTrack,CurSetLv})
    end

end

function SelfChallengeCreateView:SelectSceneClose()
  print(_GameObject,"关闭")

end

function SelfChallengeCreateView:SelectSceneClearData()
    CurSetLv=nil
    NpcIndex=nil
    if moreRowScrollView ~=nil then
    CommonHelper:InitMoreRowScrollView(moreRowScrollView,0,1,function (index, itemObj,scroll) end)
    end
end


function SelfChallengeCreateView:SelectSceneBack(id)

  --print(_GameObject,"ID",id)
  local  data=SelfChallengeDataManager:Get():GetSelfChallengeData(SelfChallengeDataManager:Get().SelectId)
  SelfChallengeDataManager:Get()._SelectScenes[CurSetLv]=data.scenes[id]

  CommonHelper:MoreRowView_RefreshCurList(moreRowScrollView,false)
  ---设置对应的场景数据
end

function SelfChallengeCreateView:SelectTrackBack(id)

  ---@type SelfChallengeData
  local  data=SelfChallengeDataManager:Get():GetSelfChallengeData(SelfChallengeDataManager:Get().SelectId)

  SelfChallengeDataManager:Get()._SelectTracks[CurSetLv]=data:GetTracks()[id]
  print(CurSetLv,data:GetTracks()[id])
  CommonHelper:MoreRowView_RefreshCurList(moreRowScrollView,false)
 ---设置对应的赛道数据
end

function SelfChallengeCreateView:SelectSelectNpcBack(id)

   local  data=SelfChallengeDataManager:Get():GetSelfChallengeData(SelfChallengeDataManager:Get().SelectId)

   local npc=data.trackNpcInfo[SelfChallengeDataManager:Get()._SelectTracks[CurSetLv]][id]

    if SelfChallengeDataManager:Get()._SelectNpcs[CurSetLv]==nil then
        SelfChallengeDataManager:Get()._SelectNpcs[CurSetLv]={}
    end
   SelfChallengeDataManager:Get()._SelectNpcs[CurSetLv][NpcIndex]=npc

   CommonHelper:MoreRowView_RefreshCurList(moreRowScrollView,false)
    ---设置对应的Npc数据
end