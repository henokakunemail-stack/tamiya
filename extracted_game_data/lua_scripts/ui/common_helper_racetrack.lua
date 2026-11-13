
--{{{ 赛道编辑
---@param RaceTrackData RaceTrackData
function CommonHelper:LoadCustomTrack(RaceTrackData,miniTrackSystem)
    TrackBuilder:Get():RestoreCamera()
    SelfDefineTrack:Clear()
    cs_coroutine.start(function()
        coroutine.yield()
        UIManager:Get():OpenView("CustomTrackEditorView",CanvasType.MainCanvas,"CustomTrackEditorView")
        SegmentDataManager:Get():Init(RaceTrackData:GetRaceNumber())
        UINotify:Get():SendNotification(UINotifyEvent.CustomTrackEditorOpen,{RaceTrackData:GetCustomData(),miniTrackSystem})
    end)
end

function CommonHelper:ExitCustomTrack(miniTrackSystem)
    SegmentDataManager:Get():ClearData()
    MonoHelper:TurnOffPhysics()
    UIManager:Get():CloseView()
    if miniTrackSystem==MiniTrackSystem.Club then
        ClubTrainSubsystem:Get():SendMsg_GetSelfTrackRaceInfo()
    end
end
--}}}
-------------------------------------------------场景预览
---@param RaceTrackData RaceTrackData
function CommonHelper:LoadReviewTrack(sceneid, RaceTrackData,lastViewShow)
    SelfDefineTrack:Clear()
    UIManager:Get():OpenView("RaceOverlookView",CanvasType.MainCanvas,"RaceOverlookView",lastViewShow or false)
    self.trackData,self.miniTrackType=CommonHelper:LoadRaceTrack(RaceTrackData)
    HomeSceneHelper:SetTrackReview(RaceTrackData.cameraDefaultPosition,RaceTrackData.cameraDefaultRotation,RaceTrackData.cameraDefaultLength)
end



------------------------------------------------加载赛道
---@param data RaceTrackData
---@param isEdit boolean 是否是编辑赛道
function CommonHelper:LoadRaceTrack(data,isEdit)
    if data.isfield==false then
        return CommonHelper:LoadMiniTrack(data.miniTrackType, data.id, data.customTrackData,isEdit)
    end
end

function CommonHelper:LoadMiniTrack(miniTrackType, trackId, customTrack_data, isGotoLoad,isEdit)
    isGotoLoad = isGotoLoad or false
    if isGotoLoad then
        return CommonHelper:LoadingMiniTrack(trackId, miniTrackType)
    end
    if miniTrackType == MiniTrackType.System or miniTrackType == MiniTrackType.LocalCustomTrack then
        local trackname, trackType = CommonHelper:GetTrackResNameAndType(trackId)
        return CommonHelper:LoadingMiniTrack(trackType, trackname)
    else
        return CommonHelper:LoadingMiniTrack(miniTrackType, trackId, customTrack_data,isEdit)
    end
end

---@param id number
---@return string,MiniTrackType
function CommonHelper:GetTrackResNameAndType(trackId)
    local  id,orgId,FillType=CommonHelper:ParseTrackId(trackId)
    local cfg = CommonHelper:GetTableDataByID(ConfigNames.racetrack_config, trackId)
    local trackresname = ""
    if cfg then
        if cfg.resname == "-1" then
            trackresname = cfg.configName
            return trackresname, MiniTrackType.LocalCustomTrack
        else
            trackresname = cfg.resname
            return trackresname, MiniTrackType.System
        end
    end
end

---@param  miniTrackType MiniTrackType
---@param  trackresname string
---@param  customTrack_data CustomTrack_Data
function CommonHelper:LoadingMiniTrack(miniTrackType, trackresname, customTrack_data,isEdit)
    isEdit=isEdit or false
    if miniTrackType == MiniTrackType.System then

        local raceTrackAsset = AssetsManager.LoadAsync(trackresname, typeof(GameObject))
        raceTrackAsset:AddComplete(function(asset)
            if asset ~= nil and asset.asset ~= nil then
                local trackObj = GameObject.Instantiate(asset.asset)
                RaceTrackDataManager:Get().TrackObj=trackObj
                mono.SetLayerName(trackObj, "TrackRes")
                mono.SetTagName(trackObj, "TrackRoot")
                local art=CS.Horizon.Game.ShowLayer.MiniSegmentArtManager()
                art:OnInit()
                art:RefreshHighlight()
                SelfDefineTrack.artManager=art
                UIUtil.SetParentTransform(art:GetRoot(),trackObj,true)

                self:AddTrackSegment(trackObj)
            end
        end)
        return raceTrackAsset, miniTrackType
    elseif miniTrackType == MiniTrackType.LocalCustomTrack then
        SelfDefineTrack:OnPreviewInitByConfigId(trackresname)
        return nil, miniTrackType
    elseif miniTrackType == MiniTrackType.OtherCustomTrack or miniTrackType == MiniTrackType.SelfCustomTrack then
        local csTrackData=customTrack_data:ConvertToMiniTrackData()
        if isEdit then
            SelfDefineTrack:OnInit(csTrackData)
            SelfDefineTrack:SetBound(CustomTrack_BoundMinX,CustomTrack_BoundMinZ,CustomTrack_BoundMaxX,CustomTrack_BoundMaxZ)
        else
            SelfDefineTrack:OnPreviewInit(csTrackData)
        end

        return nil, miniTrackType
    end
end

function CommonHelper:AddTrackSegment(obj)
    local childCount = obj.transform.childCount
    for i = 1, childCount do
        local child = obj.transform:GetChild(i-1)
        if child ~= nil then
            local container = CS.Horizon.Game.ShowLayer.SelfDefineTrackManager.MiniSegmentContainer()
            container.segmentObj = child.gameObject
            SelfDefineTrack.segmentContainers:Add(container)
        end
    end
end

---@param miniTrackType MiniTrackType
---@param asset
function CommonHelper:UnloadTrack(miniTrackType, asset)
    if RaceTrackDataManager:Get().TrackObj then
        GameObject.Destroy(RaceTrackDataManager:Get().TrackObj)
        RaceTrackDataManager:Get().TrackObj=nil
    end
    if miniTrackType == MiniTrackType.System then
        AssetsManager.Unload(asset)
    else
        SelfDefineTrack:RecycleAll()
        SelfDefineTrack:Clear()
    end

end

-------------------------------------设置赛道图片
---@param raceTrackData RaceTrackData
function CommonHelper:GetComponentSetTrackIconByData(objName, parent, raceTrackData, moduleID)
    return CommonHelper:GetComponentSetTrackIcon(objName, parent,raceTrackData.miniTrackType, raceTrackData.icon,raceTrackData:GetCustomData(),moduleID)
end
function CommonHelper:GetComponentSetTrackIcon(objName, parent, miniTrackType, iconName, trackData, moduleID)
    --print(miniTrackType,"miniTRAK")
    --print(iconName,"miniTRAK")
    local rawimage = UIUtil.GetTypeChildWightInputPath(objName, parent, typeof(RawImage))
    if rawimage then
        --print(miniTrackType,"miniTRAK111")
        --print(iconName,"miniTRAK111")
        if miniTrackType==MiniTrackType.SelfCustomTrack then
            iconName=PlayerDataManager:Get():GetPlayerRID()..trackData.id
            if moduleID==UIModuleID.ClubTraining then
                iconName=PlayerDataManager:Get():GetPlayerRID()..UIModuleID.ClubTraining..trackData.id
            end
        end
        CommonHelper:SetTrackIcon(rawimage, miniTrackType, iconName, trackData, moduleID)
    end
    return rawimage
end
---@param miniTrackType MiniTrackType
---@param trackData CustomTrack_Data
function CommonHelper:SetTrackIcon(rawImage, miniTrackType, iconName, trackData, moduleID)

    if miniTrackType == MiniTrackType.SelfCustomTrack or miniTrackType == MiniTrackType.OtherCustomTrack then
        if trackData ~= nil then
            if trackData.isEdit == false then
                CommonHelper:SetUITexture(rawImage, "uitex_sucai_default.png", moduleID)
                return
            end
        end
    end
    if miniTrackType == MiniTrackType.System or miniTrackType ==MiniTrackType.LocalCustomTrack then

        CommonHelper:SetUITexture(rawImage, iconName .. ".png", moduleID)
    elseif miniTrackType == MiniTrackType.SelfCustomTrack then
        local texture = TrackBuilder:Get():GetSelfTrackIcon(iconName)
        if texture == nil then
          --  TrackBuilder:Get():SetCameraState()
            TrackBuilder:Get():SetUI3dIconByTrackData(trackData, rawImage, iconName)
        else
            rawImage.texture = texture
        end
    else
       -- CommonHelper:SetUITexture(rawImage, "uitex_sucai_default.png", moduleID)
        --TrackBuilder:Get():SetCameraState()
        TrackBuilder:Get():BuildTexture(trackData, rawImage, iconName)
       --  SelfDefineTrack:Clear()

    end
end
-------------------------------------获取赛道列表
---@param miniTrackType MiniTrackType
---@param trackfeature table<number,number>
function CommonHelper:GetTrackListByType(miniTrackType,trackNum,trackListModule,trackfeature)
    local result= {}
    trackNum=trackNum or -1
    trackListModule=trackListModule or TrackListModule.None
    if miniTrackType==MiniTrackType.System or miniTrackType==MiniTrackType.LocalCustomTrack then
        result= RaceTrackDataManager:Get():GetSystemRacetrackDataList(trackListModule)
    elseif miniTrackType==MiniTrackType.SelfCustomTrack or miniTrackType==MiniTrackType.OtherCustomTrack then
        result=RaceTrackDataManager:Get():GetCustomRacetrackDataList()
    end
    if trackNum~=-1 and  (miniTrackType==MiniTrackType.System or miniTrackType==MiniTrackType.LocalCustomTrack) and trackfeature==nil  then
        result=RaceTrackDataManager:Get():GetSystemRaceTrackDataByTrackNum(trackNum,trackListModule)
    elseif trackNum~=-1 and miniTrackType==MiniTrackType.SelfCustomTrack or miniTrackType==MiniTrackType.OtherCustomTrack then
        result=RaceTrackDataManager:Get():GetCustomRaceTrackDataByTrackNum(trackNum)
    end
    if trackfeature~=nil and trackNum~=-1 and  (miniTrackType==MiniTrackType.System or miniTrackType==MiniTrackType.LocalCustomTrack) then
        result=RaceTrackDataManager:Get():GetSystemRaceTrackDataByTrackFeature(trackNum,trackListModule,trackfeature)
    end
    if result==nil or #result<=0 then
        CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.CustomTrackNotOpen))
    end
    return result
end

---@param trackid number
---@param param SC_TrackWrapInfo
---@param trackindex number
---@param trackInfo SC_TrackInfo
---@return RaceTrackData
function CommonHelper:GetRacetrackData(trackid,trackInfo,param,trackindex)
    if param~=nil or trackInfo ~=nil then
        local temp=RaceTrackData()
        temp:SetData(nil,trackInfo,param)
        return temp
    elseif trackindex~=nil and trackindex >-1 then
        local data=RaceTrackDataManager:Get():GetTrackListById(trackindex)
        return data
    elseif trackid~=nil and trackid>0 then
        return RaceTrackDataManager:Get():GetSystemRaceDataById(trackid)
    end
    return nil
end
----------------------------------------------获取赛道类型 1.速度2.弯道3.坡道4.越野

function CommonHelper:GetTrackTypeById(trackType)
    if trackType==SelfChallengeLVType.Speed then
        return CommonHelper:GetTempStr_Default(TemplateStringID.Speed)
    elseif trackType==SelfChallengeLVType.Curve then
        return CommonHelper:GetTempStr_Default(TemplateStringID.Curve)
    elseif trackType==SelfChallengeLVType.Ramp then
        return CommonHelper:GetTempStr_Default(TemplateStringID.Ramp)
    elseif trackType==SelfChallengeLVType.Cross then
        return CommonHelper:GetTempStr_Default(TemplateStringID.Cross)
    elseif trackType==SelfChallengeLVType.Synthesize then
        return CommonHelper:GetTempStr_Default(TemplateStringID.Synthesize)
    end
    return -1
end
-------------------------------------------------------------
function CommonHelper:GetTypeName(tracksegementNumber,type)
    if tracksegementNumber==nil or type==nil then return end
    if tracksegementNumber==TrackSegmentNumbers.Three then
        if type==TrackSegmentType.Straightaway then return CommonHelper:GetTempStr_Default(TemplateStringID.TrackThree1) end
        if type==TrackSegmentType.Curve then return CommonHelper:GetTempStr_Default(TemplateStringID.TrackThree2) end
        if type==TrackSegmentType.ChangeTrack then return CommonHelper:GetTempStr_Default(TemplateStringID.TrackThree3) end
        if type==TrackSegmentType.Special then return CommonHelper:GetTempStr_Default(TemplateStringID.TrackThree4) end
    end
    if tracksegementNumber==TrackSegmentNumbers.Five then
        if type==TrackSegmentType.Straightaway then return CommonHelper:GetTempStr_Default(TemplateStringID.TrackFive1) end
        if type==TrackSegmentType.Curve then return CommonHelper:GetTempStr_Default(TemplateStringID.TrackFive2) end
        if type==TrackSegmentType.ChangeTrack then return CommonHelper:GetTempStr_Default(TemplateStringID.TrackFive3) end
        if type==TrackSegmentType.Special then return CommonHelper:GetTempStr_Default(TemplateStringID.TrackFive4) end
    end

    print("没有图片资源")
end
function CommonHelper:GetTypeIcon(tracksegementNumber,type)
    if tracksegementNumber==nil or type==nil then return end
    if type==TrackSegmentType.Special then
        return "tracksegment_type_icon1_dt"
    end
    if tracksegementNumber==TrackSegmentNumbers.Three then
        if type==TrackSegmentType.Straightaway then return "tracksegment_type_icon2_dt" end
        if type==TrackSegmentType.Curve then return "tracksegment_type_icon4_dt" end
        if type==TrackSegmentType.ChangeTrack then return "tracksegment_type_icon3_dt" end
    end
    if tracksegementNumber==TrackSegmentNumbers.Five then
        if type==TrackSegmentType.Straightaway then return "tracksegment_type_icon6_dt" end
        if type==TrackSegmentType.Curve then return "tracksegment_type_icon7_dt" end
        if type==TrackSegmentType.ChangeTrack then return "tracksegment_type_icon5_dt" end
    end

    print("没有图片资源")
end

---将图片保存到P目录
function CommonHelper:SaveTrackPic(picName)
    TrackBuilder:Get():SetCameraState()
    SelfDefineTrack:DisactiveSelectSegmentObj()
    local oldPos = CSCameraManager.Get()._CameraManagerTrans.position
    local oldRot = CSCameraManager.Get()._CameraManagerTrans.rotation
    local camera = CSCameraManager.Get()._MainCamera
    local isOr =   camera.orthographic
    local oldSize =  camera.orthographicSize
    local fov = camera.fieldOfView

    local texture = TrackBuilder:LoadTrackFinish()
    if TrackBuilder:Get().trackPicDic[picName] ~= nil then
        CS.UnityEngine.Object.Destroy(TrackBuilder:Get().trackPicDic[picName])
        TrackBuilder:Get().trackPicDic[picName] = texture
    end
    TrackBuilder:Get():SavePicToPDir(texture, picName)
    camera.orthographic = isOr
    camera.orthographicSize = oldSize
    camera.fieldOfView = fov
    SelfDefineTrack:HeightlightSelectSegmentObj()
    CSCameraManager.Get()._CameraManagerTrans.position = oldPos
    CSCameraManager.Get()._CameraManagerTrans.rotation = oldRot
    CameraStackHelper:RestoreTrackScene(false)
end


function CommonHelper:PhotographTrack()
    CameraStackHelper:SetTrackScene()
    local screenType=SceneHomeManager:Get():GetCurScene()
    local curPort=CameraStackHelper:GetCurPort()
    HomeSceneHelper:SetCameraRecruitAni()
    local oldPos = CSCameraManager.Get()._CameraManagerTrans.position
    local oldRot = CSCameraManager.Get()._CameraManagerTrans.rotation
    local oldPost=mono.SetHQualityPost(false)
    local texture=nil
    texture = TrackBuilder:LoadTrackFinish()
    CSCameraManager.Get()._MainCamera.orthographic = false
    CSCameraManager.Get()._CameraManagerTrans.position = oldPos
    CSCameraManager.Get()._CameraManagerTrans.rotation = oldRot
    CameraStackHelper:RestoreTrackScene()
    HomeSceneHelper:SetSceneByType(screenType,curPort)
    mono.SetHQualityPost(oldPost)
    return texture
end
---从P目录读取图片
function CommonHelper:ReadTrackPicFromPDir(picName)
    local texture = TrackBuilder:Get():ReadTrackPicFromPDir(picName)
    return texture
end

---@param callBack function  直接返回回调为-1  确定选择后为RaceTrackData
---@param miniTrackType nil 自定义和系统  MiniTrackType.System 系统  MiniTrackType.SelfCustom自定义
function CommonHelper:OpenTrackListView(callBack,trackNum,miniTrackType,trackListOpenModule)
    trackNum=trackNum or -1
    miniTrackType=miniTrackType or MiniTrackType.None
    trackListOpenModule=trackListOpenModule or TrackListModule.None
    UIManager:Get():OpenView("TrackListView",CanvasType.MainCanvas,"TrackListView")
    UINotify:Get():SendNotification(UINotifyEvent.TrackListSetCallBack,{callBack,trackNum,miniTrackType,trackListOpenModule})
    UINotify:Get():SendNotification(UINotifyEvent.TrackListSetData)
end

function CommonHelper:SetTrackFeatureByParent(controlName,parent,param)
    if param=="-1" or param=="0" then return end
    local obj = UIUtil.GetChildInputPath(controlName, parent)
    local scrollView=UIUtil.GetTypeChildWightByParent("ScrollView_trackfeature",obj,typeof(InfinityScrollView))
    if obj and param  and scrollView then
        if param then
            CommonHelper:InitScroll_OneRow(scrollView, #param, function(dataIndex, itemObj, scroll)
                ---@type sign_config_cell
                local cfg= CommonHelper:GetTableDataByID(ConfigNames.sign_config,param[dataIndex+1])
                if cfg then
                    local temp= CommonHelper:GetComponentSetImage("feature", itemObj, cfg.icon,UIModuleID.Recruit)
                    CommonHelper:HButtonSetCallback("Btn",itemObj,function(btndata)
                        CommonHelper:ShowTrackFeatureByCfgId(btndata.intData)
                    end,param[dataIndex+1])
                end
            end,nil,true)
        end
    end
end


function CommonHelper:GetDefaultMiniTrack()
    local id=28000001
    return CommonHelper:GetRacetrackData(id)
end
function CommonHelper:ParseTrackId(id)
    local orgId=id
    id=tostring(id)
    local start=string.sub(id,1,2)
    if MiniTrackFillType[start] then
        id=string.sub(id,3,#id)
    else
        start=""
    end
    return tonumber(id),orgId,start
end

function CommonHelper:SetStar(curstar, maxstar, item)
    --print(curstar)
    curstar = curstar == nil and 0 or curstar
    curstar = math.floor(curstar / 50) >= 5 and 5 or math.floor(curstar / 50)
    curstar = curstar < 1 and 1 or curstar
    for i = 1, 6 do
        local star = CommonHelper:SetGameObjectActive("star" .. i, item, i <= maxstar)
        CommonHelper:SetGameObjectActive("star", star, i <= curstar)
    end
end
function CommonHelper:OnTrackError(errorType)
    if errorType==CustomTrackHandleType.Out then
        CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.TrackOutArea))
    elseif errorType==CustomTrackHandleType.OverLap then
        CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.TrackOverlap))
    elseif errorType==CustomTrackHandleType.OverFloor then
        CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.TrackOverFloor))
    elseif errorType==CustomTrackHandleType.OverHeight then
        CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.TrackOverHeight))
    elseif errorType==CustomTrackHandleType.TrackClosed then
        CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.TrackClosed))
    elseif errorType==CustomTrackHandleType.TrackNoChanger then
        CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.TrackNoChanger))
    elseif errorType==CustomTrackHandleType.UpdateStartSegment then
        CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.UpdateStartSegment))
    elseif errorType==CustomTrackHandleType.DeleteStartSegment then
        CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.DeleteStartSegment))
    elseif errorType==CustomTrackHandleType.Change5CountError then
        CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.ChangeCountError))
    elseif errorType==CustomTrackHandleType.Change3CountError then
        CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.ChangeCountError))
    elseif errorType==CustomTrackHandleType.CustomTrackAngleError then
        CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.CustomTrackAngleError))
    elseif errorType==CustomTrackHandleType.CustomTrackDistanceError then
        CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.CustomTrackDistanceError))
    elseif errorType==CustomTrackHandleType.UniversalNeedEndSeg then
        --CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.CustomTrackDistanceError))
    elseif errorType==CustomTrackHandleType.UniversalCannotUseUpdate then
        CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.UniversalCannotUseUpdate))
    elseif errorType==CustomTrackHandleType.AlreadyClose then
        CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.AlreadyClose))
    end
end
--[[Closed = 0,
NotClosed = 1,
NoChanger = 2,
Changer3CountError = 3,
Changer5CountError = 4,
NotClosedButNearly = 10,
IsUniversalCannotUseAngle = 11,
IsUniversalCannotUseDistance = 12,
UniversalNeedEndSeg = 13]]
function CommonHelper:OnTrackEditError(errorType)
    if errorType==MiniTrackClosedType.NotClosed then
        CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.TrackNotClosed))
    elseif errorType==MiniTrackClosedType.NoChanger then
        CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.TrackNoChanger))
    elseif errorType==MiniTrackClosedType.Changer3CountError then
        CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.ChangeCountError))
    elseif errorType==MiniTrackClosedType.Changer5CountError then
        CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.ChangeCountError))
    elseif errorType==MiniTrackClosedType.NotClosedButNearly then
        CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.TrackNotClosed))
    elseif errorType==MiniTrackClosedType.IsUniversalCannotUseAngle then
        CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.CustomTrackAngleError))
    elseif errorType==MiniTrackClosedType.IsUniversalCannotUseDistance then
        CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.CustomTrackDistanceError))
    elseif errorType==MiniTrackClosedType.UniversalNeedEndSeg then
        CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.CustomTrackEndError))
    else
        CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.TrackNotCanRunNoTest))
    end
end