
mono.SqlInit()
ClientDataManager:Get():InitLoginConfig()
ClientDataManager:Get():InitConfig()
local path = "Assets/ArtRes/Bundles/prefab/car/auto/dummy/"
CarAssembleRule:Get():Init()


local function Create(flag, name)
    local result = {}
    local filename = path..name..".prefab"
    local obj = mono.UnityEditorLoadAsset(filename)
    local points = CarAssembleRule:Get():GetDummyPointMap()
    for k,v in pairs(points) do
        local temp = UIUtil.GetChild(v, obj)
        if temp then
            local pos = temp.transform.position

            local data = {}
            data.dummy = name
            data.point = v
            data.x = string.format("%.8f",pos.x)
            data.y = string.format("%.8f",pos.y)
            data.z = string.format("%.8f",pos.z)
            table.insert(result, data)
        else
            --print("---------   error:找不到挂点")
        end

    end





    local file = io.output(name..".txt")
    table.sort(result,function (a,b)
        return a.point < b.point
    end)


    for i = 1, #result do
        local data = result[i]
        local idx = i
        local dummy = data.dummy
        local point = data.point
        local x = data.x
        local y = data.y
        local z = data.z
        local str = tostring(idx).."\t"..tostring(flag).."\t"..(dummy).."\t"..(point).."\t"..(x).."\t"..(y).."\t"..(z).."\n"
        io.write(str)
    end

    io.close(file)

    print("---   生成文件："..name..".txt")
end










Create(1061,"chassis_dummy_s1")
Create(1062,"chassis_dummy_s2")
Create(1063,"chassis_dummy_tz")
Create(1064,"chassis_dummy_tzx")