

--车库右侧，涂装入口

---@class PageGarageAppearance
PageGarageAppearance = class("PageGarageAppearance")

function PageGarageAppearance:initialize()

end

---@param cardata CarData
function PageGarageAppearance:SetData(root,funback, funhole, funcolor, funsticker, fungrid)
    CommonHelper:HButtonSetCallback("BtnBack",root,function (hbtn)
        if funback then funback() end
    end)

    CommonHelper:HButtonSetCallback("BtnHole",root,function (hbtn)
        if funhole then funhole() end
    end)

    CommonHelper:HButtonSetCallback("BtnColor",root,function (hbtn)
        if funcolor then funcolor() end
    end)

    CommonHelper:HButtonSetCallback("BtnSticker",root,function (hbtn)
        if funsticker then funsticker() end
    end)

    CommonHelper:HButtonSetCallback("BtnGrid",root,function (hbtn)
        if fungrid then fungrid() end
    end)
end