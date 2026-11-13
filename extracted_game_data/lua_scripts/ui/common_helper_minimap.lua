

local __resImageSizex
local __resImageSizey
local __MapImageScaleX
local __MapImageScaleY
local __CenterOffsetX = 0
local __CenterOffsetY = 0


function CommonHelper:InitMinimap(uiImageSizex, uiImageSizey, anchorTL, anchorBR)
    CommonHelper:FindSceneMinimapConfig()
    __MapImageScaleX = uiImageSizex / __resImageSizex
    __MapImageScaleY = uiImageSizey / __resImageSizey
    local temp = math.max(__MapImageScaleX, __MapImageScaleY)
    local cameraH = temp * -80   -- 定义： 512*512 的图，摄像机高度是 -80，得到的视野是默认视野
    UIManager:Get():InitMinimapCamera(anchorTL,anchorBR,cameraH)
end

function CommonHelper:GetMiniMapPos(mapPosX, mapPosY)

    mapPosX = mapPosX - __CenterOffsetX
    mapPosY = mapPosY - __CenterOffsetY

    local scale = 6--比例尺6：1
    local minimapPosX = mapPosX / scale
    local minimapPosY = mapPosY / scale
    local tab = {minimapPosX * __MapImageScaleX, minimapPosY * __MapImageScaleY}
    return tab
end


function CommonHelper:FindSceneMinimapConfig()
    local config = UIManager:Get():GetMiniMapConfig()
    print("---    config",config)
    local pos = config.transform.position
    __CenterOffsetX = pos.x
    __CenterOffsetY = pos.z

    local size = config.transform.localScale
    __resImageSizex = size.x
    __resImageSizey = size.y
end