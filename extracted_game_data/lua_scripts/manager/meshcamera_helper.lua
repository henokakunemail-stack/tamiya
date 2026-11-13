---@class MeshRoot
MeshRoot={
    CupRoot="CupRoot",
    SelectTeam="SelectTeam",
    ArticleInfo="ArticleInfo",
    Recruit="Recruit",
}
local _ShowLayer="MeshShow"


---@class MeshCameraHelper
MeshCameraHelper = class("MeshCameraHelper")

function MeshCameraHelper:initialize()
    self.Root=UIManager:GetMeshCanvasRoot()
end
function MeshCameraHelper:Get()
    if self.Instance == nil then
        self.Instance = MeshCameraHelper()
    end
    return self.Instance
end


function  MeshCameraHelper:EnableMeshCamera(enable,cameraRoot)
    if enable then
        self.Camerapartent=UIManager:GetMeshCamera().transform.parent
        self.CameraoldPos= UIManager:GetMeshCamera().transform.localPosition
        self.CameraoldScale=UIManager:GetMeshCamera().transform.localScale
        self.CameraoldRot=UIManager:GetMeshCamera().transform.localRotation
        UIUtil.SetParentTransform(cameraRoot,UIManager:GetMeshCamera(),true,false)
    else
        UIManager:GetMeshCamera().transform.parent= self.Camerapartent
        if self.CameraoldRot then
            UIManager:GetMeshCamera().transform.localPosition=self.CameraoldPos
            UIManager:GetMeshCamera().transform.localScale=self.CameraoldScale
            UIManager:GetMeshCamera().transform.localRotation=self.CameraoldRot
        end
    end
    UIManager:EnableMeshCamera(enable)
    UIManager:SetMeshCameraCullingMask(_ShowLayer)
end


function MeshCameraHelper:GetRoot(name)
    return UIUtil.GetChildInputPath(name.."/root",self.Root)
end


function MeshCameraHelper:AddChild(name)
    local asset= AssetsManager.Load(string.format("%s.prefab",name), typeof(GameObject))
    local go= CommonHelper:InstantiateGameObjectByObject(asset.asset)
    go.name=name
    UIUtil.SetParentTransform(self.Root,go,true,false)
    return UIUtil.GetChildInputPath("root",go)
end

function MeshCameraHelper:ShowGameObjectInMeshCamera(go,parentname,cameraname)
    local partent=self.Root
    if not CommonHelper:IsNullOrEmpty(parentname) then
        partent=self:GetRoot(parentname)
        if partent==nil then
            partent= self:AddChild(parentname)
        end
    end
    local cameraRoot= UIUtil.GetChildInputPath(cameraname,partent)
    self:EnableMeshCamera(true,cameraRoot)
    UIUtil.SetParentTransform(partent,go,true,false)
    mono.SetLayerName( self.Root,_ShowLayer)
end

function MeshCameraHelper:Close()
    self:EnableMeshCamera(false)
end
