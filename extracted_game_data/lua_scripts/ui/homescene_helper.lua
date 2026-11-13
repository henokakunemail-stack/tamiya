





---@class HomeSceneHelper
HomeSceneHelper = class("HomeSceneHelper")








--function HomeSceneHelper:GetTimeLineRoot_Yellow() -- 黄色车库动画挂点
--    if GameObjectIsNull(__TimeLineYellow) then
--        local temp =  CommonHelper:GetRootObjectExactMath(SceneHome_CarGroup_Garage_Yellow)
--        __TimeLineYellow = UIUtil.GetChild(SceneHome_CarTimelineRoot, temp)
--    end
--    return __TimeLineYellow
--end
--
--function HomeSceneHelper:GetAssembleCarRoot() -- 改装台车挂点
--    if GameObjectIsNull(__CarRoot_Assemble) then
--        local temp =  CommonHelper:GetRootObjectExactMath(SceneHome_CarGroup_Assemble)
--        __CarRoot_Assemble = UIUtil.GetChild(SceneHome_CarRoot, temp)
--    end
--    return __CarRoot_Assemble
--end
--
--function HomeSceneHelper:GetRecruitGroup() -- 抽奖结算配件挂点
--    local temp =  CommonHelper:GetRootObjectExactMath(SceneHome_Recruit_Group)
--    return temp
--end








--function HomeSceneHelper:SetHomeScene_MeshCtrlYellowEnable(enable) -- 启用黄色车库模型控制器
--    local temp = CommonHelper:GetRootObjectExactMath(SceneHome_MeshControl_Yellow)
--    temp = UIUtil.GetGameobjectComponent(temp, typeof(CarMeshCtrl))
--    temp:EnableControl(enable, true)
--end
--
--function HomeSceneHelper:SetMeshCtrlTarger_Yellow(tar) -- 设置黄色车库模型控制器目标
--    local temp = CommonHelper:GetRootObjectExactMath(SceneHome_MeshControl_Yellow)
--    temp = UIUtil.GetGameobjectComponent(temp, typeof(CarMeshCtrl))
--    temp:SetTarget(tar)
--end
--
--function HomeSceneHelper:SetHomeScene_MeshCtrlAssembleEnable(enable) -- 启用改装台模型控制器
--    local temp = CommonHelper:GetRootObjectExactMath(SceneHome_MeshControl_Assemble)
--    temp = UIUtil.GetTypeChildWightByParent(SceneHome_CarRotation, temp, typeof(CarMeshCtrl))
--    --temp = UIUtil.GetGameobjectComponent(temp, typeof(CarMeshCtrl))
--    temp:Reset()
--    temp:EnableControl(enable, true)
--end
--
--function HomeSceneHelper:SetMeshCtrlTarger_Assemble() -- 设置改装台模型控制器目标
--    local temp = CommonHelper:GetRootObjectExactMath(SceneHome_MeshControl_Assemble)
--    local tar = UIUtil.GetChild(SceneHome_CarRoot, temp)
--    temp = UIUtil.GetTypeChildWightByParent(SceneHome_CarRotation, temp, typeof(CarMeshCtrl))
--    temp:SetTarget(tar)
--end






-----------------------------------------获取各个场景资源挂点
--{{{ 选车场景车挂点
function HomeSceneHelper:GetCarRoot_SelectCar()
    local obj = SceneManager:Get():GetMainCityScenePrefab(SceneChangeID.SelectCar,true)
    if obj then return UIUtil.GetChild("car_root", obj) end
end
--}}}

--{{{ 改装台场景车挂点
function HomeSceneHelper:GetCarRoot_RefitTable()
    local obj = SceneManager:Get():GetMainCityScenePrefab(SceneChangeID.RefitTable,true)
    if obj then return UIUtil.GetChild("car_root", obj) end
end
--}}}

--{{{ 蓝车库场景车挂点
function HomeSceneHelper:GetCarRoot_GarageBlue()
    local obj = SceneManager:Get():GetMainCityScenePrefab(SceneChangeID.Garage,true)
    if obj then return UIUtil.GetChild("car_root", obj) end
end
--}}}

--{{{ 新车库场景车挂点
function HomeSceneHelper:GetCarRoot_GarageNew()
    local obj = SceneManager:Get():GetMainCityScenePrefab(SceneChangeID.Garage_New,true)
    if obj then return UIUtil.GetChild("car_root", obj) end
end
--}}}

--{{{蓝车库车出厂动画挂点
function HomeSceneHelper:GetTimeLineRoot_Blue()
    local obj = SceneManager:Get():GetMainCityScenePrefab(SceneChangeID.Garage,true)
    if obj then
        local aniroot = UIUtil.GetChild("timeline", obj)
        return aniroot
    end
    return nil
end
--}}}
--{{{新车库车出厂动画挂点
function HomeSceneHelper:GetTimeLineRoot_Garage_New()
    local obj = SceneManager:Get():GetMainCityScenePrefab(SceneChangeID.Garage_New,true)
    if obj then
        local aniroot = UIUtil.GetChild("timeline", obj)
        return aniroot
    end
    return nil
end
--}}}


--{{{黄车库车出厂动画挂点
function HomeSceneHelper:GetTimeLineRoot_Yellow()
    local obj = SceneManager:Get():GetMainCityScenePrefab(SceneChangeID.SelectCar,true)
    if obj then
        local aniroot = UIUtil.GetChild("timeline", obj)
        return aniroot
    end
    return nil
end
--}}}
--{{{主城车挂点
function HomeSceneHelper:GetCarRoot_MainCity()
    local obj = SceneManager:Get():GetMainCityScenePrefab(SceneChangeID.MainCity,true)
    if obj then
        local aniroot = UIUtil.GetChild("carroot", obj)
        return aniroot
    end
    return nil
end
--}}}
--{{{新主城车挂点
function HomeSceneHelper:GetCarRoot_MainCity_New()
    local obj = SceneManager:Get():GetMainCityScenePrefab(SceneChangeID.MainCity_New,true)
    if obj then
        local aniroot = UIUtil.GetChild("carroot1", obj)
        return aniroot
    end
    return nil
end
function HomeSceneHelper:GetCarRoot_MainCity_NewNight()
    local obj = SceneManager:Get():GetMainCityScenePrefab(SceneChangeID.MainCity_NewNight,true)
    if obj then
        local aniroot = UIUtil.GetChild("carroot1", obj)
        return aniroot
    end
    return nil
end
--}}}

--{{{主城车中秋挂点
function HomeSceneHelper:GetCarRoot_MainCity_Autumn()
    local obj = SceneManager:Get():GetMainCityScenePrefab(SceneChangeID.MainCity_Autumn,true)
    if obj then
        local aniroot = UIUtil.GetChild("carroot", obj)
        return aniroot
    end
    return nil
end
--}}}
--{{{荣誉墙挂点
function HomeSceneHelper:GetCarRoot_RoleInfo(carId)
    local obj = SceneManager:Get():GetMainCityScenePrefab(SceneChangeID.RoleInfo,true)
    if obj then
        local aniroot = UIUtil.GetChild("car_root_1", obj)
        print("---------<<<<<<>>>"..carId)
        local groups={}
         groups[1] = UIUtil.GetChild("car_root_1", obj)
         groups[2] = UIUtil.GetChild("car_root_2", obj)
         groups[3] = UIUtil.GetChild("car_root_3", obj)
         groups[4] = UIUtil.GetChild("car_root_4", obj)
         groups[5] = UIUtil.GetChild("car_root_5", obj)
        return groups[carId]
    end
    return nil
end
function HomeSceneHelper:GetCupRoot_RoleInfo()
    local obj = SceneManager:Get():GetMainCityScenePrefab(SceneChangeID.RoleInfo,true)
    if obj then
        local aniroot = UIUtil.GetChild("trophy_root_01", obj)
        return aniroot
    end
    return nil
end
--}}}

--{{{荣誉墙挂点
function HomeSceneHelper:GetCarRoot_PersonalHome(carId)
    local obj = PersonalHomeDataManager:Get():GetRootScene()
    if obj then
        local aniroot = UIUtil.GetChild("desktop", obj)
        print("---------<<<<<<>>>"..carId)
        local groups={}
        groups[1] = UIUtil.GetChild("carroot_1.prefab", obj)
        groups[2] = UIUtil.GetChild("carroot_2.prefab", obj)
        groups[3] = UIUtil.GetChild("carroot_3.prefab", obj)
        groups[4] = UIUtil.GetChild("carroot_4.prefab", obj)
        groups[5] = UIUtil.GetChild("carroot_5.prefab", obj)
        return groups[carId]
    end
    return nil
end
--}}}

--{{{主页面排位
function HomeSceneHelper:GetCarRoot_RankList()
    local obj = SceneManager:Get():GetMainCityScenePrefab(SceneChangeID.RankingList,true)
    if obj then
        local aniroot = UIUtil.GetChild("car_rotate", obj)
        return aniroot
    end
    return nil
end
--}}}
--{{{主页面排行榜
function HomeSceneHelper:GetCarRoot_MainRankList()
    local obj = SceneManager:Get():GetMainCityScenePrefab(SceneChangeID.MainRankingList,true)
    if obj then
        local aniroot = UIUtil.GetChild("car_root", obj)
        return aniroot
    end
    return nil
end
--}}}
--{{{主页面排行榜摄像机
function HomeSceneHelper:GetCarRoot_MainRankListCameraRoot()
    local obj = SceneManager:Get():GetMainCityScenePrefab(SceneChangeID.MainRankingList,true)
    if obj then
        local aniroot = UIUtil.GetChild("Camera", obj)
        return aniroot
    end
    return nil
end
--}}}
--{{{排位赛
function HomeSceneHelper:GetCarRoot_RaceRank()
    local obj = SceneManager:Get():GetMainCityScenePrefab(SceneChangeID.RaceRank,true)
    if obj then
        local aniroot = UIUtil.GetChild("car_root", obj)
        return aniroot
    end
    return nil
end
--}}}



--{{{激走赛
function HomeSceneHelper:GetSelfCarRoot_RaceTrot_Vs()
    local obj = SceneManager:Get():GetMainCityScenePrefab(SceneChangeID.RaceTrot_Vs,true)
    if obj then
        local aniroot = UIUtil.GetChild("car_rotate_2", obj)
        return aniroot
    end
    return nil
end
--}}}

--{{{排位赛
function HomeSceneHelper:GetSelfCarRoot_RaceRank_SelectCar()
    local obj = SceneManager:Get():GetMainCityScenePrefab(SceneChangeID.RaceRankSelectCar,true)
    if obj then
        local aniroot = UIUtil.GetChild("car_rotate", obj)
        return aniroot
    end
    return nil
end
--}}}

--{{{激走赛敌人
function HomeSceneHelper:GetEnemyCarRoot_RaceTrot_Vs()
    local obj = SceneManager:Get():GetMainCityScenePrefab(SceneChangeID.RaceTrot_Vs,true)
    if obj then
        local aniroot = UIUtil.GetChild("car_rotate_1", obj)
        return aniroot
    end
    return nil
end
--}}}

--{{{JCP場景車輛挂點
function HomeSceneHelper:GetCarRoot_JCP()
    local obj = SceneManager:Get():GetMainCityScenePrefab(SceneChangeID.RefitTable,true)
    if obj then
        local aniroot = UIUtil.GetChild("car_root", obj)
        return aniroot
    end
    return nil
end
--}}}
-----------------------------------------获取各个场景车挂点













-----------------------------------------主城切换场景
--{{{ 切换主城
function HomeSceneHelper:SetHome()

end
--}}}

--{{{ 切换空
function HomeSceneHelper:SetNone()
    SceneManager:Get():MainCityChangeScene(SceneChangeID.None)
    CameraStackHelper:SetUIDefaultGroup()
    HomeSceneHelper:SetFog(SceneChangeID.None)
end
--}}}

--{{{ 切换抽奖动画
function HomeSceneHelper:SetCameraRecruitAni(obj)
    SceneManager:Get():MainCityChangeScene(SceneChangeID.Recruit)
    CameraStackHelper:SetUIDefaultGroup()
    HomeSceneHelper:SetFog(SceneChangeID.Recruit)
end
--}}}

--{{{ 切换房间赛
function HomeSceneHelper:SetRaceRoom(port)
    SceneManager:Get():MainCityChangeScene(SceneChangeID.Room)
    CameraStackHelper:SetCamera(SceneChangeID.Room,port)
    HomeSceneHelper:SetFog(SceneChangeID.Room)
end
--}}}

--{{{ 切换选车
function HomeSceneHelper:SetSelectCar(port)
    SceneManager:Get():MainCityChangeScene(SceneChangeID.SelectCar)
    CameraStackHelper:SetCamera(SceneChangeID.SelectCar, port)
    HomeSceneHelper:SetFog(SceneChangeID.SelectCar)
end
--}}}

--{{{ 切换车库
function HomeSceneHelper:SetGarage(port)
    SceneManager:Get():MainCityChangeScene(SceneChangeID.Garage)
    CameraStackHelper:SetCamera(SceneChangeID.Garage, port)
    HomeSceneHelper:SetFog(SceneChangeID.Garage)
end
--}}}

--{{{ 切换车库
function HomeSceneHelper:SetGarage_New(port)
    SceneManager:Get():MainCityChangeScene(SceneChangeID.Garage_New)
    CameraStackHelper:SetCamera(SceneChangeID.Garage_New, port)
    CameraStackHelper:EnableGarageCamera(SceneChangeID.Garage_New)
    HomeSceneHelper:SetFog(SceneChangeID.Garage_New)
end
--}}}

--{{{ 切换改装台
function HomeSceneHelper:SetRefitTable(port)
    SceneManager:Get():MainCityChangeScene(SceneChangeID.RefitTable)
    CameraStackHelper:SetCamera(SceneChangeID.RefitTable, port)
    HomeSceneHelper:SetFog(SceneChangeID.RefitTable)
end
--}}}
--{{{ 切换激走赛准备
function HomeSceneHelper:SetRaceTrotVs(port)
    SceneManager:Get():MainCityChangeScene(SceneChangeID.RaceTrot_Vs)
    CameraStackHelper:SetCamera(SceneChangeID.RaceTrot_Vs, port)
    HomeSceneHelper:SetFog(SceneChangeID.RaceTrot_Vs)
end
--}}}
--{{{ 切换排位赛选车
function HomeSceneHelper:SetRaceRankSelectCar(port)
    SceneManager:Get():MainCityChangeScene(SceneChangeID.RaceRankSelectCar)
    CameraStackHelper:SetCamera(SceneChangeID.RaceRankSelectCar, port)
    HomeSceneHelper:SetFog(SceneChangeID.RaceRankSelectCar)
end
--}}}


--{{{ 切换个人荣誉墙
function HomeSceneHelper:SetRoleInfo(port)
    SceneManager:Get():MainCityChangeScene(SceneChangeID.RoleInfo)
    CameraStackHelper:SetCamera(SceneChangeID.RoleInfo, port)
    HomeSceneHelper:SetFog(SceneChangeID.RoleInfo)
end

function HomeSceneHelper:SetPersonalHomeInfo(port)
    SceneManager:Get():MainCityChangeScene(SceneChangeID.PersonalHome)
    CameraStackHelper:SetCamera(SceneChangeID.PersonalHome, port)
    CameraStackHelper:PersonalHomeEnter()
    HomeSceneHelper:SetFog(SceneChangeID.PersonalHome)
end
--}}}

--{{{ 切换赛道预览
function HomeSceneHelper:SetTrackReview(position,rotation,lengthDistance)
    SceneManager:Get():MainCityChangeScene(SceneChangeID.TrackReview)
    CameraStackHelper:SwitchTrackReview(position,rotation,lengthDistance)
    HomeSceneHelper:SetFog(SceneChangeID.TrackReview)
end
--}}}

--{{{ 切换赛道预览
function HomeSceneHelper:SetTrackEdit()
    SceneManager:Get():MainCityChangeScene(SceneChangeID.TrackEditor)
     CameraStackHelper:SwitchTrackEditor()
    HomeSceneHelper:SetFog(SceneChangeID.TrackEditor)
end
--}}}

--{{{ 切换主界面
function HomeSceneHelper:SetMainCity(port)
    SceneManager:Get():MainCityChangeScene(SceneChangeID.MainCity)
    CameraStackHelper:SetCamera(SceneChangeID.MainCity, port)
    HomeSceneHelper:SetFog(SceneChangeID.MainCity)
end
--}}}

--{{{ 切换主界面
function HomeSceneHelper:SetMainCity_New(port)
    SceneManager:Get():MainCityChangeScene(SceneChangeID.MainCity_New)
    CameraStackHelper:SetCamera(SceneChangeID.MainCity_New, port)
    HomeSceneHelper:SetFog(SceneChangeID.MainCity_New)
end
--}}}
--{{{ 切换主界面
function HomeSceneHelper:SetMainCity_NewNight(port)
    SceneManager:Get():MainCityChangeScene(SceneChangeID.MainCity_NewNight)
    CameraStackHelper:SetCamera(SceneChangeID.MainCity_NewNight, port)
    HomeSceneHelper:SetFog(SceneChangeID.MainCity_NewNight)
end
--}}}

--{{{ 切换主界面中秋
function HomeSceneHelper:SetMainCityAutumn(port)
    SceneManager:Get():MainCityChangeScene(SceneChangeID.MainCity_Autumn)
    CameraStackHelper:SetCamera(SceneChangeID.MainCity_Autumn, port)
    HomeSceneHelper:SetFog(SceneChangeID.MainCity_Autumn)
end
--}}}

--{{{ 切换3D主场景
function HomeSceneHelper:SetMainCityInteraction(port)
    SceneManager:Get():MainCityChangeScene(SceneChangeID.MainCity_Interaction)
    CameraStackHelper:MainSceneEnter()
    HomeSceneHelper:SetFog(SceneChangeID.MainCity_Interaction)
end
--}}}

--{{{ 切换主界面排行榜
function HomeSceneHelper:SetMainRankingListOld(port)
    SceneManager:Get():MainCityChangeScene(SceneChangeID.RankingList)
    CameraStackHelper:SetCamera(SceneChangeID.RankingList, port)
    HomeSceneHelper:SetFog(SceneChangeID.RankingList)
end
--}}}

--{{{ 切换主界面排行榜
function HomeSceneHelper:SetMainRankingList(port)
    SceneManager:Get():MainCityChangeScene(SceneChangeID.MainRankingList)
    CameraStackHelper:SetCamera(SceneChangeID.MainRankingList, port)
    HomeSceneHelper:SetFog(SceneChangeID.MainRankingList)
end
--}}}
--{{{ 切换主界面排行榜
function HomeSceneHelper:SetRaceRank(port)
    SceneManager:Get():MainCityChangeScene(SceneChangeID.RaceRank)
    CameraStackHelper:SetCamera(SceneChangeID.RaceRank, port)
    HomeSceneHelper:SetFog(SceneChangeID.RaceRank)
end
--}}}


--{{{ 切换到AR场景
function HomeSceneHelper:SetARScene()
    SceneManager:Get():MainCityChangeScene(SceneChangeID.ARScene)
    --HomeSceneHelper:SetFog(SceneChangeID.PersonalHome)
end
--}}}

--{{{ 切换到默认场景
function HomeSceneHelper:SetDefaultScene()
    SceneManager:Get():MainCityChangeScene(SceneChangeID.Recruit)
    --HomeSceneHelper:SetFog(SceneChangeID.PersonalHome)
end
--}}}
--{{{ 切换到记录场景T
function HomeSceneHelper:SetSceneByType(type,port)
    SceneManager:Get():MainCityChangeScene(type)
    if type==SceneChangeID.Recruit or type==SceneChangeID.None then
    elseif type==SceneChangeID.TrackReview  then
        CameraStackHelper:SwitchTrackReview()
        HomeSceneHelper:SetFog(SceneChangeID.TrackReview)
    elseif type==SceneChangeID.TrackEditor  then
        CameraStackHelper:SwitchTrackEditor()
        HomeSceneHelper:SetFog(SceneChangeID.TrackEditor)
    elseif type==SceneChangeID.MainCity_Interaction  then
        CameraStackHelper:MainSceneEnter()
        HomeSceneHelper:SetFog(SceneChangeID.MainCity_Interaction)
    else
        CameraStackHelper:SetCamera(type, port)
        HomeSceneHelper:SetFog(type)
    end
end
--}}}

-----------------------------------------主城切换场景

function HomeSceneHelper:SetFog(id)
    ---@type scenechange_config_cell
    local cfg = CommonHelper:GetTableDataByID(ConfigNames.scenechange_config, id)
    if cfg then
        if cfg.fog~=-1 then
            ---@type fogsetting_config_cell
            local fogCfg = CommonHelper:GetTableDataByID(ConfigNames.fogsetting_config, cfg.fog)
            if fogCfg then
                local color= stringSplitToNumber(fogCfg.color,',')
                MonoHelper:RenderSettingFog(fogCfg.fog==1, Color(color[1]/255,color[2]/255,color[3]/255,color[4]/255), fogCfg.mode, fogCfg.startPoint, fogCfg.endPoint, fogCfg.density)

            end
        else
            MonoHelper:RenderSettingFog(false, Color(), 1, 1, 1, 1)

        end
      --
    end

end

local _CarMeshCtrl
function HomeSceneHelper:SetMeshCtrl_Rot(tar)
    _CarMeshCtrl:RotationToTarget(tar or 0)
end


-----------------------------------------模型控制器
--{{{蓝色车库模型控制器
function HomeSceneHelper:SetMeshCtrl_Blue(enable, tar)
    local obj = SceneManager:Get():GetMainCityScenePrefab(SceneChangeID.Garage,enable)
    if obj then
        local ctrlobj = UIUtil.GetChild("rotate_bule", obj)
        if ctrlobj then
             _CarMeshCtrl = UIUtil.GetGameobjectComponent(ctrlobj, typeof(CarMeshCtrl))
            if _CarMeshCtrl then
                _CarMeshCtrl:EnableControl(enable, true)
                _CarMeshCtrl:SetTarget(tar)
            end
        end
    end
end
--}}}
--{{{蓝色车库模型控制器
function HomeSceneHelper:SetMeshCtrl_GarageNew(enable, tar)
    local obj = SceneManager:Get():GetMainCityScenePrefab(SceneChangeID.Garage_New,enable)
    if obj then
        local ctrlobj = UIUtil.GetChild("rotate_bule", obj)
        if ctrlobj then
             _CarMeshCtrl = UIUtil.GetGameobjectComponent(ctrlobj, typeof(CarMeshCtrl))
            if _CarMeshCtrl then
                _CarMeshCtrl:EnableControl(enable, true)
                _CarMeshCtrl:SetTarget(tar)
            end
        end
    end
end
--}}}
--{{{黄色车库模型控制器
function HomeSceneHelper:SetMeshCtrl_Yellow(enable, tar)
    local obj = SceneManager:Get():GetMainCityScenePrefab(SceneChangeID.SelectCar,enable)
    if obj then
        local ctrlobj = UIUtil.GetChild("rotate_yellow", obj)
        if ctrlobj then
             _CarMeshCtrl = UIUtil.GetGameobjectComponent(ctrlobj, typeof(CarMeshCtrl))
            if _CarMeshCtrl then
                _CarMeshCtrl:EnableControl(enable, true)
                _CarMeshCtrl:SetTarget(tar)
            end
        end
    end
end
--}}}
--{{{个人信息改装台模型控制器
function HomeSceneHelper:SetMeshCtrl_Tamiya(enable, tar)
    local obj = SceneManager:Get():GetMainCityScenePrefab(SceneChangeID.RefitTable,enable)
    if obj then
        local ctrlobj = UIUtil.GetChild("rotation_root", obj)
        if ctrlobj then
             _CarMeshCtrl = UIUtil.GetGameobjectComponent(ctrlobj, typeof(CarMeshCtrl))
            if _CarMeshCtrl then
                _CarMeshCtrl:EnableControl(enable, true)
                _CarMeshCtrl:SetTarget(tar)
                _CarMeshCtrl:EnableZoom(enable)
            end
        end
    end
end
--}}}
--{{{ 注城模型控制器
function HomeSceneHelper:SetMeshCtrl_MainCity(enable, tar)
    local obj = SceneManager:Get():GetMainCityScenePrefab(SceneChangeID.MainCity,enable)
    if obj then
        local ctrlobj = UIUtil.GetChild("rotation_root", obj)
        if ctrlobj then
             _CarMeshCtrl = UIUtil.GetGameobjectComponent(ctrlobj, typeof(CarMeshCtrl))
            if _CarMeshCtrl then
                _CarMeshCtrl:EnableControl(enable, true)
                _CarMeshCtrl:SetTarget(tar)
            end
        end
    end
end
--}}}
--{{{ 注城模型控制器
function HomeSceneHelper:SetMeshCtrl_MainCityNew(enable, tar)
    local obj = SceneManager:Get():GetMainCityScenePrefab(SceneChangeID.MainCity_New,enable)
    if obj then
        local ctrlobj = UIUtil.GetChild("rotation_root", obj)
        if ctrlobj then
             _CarMeshCtrl = UIUtil.GetGameobjectComponent(ctrlobj, typeof(CarMeshCtrl))
            if _CarMeshCtrl then
                _CarMeshCtrl:EnableControl(enable, true)
                _CarMeshCtrl:SetTarget(tar)
                _CarMeshCtrl:EnableZoom(enable)
            end
        end
    end
end
function HomeSceneHelper:SetMeshCtrl_MainCityNewNight(enable, tar)
    local obj = SceneManager:Get():GetMainCityScenePrefab(SceneChangeID.MainCity_NewNight,enable)
    if obj then
        local ctrlobj = UIUtil.GetChild("rotation_root", obj)
        if ctrlobj then
             _CarMeshCtrl = UIUtil.GetGameobjectComponent(ctrlobj, typeof(CarMeshCtrl))
            if _CarMeshCtrl then
                _CarMeshCtrl:EnableControl(enable, true)
                _CarMeshCtrl:SetTarget(tar)
                _CarMeshCtrl:EnableZoom(enable)
            end
        end
    end
end
--}}}

--{{{ 注城中秋模型控制器
function HomeSceneHelper:SetMeshCtrl_MainCity_Autumn(enable, tar)
    local obj = SceneManager:Get():GetMainCityScenePrefab(SceneChangeID.MainCity_Autumn,enable)
    if obj then
        local ctrlobj = UIUtil.GetChild("rotation_root", obj)
        if ctrlobj then
             _CarMeshCtrl = UIUtil.GetGameobjectComponent(ctrlobj, typeof(CarMeshCtrl))
            if _CarMeshCtrl then
                _CarMeshCtrl:EnableControl(enable, true)
                _CarMeshCtrl:SetTarget(tar)
                _CarMeshCtrl:EnableZoom(enable)
            end
        end
    end
end
--}}}
--{{{ 注城模型控制器
function HomeSceneHelper:SetMeshCtrl_RankingList(enable, tar)
    local obj = SceneManager:Get():GetMainCityScenePrefab(SceneChangeID.RankingList,enable)
    if obj then
        local ctrlobj = UIUtil.GetChild("rotation_root", obj)
        if ctrlobj then
            _CarMeshCtrl = UIUtil.GetGameobjectComponent(ctrlobj, typeof(CarMeshCtrl))
            if _CarMeshCtrl then
                _CarMeshCtrl:EnableControl(enable, true)
                _CarMeshCtrl:SetTarget(tar)
            end
        end
    end
end
--}}}
--{{{ 注城模型控制器
function HomeSceneHelper:SetMeshCtrl_MainRankingList(enable, tar)
    local obj = SceneManager:Get():GetMainCityScenePrefab(SceneChangeID.MainRankingList,enable)
    if obj then
        local ctrlobj = UIUtil.GetChild("rotate_bule", obj)
        if ctrlobj then
            _CarMeshCtrl = UIUtil.GetGameobjectComponent(ctrlobj, typeof(CarMeshCtrl))
            if _CarMeshCtrl then
                _CarMeshCtrl:EnableControl(enable, true)
                _CarMeshCtrl:SetTarget(tar)
            end
        end
    end
end
--}}}
--{{{ 注城模型控制器
function HomeSceneHelper:SetMeshCtrl_RaceRank(enable, tar)
    local obj = SceneManager:Get():GetMainCityScenePrefab(SceneChangeID.RaceRank,enable)
    if obj then
        local ctrlobj = UIUtil.GetChild("rotation_root", obj)
        if ctrlobj then
            _CarMeshCtrl = UIUtil.GetGameobjectComponent(ctrlobj, typeof(CarMeshCtrl))
            if _CarMeshCtrl then
                _CarMeshCtrl:EnableControl(enable, true)
                _CarMeshCtrl:SetTarget(tar)
            end
        end
    end
end
--}}}



-----------------------------------------模型控制器





--function HomeSceneHelper:SetCameraTeam_PosTop(height)
--    local temp = CommonHelper:GetRootObjectExactMath(SceneHome_CameraGroup_Team)
--    temp = UIUtil.GetChild(SceneHome_Camera_Team, temp)
--
--    temp.transform.localEulerAngles = Vector3(4,0,0)
--
--    local endpos = temp.transform.localPosition
--    endpos = Vector3(endpos.x, -2,endpos.z)
--    TweenPosition.Begin(temp, temp.transform.localPosition, endpos,  0.2)
--    TweenRotation.Begin(temp, temp.transform.localEulerAngles, Vector3(4,0,0),  0.2)
--
--    local w =     CS.UnityEngine.Screen.width
--    local h =     CS.UnityEngine.Screen.height
--    local temph = w / h
--    local port = Rect(0,height,1,temph)
--    local cam = UIUtil.GetTypeChildWightByParent("camera", temp, typeof(Camera))
--    cam.rect = port
--
--
--
--end
--
--function HomeSceneHelper:SetCameraTeam_PosCenter(height)
--    local temp = CommonHelper:GetRootObjectExactMath(SceneHome_CameraGroup_Team)
--    --temp = UIUtil.GetChild(SceneHome_Camera_Team, temp)

--    --temp.transform.localEulerAngles = Vector3.zero
--
--
--    --local endpos = temp.transform.localPosition
--    --endpos = Vector3(endpos.x, 0,endpos.z)
--    --TweenPosition.Begin(temp, temp.transform.localPosition, endpos,  0.2)
--    --TweenRotation.Begin(temp, temp.transform.localEulerAngles, Vector3.zero,  0.2)
--
--    local w =     CS.UnityEngine.Screen.width
--    local h =     CS.UnityEngine.Screen.height
--    local temph = w / h
--    local port = Rect(0,height,1,temph)
--    --local cam = UIUtil.GetTypeChildWightByParent("camera", temp, typeof(Camera))
--    --cam.rect = port
--end


