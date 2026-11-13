


---@class AppearanceData
AppearanceData = class("AppearanceData")

function AppearanceData:initialize()
    self.LightweightState = 0
    self.GridList = {}
    self.ColorID = 0
    self.StickerID = 0
end


function AppearanceData:SetData(lightweight, grid, color, sticker)

    self:SetShellColor(color)
    self:SetShellSticker(sticker)
    self:SetLightweight(lightweight)
    self:SetShellGridList(grid)

end

function AppearanceData:SetShellColor(color) self.ColorID = color end
function AppearanceData:SetShellSticker(sticker) self.StickerID = sticker end
function AppearanceData:SetLightweight(lightweight) self.LightweightState = lightweight end
function AppearanceData:SetShellGrid(index, gridid) self.GridList[index] = gridid end
function AppearanceData:SetShellGridList(grid)
    self.GridList = {}
    if grid and #grid == 5 then
        for i = 1, 5 do
            self.GridList[i] = grid[i]
        end
    end
end

function AppearanceData:GetShellColor()         return self.ColorID end
function AppearanceData:GetShellSticker()       return self.StickerID end
function AppearanceData:GetShellLightweight()   return self.LightweightState end
function AppearanceData:GetShellGridList()      return self.GridList end