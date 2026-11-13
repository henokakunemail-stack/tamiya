


---@class AssembleSiftData
AssembleSiftData = class("AssembleSiftData")

function AssembleSiftData:initialize()
    ---@type ArticleCell
    self.Article = nil
    self.File_Using = false -- true:匹配失败  筛选失败原因：配件在其他车上使用
    self.File_OnlyOne = false -- true:匹配失败  筛选失败原因：配件在当前车的其他槽位上使用了
    self.File_Stronger = false -- true:匹配失败  筛选失败原因：增强位配件使用过相同类型
    self.File_Tail = false -- true:匹配失败  筛选失败原因：凤尾不能装在底盘上
    self.File_Hub = false -- true:匹配失败  筛选失败原因：前后轮毂尺寸不一致
    self.File_Tyre = false -- true:匹配失败  筛选失败原因：轮胎与轮毂不匹配
    self.File_Motor = false -- true:匹配失败  筛选失败原因：马达不能装在底盘上
    self.File_DingDing = false -- true:匹配失败  中翼未安装平衡杆
    self.File_Exp = false -- true:匹配失败  过期
end
function AssembleSiftData:GetArticle() return self.Article end


function AssembleSiftData:IsFail(flag)
    if flag == nil then return self:IsFailDefault() end
    if flag == TransformUIFlag.Suit then return self:IsFailExceptUsing() end
    if flag == TransformUIFlag.Car then return self:IsFailDefault() end

    return true
end
function AssembleSiftData:IsFailDefault()
    local result = (self.File_Using or self.File_Stronger or self.File_Tail or self.File_Hub or self.File_Tyre or self.File_Motor or self.File_OnlyOne or self.File_DingDing or self.File_Exp)
    return result
end
function AssembleSiftData:IsFailExceptUsing()
    local result = (self.File_Stronger or self.File_Tail or self.File_Hub or self.File_Tyre or self.File_Motor or self.File_OnlyOne or self.File_DingDing or self.File_Exp)
    return result
end
function AssembleSiftData:IsUsingAtSelfCar()
    --配件是否安装在当前槽位上
    local temp = not self:IsFail() and self.Article:GetCarId() > 0
    return temp
end