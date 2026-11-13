



---@param cardata CarData
function CommonHelper:ChartRadarSetValue(objname , obj, cardata)
    if obj then
        local radarobj = UIUtil.GetChildInputPath(objname , obj)
        if radarobj then
            --local valueA = CommonHelper:CalculateRadarValueA(cardata)
            --local valueB = CommonHelper:CalculateRadarValueB(cardata)
            --local valueC = CommonHelper:CalculateRadarValueC(cardata)
            --local valueD = CommonHelper:CalculateRadarValueD(cardata)
            --local valueE = CommonHelper:CalculateRadarValueE(cardata)
            --local list = {}
            --table.insert(list, valueA * 0.001)
            --table.insert(list, valueB * 0.001)
            --table.insert(list, valueE * 0.001)
            --table.insert(list, valueD * 0.001)
            --table.insert(list, valueC * 0.001)
            --mono.ChartRadarSetValue(radarobj, list)
            --CommonHelper:SetText("attrnameA", obj, CommonHelper:GetAttrName(101))
            --CommonHelper:SetText("attrnameB", obj, CommonHelper:GetAttrName(102))
            --CommonHelper:SetText("attrnameC", obj, CommonHelper:GetAttrName(103))
            --CommonHelper:SetText("attrnameD", obj, CommonHelper:GetAttrName(104))
            --CommonHelper:SetText("attrnameE", obj, CommonHelper:GetAttrName(105))
            --
            --CommonHelper:SetText("attrvalueA", obj, string.format("%0.0f", valueA))
            --CommonHelper:SetText("attrvalueB", obj, string.format("%0.0f", valueB))
            --CommonHelper:SetText("attrvalueC", obj, string.format("%0.0f", valueC))
            --CommonHelper:SetText("attrvalueD", obj, string.format("%0.0f", valueD))
            --CommonHelper:SetText("attrvalueE", obj, string.format("%0.0f", valueE))
        end
    end
end


function CommonHelper:SendMsgFilter(type,content,func)
    if CommonHelper:IsNullOrEmpty(content) then
        func()
        return
    end
    if type~=ChatType.World then
        func()
        return
    end
    local curCount= CommonHelper:ChatFilter(content)
    if curCount>=10 then
        func()
         log("当天发送次数大于十次")
    else
        func()
    end
end

function CommonHelper:RecMsgFilter(type,rid,content,func)
    if CommonHelper:IsNullOrEmpty(content) then
        func()
        return
    end
    if type~=ChatType.World then
        func()
        return
    end
    local curCount= CommonHelper:ChatFilter(string.format("%d=%s",rid,content))
    if curCount>=10 then
        func()
        --log("当天接收次数大于十次")
    else
        func()
    end
end

function CommonHelper:ChatFilter(value)
    local md5= CS.AndroidUtility.Md5Encode(value)
    local flag= PlayerPrefsHelper:GetValue_ChatContent(md5)
    if flag==0 or PlayerPrefsHelper:TimeFlagDay()~=flag then
        if ChatDataManager:Get().ChatMd5Dic[md5] then
            ChatDataManager:Get().ChatMd5Dic[md5]=ChatDataManager:Get().ChatMd5Dic[md5]+1
        else
            ChatDataManager:Get().ChatMd5Dic[md5]=1
        end
        local  count=ChatDataManager:Get().ChatMd5Dic[md5]
        if count>11 then
            PlayerPrefsHelper:SetValue_ChatContent(md5)
        end
        return count
    else
        return 11
    end
end