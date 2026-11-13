---@class CupBuilderTexture
CupBuilderTexture={}
local _Count=0
function CupBuilderTexture:BuilderTexture(name,func,textname,text)
    self.CupAsset= AssetsManager.LoadAsync(name, typeof(GameObject))
    self.CupAsset:AddComplete(function(asset)
        cs_coroutine.start(function()
            _Count=_Count+1
            self.Root=CommonHelper:InstantiateGameObjectByObject(asset.asset)
            UIUtil.SetParentGameObject( CupBuilderTexture:GetRoot(),self.Root,true)
            self.Root.transform.localScale=Vector3.one
            if textname and text and self.Root then
                CommonHelper:Set3D_TextGroup(textname,text,self.Root)
            end
            mono.SetLayerName( self.Root,"RaceTrot")
            local  Icon=RtHelper:CreateUI3DIcon(self.Root,CupBuilderTexture:GetCameraRoot(), "RaceTrot", "cup_texture".._Count,812,1125)
            if  func then func(Icon) end
            GameObject.Destroy(self.Root)
            AssetsManager.Unload(self.CupAsset)
        end)
    end)
end

function CupBuilderTexture:GetRoot()
    local Root=UIUtil.GetChild("CupPicRoot/cuproot", RtHelper:GetRoot())
    return Root
end

function CupBuilderTexture:GetCameraRoot()
    local Root=UIUtil.GetChild("CupPicRoot/cameraroot",RtHelper:GetRoot())
    return Root
end