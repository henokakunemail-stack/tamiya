
AudioNameJp2 = {
    CheerTypeId = 1001,
    LastLap = 1002,
    FlyOut = 1003,
    BattleFail = 1004,
    NPCFail = 1005,
    SkillVoice = 1006,
    ProtectStart = 1007,
    ProtectSuccess = 1008,
    Open = 1009,
    OpenLong = 1010,
    Win = 1011,
    SelfFirstRank = 1012,
    SelfNotFirstRank = 1013,
    LargeBehind = 1014,
    Overtake = 1015,
    BeOvertake = 1016,
    CurveSegmentRun = 1017,
    LineSegmentRun  = 1018,
    BackHitCrash = 1019,
    StartCountDown = 1021,
    CheerTypeIdRear = 1022,

    Fail_CurveTurnOver = 1023,
    Fail_Flyout = 1024,
    Fail_LandOver = 1025,
    Fail_FrontLandAngleCrash = 1026,
    Fail_RearLandAngleCrash = 1027,
    Fail_LandAreaCrash = 1028,
    EnterScenePartName = 1029,
    XuanfengSkillVoice = 1030,
    ClimbSkillVoice = 1031,
    OpenRaceType_Relay = 1032,
    OpenRaceType_Time = 1033,
    RaceTypeRelayIdle = 1041,
    RaceTypeTimeIdle = 1042,
    RaceTypeRelayHalfLength = 1043,
    RaceTypeTimeLastLap = 1044,
    RaceTypeRelayBatteryLow = 1045,
    RaceTypeRelayFail = 1046,
    RaceTypeRelayFinish = 1047,
    RaceTypeRelay1Go = 1048,
    RaceTypeRelay2Go = 1049,
    RaceTypeRelay3Go = 1050,
    RaceTypeRelay4Go = 1051,
    RaceTypeRelay5Go = 1052,
    RaceTypeTimeFinish = 1053,
    CheerTypeIdWater = 10011,
    CheerTypeIdGrass = 10012,
    CheerTypeIdSand = 10013,
    CheerTypeIdIce = 10014,
    Guide1_Enter = 20001,
    Guide2_SlopeDown = 20002,
    Guide3_SkillPlay = 20003,
    Guide4_SkillAfter = 20004,
    Guide5_Cheer = 20005,
    Guide6_ProtectSuccess = 20006,
    Guide7_Success = 20007,
    Guide5_Cheer2 = 20008,
    EnterScene_Rank = 30001,
    EnterScene_PVE = 30002,
    EnterScene_RaceTrot = 30003, -- 黄金联赛
    EnterScene_RaceJcp = 30004, -- Jcup
    EnterScene_RaceSuperBattle = 30005,
    EnterScene_RaceRoom = 30006
}

AudioGasJp = {
    LastLap = 2000,
    Cheer = 2001,
    Fail = 2002,
    Protect = 2003,
    Skill = 2004,
    FirstRank = 2005,
    BeOvertake = 2006
}

AudioSkillType =
{
    Normal = 21,
    Xuanfeng = 31,
    Climb = 41
}


local overTackCount =0
local lastSegmentIndex = -2
local playCount  = 0;
function RaceHelper:PlayJpVoiceAudio2(voiceType, trackNumber, isSelf, paramInt, floatParam, carShellId)



    playCount = playCount +1
    local clipLength = 0.5
    if PlayerPrefsHelper:GetValue_BattleBgmOffOrOn()==0 then
        return 0.5
    end

    local isFirstGuide = BattleDataManager:Get():IsGuideFirstOneLevel()
    if isFirstGuide then

        local result =  RaceHelper:PlayFirstGuide(voiceType, trackNumber, isSelf, paramInt, floatParam, carShellId)

        print("RaceHelper:PlayFirstGuide", voiceType, paramInt, result)
        return result
    end

    print("PlayJpVoiceAudio2_0", voiceType, paramInt, playCount)
    if voiceType == VoiceType.Length3_2 then
        if CommonHelper:IsRaceType_Relay() then
            if paramInt == 21 then
                RaceHelper:RandPlayGas(AudioGasJp.Cheer, true)
                local config = RaceHelper:GetSoundsByType(AudioNameJp2.RaceTypeRelayHalfLength)
                clipLength = CommonHelper:Audio_PlayLocalizeAudioByConfig(config, AudioType.VOICE, false, 1, 0,carShellId,trackNumber, true)
            end
        else
            local config = RaceHelper:GetSoundsByType(AudioNameJp2.CheerTypeId)
            RaceHelper:RandPlayGas(AudioGasJp.Cheer, true)
            clipLength = CommonHelper:Audio_PlayLocalizeAudioByConfig(config, AudioType.VOICE, false, 1, 0,carShellId,trackNumber)
        end
        --logError("VoiceType.Length3_2", tostring(paramInt), formatName)
        --if paramInt == 32 then
        --CommonHelper:Audio_PlayAudioRandom({ AudioNameJp.m_half_wav, AudioNameJp.m_half_wav }, AudioType.VOICE, false, 1, 0)
        --elseif paramInt == 21 then

    elseif voiceType == VoiceType.StartGo then
        if CommonHelper:IsRaceType_Relay() then
            local config = RaceHelper:GetSoundsByType(AudioNameJp2.RaceTypeRelay1Go)
            clipLength = CommonHelper:Audio_PlayLocalizeAudioByConfig(config, AudioType.VOICE, false, 1, 0,carShellId,trackNumber, true)
        end
            --local formatName = RaceHelper:GetSoundsByType(AudioNameJp2.ExitStartSlope)
            --clipLength = CommonHelper:Audio_PlayLocalizeAudioByConfig(formatName, AudioType.VOICE, false, 1, 0)

    elseif voiceType == VoiceType.SegmentType or voiceType == VoiceType.ExitStartSlope then
        local num = math.random(10)

        if floatParam == VoiceSubType.CurveNearly and num ==1 then

            local config = RaceHelper:GetSoundsByType(AudioNameJp2.CurveSegmentRun)
            clipLength = CommonHelper:Audio_PlayLocalizeAudioByConfig(config, AudioType.VOICE, false, 1, 0,carShellId,trackNumber)
        elseif floatParam == VoiceSubType.Line and num ==1 then
            print("切换赛道块的参数1", paramInt, 0)
            local config = RaceHelper:GetSoundsByType(AudioNameJp2.LineSegmentRun)
            clipLength = CommonHelper:Audio_PlayLocalizeAudioByConfig(config, AudioType.VOICE, false, 1, 0,carShellId,trackNumber)
        else
            local tracksegement_config = CommonHelper:GetTableDataByID(ConfigNames.tracksegement_config, paramInt)
            local trackcv = 0
            if tracksegement_config ~= nil then
                trackcv = tracksegement_config.cv
            end

            local num = math.random(10)


            print("切换赛道块的参数2", paramInt, trackcv == 0)
            if trackcv == 0 then
                local config = RaceHelper:GetSoundsByType(AudioNameJp2.CheerTypeId)


                if(lastSegmentIndex % 3) == 0 then
                    RaceHelper:RandPlayGas(AudioGasJp.Cheer)
                end
                lastSegmentIndex = lastSegmentIndex +1

                clipLength = CommonHelper:Audio_PlayLocalizeAudioByConfig(config, AudioType.VOICE, false, 1, 0,carShellId,trackNumber)
            else
                local numberId = tonumber(trackcv)

            end
        end

        --lastSegmentIndex = paramInt
        --end
    elseif voiceType == VoiceType.LapChange then
        --local num = math.random(3)
        --local formatName = string.format(AudioNameJp2.LastLap1, num)
        if CommonHelper:IsRaceType_Relay() then
            local config = RaceHelper:GetSoundsByType(AudioNameJp2.RaceTypeRelayIdle)
            clipLength = CommonHelper:Audio_PlayLocalizeAudioByConfig(config, AudioType.VOICE, false, 1, 0,carShellId,trackNumber, true)
        elseif CommonHelper:IsRaceType_Time() then
            if paramInt == 33 or paramInt == 55 then
                RaceHelper:RandPlayGas(AudioGasJp.LastLap, true)
                local config = RaceHelper:GetSoundsByType(AudioNameJp2.RaceTypeTimeLastLap)
                clipLength = CommonHelper:Audio_PlayLocalizeAudioByConfig(config, AudioType.VOICE, false, 1, 0,carShellId,trackNumber, true)
            else
                local config = RaceHelper:GetSoundsByType(AudioNameJp2.RaceTypeTimeIdle)
                clipLength = CommonHelper:Audio_PlayLocalizeAudioByConfig(config, AudioType.VOICE, false, 1, 0,carShellId,trackNumber, true)
            end
        else
            if paramInt == 33 then
                local formatName = RaceHelper:GetSoundsByType(AudioNameJp2.LastLap)
                BattleDataManager:Get():OnFirstPlayDone()
                clipLength = CommonHelper:Audio_PlayLocalizeAudioByConfig(formatName, AudioType.VOICE, false, 1, 0,carShellId,trackNumber)

                RaceHelper:RandPlayGas(AudioGasJp.LastLap)
            end
            if paramInt == 55 then
                local formatName = RaceHelper:GetSoundsByType(AudioNameJp2.LastLap)
                BattleDataManager:Get():OnFirstPlayDone()
                clipLength = CommonHelper:Audio_PlayLocalizeAudioByConfig(formatName, AudioType.VOICE, false, 1, 0,carShellId,trackNumber)
                RaceHelper:RandPlayGas(AudioGasJp.LastLap)
            end
        end
    elseif voiceType == VoiceType.FlyOut then
        RaceHelper:RandPlayGas(AudioGasJp.Fail)
        --local formatName = RaceHelper:GetSoundsByType(AudioNameJp2.FlyOut)
        --clipLength = CommonHelper:Audio_PlayLocalizeAudioByConfig(formatName, AudioType.VOICE, false, 1, 0,carShellId,trackNumber)
        local formatName = RaceHelper:GetSoundsByType(AudioNameJp2.Fail_Flyout)
        clipLength = CommonHelper:Audio_PlayLocalizeAudioByConfig(formatName, AudioType.VOICE, false, 1, 0,carShellId,trackNumber)

    elseif voiceType == VoiceType.StartCountDown then
        local formatName = RaceHelper:GetSoundsByType(AudioNameJp2.StartCountDown)
        clipLength = CommonHelper:Audio_PlayLocalizeAudioByConfig(formatName, AudioType.VOICE, false, 1, 0,carShellId,trackNumber)

    elseif voiceType == VoiceType.BattleFail then
        RaceHelper:RandPlayGas(AudioGasJp.Fail, true)
        if isSelf then
            if CommonHelper:IsRaceType_Relay() then
                local failReason = paramInt
                if failReason == BattleFailError.BatteryLow then
                    local formatName = RaceHelper:GetSoundsByType(AudioNameJp2.RaceTypeRelayBatteryLow)
                    clipLength = CommonHelper:Audio_PlayLocalizeAudioByConfig(formatName, AudioType.VOICE, false, 1, 0,carShellId,trackNumber, true)
                else
                    local formatName = RaceHelper:GetSoundsByType(AudioNameJp2.RaceTypeRelayFail)
                    clipLength = CommonHelper:Audio_PlayLocalizeAudioByConfig(formatName, AudioType.VOICE, false, 1, 0,carShellId,trackNumber, true)
                end
            else
                local num = math.random(8)
                if num >2 then

                    if failReason == BattleFailError.CurveTurnOver then
                        local formatName = RaceHelper:GetSoundsByType(AudioNameJp2.Fail_CurveTurnOver)
                        clipLength = CommonHelper:Audio_PlayLocalizeAudioByConfig(formatName, AudioType.VOICE, false, 1, 0,carShellId,trackNumber)

                    elseif failReason == BattleFailError.DropGroundTurnOver then
                        local formatName = RaceHelper:GetSoundsByType(AudioNameJp2.Fail_LandOver)
                        clipLength = CommonHelper:Audio_PlayLocalizeAudioByConfig(formatName, AudioType.VOICE, false, 1, 0,carShellId,trackNumber)
                    elseif failReason == BattleFailError.LandAngleCrash then
                        if floatParam > 0 then
                            local formatName = RaceHelper:GetSoundsByType(AudioNameJp2.Fail_FrontLandAngleCrash)
                            clipLength = CommonHelper:Audio_PlayLocalizeAudioByConfig(formatName, AudioType.VOICE, false, 1, 0,carShellId,trackNumber)
                        else
                            local formatName = RaceHelper:GetSoundsByType(AudioNameJp2.Fail_RearLandAngleCrash)
                            clipLength = CommonHelper:Audio_PlayLocalizeAudioByConfig(formatName, AudioType.VOICE, false, 1, 0,carShellId,trackNumber)
                        end
                    elseif failReason == BattleFailError.LandAreaCrash then
                        local formatName = RaceHelper:GetSoundsByType(AudioNameJp2.Fail_LandAreaCrash)
                        clipLength = CommonHelper:Audio_PlayLocalizeAudioByConfig(formatName, AudioType.VOICE, false, 1, 0,carShellId,trackNumber)
                    elseif failReason == BattleFailError.BackHitCrash then
                        local formatName = RaceHelper:GetSoundsByType(AudioNameJp2.BackHitCrash)
                        clipLength = CommonHelper:Audio_PlayLocalizeAudioByConfig(formatName, AudioType.VOICE, false, 1, 0,carShellId,trackNumber)
                    else
                        local formatName = RaceHelper:GetSoundsByType(AudioNameJp2.BattleFail)
                        clipLength = CommonHelper:Audio_PlayLocalizeAudioByConfig(formatName, AudioType.VOICE, false, 1, 0,carShellId,trackNumber)
                    end
                else
                    local formatName = RaceHelper:GetSoundsByType(AudioNameJp2.BattleFail)
                    clipLength = CommonHelper:Audio_PlayLocalizeAudioByConfig(formatName, AudioType.VOICE, false, 1, 0,carShellId,trackNumber)
                end
            end

        else
            local formatName = RaceHelper:GetSoundsByType(AudioNameJp2.NPCFail)
            clipLength = CommonHelper:Audio_PlayLocalizeAudioByConfig(formatName, AudioType.VOICE, false, 1, 0,carShellId,trackNumber)
        end
    elseif voiceType == VoiceType.PlaySkillVoice then
        if isSelf then
            local playLvl = PlayerDataManager:Get():GetPlayerLV()
            if playLvl > 2 then
                RaceHelper:RandPlayGas(AudioGasJp.Skill, true)
            end

            local isPlaySpecial = false
            local num = math.random(3)

            if paramInt == AudioSkillType.Xuanfeng then
                local result = PlayerPrefsHelper:GetValue_Skill_Xuanfeng()
                if result < 0 or num == 1 or num == 2 then
                    PlayerPrefsHelper:SetValue_Skill_Xuanfeng(1)
                    isPlaySpecial = true
                    local formatName = RaceHelper:GetSoundsByType(AudioNameJp2.XuanfengSkillVoice)
                    clipLength = CommonHelper:Audio_PlayLocalizeAudioByConfig(formatName, AudioType.VOICE, false, 1, 0,carShellId,trackNumber, true)
                end
            elseif paramInt == AudioSkillType.Climb then
                local result = PlayerPrefsHelper:GetValue_Skill_ClimbWall()
                if result < 0 or num == 1 or num == 2then
                    isPlaySpecial = true
                    PlayerPrefsHelper:SetValue_Skill_ClimbWall()
                    local formatName = RaceHelper:GetSoundsByType(AudioNameJp2.ClimbSkillVoice)
                    clipLength = CommonHelper:Audio_PlayLocalizeAudioByConfig(formatName, AudioType.VOICE, false, 1, 0,carShellId,trackNumber, true)
                end
            end

            if paramInt == AudioSkillType.Normal or not isPlaySpecial then
                local formatName = RaceHelper:GetSoundsByType(AudioNameJp2.SkillVoice)
                clipLength = CommonHelper:Audio_PlayLocalizeAudioByConfig(formatName, AudioType.VOICE, false, 1, 0,carShellId,trackNumber, true)
            end

        end
    elseif voiceType == VoiceType.PreCrashVoice then
        RaceHelper:RandPlayGas(AudioGasJp.Protect)
        local formatName = RaceHelper:GetSoundsByType(AudioNameJp2.ProtectStart)
        clipLength = CommonHelper:Audio_PlayLocalizeAudioByConfig(formatName, AudioType.VOICE, false, 1, 0,carShellId,trackNumber)
        --audioResult = CommonHelper:Audio_PlayAudioRandom({ "audio_crash_gennipinle.mp3", "audio_crash_jiayou.mp3", "audio_crash_zenmele.mp3" }, AudioType.VOICE, false, 1, 0)
    elseif voiceType == VoiceType.Common then

        if paramInt ==VoiceSubType.CommonProtectCrashZoomIn then
            --audioResult = CommonHelper:Audio_PlayAudio("protect_slowmotion.wav", AudioType.VOICE, false, 1, 0)

        elseif paramInt == VoiceSubType.PreCrashSuccess then
            local playLvl = PlayerDataManager:Get():GetPlayerLV()
            if playLvl > 2 then
                RaceHelper:RandPlayGas(AudioGasJp.Protect)
            end
            local formatName = RaceHelper:GetSoundsByType(AudioNameJp2.ProtectSuccess)
            clipLength = CommonHelper:Audio_PlayLocalizeAudioByConfig(formatName, AudioType.VOICE, false, 1, 0,carShellId,trackNumber)
        end
    elseif voiceType == VoiceType.EnterScene then
        RaceHelper:ClearCache()
        local num = math.random(2)
        if CommonHelper:IsRaceType_Time() then
            local formatName = RaceHelper:GetSoundsByType(AudioNameJp2.OpenRaceType_Time)
            clipLength = CommonHelper:Audio_PlayLocalizeAudioByConfig(formatName, AudioType.VOICE, false, 1, 0,carShellId,trackNumber, true)
        elseif CommonHelper:IsRaceType_Relay() then
            local formatName = RaceHelper:GetSoundsByType(AudioNameJp2.OpenRaceType_Relay)
            clipLength = CommonHelper:Audio_PlayLocalizeAudioByConfig(formatName, AudioType.VOICE, false, 1, 0,carShellId,trackNumber, true)
        else
            local num1 = math.random(3)
            local formatName = RaceHelper:GetBattleTypeVoice()
            if formatName ~= nil and num1 == 2 then
                clipLength = CommonHelper:Audio_PlayLocalizeAudioByConfig(formatName, AudioType.VOICE, false, 1, 0,carShellId,trackNumber)
            else
                if num == 1 then
                    if paramInt == 5 then
                        local formatName = RaceHelper:GetSoundsByType(AudioNameJp2.OpenLong)
                        clipLength = CommonHelper:Audio_PlayLocalizeAudioByConfig(formatName, AudioType.VOICE, false, 1, 0,carShellId,trackNumber)
                    else
                        local formatName = RaceHelper:GetSoundsByType(AudioNameJp2.Open)
                        clipLength = CommonHelper:Audio_PlayLocalizeAudioByConfig(formatName, AudioType.VOICE, false, 1, 0,carShellId,trackNumber)
                    end
                else
                    local formatName = RaceHelper:GetSoundsByType(AudioNameJp2.EnterScenePartName)
                    clipLength = CommonHelper:Audio_PlayLocalizeAudioByConfig(formatName, AudioType.VOICE, false, 1, 0,carShellId,trackNumber)
                    if clipLength < 0.6 then
                        if paramInt == 5 then
                            local formatName = RaceHelper:GetSoundsByType(AudioNameJp2.OpenLong)
                            clipLength = CommonHelper:Audio_PlayLocalizeAudioByConfig(formatName, AudioType.VOICE, false, 1, 0,carShellId,trackNumber)
                        else
                            local formatName = RaceHelper:GetSoundsByType(AudioNameJp2.Open)
                            clipLength = CommonHelper:Audio_PlayLocalizeAudioByConfig(formatName, AudioType.VOICE, false, 1, 0,carShellId,trackNumber)
                        end
                    end
                end
            end
        end
    elseif voiceType == VoiceType.CameraShowTime then

    elseif voiceType == VoiceType.FirstRank then
        if isSelf then
            RaceHelper:RandPlayGas(AudioGasJp.FirstRank)
            local formatName = RaceHelper:GetSoundsByType(AudioNameJp2.SelfFirstRank)
            clipLength = CommonHelper:Audio_PlayLocalizeAudioByConfig(formatName, AudioType.VOICE, false, 1, 0,carShellId,trackNumber)
        end
    elseif voiceType == VoiceType.NotFirstRank then
        if isSelf then
            local formatName = RaceHelper:GetSoundsByType(AudioNameJp2.SelfNotFirstRank)
            clipLength = CommonHelper:Audio_PlayLocalizeAudioByConfig(formatName, AudioType.VOICE, false, 1, 0,carShellId,trackNumber)
        end
    elseif voiceType == VoiceType.Overtake then
        if isSelf then
            local formatName = RaceHelper:GetSoundsByType(AudioNameJp2.Overtake)
            clipLength = CommonHelper:Audio_PlayLocalizeAudioByConfig(formatName, AudioType.VOICE, false, 1, 0,carShellId,trackNumber)
        end
    elseif voiceType == VoiceType.BeOvertake then
        if isSelf then
            RaceHelper:RandPlayGas(AudioGasJp.BeOvertake)
            local formatName = RaceHelper:GetSoundsByType(AudioNameJp2.BeOvertake)
            clipLength = CommonHelper:Audio_PlayLocalizeAudioByConfig(formatName, AudioType.VOICE, false, 1, 0,carShellId,trackNumber)
        end
    elseif voiceType == VoiceType.LargeBehind then
        if isSelf then
            local formatName = RaceHelper:GetSoundsByType(AudioNameJp2.LargeBehind)
            clipLength = CommonHelper:Audio_PlayLocalizeAudioByConfig(formatName, AudioType.VOICE, false, 1, 0,carShellId,trackNumber)
        end
    elseif voiceType == VoiceType.FirstWin then
        if isSelf then
            if CommonHelper:IsRaceType_Relay() then
                local formatName = RaceHelper:GetSoundsByType(AudioNameJp2.RaceTypeRelayFinish)
                clipLength = CommonHelper:Audio_PlayLocalizeAudioByConfig(formatName, AudioType.VOICE, false, 1, 0,carShellId,trackNumber, true)
            elseif CommonHelper:IsRaceType_Time() then
                local formatName = RaceHelper:GetSoundsByType(AudioNameJp2.RaceTypeTimeFinish)
                clipLength = CommonHelper:Audio_PlayLocalizeAudioByConfig(formatName, AudioType.VOICE, false, 1, 0,carShellId,trackNumber, true)
            else
                local formatName = RaceHelper:GetSoundsByType(AudioNameJp2.Win)
                clipLength = CommonHelper:Audio_PlayLocalizeAudioByConfig(formatName, AudioType.VOICE, false, 1, 0,carShellId,trackNumber)
            end
        end
    elseif voiceType == VoiceType.RelaySwitchEntity then
        if CommonHelper:IsRaceType_Relay() then
            if paramInt == 1 then
                local formatName = RaceHelper:GetSoundsByType(AudioNameJp2.RaceTypeRelay2Go)
                clipLength = CommonHelper:Audio_PlayLocalizeAudioByConfig(formatName, AudioType.VOICE, false, 1, 0,carShellId,trackNumber, true)
            elseif paramInt == 2 then
                local formatName = RaceHelper:GetSoundsByType(AudioNameJp2.RaceTypeRelay3Go)
                clipLength = CommonHelper:Audio_PlayLocalizeAudioByConfig(formatName, AudioType.VOICE, false, 1, 0,carShellId,trackNumber, true)
            elseif paramInt == 3 then
                local formatName = RaceHelper:GetSoundsByType(AudioNameJp2.RaceTypeRelay4Go)
                clipLength = CommonHelper:Audio_PlayLocalizeAudioByConfig(formatName, AudioType.VOICE, false, 1, 0,carShellId,trackNumber, true)
            elseif paramInt == 4 then
                local formatName = RaceHelper:GetSoundsByType(AudioNameJp2.RaceTypeRelay5Go)
                clipLength = CommonHelper:Audio_PlayLocalizeAudioByConfig(formatName, AudioType.VOICE, false, 1, 0,carShellId,trackNumber, true)
            end
        end
    end

    return clipLength

end




local overTackCount =0
function RaceHelper:PlayJpVoiceAudio5(voiceType, trackNumber, isSelf, paramInt)
    local audioResult = nil
    if PlayerPrefsHelper:GetValue_BattleBgmOffOrOn()==0 then
        return audioResult
    end

    log("voiceType0 = ", voiceType, tostring(trackNumber), paramInt)
    local value=PlayerPrefsHelper:GetValue_BattleBgmValue()
    CSLuaHelper.SetAudioVolumeByAudioType(AudioType.VOICE, value)
    if voiceType == VoiceType.ExitStartSlope then
        --- 一号车一马当先，率先出发！
        --CommonHelper:Audio_PlayAudio("voice_1002.mp3", AudioType.VOICE, false, 1, 0)
        local num = math.random(5)
        if num == 1 then
            audioResult = CommonHelper:Audio_PlayAudioRandom({ AudioNameJp.m_go1_wav, AudioNameJp.m_go1_wav }, AudioType.VOICE, false, 1, 0)
        elseif num == 2 then
            audioResult = CommonHelper:Audio_PlayAudioRandom({ AudioNameJp.m_go2_wav, AudioNameJp.m_go2_wav }, AudioType.VOICE, false, 1, 0)
        elseif num == 3 then
            audioResult = CommonHelper:Audio_PlayAudioRandom({ AudioNameJp.m_go3_wav, AudioNameJp.m_go3_wav }, AudioType.VOICE, false, 1, 0)
        elseif num == 4  then
            audioResult = CommonHelper:Audio_PlayAudioRandom({ AudioNameJp.m_go4_wav, AudioNameJp.m_go4_wav }, AudioType.VOICE, false, 1, 0)
        elseif num == 5  then
            audioResult = CommonHelper:Audio_PlayAudioRandom({ AudioNameJp.m_go5_wav, AudioNameJp.m_go5_wav }, AudioType.VOICE, false, 1, 0)
        end
    elseif voiceType == VoiceType.FirstRank then
        --- 一号车保持领先！
        logError("VoiceType.FirstRank")
        -- CommonHelper:Audio_PlayAudio("voice_1014.mp3", AudioType.VOICE, false, 1, 0)
        --if trackNumber == 1 then
        --    CommonHelper:Audio_PlayAudioRandom({ AudioNameJp.m_first1_wav, AudioNameJp.m_first1_wav }, AudioType.VOICE, false, 1, 0)
        --elseif trackNumber == 2 then
        --    CommonHelper:Audio_PlayAudioRandom({ AudioNameJp.m_first2_wav, AudioNameJp.m_first2_wav }, AudioType.VOICE, false, 1, 0)
        --elseif trackNumber == 3 then
        --    CommonHelper:Audio_PlayAudioRandom({ AudioNameJp.m_first3_wav, AudioNameJp.m_first3_wav }, AudioType.VOICE, false, 1, 0)
        --elseif trackNumber == 4 then
        --    CommonHelper:Audio_PlayAudioRandom({ AudioNameJp.m_first4_wav, AudioNameJp.m_first4_wav }, AudioType.VOICE, false, 1, 0)
        --elseif trackNumber == 5 then
        --    CommonHelper:Audio_PlayAudioRandom({ AudioNameJp.m_first5_wav, AudioNameJp.m_first5_wav }, AudioType.VOICE, false, 1, 0)
        --end
    elseif voiceType == VoiceType.Overtake then

        if paramInt == VoiceSubType.OverTackSelfNotFirst then --超车，非第一的时候触发

        else
            overTackCount = overTackCount +1

            local result = overTackCount % 5
            if result == 0 then
                local num = math.random(3)
                local formatName = string.format(AudioNameJp.m_overtake_wav, num)
                audioResult = CommonHelper:Audio_PlayLocalizeAudio(formatName, AudioType.VOICE, false, 1, 0)
            end
        end

        --CommonHelper:Audio_PlayAudio("voice_1020.mp3", AudioType.VOICE, false, 1, 0)
    elseif voiceType == VoiceType.FirstWin then
        --log("voiceType0 =1111111 ", voiceType, tostring(trackNumber), paramInt)
        --if paramInt ~= 0 then
            local num = math.random(5)
            local formatName = string.format(AudioNameJp.m_win1_wav, num)


            audioResult = CommonHelper:Audio_PlayLocalizeAudio(formatName, AudioType.VOICE, false, 1, 0)

    end

    return audioResult
end

function RaceHelper:RandPlayGas(type, isForce)

    if GameProperties.AreaType == AreaType.AreaTypeKR then
        return
    end
    if not CommonHelper:IsRaceType_Normal() then
        isForce = isForce or false
        if not isForce then
            return
        end
    end

    local playLvl = PlayerDataManager:Get():GetPlayerLV()
    if playLvl < 2 then
        return
    end
    --local rand = math.random(10)
    --if rand > 5 then
        local formatName = RaceHelper:GetSoundsByType(type)
        print("音效的类型 2", type, formatName)
        CommonHelper:Audio_PlayLocalizeAudio(formatName.name, AudioType.VOICE, false, 1, 0)
   --end
end

local soundCacheTable = {}
local lastSoundConfig = nil
function RaceHelper:GetSoundsByType(type)
    local table1 = ClientDataManager:Get():GetDataTable(ConfigNames.soundeffect_config)
    local sounds = table1.GetByType(type)

    local isNeedRemove = false
    if type == AudioNameJp2.CheerTypeId or type == AudioNameJp2.RaceTypeRelayIdle or type == AudioNameJp2.RaceTypeTimeIdle then
        if soundCacheTable == nil then
            soundCacheTable = {}
        end
        if  soundCacheTable[type] == nil or (#soundCacheTable[type] == 0 and type == AudioNameJp2.CheerTypeId) then
            local ds = {}
            for i,v in ipairs(sounds) do
                table.insert(ds,v)
            end
            soundCacheTable[type] =ds
            sounds = soundCacheTable[type]
        else
            sounds = soundCacheTable[type]
        end

        isNeedRemove = true
    end

    if sounds ~= nil and #sounds > 0 then
        local num = math.random(1,#sounds)

        if isNeedRemove then
            local config = sounds[num]
            table.remove(sounds, num)
            for i,v in ipairs(sounds) do
                if v.cvwordid == config.cvwordid then
                    table.remove(sounds, i)
                end
            end

            lastSoundConfig = config
            return config
        else
            if sounds[num] ~= nil then
                local config = sounds[num]
                local dupCount = 0
                while dupCount <2 do
                    if lastSoundConfig ~= nil and lastSoundConfig.cvwordid == config.cvwordid then
                        lastSoundConfig = config
                        num = (num+1)%#sounds
                        if sounds[num] ~= nil then
                            config = sounds[num]
                        end
                    else
                        break
                    end

                    dupCount = dupCount +1
                end
                lastSoundConfig = config

                --print("PlayJpVoiceAudio2_1", type, #sounds, config.name, config.cvwordid, playCount, debug.traceback())
                return config
            end
        end
    end
    return nil
end


function RaceHelper:ClearCache()
    soundCacheTable = nil
end

function RaceHelper:GetBattleTypeVoice()
    local battleType = BattleDataManager:Get():GetBattleType()
    --BattleDataManager:Get():IsReplay()
    if battleType == RaceModel.Battle or battleType == RaceModel.RaceReplay_Pve then  --剧情赛， 欢迎来到大赛之路，我是赛事解说员
        return RaceHelper:GetSoundsByType(AudioNameJp2.EnterScene_PVE)
    elseif battleType == RaceModel.RaceRank  then -- 排位赛， 欢迎来到金导轮杯现场
        return RaceHelper:GetSoundsByType(AudioNameJp2.EnterScene_Rank)
    elseif battleType == RaceModel.RaceTrot then -- 黄金联赛
        return nil
    elseif battleType == RaceModel.RaceJcp then -- Jcup
        return nil
    elseif battleType == RaceModel.RaceXcp then -- Jcup
        return nil
    elseif battleType == RaceModel.RaceSuperBattle then -- 乱斗
        return nil
    elseif battleType == RaceModel.RaceRoom then -- 房间赛
        return nil
    else
        return nil
    end
end

local voiceGuideStep = 0
function RaceHelper:PlayFirstGuide(voiceType, trackNumber, isSelf, paramInt, floatParam, carShellId)
    local clipLength = 0.5

    print("PlayJpVoiceAudio5_0", voiceType, paramInt, playCount)
    if voiceType == VoiceType.Length3_2 then
        if CommonHelper:IsRaceType_Relay() then
            if paramInt == 21 then
                RaceHelper:RandPlayGas(AudioGasJp.Cheer, true)
                local config = RaceHelper:GetSoundsByType(AudioNameJp2.RaceTypeRelayHalfLength)
                clipLength = CommonHelper:Audio_PlayLocalizeAudioByConfig(config, AudioType.VOICE, false, 1, 0,carShellId,trackNumber, true)
            end
        else
            local config = RaceHelper:GetSoundsByType(AudioNameJp2.CheerTypeId)
            RaceHelper:RandPlayGas(AudioGasJp.Cheer, true)
            clipLength = CommonHelper:Audio_PlayLocalizeAudioByConfig(config, AudioType.VOICE, false, 1, 0,carShellId,trackNumber)
        end
        --logError("VoiceType.Length3_2", tostring(paramInt), formatName)
        --if paramInt == 32 then
        --CommonHelper:Audio_PlayAudioRandom({ AudioNameJp.m_half_wav, AudioNameJp.m_half_wav }, AudioType.VOICE, false, 1, 0)
        --elseif paramInt == 21 then

    elseif voiceType == VoiceType.StartGo then
        if CommonHelper:IsRaceType_Relay() then
            local config = RaceHelper:GetSoundsByType(AudioNameJp2.RaceTypeRelay1Go)
            clipLength = CommonHelper:Audio_PlayLocalizeAudioByConfig(config, AudioType.VOICE, false, 1, 0,carShellId,trackNumber, true)
        end
        --local formatName = RaceHelper:GetSoundsByType(AudioNameJp2.ExitStartSlope)
        --clipLength = CommonHelper:Audio_PlayLocalizeAudioByConfig(formatName, AudioType.VOICE, false, 1, 0)
    elseif voiceType == VoiceType.ExitStartSlope then
        print("RaceHelper:ExitStartSlope", voiceType, paramInt, isSelf)
        if voiceGuideStep == 1 then
            local formatName = RaceHelper:GetSoundsByType(AudioNameJp2.Guide2_SlopeDown)
            clipLength = CommonHelper:Audio_PlayLocalizeAudioByConfig(formatName, AudioType.VOICE, false, 1, 0,carShellId,trackNumber)
            voiceGuideStep =  2
        end
    elseif voiceType == VoiceType.SegmentType then
        local num = math.random(10)

        logError("------------voiceGuideStep", voiceGuideStep)
        if floatParam == VoiceSubType.CurveNearly and num ==1 then

            local config = RaceHelper:GetSoundsByType(AudioNameJp2.CurveSegmentRun)
            clipLength = CommonHelper:Audio_PlayLocalizeAudioByConfig(config, AudioType.VOICE, false, 1, 0,carShellId,trackNumber)
        elseif floatParam == VoiceSubType.Line and num ==1 then
            print("切换赛道块的参数1", paramInt, 0)
            local config = RaceHelper:GetSoundsByType(AudioNameJp2.LineSegmentRun)
            clipLength = CommonHelper:Audio_PlayLocalizeAudioByConfig(config, AudioType.VOICE, false, 1, 0,carShellId,trackNumber)
        else

            if voiceGuideStep == 3 then
                local formatName = RaceHelper:GetSoundsByType(AudioNameJp2.Guide4_SkillAfter)
                clipLength = CommonHelper:Audio_PlayLocalizeAudioByConfig(formatName, AudioType.VOICE, false, 1, 0,carShellId,trackNumber)

                voiceGuideStep = 4-- 4
                --local formatName = RaceHelper:GetSoundsByType(AudioNameJp2.Guide6_ProtectSuccess)
                --clipLength = --CommonHelper:Audio_PlayLocalizeAudioByConfig(formatName, AudioType.VOICE, false, 1, 0,carShellId,trackNumber)
            elseif voiceGuideStep == 7 then
                local formatName = RaceHelper:GetSoundsByType(AudioNameJp2.Guide5_Cheer2)
                clipLength = CommonHelper:Audio_PlayLocalizeAudioByConfig(formatName, AudioType.VOICE, false, 1, 0,carShellId,trackNumber)
                voiceGuideStep = 8-- 7else
            elseif voiceGuideStep == 6 then
                local formatName = RaceHelper:GetSoundsByType(AudioNameJp2.Guide5_Cheer)
                clipLength = CommonHelper:Audio_PlayLocalizeAudioByConfig(formatName, AudioType.VOICE, false, 1, 0,carShellId,trackNumber)

                voiceGuideStep = 7-- 8
            else
                if voiceGuideStep >= 4 then
                    local tracksegement_config = CommonHelper:GetTableDataByID(ConfigNames.tracksegement_config, paramInt)
                    local trackcv = 0
                    if tracksegement_config ~= nil then
                        trackcv = tracksegement_config.cv
                    end
                    print("切换赛道块的参数2", paramInt, trackcv == 0)
                    if trackcv == 0 then
                        local config = RaceHelper:GetSoundsByType(AudioNameJp2.CheerTypeId)


                        if(lastSegmentIndex % 3) == 0 then
                            RaceHelper:RandPlayGas(AudioGasJp.Cheer)
                        end
                        lastSegmentIndex = lastSegmentIndex +1

                        if config.name ~= "cv_1001_411.wav" and config.name ~= "cv_1001_412.wav" then
                            clipLength = CommonHelper:Audio_PlayLocalizeAudioByConfig(config, AudioType.VOICE, false, 1, 0,carShellId,trackNumber)
                        end
                    else
                        local numberId = tonumber(trackcv)

                    end
                end
            end
        end

        --lastSegmentIndex = paramInt
        --end
    elseif voiceType == VoiceType.LapChange then
        --local num = math.random(3)
        --local formatName = string.format(AudioNameJp2.LastLap1, num)
        if CommonHelper:IsRaceType_Relay() then
            local config = RaceHelper:GetSoundsByType(AudioNameJp2.RaceTypeRelayIdle)
            clipLength = CommonHelper:Audio_PlayLocalizeAudioByConfig(config, AudioType.VOICE, false, 1, 0,carShellId,trackNumber, true)
        elseif CommonHelper:IsRaceType_Time() then
            if paramInt == 33 or paramInt == 55 then
                RaceHelper:RandPlayGas(AudioGasJp.LastLap, true)
                local config = RaceHelper:GetSoundsByType(AudioNameJp2.RaceTypeTimeLastLap)
                clipLength = CommonHelper:Audio_PlayLocalizeAudioByConfig(config, AudioType.VOICE, false, 1, 0,carShellId,trackNumber, true)
            else
                local config = RaceHelper:GetSoundsByType(AudioNameJp2.RaceTypeTimeIdle)
                clipLength = CommonHelper:Audio_PlayLocalizeAudioByConfig(config, AudioType.VOICE, false, 1, 0,carShellId,trackNumber, true)
            end
        else
            if paramInt == 33 then
                local formatName = RaceHelper:GetSoundsByType(AudioNameJp2.LastLap)
                BattleDataManager:Get():OnFirstPlayDone()
                clipLength = CommonHelper:Audio_PlayLocalizeAudioByConfig(formatName, AudioType.VOICE, false, 1, 0,carShellId,trackNumber)

                RaceHelper:RandPlayGas(AudioGasJp.LastLap)
            end
            if paramInt == 55 then
                local formatName = RaceHelper:GetSoundsByType(AudioNameJp2.LastLap)
                BattleDataManager:Get():OnFirstPlayDone()
                clipLength = CommonHelper:Audio_PlayLocalizeAudioByConfig(formatName, AudioType.VOICE, false, 1, 0,carShellId,trackNumber)
                RaceHelper:RandPlayGas(AudioGasJp.LastLap)
            end
        end
    elseif voiceType == VoiceType.FlyOut then
        RaceHelper:RandPlayGas(AudioGasJp.Fail)
        --local formatName = RaceHelper:GetSoundsByType(AudioNameJp2.FlyOut)
        --clipLength = CommonHelper:Audio_PlayLocalizeAudioByConfig(formatName, AudioType.VOICE, false, 1, 0,carShellId,trackNumber)
        local formatName = RaceHelper:GetSoundsByType(AudioNameJp2.Fail_Flyout)
        clipLength = CommonHelper:Audio_PlayLocalizeAudioByConfig(formatName, AudioType.VOICE, false, 1, 0,carShellId,trackNumber)

    elseif voiceType == VoiceType.StartCountDown then
        local formatName = RaceHelper:GetSoundsByType(AudioNameJp2.StartCountDown)
        clipLength = CommonHelper:Audio_PlayLocalizeAudioByConfig(formatName, AudioType.VOICE, false, 1, 0,carShellId,trackNumber)

    elseif voiceType == VoiceType.BattleFail then
        RaceHelper:RandPlayGas(AudioGasJp.Fail, true)
        if isSelf then
            if CommonHelper:IsRaceType_Relay() then
                local failReason = paramInt
                if failReason == BattleFailError.BatteryLow then
                    local formatName = RaceHelper:GetSoundsByType(AudioNameJp2.RaceTypeRelayBatteryLow)
                    clipLength = CommonHelper:Audio_PlayLocalizeAudioByConfig(formatName, AudioType.VOICE, false, 1, 0,carShellId,trackNumber, true)
                else
                    local formatName = RaceHelper:GetSoundsByType(AudioNameJp2.RaceTypeRelayFail)
                    clipLength = CommonHelper:Audio_PlayLocalizeAudioByConfig(formatName, AudioType.VOICE, false, 1, 0,carShellId,trackNumber, true)
                end
            else
                local num = math.random(8)
                if num >2 then

                    if failReason == BattleFailError.CurveTurnOver then
                        local formatName = RaceHelper:GetSoundsByType(AudioNameJp2.Fail_CurveTurnOver)
                        clipLength = CommonHelper:Audio_PlayLocalizeAudioByConfig(formatName, AudioType.VOICE, false, 1, 0,carShellId,trackNumber)

                    elseif failReason == BattleFailError.DropGroundTurnOver then
                        local formatName = RaceHelper:GetSoundsByType(AudioNameJp2.Fail_LandOver)
                        clipLength = CommonHelper:Audio_PlayLocalizeAudioByConfig(formatName, AudioType.VOICE, false, 1, 0,carShellId,trackNumber)
                    elseif failReason == BattleFailError.LandAngleCrash then
                        if floatParam > 0 then
                            local formatName = RaceHelper:GetSoundsByType(AudioNameJp2.Fail_FrontLandAngleCrash)
                            clipLength = CommonHelper:Audio_PlayLocalizeAudioByConfig(formatName, AudioType.VOICE, false, 1, 0,carShellId,trackNumber)
                        else
                            local formatName = RaceHelper:GetSoundsByType(AudioNameJp2.Fail_RearLandAngleCrash)
                            clipLength = CommonHelper:Audio_PlayLocalizeAudioByConfig(formatName, AudioType.VOICE, false, 1, 0,carShellId,trackNumber)
                        end
                    elseif failReason == BattleFailError.LandAreaCrash then
                        local formatName = RaceHelper:GetSoundsByType(AudioNameJp2.Fail_LandAreaCrash)
                        clipLength = CommonHelper:Audio_PlayLocalizeAudioByConfig(formatName, AudioType.VOICE, false, 1, 0,carShellId,trackNumber)
                    elseif failReason == BattleFailError.BackHitCrash then
                        local formatName = RaceHelper:GetSoundsByType(AudioNameJp2.BackHitCrash)
                        clipLength = CommonHelper:Audio_PlayLocalizeAudioByConfig(formatName, AudioType.VOICE, false, 1, 0,carShellId,trackNumber)
                    else
                        local formatName = RaceHelper:GetSoundsByType(AudioNameJp2.BattleFail)
                        clipLength = CommonHelper:Audio_PlayLocalizeAudioByConfig(formatName, AudioType.VOICE, false, 1, 0,carShellId,trackNumber)
                    end
                else
                    local formatName = RaceHelper:GetSoundsByType(AudioNameJp2.BattleFail)
                    clipLength = CommonHelper:Audio_PlayLocalizeAudioByConfig(formatName, AudioType.VOICE, false, 1, 0,carShellId,trackNumber)
                end
            end

        else
            local formatName = RaceHelper:GetSoundsByType(AudioNameJp2.NPCFail)
            clipLength = CommonHelper:Audio_PlayLocalizeAudioByConfig(formatName, AudioType.VOICE, false, 1, 0,carShellId,trackNumber)
        end
    elseif voiceType == VoiceType.PlaySkillVoice then
        if isSelf then
            local playLvl = PlayerDataManager:Get():GetPlayerLV()
            if playLvl > 2 then
                RaceHelper:RandPlayGas(AudioGasJp.Skill, true)
            end

            local isPlaySpecial = false
            local num = math.random(3)

            if paramInt == AudioSkillType.Xuanfeng then
                local result = PlayerPrefsHelper:GetValue_Skill_Xuanfeng()
                if result < 0 or num == 1 or num == 2 then
                    PlayerPrefsHelper:SetValue_Skill_Xuanfeng(1)
                    isPlaySpecial = true
                    local formatName = RaceHelper:GetSoundsByType(AudioNameJp2.XuanfengSkillVoice)
                    clipLength = CommonHelper:Audio_PlayLocalizeAudioByConfig(formatName, AudioType.VOICE, false, 1, 0,carShellId,trackNumber, true)
                end
            elseif paramInt == AudioSkillType.Climb then
                local result = PlayerPrefsHelper:GetValue_Skill_ClimbWall()
                if result < 0 or num == 1 or num == 2then
                    isPlaySpecial = true
                    PlayerPrefsHelper:SetValue_Skill_ClimbWall()
                    local formatName = RaceHelper:GetSoundsByType(AudioNameJp2.ClimbSkillVoice)
                    clipLength = CommonHelper:Audio_PlayLocalizeAudioByConfig(formatName, AudioType.VOICE, false, 1, 0,carShellId,trackNumber, true)
                end
            end

            if paramInt == AudioSkillType.Normal or not isPlaySpecial then
                local formatName = RaceHelper:GetSoundsByType(AudioNameJp2.Guide3_SkillPlay)
                clipLength = CommonHelper:Audio_PlayLocalizeAudioByConfig(formatName, AudioType.VOICE, false, 1, 0,carShellId,trackNumber, true)
            end

            voiceGuideStep = 3
        end
    elseif voiceType == VoiceType.PreCrashVoice then
        RaceHelper:RandPlayGas(AudioGasJp.Protect)
        local formatName = RaceHelper:GetSoundsByType(AudioNameJp2.ProtectStart)
        clipLength = CommonHelper:Audio_PlayLocalizeAudioByConfig(formatName, AudioType.VOICE, false, 1, 0,carShellId,trackNumber)
        logError("------------voiceGuideStep PreCrashVoice", voiceGuideStep)
        voiceGuideStep = 5 -- 5
        --audioResult = CommonHelper:Audio_PlayAudioRandom({ "audio_crash_gennipinle.mp3", "audio_crash_jiayou.mp3", "audio_crash_zenmele.mp3" }, AudioType.VOICE, false, 1, 0)
    elseif voiceType == VoiceType.Common then

        if voiceGuideStep >= 5 then
            if paramInt ==VoiceSubType.CommonProtectCrashZoomIn then
                --audioResult = CommonHelper:Audio_PlayAudio("protect_slowmotion.wav", AudioType.VOICE, false, 1, 0)

            elseif paramInt == VoiceSubType.PreCrashSuccess then
                local playLvl = PlayerDataManager:Get():GetPlayerLV()
                if playLvl > 2 then
                    RaceHelper:RandPlayGas(AudioGasJp.Protect)
                end

                voiceGuideStep = 6 --6
                local formatName = RaceHelper:GetSoundsByType(AudioNameJp2.ProtectSuccess)
                clipLength = CommonHelper:Audio_PlayLocalizeAudioByConfig(formatName, AudioType.VOICE, false, 1, 0,carShellId,trackNumber)
            end
        end

    elseif voiceType == VoiceType.EnterScene then
        RaceHelper:ClearCache()
        local num = math.random(2)
        if CommonHelper:IsRaceType_Time() then
            local formatName = RaceHelper:GetSoundsByType(AudioNameJp2.OpenRaceType_Time)
            clipLength = CommonHelper:Audio_PlayLocalizeAudioByConfig(formatName, AudioType.VOICE, false, 1, 0,carShellId,trackNumber, true)
        elseif CommonHelper:IsRaceType_Relay() then
            local formatName = RaceHelper:GetSoundsByType(AudioNameJp2.OpenRaceType_Relay)
            clipLength = CommonHelper:Audio_PlayLocalizeAudioByConfig(formatName, AudioType.VOICE, false, 1, 0,carShellId,trackNumber, true)
        else
            voiceGuideStep =1
            local formatName = RaceHelper:GetSoundsByType(AudioNameJp2.Guide1_Enter)
            clipLength = CommonHelper:Audio_PlayLocalizeAudioByConfig(formatName, AudioType.VOICE, false, 1, 0,carShellId,trackNumber)
        end
    elseif voiceType == VoiceType.CameraShowTime then

    elseif voiceType == VoiceType.FirstRank then
        if isSelf then
            if voiceGuideStep >= 5 then
                RaceHelper:RandPlayGas(AudioGasJp.FirstRank)
                local formatName = RaceHelper:GetSoundsByType(AudioNameJp2.SelfFirstRank)
                clipLength = CommonHelper:Audio_PlayLocalizeAudioByConfig(formatName, AudioType.VOICE, false, 1, 0,carShellId,trackNumber)

            end
        end
    elseif voiceType == VoiceType.NotFirstRank then
        if isSelf then
            local formatName = RaceHelper:GetSoundsByType(AudioNameJp2.SelfNotFirstRank)
            clipLength = CommonHelper:Audio_PlayLocalizeAudioByConfig(formatName, AudioType.VOICE, false, 1, 0,carShellId,trackNumber)
        end
    elseif voiceType == VoiceType.Overtake then
        if isSelf then
            local formatName = RaceHelper:GetSoundsByType(AudioNameJp2.Overtake)
            clipLength = CommonHelper:Audio_PlayLocalizeAudioByConfig(formatName, AudioType.VOICE, false, 1, 0,carShellId,trackNumber)
        end
    elseif voiceType == VoiceType.BeOvertake then
        if isSelf then
            RaceHelper:RandPlayGas(AudioGasJp.BeOvertake)
            local formatName = RaceHelper:GetSoundsByType(AudioNameJp2.BeOvertake)
            clipLength = CommonHelper:Audio_PlayLocalizeAudioByConfig(formatName, AudioType.VOICE, false, 1, 0,carShellId,trackNumber)
        end
    elseif voiceType == VoiceType.LargeBehind then
        if isSelf then
            local formatName = RaceHelper:GetSoundsByType(AudioNameJp2.LargeBehind)
            clipLength = CommonHelper:Audio_PlayLocalizeAudioByConfig(formatName, AudioType.VOICE, false, 1, 0,carShellId,trackNumber)
        end
    elseif voiceType == VoiceType.FirstWin then
        if isSelf then

            if voiceGuideStep >= 8 then
                local formatName = RaceHelper:GetSoundsByType(AudioNameJp2.Guide7_Success)
                clipLength = CommonHelper:Audio_PlayLocalizeAudioByConfig(formatName, AudioType.VOICE, false, 1, 0,carShellId,trackNumber)
            else
                local formatName = RaceHelper:GetSoundsByType(AudioNameJp2.Win)
                clipLength = CommonHelper:Audio_PlayLocalizeAudioByConfig(formatName, AudioType.VOICE, false, 1, 0,carShellId,trackNumber)
            end
        end
    elseif voiceType == VoiceType.RelaySwitchEntity then
        if CommonHelper:IsRaceType_Relay() then
            if paramInt == 1 then
                local formatName = RaceHelper:GetSoundsByType(AudioNameJp2.RaceTypeRelay2Go)
                clipLength = CommonHelper:Audio_PlayLocalizeAudioByConfig(formatName, AudioType.VOICE, false, 1, 0,carShellId,trackNumber, true)
            elseif paramInt == 2 then
                local formatName = RaceHelper:GetSoundsByType(AudioNameJp2.RaceTypeRelay3Go)
                clipLength = CommonHelper:Audio_PlayLocalizeAudioByConfig(formatName, AudioType.VOICE, false, 1, 0,carShellId,trackNumber, true)
            elseif paramInt == 3 then
                local formatName = RaceHelper:GetSoundsByType(AudioNameJp2.RaceTypeRelay4Go)
                clipLength = CommonHelper:Audio_PlayLocalizeAudioByConfig(formatName, AudioType.VOICE, false, 1, 0,carShellId,trackNumber, true)
            elseif paramInt == 4 then
                local formatName = RaceHelper:GetSoundsByType(AudioNameJp2.RaceTypeRelay5Go)
                clipLength = CommonHelper:Audio_PlayLocalizeAudioByConfig(formatName, AudioType.VOICE, false, 1, 0,carShellId,trackNumber, true)
            end
        end
    end

    return clipLength
end







