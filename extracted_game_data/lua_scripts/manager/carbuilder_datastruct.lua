



---@class CarBuilderPartData @车的配件数据，包括车的配件id 和 该配件的合成配件的ids
CarBuilderPartData = class("CarBuilderPartData")
function CarBuilderPartData:initialize()
    self.partid = -1
    self.composeIds = {}
    self.generation=1
    self.sticker=-1
end
function CarBuilderPartData:SetData(id, list,generation,sticker)
    if list == nil then list = {}  end

    self.partid = id
    self.composeIds = list
    self.generation=generation
    self.sticker=sticker
    if list == nil or #list == 0 then
        if id and id > 0 then
            ---@type dictparts_config_cell
            local cfg = CommonHelper:GetTableDataByID(ConfigNames.parts_config, id)
            if cfg then
                if cfg.composeids ~= "-1" then
                    self.composeIds = cfg.NewComposeIDs
                end
            end
        end
    end
end

function CarBuilderPartData:GetPartID()
    return self.partid
end

function CarBuilderPartData:GetComposeIds()
    return self.composeIds
end
function CarBuilderPartData:GetGeneration()
    return self.generation
end
function CarBuilderPartData:GetSticker()
    return self.sticker
end








---@class CarBuilderAppearanceData @车的表现数据，比如配种，纱网s,车壳颜色，贴纸id
CarBuilderAppearanceData = class("CarBuilderAppearanceData")
function CarBuilderAppearanceData:initialize()
    self.Lightweight = 0
    self.ShellGrids = {}
    self.ShellColorID = 0
    self.StickerID = 0
    self.DefaultSticker = ""
end
function CarBuilderAppearanceData:SetData()

end


