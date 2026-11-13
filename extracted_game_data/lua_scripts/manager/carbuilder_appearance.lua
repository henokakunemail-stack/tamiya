


--{{{轻量化数据
function CarBuilder:AnalyseLightweight(value)
    self.Lightweight = value
end
function CarBuilder:GetLightweight() return self.Lightweight end
--}}}

--{{{纱网数据
function CarBuilder:AnalyseShellGrid(value)
    self.ShellGrids = value and value or {}
end
function CarBuilder:GetShellGrid() return self.ShellGrids end
--}}}

--{{{车壳颜色
function CarBuilder:AnalyseShellColor(value)
    self.ShellColorID = value and value or 0
end
function CarBuilder:GetShellColor() return self.ShellColorID end
--}}}

--{{{车壳贴纸
----给车壳贴纸赋值，默认是根据槽位读取车壳配件ID ，然后找到车壳表里的默认贴纸
function CarBuilder:AnalyseSticker(value)
    if value and value > 0 then
        self.StickerID = value
        self.DefaultSticker = 0
    else
        self.StickerID = 0
        local partid = self:GetPartDataID(PartGrooveID.Shell)
        if partid ~= -1 and partid ~= nil then
            local shellcfg = self:GetCarShellCfg(partid)
            if shellcfg then
                self.DefaultSticker = shellcfg.defaultSticker
            end
        end
    end
end
function CarBuilder:GetSticker()
    if self.StickerID > 0 then
        return self.StickerID
    else
        return self.DefaultSticker
    end
end
--}}}
--{{{车壳默认颜色
function CarBuilder:AnalyseDefaultColor()
    local partid = self:GetPartDataID(PartGrooveID.Shell)
    if partid ~= -1 and partid ~= nil then
        local shellcfg = self:GetCarShellCfg(partid)
        if shellcfg then
            self.IsColor = shellcfg.isColour
        end
    end

end
--}}}
