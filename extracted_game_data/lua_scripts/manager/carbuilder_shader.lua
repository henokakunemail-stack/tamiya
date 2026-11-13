



function CarBuilder:ChangeShader()
    local objs = {}
    for i = 1, #self.MeshKeyList do
        local temp = self.MeshKeyList[i]
        for m = 1, #temp.Objs do
            if temp.Objs[m] then
                table.insert(objs, temp.Objs[m])
            end
        end
    end

    MonoHelper:ChangeShader(objs, true, ShaderLowCfg, ShaderHighCfg)
end