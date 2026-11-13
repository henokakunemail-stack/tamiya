






---@class BattleDataHelper
BattleDataHelper = class("BattleDataHelper")




---@param msg table<number,number>
function BattleDataHelper.CreateCarAttrData(msg)


   print("www................" ,msg[1], msg[2], msg[3], msg[4], msg[5], msg[6], msg[7],msg[8], msg[9],msg[10], msg[11],msg[12], msg[13],msg[14], msg[15],msg[16], msg[17], msg[18], msg[19],msg[20], msg[21],msg[22], msg[23])

    local result = CSCarStaticData()
    ---------- 五维属性 --------------------------------------------------------------------------------------
    result.carTorqueData.maxRPM     = BattleDataHelper.Parse(msg, 1)-- /  10000         -- 最大转速
    result.carTorqueData.maxTorque  = BattleDataHelper.Parse(msg, 2)-- /  10000         -- 最大扭矩
    result.stability                = BattleDataHelper.Parse(msg, 3)-- /  10000         -- 稳定性
    result.durableValue             = BattleDataHelper.Parse(msg, 4)-- /  10000         -- 耐久
    result.mass                     = BattleDataHelper.Parse(msg, 5)-- /  10000         -- 质量

    ---------- 二级属性 --------------------------------------------------------------------------------------
    result.pressureRadio            = BattleDataHelper.Parse(msg, 6) --/ 100 --/  10000   -- 空气下压力
    result.batterySaveRadio         = BattleDataHelper.Parse(msg, 7) --/ 100 --/  10000   -- 节电系数
    result.batteryCostSpeed         = BattleDataHelper.Parse(msg, 8) --/  10000         -- 电量消耗速度
    result.gearRadio                = BattleDataHelper.Parse(msg, 9) --/  10000         -- 齿轮比
    result.transmissionEfficiency   = BattleDataHelper.Parse(msg, 10) --/ 100--/ 10000    -- 传输效率，传动损失
    result.backWheelRadius          = BattleDataHelper.Parse(msg, 11) / 2--/  10000         --后轮半径
    --result.tireBounce          = BattleDataHelper.Parse(msg, 12)/  10000                 --轮胎弹性
    --result.jumpReduce          = BattleDataHelper.Parse(msg, 13)/  10000                 --弹跳抑制
    result.rollingWheelFrictionAttr  = BattleDataHelper.Parse(msg, 14)--/  10000        -- 滚动摩擦系数
    result.staticWheelFrictionAttr   = BattleDataHelper.Parse(msg, 15)                  -- 轮胎滑动摩擦
    result.carRestitution            = BattleDataHelper.Parse(msg, 16)                 -- 恢复系数，缓冲系数，当导轮与赛道壁发生碰撞时，影响实际速度的损失比例
    result.guideFrictionAttr         = BattleDataHelper.Parse(msg, 17)                  -- 导轮摩擦
    --result.guideAngle     = BattleDataHelper.Parse(msg, 18) /  10000         -- 导轮倾角
    result.rpmLoseAttr               = BattleDataHelper.Parse(msg, 19)                   -- 极速损失，影响跑动过程中的实际最大转速
    result.torqueLoseAttr            = BattleDataHelper.Parse(msg, 20)                   -- 加速损失，影响跑动过程中的实际最大扭矩
    result.brakingForceAttr          = BattleDataHelper.Parse(msg, 22)                   -- 影响刹车时滑动摩擦力的大小
    --result.accelSpeedRadio = BattleDataHelper.Parse(msg, 21) /  10000                         -- 稳定杆减速
    --result.accelSpeedRadio = BattleDataHelper.Parse(msg, 22) /  10000                         -- 刹车性能系数
    --result.accelSpeedRadio = BattleDataHelper.Parse(msg, 23) /  10000                         -- 越野性能系数
    --result.accelSpeedRadio = BattleDataHelper.Parse(msg, 24) /  10000                         -- 波浪弯性能系数
    --result.accelSpeedRadio = BattleDataHelper.Parse(msg, 25) /  10000                         -- 角弯性能系数


------------------old -------------------------------------------------------------------------------------------------
    --result.              = msg[5]           -- 地面抗滚动摩擦系数
    --result.              = msg[6]           -- 墙面抗滚动摩擦系数
    --result.airDragFactor       = msg[7]        -- 风阻系数
    --result.carLength                = BattleDataHelper.Parse(msg, 8) /  1000      -- 车长
    ----result.                 = msg[11]       --
    ----result.                 = msg[12]       --强度
    --result.battery                  = BattleDataHelper.Parse(msg, 12)       --电量
    --result.batteryCostSpeed              = BattleDataHelper.Parse(msg, 13)     --耗电量
    --result.carWidth                 = BattleDataHelper.Parse(msg, 15)/  1000      --车宽
    --result.carSafeWidth             = BattleDataHelper.Parse(msg, 16)/  1000       -- 车安全宽度参数
    --result.mass                     = BattleDataHelper.Parse(msg, 17)/  1000      --重量
    --result.offsetIncrement          = BattleDataHelper.Parse(msg, 18)/  1000       --多快的速度回到赛道线参数
    --result.airDragFactor            = (BattleDataHelper.Parse(msg, 19) - BattleDataHelper.Parse(msg, 7)  )/1000       -- 抗风阻系数参数
    --result.rolling_resistance_constant = (BattleDataHelper.Parse(msg, 20) - BattleDataHelper.Parse(msg, 5))/1000 -- 地面抗摩擦系数参数
    ----result.                 =msg[22]        -- 墙面抗摩擦系数
    --result.carHeight                 = BattleDataHelper.Parse(msg, 22) /1000       -- 车高
    --result.flyAngleLimit             = BattleDataHelper.Parse(msg, 24) /1000       -- 飞起角度参数
    --result.flyYSpeedLimit            = BattleDataHelper.Parse(msg, 25) /1000         --飞起时Y方向起飞速度参数
    --result.cornerStiffnessFront      = BattleDataHelper.Parse(msg, 26) /1000       -- 前轮弯道转角系数参数
    --result.cornerStiffnessRear       = BattleDataHelper.Parse(msg, 27) /1000        -- 后轮弯道转角系数参数
    --result.brakingForce              = BattleDataHelper.Parse(msg, 28)        -- 刹车力
    --result.wheelFrictionCoefficient  = BattleDataHelper.Parse(msg, 29) /1000          -- 地面附着系数/地面滑动摩擦系数/静摩擦系数
    --result.tireGrip                  = BattleDataHelper.Parse(msg, 30) /1000        -- 抓地限制大小参数
    --result.limitSpeedRadio           = (BattleDataHelper.Parse(msg, 31) + result.stability) /1000        -- 路线限制速度系数参数
    --result.cgHeight                  = BattleDataHelper.Parse(msg, 32) /1000        -- 重心点分布（高度）
    --result.airDragFactor = msg[1]
-----------------------------------------------------------------------------------------------------------------------

    if(result.limitSpeedRadio > 3.5) then
        result.limitSpeedRadio = 3.5
    end
    return result
end

function BattleDataHelper.Parse(msg, index)
    return msg[index + 1]
end

function BattleDataHelper.CreateBattleData(battletype)
    local battlestate = nil
    local battledata = nil
    if battletype == RaceModel.Battle then
        battlestate = BattleStatePVE()
        battledata = BattleDataPVE()
    end
    if battletype == RaceModel.NewBieChapter then
        battlestate = BattleStateRaceNewbie()
        battledata = BattleDataRaceNewbie()
    end

    if battletype == RaceModel.RaceRoom then
        battlestate = BattleStateRoom()
        battledata = BattleDataRoom()
    end

    if battletype == RaceModel.RaceRank then
        battlestate = BattleStateRank()
        battledata = BattleDataRank()
    end

    if battletype == RaceModel.Challenge then
        battlestate = BattleStateChallenge()
        battledata = BattleDataChallenge()
    end

    if battletype==RaceModel.SelfChallenge then
        battlestate = BattleStateSelfChallenge()
        battledata =BattleDataSelfChallenge()
    end

    if battletype == RaceModel.RaceSelf then
        battlestate = BattleStateSelf()
        battledata = BattleDataSelf()
    end

    if battletype == RaceModel.ClubTrain then
        battlestate = BattleStateClubTrain()
        battledata = BattleDataClubTrain()
    end

    if battletype == RaceModel.RaceWeek then
        battlestate = BattleStateWeek()
        battledata = BattleDataWeek()
    end
    if battletype == RaceModel.RaceSelfChapter then
        battlestate = BattleStateRaceSelfChapter()
        battledata = BattleDataRaceSelfChapter()
    end
    if battletype == RaceModel.RaceSelfLevel then
        battlestate = BattleStateRaceSelfLevel()
        battledata = BattleDataRaceSelfLevel()
    end
    if battletype == RaceModel.ClubRaceSelfChapter then
        battlestate = BattleStateClubRaceSelfChapter()
        battledata = BattleDataClubRaceSelfChapter()
    end
    if battletype == RaceModel.ClubRaceSelfLevel then
        battlestate = BattleStateClubRaceSelfLevel()
        battledata = BattleDataClubRaceSelfLevel()
    end
    if battletype == RaceModel.RaceReplay_Pve then
        battlestate = BattleStateRaceReplay()
        battledata = BattleDataRaceReplay()
    end
    if battletype == RaceModel.RaceReplay_Rank then
        battlestate = BattleStateRaceReplay()
        battledata = BattleDataRaceReplay()
    end
    if battletype == RaceModel.GuideBattle then
        battlestate = BattleStateGuideBattle()
        battledata = BattleDataGuideBattle()
    end
    if battletype == RaceModel.CustomTestBattle then
        battlestate = BattleStateTestRun()
        battledata = BattleDataTestRun()
    end
    if battletype == RaceModel.RaceTrot then
        battlestate = BattleStateRaceTrot()
        battledata = BattleDataRaceTrot()
    end
  if battletype == RaceModel.RaceJcp then
        battlestate = BattleStateRaceJcp()
        battledata = BattleDataRaceJcp()
    end
 if battletype == RaceModel.RaceXcp then
        battlestate = BattleStateRaceXcp()
        battledata = BattleDataRaceXcp()
    end
   if battletype == RaceModel.RaceClub3v3 then
        battlestate = BattleStateRaceClub3v3()
        battledata = BattleDataRaceClub3V3()
    end
   if battletype == RaceModel.RaceTop then
        battlestate = BattleStateRaceTop()
        battledata = BattleDataRaceTop()
    end
 if battletype == RaceModel.RaceTopSuper then
        battlestate = BattleStateRaceTopSuper()
        battledata = BattleDataRaceTopSuper()
    end
   if battletype == RaceModel.RaceGVG then
        battlestate = BattleStateRaceGVG()
        battledata = BattleDataRaceGVG()
    end
   if battletype == RaceModel.RaceSeniorTrain then
        battlestate = BattleStateRaceSeniorTrain()
        battledata = BattleDataRaceSeniorTrain()
    end
    if battletype == RaceModel.RaceCarGod then
        battlestate = BattleStateRaceCarGod()
        battledata = BattleDataRaceCarGod()
    end
    if battletype == RaceModel.RaceSuperBattle then
        battlestate = BattleStateRaceSuperBattle()
        battledata = BattleDataRaceSuperBattle()
    end
    if battletype == RaceModel.RaceAssemble then
        battlestate = BattleStateRaceAssemble()
        battledata = BattleDataRaceAssemble()
    end
    if battletype == RaceModel.RaceAssembleTest then
        battlestate = BattleStateRaceAssembleTest()
        battledata = BattleDataRaceAssembleTest()
    end

    return battlestate, battledata
end