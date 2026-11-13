

function CommonHelper:GetTempStr_Default(id, ...)
    local str = ClientDataManager:Get():GetTemplateString(id)
    if(...)then
        str = string.format(str, ...)
    end
    return str
end

function CommonHelper:GetTempStr_UIStatic(id)
    ---@type tempstringuistatic_config_cell
    local cfgdata = CommonHelper:GetTableDataByID(ConfigNames.tempstringuistatic_config, id)
    local  languageType = LanguageSwitchManager.Get():GetCurLanguage()

    if cfgdata then
        if GameProperties.CfgIsLuaTable then
            return cfgdata
        end
        if GameProperties.AssetBundleMode then
            return cfgdata.text
        end
        if languageType == LanguageType.CHS then
            return cfgdata.chs
        end
        if languageType == LanguageType.CHT then
            return cfgdata.cht
        end
        if languageType == LanguageType.EN then
            return cfgdata.en
        end
        if languageType == LanguageType.THAI then
            return cfgdata.tai
        end
        if languageType == LanguageType.IDA then
            return cfgdata.ind
        end
        if languageType == LanguageType.PT_BR then
            return cfgdata.pt_BR
        end
        if languageType == LanguageType.KR then
            return cfgdata.kr
        end

        return cfgdata.chs
    end
    return ""
end



function CommonHelper:GetTempStr_RaceSelfState(state)
    local result = "无"
    if state == RaceSelfState.Join then result = "报名" end
    if state == RaceSelfState.Select then result = "海选" end
    if state == RaceSelfState.Knockout then result = "淘汰赛" end
    if state == RaceSelfState.SemiFinal then result = "半决赛" end
    if state == RaceSelfState.Finals then result = "决赛" end
    return result
end

function CommonHelper:GetTempStr_RaceSelfRule(type)
    local result = "默认"
    if type == RaceSelfRule.Type2To1 then result = "二进一" end
    if type == RaceSelfRule.Type3To1 then result = "三进一" end
    if type == RaceSelfRule.Type4To1 then result = "四进一" end
    if type == RaceSelfRule.Type5To1 then result = "五进一" end
    return result
end

function CommonHelper:GetTempStr_RaceSelfJoinerLimit(count)
    local result = "不限制"
    if count > 0 then result = count.."人" end
    return result
end


function CommonHelper:GetTempStr_RaceSelfFightGroupTitle(idx, groupidx, areaidx)
    local title1 = ""
    local title2 = ""
    if groupidx == 1 then
        title1 = "A组"
        title2 = "A"..idx.."组"
    end
    if groupidx == 2 then
        title1 = "B组"
        title2 = "B"..idx.."组"
    end
    if groupidx == 3 then
        title1 = "C组"
        title2 = "C"..idx.."组"
    end
    if groupidx == 4 then
        title1 = "D组"
        title2 = "D"..idx.."组"
    end
    if groupidx == 5 then
        title1 = "E组"
        title2 = "E"..idx.."组"
    end
    return title2
end

function CommonHelper:GetTempStr_RaceSelfResultTips(type, rank)
    local result = ""
    if type == RaceSelfResultFlag.Fail_Knockout then result = "未进淘汰赛" end
    if type == RaceSelfResultFlag.Fail_SemiFinal then result = "未进半决赛" end
    if type == RaceSelfResultFlag.Fail_Finals then result = "未进决赛" end
    if type == RaceSelfResultFlag.Rank then
        result = string.format("第%d名", rank)
    end
    return result
end

function CommonHelper:GetTempStr_RaceWeekState(state)
    local result = "无"
    if state == RaceWeekState.Join then result = "报名" end
    if state == RaceWeekState.First then result = "第一轮" end
    if state == RaceWeekState.Second then result = "第二轮" end
    if state == RaceWeekState.Third then result = "第三轮" end
    return result
end

function CommonHelper:GetTempStr_BattleFailErrorTips(error)
    local result = "5683"
    if error==nil then result = "5683" end
    if error == BattleFailError.None then result = "5683" end
    if error == BattleFailError.FlyOut then result = "FlyOut_name" end
    if error == BattleFailError.BackHitCrash then result = "BackHitCrash_name" end
    if error == BattleFailError.ReverseMoveCrash then result = "ReverseMoveCrash_name" end
    if error == BattleFailError.CurveTurnOver then result = "CurveTurnOver_name" end
    if error == BattleFailError.DropGroundTurnOver then result = "DropGroundTurnOver_name" end
    if error == BattleFailError.DropEmptyHole then result = "DropEmptyHole_name" end
    if error == BattleFailError.DurableUseUp_CurveTurnOver then result = "DurableUseUp_CurveTurnOver_name" end
    if error == BattleFailError.DurableUseUp_DropGroundTurnOver then result = "DurableUseUp_DropGroundTurnOver_name" end
    if error == BattleFailError.BatteryLow then result = "BatteryLow_name" end
    if error == BattleFailError.BatteryDown then result = "BatteryDown_name" end
    if error == BattleFailError.OverTheWall then result = "OverTheWall_name" end
    if error == BattleFailError.LandAngleCrash then result = "LandAngleCrash_name" end
    if error == BattleFailError.LandAreaCrash then result = "LandAreaCrash_name" end
    return CommonHelper:GetTempStr_Default(result)
end
function CommonHelper:GetTempStr_BattleFailM_ErrorTips(error)
    local result = "5683"
    if error==nil then result = "5683" end
    if error == BattleFailError.None then result = "5683" end
    if error == BattleFailError.FlyOut then result = "FlyOut_mdesc" end
    if error == BattleFailError.BackHitCrash then result = "BackHitCrash_mdesc" end
    if error == BattleFailError.ReverseMoveCrash then result = "ReverseMoveCrash_mdesc" end
    if error == BattleFailError.CurveTurnOver then result = "CurveTurnOver_mdesc" end
    if error == BattleFailError.DropGroundTurnOver then result = "DropGroundTurnOver_mdesc" end
    if error == BattleFailError.DropEmptyHole then result = "DropEmptyHole_mdesc" end
    if error == BattleFailError.DurableUseUp_CurveTurnOver then result = "DurableUseUp_CurveTurnOver_mdesc" end
    if error == BattleFailError.DurableUseUp_DropGroundTurnOver then result = "DurableUseUp_DropGroundTurnOver_mdesc" end
    if error == BattleFailError.BatteryLow then result = "BatteryLow_mdesc" end
    if error == BattleFailError.BatteryDown then result = "BatteryDown_mdesc" end
    if error == BattleFailError.OverTheWall then result = "OverTheWall_mdesc" end
    if error == BattleFailError.LandAngleCrash then result = "LandAngleCrash_mdesc" end
    if error == BattleFailError.LandAreaCrash then result = "LandAreaCrash_mdesc" end
    if error == BattleFailError.Timeout then result = "TimeOut_mdesc" end

    return CommonHelper:GetTempStr_Default(result)
end


function CommonHelper:GetShareNameByType(type)
    local result=nil
    if type == ShareType.RoomInvite then result = TemplateStringID.ShareTypeRoom
    end
    if type == ShareType.ChallengeMatchInvite then result = TemplateStringID.ShareTypeChallage
    end
    if type == ShareType.ClubInvite then result = TemplateStringID.ShareTypeClub
    end
    return CommonHelper:GetTempStr_Default(result)
end
function CommonHelper:GetAttrCompareString(value1,value2)
    local sub=value2-value1
    local result=CommonHelper:GetTempStr_Default(TemplateStringID.CarAttrCompareHigh,math.floor(sub))
    if sub<0 then
        result=CommonHelper:GetTempStr_Default(TemplateStringID.CarAttrCompareLow,math.floor(sub))
    end
    return result
end

function CommonHelper:GetLabQualityString(propType,Quality)
    local result=""
    if propType==ComposeType.Part then
        if Quality == 1 then result = TemplateStringID.PartQuality1 end
        if Quality == 2 then result = TemplateStringID.PartQuality2 end
        if Quality == 3 then result = TemplateStringID.PartQuality3 end
        if Quality == 4 then result = TemplateStringID.PartQuality4 end
        if Quality == 5 then result = TemplateStringID.PartQuality5 end
        if Quality == 6 then result = TemplateStringID.PartQuality6 end
    end
   if propType==ComposeType.Article then
       if Quality == 1 then result = TemplateStringID.ArticleQuality1 end
       if Quality == 2 then result = TemplateStringID.ArticleQuality2 end
       if Quality == 3 then result = TemplateStringID.ArticleQuality3 end
       if Quality == 4 then result = TemplateStringID.ArticleQuality4 end
       if Quality == 5 then result = TemplateStringID.ArticleQuality5 end
   end
    return CommonHelper:GetTempStr_Default(result)
end

function CommonHelper:GetLevelPassDesc(type,param)
    local result
    if type==PVELevelPassType.BattleDone then
        result=CommonHelper:GetTempStr_Default(TemplateStringID.PVELevelPassType0)
    end
    if type==PVELevelPassType.Time then
        local time=CommonHelper:GetSelfTransferTimeStr(param)
        local second=string.format("%s'%s'%s",time.minute,time.second,time.milliSecond)
        result=CommonHelper:GetTempStr_Default(TemplateStringID.PVELevelPassType1,second)
    end
    if type==PVELevelPassType.UsePart then
        ---@type dictparts_config_cell
        local cfg= CommonHelper:GetTableDataByID(ConfigNames.parts_config,param)
        if cfg then
            result=CommonHelper:GetTempStr_Default(TemplateStringID.PVELevelPassType2,CommonHelper:GetTempStr_Default(cfg.partname))
        end
    end
    if type==PVELevelPassType.NotUsePart then
        ---@type dictparts_config_cell
        local cfg= CommonHelper:GetTableDataByID(ConfigNames.parts_config,param)
        if cfg then
            result=CommonHelper:GetTempStr_Default(TemplateStringID.PVELevelPassType3,CommonHelper:GetTempStr_Default(cfg.partname))
        end
    end
    if type==PVELevelPassType.BattleFirst then
        result=CommonHelper:GetTempStr_Default(TemplateStringID.PVELevelPassType4)
    end
    if type==PVELevelPassType.BattleNotLast then
        result=CommonHelper:GetTempStr_Default(TemplateStringID.PVELevelPassType5)
    end
    if type==PVELevelPassType.BattleRank then
        result=CommonHelper:GetTempStr_Default(TemplateStringID.PVELevelPassType6,param)
    end
    if type==PVELevelPassType.NoBrake then
        result=CommonHelper:GetTempStr_Default(TemplateStringID.PVELevelPassType7,param)
    end
    if type==PVELevelPassType.PassLevelAttrLimit then
        local attrs=stringSplitToNumber(param)
        result=CommonHelper:GetTempStr_Default(TemplateStringID.PVELevelPassType8,CommonHelper:GetAttrName(attrs[1]),attrs[2])
    end
    if type==PVELevelPassType.ExceedOtherPlayerTime then
        local time=CommonHelper:GetSelfTransferTimeStr(param)
        local second=string.format("%s'%s'%s",time.minute,time.second,time.milliSecond)
        result=CommonHelper:GetTempStr_Default(TemplateStringID.PVELevelPassType9,second)
    end
    return result
end