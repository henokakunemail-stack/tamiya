---@class CarBuilderTextureParam
CarBuilderTextureParam=class("CarBuilderTextureParam")

function CarBuilderTextureParam:initialize()
    self.CarReviewData=nil
    self.idx=nil
    self.isBuildTexture=true
    self.UIModuleId=UIModuleID.None
end

---@class CarBuilderTexture
CarBuilderTexture=class("CarBuilderTexture")

function CarBuilderTexture:initialize()
    self.EndFunc=nil
    self.CarId=-1
    self.CarObj=nil
    self.Param=nil
    self.Texture=nil
    self.Id=-1
    self.BuildDone=false
end
---@type CarBuilderTextureParam
function CarBuilderTexture:BeninBuild(builderData,endFunc)
    self.EndFunc=endFunc
    self.BuildDone=false
    self.BuilderData=builderData
    if builderData then
        ---@type CarReviewData
        local carData=builderData.CarReviewData
        local param = CarBuilderParam()
        param.buildType = CarBuilderType.Data
        param.parts = carData:GetPartList()
        param.lightweight = carData:GetLightweight()
        param.grids = carData:GetGrids()
        param.colorid = carData:GetColorId()
        param.stickerid = carData:GetStickerid()
        param.combineType = CombineType.None
        param.parent = self:GetCarRoot()
        param.BuilderTexture=true
        param.finishEvt=function(id, obj, param)
            if  self.BuilderData.isBuildTexture then
                self:BuilderTexture(id, obj, param)
            else
                self:BuildOver(id, obj, param)
                self.BuildDone=true
                if self.EndFunc then
                    self.EndFunc(self)
                end
            end
        end
        param.finishParam=param
        CarBuilderManager:Get():BuildCar(param)
    end
end

function CarBuilderTexture:BuildOver(id, obj, param)
    self.CarId=id
    self.CarObj=obj
    self.Param=param
end

function CarBuilderTexture:BuilderTexture(id, obj, param)
    self:BuildOver(id, obj, param)
    local layer=obj.layer
    --mono.SetLayerName(obj,"RaceTrot")
    self.Texture=CarBuilderManager:Get():GetCarBuilder(self.CarId).CarIcon
    cs_coroutine.start(function()
        --mono.SetLayer(obj,layer)
       -- CommonHelper:CSGameObjectSetActive(obj, false)
        self.BuildDone=true
        if self.EndFunc then
            self.EndFunc(self)
        end
    end)

end


function CarBuilderTexture:GetCarRoot()
    local Root=UIUtil.GetChild("CarRt/car_root", RtHelper:GetRoot())
    return Root
end

function CarBuilderTexture:GetCameraRoot()
    local Root=UIUtil.GetChild("CarRt/camera_root",RtHelper:GetRoot())
    return Root
end
function CarBuilderTexture:SetId(value)
    self.Id=value
end

function CarBuilderTexture:Break()

end

function CarBuilderTexture:Release()
    CarBuilderManager:Get():Recycle(self.CarId)
    self.EndFunc=nil
    self.CarId=-1
    self.CarObj=nil
    self.Param=nil
    self.Id=-1
    self.Texture=nil
end
