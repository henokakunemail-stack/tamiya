
ClientDataManager:Get():InitLoginConfig()
ClientDataManager:Get():InitConfig()
local path = "Assets/ArtRes/Bundles/prefab/car/auto/dummy/"
CarAssembleRule:Get():Init()
local dummyPrefab = {}
local dummyFlag = {}


local function LoadPrefab()
    dummyPrefab = {}
    dummyFlag = {}
    ---@type dummy_config
    local tab = ClientDataManager:Get():GetDataTable(ConfigNames.dummy_config)
    local list =  tab.GetConfigData()
    local sortlist = {}
    for k,v in pairs(list) do
        table.insert(sortlist, v.id)
    end
    table.sort(sortlist)

    for i = 1, #sortlist do
        local v = list[sortlist[i]]
        local filepath = path..v.resname
        local obj = CS.Horizon.EditorTool.EditorHelper.EditorHelper.UnityEditorLoadAsset(filepath)

        if obj then
            table.insert(dummyPrefab, obj)
            table.insert(dummyFlag, v.id)
        else
            table.insert(dummyPrefab, GameObject())
            table.insert(dummyFlag, v.id)
        end
    end

end

local function WriteExcel()
    CS.Horizon.EditorTool.EditorHelper.EditorHelper.WriteCentreOfGravity(dummyFlag, dummyPrefab)
end

LoadPrefab()
WriteExcel()