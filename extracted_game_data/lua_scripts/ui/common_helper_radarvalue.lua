





















--
--
--
----{{{极速
-----@param cardata CarData
--function CommonHelper:CalculateRadarValueA(cardata)
--    if cardata == nil then return -1 end
--
--    local param1 = cardata:GetAttrData(1).value
--    local param2 = cardata:GetAttrData(14).value
--    local param3 = cardata:GetAttrData(9).value
--    local param4 = cardata:GetAttrData(20).value
--    local param5 = cardata:GetAttrData(19).value
--    local param6 = cardata:GetAttrData(7).value
--
--    if param5 == 0 then return 0 end
--
--    local result = (param1 * (1 - param2/10000) * (param3/10000) * param4 / param5 ) * (1 - param6/3000) * 0.25+200
--    return result
--end
----}}}
--
--
----{{{加速
-----@param cardata CarData
--function CommonHelper:CalculateRadarValueB(cardata)
--    if cardata == nil then return -1 end
--
--    local param1 = cardata:GetAttrData(2).value
--    local param2 = cardata:GetAttrData(15).value
--    local param3 = cardata:GetAttrData(9).value
--    local param4 = cardata:GetAttrData(19).value
--    local param5 = cardata:GetAttrData(20).value
--    local param6 = cardata:GetAttrData(5).value
--    local param7 = cardata:GetAttrData(7).value
--    local param8 = cardata:GetAttrData(12).value
--
--    if param5 == 0 then return 0 end
--    if param6 == 0 then return 0 end
--
--    local result = (param1*(1-param2/10000)*(param3/10000)*param4/param5/param6)*(1-param7/3000)*(1+param8/10000)*0.5+200
--    return result
--end
----}}}
--
--
----{{{稳定
-----@param cardata CarData
--function CommonHelper:CalculateRadarValueC(cardata)
--    if cardata == nil then return -1 end
--
--    local param1 = cardata:GetAttrData(3).value
--    local param2 = cardata:GetAttrData(11).value
--    local param3 = cardata:GetAttrData(10).value
--
--    if param3 == 0 then return 0 end
--
--    local result = 0.025*param1+0.04*param2+180000/param3+200
--    return result
--end
----}}}
--
--
----{{{续航
-----@param cardata CarData
--function CommonHelper:CalculateRadarValueD(cardata)
--    if cardata == nil then return -1 end
--
--    local param1 = cardata:GetAttrData(8).value
--    local param2 = cardata:GetAttrData(23).value
--
--    if param2 == 0 then return 0 end
--
--    local result = 75*param1/param2+400
--    return result
--end
----}}}
--
--
----{{{抗阻
-----@param cardata CarData
--function CommonHelper:CalculateRadarValueE(cardata)
--    if cardata == nil then return -1 end
--
--    local param1 = cardata:GetAttrData(7).value
--    local param2 = cardata:GetAttrData(13).value
--    local param3 = cardata:GetAttrData(16).value
--
--    if param1 == 0 then return 0 end
--    if param2 == 0 then return 0 end
--    if param3 == 0 then return 0 end
--
--    local result = 56000/param1+210000/param2+3500/param3+100
--    return result
--end
----}}}
--
--
