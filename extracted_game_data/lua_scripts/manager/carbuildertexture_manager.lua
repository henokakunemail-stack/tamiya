---@class CarBuilderTextureManager
CarBuilderTextureManager = class("CarBuilderTextureManager")
function CarBuilderTextureManager:initialize()
    self.BuilderQueue=Queue()
    self.IsBuilding=false
    ---@type CarBuilderTexture[]
    self.CarList={}
end
---@return CarBuilderTextureManager
function CarBuilderTextureManager:Get()
    if self._instance then
        return self._instance
    end
    self._instance = CarBuilderTextureManager()
    return self._instance
end


---@type CarBuilderTextureParam
function CarBuilderTextureManager:BuildOne(param,endFun)
    self.EndFunction=endFun
    self.BuilderQueue:EnQueueFront(param)
    self.CoroutineList= {}
    self.TextureBuildList={}
    self:BeninBuild()
end
---@type CarBuilderTextureParam[]
function CarBuilderTextureManager:BuildMore(param,endFun,changeFun)
    self.EndFunction=endFun
    self.ChangeFun=changeFun
    for i = 1, #param do
        self.BuilderQueue:EnQueueFront(param[i])
    end
    self.CoroutineList= {}
    self.TextureBuildList={}
    self:BeninBuild()
end

---@type CarBuilderTextureParam
function CarBuilderTextureManager:BeninBuild()
    local buildData=self.BuilderQueue:DeQueueFront()
    if buildData then
        self.IsBuilding=true
        local index=#self.CoroutineList+1
        local Coroutine=cs_coroutine.start(function(data)
            coroutine.yield(CS.UnityEngine.WaitForSeconds(0.2))
            local TextureBuild=CarBuilderTexture()
            table.insert(self.CarList,TextureBuild)
            TextureBuild:SetId(#self.CarList)
            TextureBuild:BeninBuild(data[1],function(textureBuild)
                if self.ChangeFun then
                    self.ChangeFun(textureBuild)
                end
                self:SetDone()
            end)
            CarBuilderTextureManager:Get().CoroutineList[data[2]]=-1
        end,{buildData,index})
        self.CoroutineList[index]=Coroutine
        self:BeninBuild()
    end
end
function CarBuilderTextureManager:SetDone()
    for i = 1, #self.CarList do
        if self.CarList[i].BuildDone==false then
          return
        end
    end
    self.IsBuilding=false
    if self.EndFunction then
      self.EndFunction(self.CarList)
    end
    self.EndFunction=nil
end
function CarBuilderTextureManager:GetCarList() return self.CarList end
function CarBuilderTextureManager:Break()
    if self.IsBuilding then
        if self.CoroutineList then
            for k, v in pairs(self.CoroutineList) do
                if v~=-1 then
                    cs_coroutine.stop(v)
                end
            end
        end
        if self.CarList then
            for k, v in pairs(self.CarList) do
                v:Break()
            end
        end
        self.IsBuilding=false
        self.EndFunction=nil
    end
end

function CarBuilderTextureManager:Clear()
    self:Break()
    if self.CarList then
        for k, v in pairs(self.CarList) do
            v:Release()
        end
    end
    self.CarList={}
    self.BuilderQueue:Clear()
end
