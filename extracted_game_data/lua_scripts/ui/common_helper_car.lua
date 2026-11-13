function CommonHelper:GetParkingSpaceName(index)
    if index==1 then
        return CommonHelper:GetTempStr_Default(TemplateStringID.FirstParkingSpace)
    end
    if index==2 then
        return CommonHelper:GetTempStr_Default(TemplateStringID.SecondParkingSpace)
    end
    if index==3 then
        return CommonHelper:GetTempStr_Default(TemplateStringID.ThirdParkingSpace)
    end
    if index==4 then
        return CommonHelper:GetTempStr_Default(TemplateStringID.FourthParkingSpace)
    end
    if index==5 then
        return CommonHelper:GetTempStr_Default(TemplateStringID.FifthParkingSpace)
    end
end