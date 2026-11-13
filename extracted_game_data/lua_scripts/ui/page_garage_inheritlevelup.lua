---@class PageGarageInheritLevelUp
PageGarageInheritLevelUp = class("PageGarageInheritLevelUp")

function PageGarageInheritLevelUp:initialize()

end

---@param data ArticleCell
function PageGarageInheritLevelUp:SetData(root, data, index, funback)
    CommonHelper:HButtonSetCallback("BtnBack",root,function (hbtn)
        if funback then funback(data) end
    end)
end
