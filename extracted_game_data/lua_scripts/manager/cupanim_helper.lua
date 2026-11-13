---@class CupAnimHelper
CupAnimHelper = class("CupAnimHelper")

function CupAnimHelper:initialize()

end
function CupAnimHelper:Get()
    if self.Instance == nil then
        self.Instance = CupAnimHelper()
    end
    return self.Instance
end

---@type RaceModel
function CupAnimHelper:ShowCupAnimByRaceModel(type)
    ---@type cup_config_cell
     self.Cfg=CommonHelper:GetTableDataByID(ConfigNames.cup_config,type)
    local show=true
    if type==RaceModel.Battle then
       local chapterId,levelid=CommonHelper:AnalyseChapterId(BattleDataManager:Get():GetLevelId())
       show=chapterId<self.Cfg.param
    end
    if self.Cfg and show then
        self.CupAsset= AssetsManager.Load(self.Cfg.cupprefab..".prefab", typeof(GameObject))
        self.CupGo= CommonHelper:InstantiateGameObjectByObject(self.CupAsset.asset)
        if type==RaceModel.RaceRank then
            local textname={"num1","num2","num3" }
            local text=tostring(RaceRankManager:Get():GetSessionId())
            if textname and text then
                CommonHelper:Set3D_TextGroup(textname,text,self.CupGo)
            end
        end
        self.Asset= AssetsManager.Load(self.Cfg.animation..".prefab", typeof(GameObject))
        self.Go= CommonHelper:InstantiateGameObjectByObject(self.Asset.asset)
        UIUtil.SetParentTransform(UIUtil.GetChildInputPath("cuproot/race"..type.."_cup",self.Go),self.CupGo,true,false)
        for i = 0, UIUtil.GetChild("cuproot",self.Go).transform.childCount-1 do
            local go=UIUtil.GetChild("cuproot",self.Go).transform:GetChild(i).gameObject
            if go then
                CommonHelper:CSGameObjectSetActive(go,go.name=="race"..type.."_cup")
            end
        end
        local name=CommonHelper:GetTempStr_Default(self.Cfg.name)
        --local textRoot=nil
        --local length,result=getStringTrueLength(name)
        --for i = 3, 8 do
        --    local text= CommonHelper:SetGameObjectActive("text"..i,self.Go,i==length)
        --    if i==length then
        --        textRoot=text
        --    end
        --end

        for i = 0, UIUtil.GetChild("allrace",self.Go).transform.childCount-1 do
            local go=UIUtil.GetChild("allrace",self.Go).transform:GetChild(i).gameObject
            if go then
                CommonHelper:CSGameObjectSetActive(go,go.name=="race"..self.Cfg.C_ID)
            end
        end
        MeshCameraHelper:Get():ShowGameObjectInMeshCamera(self.Go,MeshRoot.CupRoot,"CameraRoot")
        cs_coroutine.start(function()
            coroutine.yield(CS.UnityEngine.WaitForSeconds(5))
            CupAnimHelper:Release()
        end)
        return true
    else
        return false
    end

end
function CupAnimHelper:Release()
    if self.Go then
        GameObject.Destroy(self.CupGo)
        AssetsManager.Unload(self.CupAsset)
        GameObject.Destroy(self.Go)
        AssetsManager.Unload(self.Asset)
        self.Asset= nil
        self.Go= nil
        MeshCameraHelper:Get():Close()
    end
end

