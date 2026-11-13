
---@class Template_TrackPic : ViewBase
Template_TrackPic = class("Template_TrackPic", ViewBase)

-- View必加
function Template_TrackPic:initialize()
    ViewBase.initialize(self)
    self.trackPicDic={}
end

local textTrue=nil
local _CfgList= { }
local _Index=1
function Template_TrackPic:Awake()
    local  cfg= ClientDataManager:Get():GetDataTable(ConfigNames.racetrack_config)
    for i, v in pairs(cfg.GetConfigData()) do
        table.insert(_CfgList,v)
    end
    self.trackIdInput = UIUtil.GetTypeChildWightInputPath("TrackID", self.gameObject, typeof(InputField))
    self.PosX = UIUtil.GetTypeChildWightInputPath("PosX", self.gameObject, typeof(InputField))
    self.PosY = UIUtil.GetTypeChildWightInputPath("PosY", self.gameObject, typeof(InputField))
    self.PosZ = UIUtil.GetTypeChildWightInputPath("PosZ", self.gameObject, typeof(InputField))
    self.RotX = UIUtil.GetTypeChildWightInputPath("RotX", self.gameObject, typeof(InputField))
    self.RotY = UIUtil.GetTypeChildWightInputPath("RotY", self.gameObject, typeof(InputField))
    self.RotZ = UIUtil.GetTypeChildWightInputPath("RotZ", self.gameObject, typeof(InputField))
    self.raw = UIUtil.GetTypeChildWightInputPath("TrackPic", self.gameObject, typeof(RawImage))
    self.PicName = UIUtil.GetTypeChildWightInputPath("PicName", self.gameObject, typeof(InputField))
   CommonHelper:HButtonSetCallback("BtnClose",self.gameObject,function (data)
       UIManager:Get():CloseView()
   end)
    CommonHelper:HButtonSetCallback("BtnLoadTrack",self.gameObject,function (data)
        _Index=_Index+1
        self:SetView()
   end)
    CommonHelper:HButtonSetCallback("BtnPhotograph",self.gameObject,function (data)
        --if self.trackPicDic[_CfgList[_Index].resname]~=nil then
        --    self.trackPicDic[_CfgList[_Index].resname]:SetActive(true)
        --end
        textTrue= UIRenderTextureUtil.CreateTrackUI3DIcon(Vector3(tonumber(self.PosX.text),tonumber(self.PosY.text),tonumber(self.PosZ.text)),Vector3(tonumber(self.RotX.text),tonumber(self.RotY.text),tonumber(self.RotZ.text)),"AAA")
        self.raw.texture=textTrue
        --self.trackPicDic[_CfgList[_Index].id]:SetActive(false)
    end)
    CommonHelper:HButtonSetCallback("SaveBtn",self.gameObject,function (data)
        TrackBuilder:Get():SavePic(textTrue,_CfgList[_Index].icon)
    end)
end
function Template_TrackPic:SetUI3dIcon(resName,rawImage)

        CommonHelper:LoadMiniTrack(MiniTrackType.System,resName)
        local texture= UIRenderTextureUtil.CreateTrackUI3DIcon(Vector3(0,100,0),Vector3(90,0,0),"AAA")
               -- self.trackPicDic[resName]=trackObj
        rawImage.texture=texture
        CommonHelper:UnloadTrack(MiniTrackType.LocalCustomTrack)
    return rawImage.texture
end
function Template_TrackPic:SetView()
    CommonHelper:InputFieldSetValue(self.trackIdInput,_CfgList[_Index].id)
    textTrue=self:SetUI3dIcon(_CfgList[_Index].id,self.raw)
    self.PicName.text=_CfgList[_Index].icon
    self.PosX.text="0"
    self.PosY.text="100"
    self.PosZ.text="0"
    self.RotX.text="90"
    self.RotY.text="0"
    self.RotZ.text="0"
end
function Template_TrackPic:OnOpen()
    --LightGroupManager:Get():BuildLight(SceneHome_LightGroup_Recruit)
   TrackBuilder:Get():SetCameraState()
   self:SetView()
end
function Template_TrackPic:OnClose()
 _Index=1
end