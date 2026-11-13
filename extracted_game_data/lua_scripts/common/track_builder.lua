---@class TrackBuilder
TrackBuilder = class("TrackBuilder")

function TrackBuilder:initialize()

end
function TrackBuilder:initialize()
    self.Instance = nil
    ---@table<string,texture>
    self.trackPicDic ={}
    ---@table<gameObject>
    self.trackList={}
    ---@table<CustomTrack_Data>

end
local  trackDataList={}
local _IsCreate=false
local _IsBuilding=false
local index=1
local _skip=false
local _CreateHandle=nil
local lastTrackData=nil
function TrackBuilder:Get()
    if self.Instance == nil then self.Instance = TrackBuilder() end
    return self.Instance
end
function TrackBuilder:SetCameraState()
    CameraStackHelper:SetTrackScene()
end
function TrackBuilder:LoadPrefab(resname)
    self.raceTrackAsset = AssetsManager.LoadAsync( string.format("%s.prefab",resname), typeof(GameObject))
    self.raceTrackAsset:AddComplete( function(asset)
        if asset ~= nil and asset.asset ~= nil then
            local trackObj = GameObject.Instantiate(asset.asset)
            table.insert(self.trackList,trackObj)
            mono.SetLayerName(trackObj, "TrackRes")
            mono.SetTagName(trackObj, "TrackRoot")
            local texture=  CommonHelper:PhotographTrack()
            self.trackPicDic[resname]=texture
            rawImage.texture=texture
            trackObj:SetActive(false)
        end
    end)
end
function TrackBuilder:SetUI3dIcon(resName,rawImage)
    if self.trackPicDic[resName]~=nil then
       rawImage.texture=self.trackPicDic[resName]
    else
        --print("resName"..resName)
        --PrefabCacheMgr:Get():SwapPrefabAsync(resName..".prefab",nil,nil,function(param,trackObj)
        --    table.insert(self.trackList,trackObj)
        --    mono.SetLayerName(trackObj, "TrackRes")
        --    local texture= self:LoadTrackFinish(rawImage)
        --    self.trackPicDic[resName]=texture
        --    rawImage.texture=texture
        --    trackObj:SetActive(false)
        --end)
        ---[[
        self.raceTrackAsset = AssetsManager.LoadAsync( string.format("%s.prefab",resName), typeof(GameObject))
        self.raceTrackAsset:AddComplete( function(asset)
            if asset ~= nil and asset.asset ~= nil then
                local trackObj = GameObject.Instantiate(asset.asset)
                table.insert(self.trackList,trackObj)
                mono.SetLayerName(trackObj, "TrackRes")
                mono.SetTagName(trackObj, "TrackRoot")
               local texture=  CommonHelper:PhotographTrack()
                self.trackPicDic[resName]=texture
                rawImage.texture=texture
                trackObj:SetActive(false)
            end
        end)
        ---]]
    end
    return rawImage.texture
end

---@param trackData CustomTrack_Data
function TrackBuilder:SetUI3dIconByTrackData(trackData,rawImage,picName)

    print("拍照赛道")
    if self.trackPicDic==nil then
        self.trackPicDic={}
    end
    if self.trackPicDic[picName]~=nil then
        rawImage.texture=self.trackPicDic[picName]
    else
        table.insert(trackDataList,{trackData,rawImage,picName})
        if not _IsCreate then
            _IsCreate=true
            _CreateHandle = cs_coroutine.start(function ()
                while index<=#trackDataList do
                    local trackData=trackDataList[index][1]
                    local rawImage=trackDataList[index][2]
                    local name=trackDataList[index][3]
                    coroutine.yield(TrackBuilder:Get():BuildTexture(trackData,rawImage,name))
                    index=index+1
                    coroutine.yield(CS.UnityEngine.WaitForSeconds(0.1))
                end
                trackDataList={}
                index=1
                SelfDefineTrack:Clear()
                _CreateHandle=nil
                lastTrackData=nil
                _IsCreate=false
            end)
        end
    end
end
function TrackBuilder:BuildAllTexture()

end
local _handle=nil
function TrackBuilder:CreateUI3DIcon()
    --print(#trackDataList.."#trackdatalist")
end
function TrackBuilder:CheckTrackDataChange(trackData)
    local isReturn=true
    if trackData==nil then return end
    if trackData.trackSgList~=nil then
        if #trackData.trackSgList==#lastTrackData.trackSgList then
            for i = 1, #trackData.trackSgList do
                if lastTrackData.trackSgList[i]~=trackData.trackSgList[i] then
                    isReturn=false
                    break
                end
            end
        else
            isReturn=false
        end
    end
    return isReturn
end
---@param trackData CustomTrack_Data
function TrackBuilder:BuildTexture(trackData,rawImage,name)
    _IsBuilding=true
    if  lastTrackData~=nil then
        local isReturn =self:CheckTrackDataChange(trackData)
        if isReturn then
            rawImage.texture=TrackBuilder:Get().trackPicDic[name]
            return
        end
    end
    CameraStackHelper:SetTrackScene()
    _handle= cs_coroutine.start(function(param)
        ---@type CustomTrack_Data
        local trackData=param[1]
        local rawImage=param[2]
        local name=param[3]
        if trackData~=nil then
            trackData:InitCSharpOnPreview()
            while not SelfDefineTrack:isDone() do
                coroutine.yield()
            end
            coroutine.yield()
            coroutine.yield()
            coroutine.yield()
            local texture= CommonHelper:PhotographTrack()
            texture.name=name
            if texture~=nil then
                if TrackBuilder:Get().trackPicDic[name]~=nil then
                    CS.UnityEngine.Object.Destroy(TrackBuilder:Get().trackPicDic[name])
                end
            end
            rawImage.texture=texture
            TrackBuilder:Get().trackPicDic[name]=texture
            SelfDefineTrack:RecycleAll()
            coroutine.yield()
            coroutine.yield()
            --CameraStackHelper:RestoreTrackScene()
            lastTrackData=trackData
            _handle = nil
            _IsBuilding=false
        end
    end,{trackData,rawImage,name})
end
function TrackBuilder:LoadTrackFinish()
    SelfDefineTrack:GetRequiredOrthographicSize()
   local textTrue= UIRenderTextureUtil.CreateTrackUI3DIcon("AAA")
    return textTrue
end

function TrackBuilder:StopSequence()

end
function TrackBuilder:RestoreCamera(disableComponent)
    if _IsBuilding then
        if _handle~=nil then
            cs_coroutine.stop(_handle)
        end
        if _CreateHandle~=nil and _IsCreate  then
            lastTrackData=nil
            _IsCreate=false
            index=1
            cs_coroutine.stop(_CreateHandle)
        end
    end
    _IsBuilding=false
    SelfDefineTrack:RecycleAll()
    CameraStackHelper:RestoreTrackScene(disableComponent)
    SelfDefineTrack:Clear()
end
function TrackBuilder:SavePic(texture,picName)
    UIRenderTextureUtil.SavePic(texture,picName)
end
function TrackBuilder:GetSelfTrackIcon(iconName)
    if self.trackPicDic[iconName] ==nil then
        local texture=self:ReadTrackPicFromPDir(iconName)
        if texture~=nil then
            self.trackPicDic[iconName]=texture
        end
    end
    return self.trackPicDic[iconName]
end
function TrackBuilder:SavePicToPDir(texture,picName)
    UIRenderTextureUtil.SavePicToPDir(texture,picName)
end

function TrackBuilder:ReadTrackPicFromPDir(name)
   local texture = UIRenderTextureUtil.ReadPicFromPDir(name)
   return texture
end
function TrackBuilder:Clear()
    for i, v in pairs(self.trackPicDic) do
        CS.UnityEngine.Object.Destroy(v)
    end
    lastTrackData=nil
    self.trackPicDic= {}
end
function TrackBuilder:GetTrackPicByTrackData(trackData)

end