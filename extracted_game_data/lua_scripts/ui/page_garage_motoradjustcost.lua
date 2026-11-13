---@class PageGarageMotorAdjustCost
PageGarageMotorAdjustCost = class("PageGarageMotorAdjustCost")

function PageGarageMotorAdjustCost:initialize()

end

---@param data ArticleCell
function PageGarageMotorAdjustCost:SetData(root, data, funback)
    CommonHelper:HButtonSetCallback("BtnBack",root,function (hbtn)
        if funback then funback() end
    end)
end