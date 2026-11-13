function CommonHelper:VerifyCar_ForCarIdx(idx)
   local cardata=CarDataManager:Get():GetCarDataByCarID(idx)
   return CommonHelper:VerifyCar_ForCarAttr(cardata:GetAttrList())
end
---@param attrs PartAttrData[]
local function GetCarAttr(type,attrs)
    return attrs[type].value/1000
end

local g = 9.8*2
local high = 6.806

--[[速度换算]]
local function SpeedConversion(speed)
    local showSpeed = 0
    if speed<=120  then
        showSpeed = speed / 2

    elseif speed>120 and speed<=150 then
        showSpeed = 60+(speed-120)/3

    elseif speed>150 and speed<=190 then
        showSpeed = 70+(speed-150)/4

    else
        showSpeed = 80+(speed-190)/5
    end

    return showSpeed
end

--[[转速有效率]]
local function RPMefficient(attrs)

    local lossRPM = GetCarAttr(14,attrs)
    local rPMefficient = 1-lossRPM/10000

    return rPMefficient
end

--[[扭矩有效率]]
local function TorqueEfficient(attrs)

    local lossTorque = GetCarAttr(15,attrs)
    local torqueEfficient = 1-lossTorque/10000

    return torqueEfficient
end


--[[传动有效率]]
local function TransmissionEfficiencyEfficient(attrs)

    local transmissionEfficiency = GetCarAttr(9,attrs)
    local transmissionEfficiencyEfficient = 0.5+transmissionEfficiency/20000

    return transmissionEfficiencyEfficient
end

local function MaxSpeed(attrs)
    local maxRPM = GetCarAttr(1,attrs)
    local gearRadio = GetCarAttr(19,attrs)
    local backWheelRadius = GetCarAttr(20,attrs)

    local maxSpeed = 0.7*maxRPM*(RPMefficient(attrs)+TransmissionEfficiencyEfficient(attrs))*0.5*(1/60/gearRadio)*2*3.1416*backWheelRadius

    return maxSpeed
end

local function CollisionSpeedReduction(attrs)

    local guideRestitution = GetCarAttr(17,attrs)
    local guideFrictionAttr = GetCarAttr(16,attrs)

    local sin = Math.Cos(13*Math.PI/180)
    local cos = Math.Sin(13*Math.PI/180)

    if guideFrictionAttr<6000 then
        guideFrictionAttr = 6000
    end

    local guideRestitutionCoefficient = (1300+guideRestitution)/2600*0.5;
    local guideFrictionAttrCoefficient = (11000+17000-guideFrictionAttr)/22000*0.5

    local coefficient = Mathf.Min(Mathf.Max(0.7,guideRestitutionCoefficient+guideFrictionAttrCoefficient),1)
    local radio = cos*cos + coefficient*sin*sin

    return radio
end

local function MaxStability(attrs)

    local airDownPressure = GetCarAttr(6,attrs)
    local mass = GetCarAttr(5,attrs)

    local airDownPressureCoefficient = (100+airDownPressure)*100*0.3
    local energy = mass*MaxSpeed(attrs)*MaxSpeed(attrs)*CollisionSpeedReduction(attrs)/9

    local maxStability = (energy-airDownPressureCoefficient-2300)/100/0.7

    return maxStability
end





local function FlyDistance(attrs)


    local speed = MaxSpeed(attrs)
    local airDownPressure = GetCarAttr(6,attrs)

    local downA = g*(100+airDownPressure)/100
    local flyTime = Math.Sqrt(2*high/downA)
    local flyDistance = speed * flyTime
    return flyDistance
end

local function MaxDamping(attrs)

    --local dampingCoefficient = CommonHelper:GetTableDataByID(ConfigNames.minicarvalue_config,19).value
    --local dampingCoefficient = CommonHelper:GetTableDataByID(ConfigNames.minicarvalue_config,19).value
    local tireElasticity = GetCarAttr(10,attrs)
    local speed = MaxSpeed(attrs)

    local maxDamping = (1500+tireElasticity)/300*speed-250

    return maxDamping
end

local function SpecialTrackParameter(attrs)

    local mass = GetCarAttr(5,attrs)
    local effMass_more = Mathf.Min(Mathf.Max(0,mass-140),60)
    local effMass_less = Mathf.Min(Mathf.Max(0,200-mass),60)

    local effTorque = GetCarAttr(2,attrs)
    if effTorque<2000 then
        effTorque = Mathf.Max(0,effTorque-1200)
    else
        effTorque = 800+(effTorque-2000)/2
    end

    local effWheelFriction = GetCarAttr(12,attrs)
    if effWheelFriction<3000 then
        effWheelFriction = (effWheelFriction-1500)/4
    elseif effWheelFriction>=3000 and effWheelFriction<6000 then
        effWheelFriction = 250+(effWheelFriction-3000)/1.5
    else
        effWheelFriction = 2250+(effWheelFriction-6000)/4
    end

    return effMass_more,effMass_less,effTorque,effWheelFriction
end

local function MinSpeedSpecialTrack(attrs)

    local effMass_more,effMass_less,effTorque,effWheelFriction = SpecialTrackParameter(attrs)

    local gearRadio = GetCarAttr(19,attrs)
    local backWheelRadius = GetCarAttr(20,attrs)

    local grassPerformance = GetCarAttr(42,attrs)
    local sandPerformance = GetCarAttr(41,attrs)
    local icePerformance = GetCarAttr(44,attrs)
    local waterPerformance = GetCarAttr(40,attrs)
    local snowPerformance = GetCarAttr(39,attrs)

    local grassMinSpeed = 7+grassPerformance*0.02+effMass_more*0.4+effWheelFriction*0.02+effTorque*0.02*gearRadio/3.5/backWheelRadius*0.31
    grassMinSpeed = Math.Round(SpeedConversion(grassMinSpeed),2)
    local sandMinSpeed = 0
    local wheel = 0
    if Mathf.Abs(backWheelRadius-0.24)<0.0001 then
        wheel = 1
    elseif Mathf.Abs(backWheelRadius-0.26)<0.0001 then
        wheel = 1+0.08
    elseif Mathf.Abs(backWheelRadius-0.31)<0.0001 then
        wheel = 1+0.3
    else
        wheel = 1
    end
    sandMinSpeed = 7+sandPerformance*0.02+effMass_less*0.4+effWheelFriction*0.04+effTorque*0.01*gearRadio/3.5*wheel
    sandMinSpeed = Math.Round(SpeedConversion(sandMinSpeed),2)

    local iceMinSpeed = 7+icePerformance*0.02+effMass_more*0.4
    iceMinSpeed = Math.Round(SpeedConversion(iceMinSpeed),2)
    local snowMinSpeed = 7+snowPerformance*0.02+effMass_more*0.4
    snowMinSpeed = Math.Round(SpeedConversion(snowMinSpeed),2)
    local waterMinSpeed = 7+waterPerformance*0.02+effMass_more*0.4
    waterMinSpeed = Math.Round(SpeedConversion(waterMinSpeed),2)

    return grassMinSpeed,sandMinSpeed,waterMinSpeed,iceMinSpeed,snowMinSpeed
end






---@param attrs PartAttrData[]
function CommonHelper:VerifyCar_ForCarAttr(attrs)


    local showMaxSpeed = Math.Round(SpeedConversion(MaxSpeed(attrs)),2)
    local showMaxStability = Math.Round(MaxStability(attrs),0)
    local flyDistance = Math.Round(FlyDistance(attrs),2)
    local maxDamping = Math.Round(MaxDamping(attrs),0)
    local collisionSpeedReduction = Math.Round(CollisionSpeedReduction(attrs),3)

    local grassMinSpeed,sandMinSpeed,waterMinSpeed,iceMinSpeed,snowMinSpeed = MinSpeedSpecialTrack(attrs)

    return showMaxSpeed .."+++".. showMaxStability .."+++".. flyDistance .."+++".. maxDamping .."+++".. collisionSpeedReduction .."+++".. grassMinSpeed
            .."+++".. sandMinSpeed .."+++".. waterMinSpeed .."+++".. iceMinSpeed .."+++".. snowMinSpeed
end

