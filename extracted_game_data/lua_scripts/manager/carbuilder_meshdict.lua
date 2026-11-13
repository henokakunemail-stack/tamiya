local _ID = 0

---@class CarBuilderMeshKey @车模型mesh 的详细信息，比如这个mesh的名字，槽位id，是不是挂点，是不是金属，以及obj{},是不是连接件
CarBuilderMeshKey = class("CarBuilderMeshKey")
function CarBuilderMeshKey:initialize()
    _ID = _ID + 1

    --print("------当前mesh的id----:",_ID)
    self.ID = _ID
    self.ResName = ""
    self.GrooveID = PartGrooveID.Error
    self.IsDummy = false
    self.IsDefaultMesh = false
    self.IsLink = false
    self.LinkIdx = -1
    self.Metal = false
    self.Objs = {}
end

-----@param value CarBuilderMeshKey
--function CarBuilderMeshKey:IsEqual(value)
--    local temp = false
--    if value then
--        temp = (self.ResName == value.ResName) and
--               (self.GrooveID == value.GrooveID) and
--               (self.IsDummy == value.IsDummy) and
--               (self.IsDefaultMesh == value.IsDefaultMesh) and
--               (self.IsLink == value.IsLink) and
--               (self.Metal == value.Metal)
--    end
--    return temp
--end





----根据mesh名字，创建 挂点 的mesh信息
---@return CarBuilderMeshKey
function CarBuilder:CreateMeshKeyDummy(resname)
    local key = CarBuilderMeshKey()
    key.ResName = resname
    key.IsDummy = true
    return key
end

----根据槽位id 和 mesh 名字 创建 安装到槽位 的mesh信息
---@return CarBuilderMeshKey
function CarBuilder:CreateMeshKeyGroovePart(resname, grooveid)
    --
    local key = CarBuilderMeshKey()
    key.ResName = resname
    key.GrooveID = grooveid
    return key
end

----创建 连接件 的mesh信息
---@return CarBuilderMeshKey
function CarBuilder:CreateMeshKeyLinkPart(resname, grooveid, linkidx)
    --创建连接件id
    local key = CarBuilderMeshKey()
    key.ResName = resname
    key.IsLink = true
    key.LinkIdx = linkidx
    key.GrooveID = grooveid
    return key
end
----创建默认模型 的mesh 信息
---@return CarBuilderMeshKey
function CarBuilder:CreateMeshKeyDefaultPart(resname)
    --创建普通mesh
    local key = CarBuilderMeshKey()
    key.ResName = resname
    key.IsDefaultMesh = true
    return key
end

----给mesh添加模型GameObject,也就是这个mesh由哪些GameObject组成,同时检查该mesh 是不是金属材质
---@param key CarBuilderMeshKey
function CarBuilder:AddMesh(key, obj)
    if key == nil then
        if AssembleLogEnable then
            logError("---   error:CarBuilder:AddMesh   key = nil   obj = ", obj)
        end
        return
    end
    if #key.Objs == 0 then
        self:UpdateMeshKey(key, obj)
    end

    table.insert(key.Objs, obj)

    local isexist = false
    for i = 1, #self.MeshKeyList do
        local temp = self.MeshKeyList[i]
        if temp.ID == key.ID then
            isexist = true
            break
        end
    end
    if isexist == false then
        table.insert(self.MeshKeyList, key)
        --print("当前meshKey的数量------",#self.MeshKeyList)
    end
end

----如果mesh不是挂点，就检查该mesh 是不是金属材质
---@param key CarBuilderMeshKey
function CarBuilder:UpdateMeshKey(key, obj)
    if key.IsDummy == false then
        key.Metal = MonoHelper:CheckPartMetal(obj)
    end
end

----根据槽位id 获取该mesh 下所有组成的object
function CarBuilder:GetMeshListByGrooveID(grooveid, resname)
    --local result = {}
    --if self.UsingMeshDict[grooveid] == nil then
    --    return result
    --end
    --
    --local temp = self.UsingMeshDict[grooveid]
    --for i = 1, #temp do
    --    if temp[i].name == resname then
    --        table.insert(result, temp[i])
    --    end
    --end
    --return result


    local result = {}
    for i = 1, #self.MeshKeyList do
        local temp = self.MeshKeyList[i]
        if temp.IsDummy == false and temp.GrooveID == grooveid and temp.ResName == resname then
            for m = 1, #temp.Objs do
                table.insert(result, temp.Objs[m])
            end
        end
    end
    return result
end

----获取所有mesh 下 不是挂点的所有obj,一个mesh 可以有多个obj组成
function CarBuilder:GetAllMeshObj()
    local result = {}
    for i = 1, #self.MeshKeyList do
        local temp = self.MeshKeyList[i]
        if temp.IsDummy == false then
            for m = 1, #temp.Objs do
                table.insert(result, temp.Objs[m])
            end
        end
    end
    return result
end