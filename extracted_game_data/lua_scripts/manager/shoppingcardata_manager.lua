
---@class ShoppingCarDataManager
ShoppingCarDataManager = class("ShoppingCarDataManager")

function ShoppingCarDataManager:Get()
    if self._instance == nil then
        self._instance = ShoppingCarDataManager()
    end
    return self._instance
end


function ShoppingCarDataManager:initialize()

end
---@param data GoodsData
function ShoppingCarDataManager:AddGoods(shopid,data)
   local temp=  PlayerPrefsHelper:GetValue_Shop(shopid.."_"..data.grid)
    if CommonHelper:IsNullOrEmpty(temp) then
        PlayerPrefsHelper:SetValue_Shop(shopid.."_"..data.grid,data.id.."_"..1)
    else
        local tempGood=stringSplitToNumber(temp,"_")
        if tempGood[1]==data.id then
            PlayerPrefsHelper:SetValue_Shop(shopid.."_"..data.grid,data.id.."_"..tempGood[2]+1)
        else
            PlayerPrefsHelper:SetValue_Shop(shopid.."_"..data.grid,data.id.."_"..1)
        end
    end
end

function ShoppingCarDataManager:GetLocalGoods()
   local curShop=ShopDataManager:Get():GetCurShop()
   local result={}
    if curShop then
        for i = 1, #curShop.goodExs2 do
            local temp=  PlayerPrefsHelper:GetValue_Shop(curShop.ShopId.."_"..curShop.goodExs2[i].grid)
            if not CommonHelper:IsNullOrEmpty(temp) then
                local tempGood=stringSplitToNumber(temp,"_")
                if tempGood[1]==curShop.goodExs2[i].id then
                    local shoppingCarData=ShoppingCarGoodsData()
                    shoppingCarData:SetData(curShop.goodExs2[i],temp[2])
                    table.insert(result,shoppingCarData)
                end
            end
        end
        return result
    end
end
