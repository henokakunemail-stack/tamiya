--CarAudioType = {
--    Line_Engine, -- 直线引擎声音
--    Curve_Engine, -- 弯道声音
--    LandDown, --  落地的声音
--    Curve_Collision, -- 弯道碰撞
--}

AudioName = {
    m_half_wav = "m_half.wav",
    f_half_wav = "f_half.wav",

    m_cheer1_wav = "m_cheer1.wav",
    m_cheer2_wav = "m_cheer2.wav",
    m_cheer3_wav = "m_cheer3.wav",
    f_cheer1_wav = "f_cheer1.wav",
    f_cheer2_wav = "f_cheer2.wav",
    f_cheer3_wav = "f_cheer3.wav",

    m_go1_wav = "m_go1.wav",
    m_go2_wav = "m_go2.wav",
    m_go3_wav = "m_go3.wav",
    m_go4_wav = "m_go4.wav",
    m_go5_wav = "m_go5.wav",
    f_go1_wav = "f_go1.wav",
    f_go2_wav = "f_go2.wav",
    f_go3_wav = "f_go3.wav",
    f_go4_wav = "f_go4.wav",
    f_go5_wav = "f_go5.wav",

    m_open1_1_wav = "m_open1_1.wav",
    m_open1_2_wav = "m_open1_2.wav",
    m_open2_1_wav = "m_open2_1.wav",
    m_open2_2_wav = "m_open2_2.wav",
    f_open1_1_wav = "f_open1_1.wav",
    f_open1_2_wav = "f_open1_2.wav",
    f_open2_1_wav = "f_open2_1.wav",
    f_open2_2_wav = "f_open2_2.wav",

    voice_1004_wav = "voice_1004.wav",
    voice_1013_wav = "voice_1013.wav",
    voice_1017_wav = "voice_1017.wav",

    m_final_wav = "m_final.wav",
    f_final_wav = "f_final.wav",

    m_fail1_wav = "m_fail1.wav",
    m_fail2_wav = "m_fail2.wav",
    m_fail3_wav = "m_fail3.wav",
    m_fail4_wav = "m_fail4.wav",
    m_fail5_wav = "m_fail5.wav",
    f_fail1_wav = "f_fail1.wav",
    f_fail2_wav = "f_fail2.wav",
    f_fail3_wav = "f_fail3.wav",
    f_fail4_wav = "f_fail4.wav",
    f_fail5_wav = "f_fail5.wav",

    m_win1_wav = "m_win1.wav",
    m_win2_wav = "m_win2.wav",
    m_win3_wav = "m_win3.wav",
    m_win4_wav = "m_win4.wav",
    m_win5_wav = "m_win5.wav",
    f_win1_wav = "f_win1.wav",
    f_win2_wav = "f_win2.wav",
    f_win3_wav = "f_win3.wav",
    f_win4_wav = "f_win4.wav",
    f_win5_wav = "f_win5.wav",


    m_first1_wav = "m_first1.wav",
    m_first2_wav = "m_first2.wav",
    m_first3_wav = "m_first3.wav",
    m_first4_wav = "m_first4.wav",
    m_first5_wav = "m_first5.wav",
    f_first1_wav = "f_first1.wav",
    f_first2_wav = "f_first2.wav",
    f_first3_wav = "f_first3.wav",
    f_first4_wav = "f_first4.wav",
    f_first5_wav = "f_first5.wav",
}


function RaceHelper:PlayVoiceAudio(voiceType, trackNumber, isSelf, paramInt,floatParam, carShellId)
    if PlayerPrefsHelper:GetValue_BattleBgmOffOrOn()==0 then
        return 0.5
    end

    local audioResult = nil
    log("voiceType0 = ", voiceType, tostring(trackNumber), paramInt)
    local value=PlayerPrefsHelper:GetValue_BattleBgmValue()
    CSLuaHelper.SetAudioVolumeByAudioType(AudioType.VOICE, value)
    --- 比赛已经进入后半段了！
    if voiceType == VoiceType.Length3_2 then
        logError("length32" .. tostring(paramInt))
        if paramInt == 32 then
            audioResult = CommonHelper:Audio_PlayAudioRandom({ AudioName.m_half_wav, AudioName.f_half_wav }, AudioType.VOICE, false, 1, 0)
        elseif paramInt == 21 then
            local num = math.random(4)
            if num == 1 then
                audioResult = CommonHelper:Audio_PlayAudioRandom({ AudioName.m_cheer3_wav, AudioName.f_cheer3_wav }, AudioType.VOICE, false, 1, 0)
            elseif num == 2 then
                audioResult =  CommonHelper:Audio_PlayAudioRandom({ AudioName.m_cheer1_wav, AudioName.f_cheer1_wav }, AudioType.VOICE, false, 1, 0)
            elseif num == 3 then
                audioResult =  CommonHelper:Audio_PlayAudioRandom({ AudioName.m_cheer2_wav, AudioName.f_cheer2_wav }, AudioType.VOICE, false, 1, 0)
            else
                audioResult = CommonHelper:Audio_PlayAudioRandom({ AudioName.m_half_wav, AudioName.f_half_wav }, AudioType.VOICE, false, 1, 0)
            end
        end
    elseif voiceType == VoiceType.ExitStartSlope then
        --- 一号车一马当先，率先出发！
        --CommonHelper:Audio_PlayAudio("voice_1002.mp3", AudioType.VOICE, false, 1, 0)
        if trackNumber == 1 then
            audioResult = CommonHelper:Audio_PlayAudioRandom({ AudioName.m_go1_wav, AudioName.f_go1_wav }, AudioType.VOICE, false, 1, 0)
        elseif trackNumber == 2 then
            audioResult = CommonHelper:Audio_PlayAudioRandom({ AudioName.m_go2_wav, AudioName.f_go2_wav }, AudioType.VOICE, false, 1, 0)
        elseif trackNumber == 3 then
            audioResult = CommonHelper:Audio_PlayAudioRandom({ AudioName.m_go3_wav, AudioName.f_go3_wav }, AudioType.VOICE, false, 1, 0)
        elseif trackNumber == 4 then
            audioResult = CommonHelper:Audio_PlayAudioRandom({ AudioName.m_go4_wav, AudioName.f_go4_wav }, AudioType.VOICE, false, 1, 0)
        elseif trackNumber == 5 then
            audioResult = CommonHelper:Audio_PlayAudioRandom({ AudioName.m_go5_wav, AudioName.f_go5_wav }, AudioType.VOICE, false, 1, 0)
        end
    elseif voiceType == VoiceType.StartCountDown then
        --- 大家各就各位！READY …… ！ GO！！！
        --CommonHelper:Audio_PlayAudio("voice_1003.mp3", AudioType.VOICE, false, 1, 0)
        -- CommonHelper:Audio_PlayAudio("m_ready.wav", AudioType.VOICE, false, 1, 0)
        local num = math.random(3)
        if num == 1 then
            audioResult = CommonHelper:Audio_PlayAudioRandom({ AudioName.m_open1_1_wav, AudioName.f_open1_1_wav }, AudioType.VOICE, false, 1, 0)
        elseif num == 2 then
            audioResult = CommonHelper:Audio_PlayAudioRandom({ AudioName.m_open2_2_wav, AudioName.f_open2_2_wav }, AudioType.VOICE, false, 1, 0)
        end
    elseif voiceType == VoiceType.CameraShowTime then
        audioResult = CommonHelper:Audio_PlayAudio("voice_1004.wav", AudioType.VOICE, false, 1, 0)
    elseif voiceType == VoiceType.EnterScene then
        local num = math.random(3)
        --if trackNumber == 3 then
        --    num = math.random(12)
        --end
        if num == 1 then
            audioResult = CommonHelper:Audio_PlayAudioRandom({ AudioName.m_open1_1_wav, AudioName.f_open1_1_wav }, AudioType.VOICE, false, 1, 0)
        elseif num == 2 then
            audioResult = CommonHelper:Audio_PlayAudioRandom({ AudioName.m_open2_1_wav, AudioName.f_open2_1_wav }, AudioType.VOICE, false, 1, 0)
        end
    elseif voiceType == VoiceType.LapChange then
        --if paramInt == 2 then
        --    CommonHelper:Audio_PlayAudio("voice_1007.mp3", AudioType.VOICE, false, 1, 0)
        --elseif paramInt == 3 then
        --    CommonHelper:Audio_PlayAudio("voice_1008.mp3", AudioType.VOICE, false, 1, 0)
        --elseif paramInt == 4 then
        --    CommonHelper:Audio_PlayAudio("voice_1009.mp3", AudioType.VOICE, false, 1, 0)
        --
        --end

        local num = math.random(10)

        if paramInt == 33 then
            BattleDataManager:Get():OnFirstPlayDone()
            if num > 5 then
                audioResult = CommonHelper:Audio_PlayAudioRandom({ AudioName.m_final_wav, AudioName.f_final_wav }, AudioType.VOICE, false, 1, 0)
            else
                audioResult = CommonHelper:Audio_PlayAudioRandom({ AudioName.m_final_wav, AudioName.f_final_wav }, AudioType.VOICE, false, 1, 0)
            end
        end
        if paramInt == 55 then
            BattleDataManager:Get():OnFirstPlayDone()
            if num > 5 then
                audioResult = CommonHelper:Audio_PlayAudioRandom({ AudioName.m_final_wav, AudioName.f_final_wav }, AudioType.VOICE, false, 1, 0)
            else
                audioResult = CommonHelper:Audio_PlayAudioRandom({ AudioName.m_final_wav, AudioName.f_final_wav }, AudioType.VOICE, false, 1, 0)
            end
        end
    elseif voiceType == VoiceType.OutOfTrack then
        if trackNumber == 1 then
            audioResult = CommonHelper:Audio_PlayAudioRandom({ AudioName.m_fail1_wav, AudioName.f_fail1_wav }, AudioType.VOICE, false, 1, 0)
        elseif trackNumber == 2 then
            audioResult = CommonHelper:Audio_PlayAudioRandom({ AudioName.m_fail2_wav, AudioName.f_fail2_wav }, AudioType.VOICE, false, 1, 0)
        elseif trackNumber == 3 then
            audioResult = CommonHelper:Audio_PlayAudioRandom({ AudioName.m_fail3_wav, AudioName.f_fail3_wav }, AudioType.VOICE, false, 1, 0)
        elseif trackNumber == 4 then
            audioResult = CommonHelper:Audio_PlayAudioRandom({ AudioName.m_fail4_wav, AudioName.f_fail4_wav }, AudioType.VOICE, false, 1, 0)
        elseif trackNumber == 5 then
            audioResult = CommonHelper:Audio_PlayAudioRandom({ AudioName.m_fail5_wav, AudioName.f_fail5_wav }, AudioType.VOICE, false, 1, 0)
        end

        --- 太可惜了！一号车飞出了赛道！
        --if isSelf then
        --    CommonHelper:Audio_PlayAudio("voice_1017.mp3", AudioType.VOICE, false, 1, 0)
        --else
        --    CommonHelper:Audio_PlayAudio("voice_1013.mp3", AudioType.VOICE, false, 1, 0)
    elseif voiceType == VoiceType.CurveTurnOver then
        if isSelf then
            audioResult = CommonHelper:Audio_PlayAudio("voice_1017.wav", AudioType.VOICE, false, 1, 0)
        else
            audioResult = CommonHelper:Audio_PlayAudio("voice_1013.wav", AudioType.VOICE, false, 1, 0)
        end
    elseif voiceType == VoiceType.BattleFail then

        if trackNumber == 1 then
        elseif trackNumber == 2 then
        elseif trackNumber == 3 then
        elseif trackNumber == 4 then
        elseif trackNumber == 5 then
        end
        --print("paramInt = ", paramInt, "trackNumber = ", trackNumber)

    elseif voiceType == VoiceType.FirstRank then
        --- 一号车保持领先！
        logError("VoiceType.FirstRank")
        -- CommonHelper:Audio_PlayAudio("voice_1014.mp3", AudioType.VOICE, false, 1, 0)
        if trackNumber == 1 then
            audioResult = CommonHelper:Audio_PlayAudioRandom({ AudioName.m_first1_wav, AudioName.f_first1_wav }, AudioType.VOICE, false, 1, 0)
        elseif trackNumber == 2 then
            audioResult = CommonHelper:Audio_PlayAudioRandom({ AudioName.m_first2_wav, AudioName.f_first2_wav }, AudioType.VOICE, false, 1, 0)
        elseif trackNumber == 3 then
            audioResult = CommonHelper:Audio_PlayAudioRandom({ AudioName.m_first3_wav, AudioName.f_first3_wav }, AudioType.VOICE, false, 1, 0)
        elseif trackNumber == 4 then
            audioResult = CommonHelper:Audio_PlayAudioRandom({ AudioName.m_first4_wav, AudioName.f_first4_wav }, AudioType.VOICE, false, 1, 0)
        elseif trackNumber == 5 then
            audioResult = CommonHelper:Audio_PlayAudioRandom({ AudioName.m_first5_wav, AudioName.f_first5_wav }, AudioType.VOICE, false, 1, 0)
        end
    elseif voiceType == VoiceType.Overtake then
        --CommonHelper:Audio_PlayAudio("voice_1020.mp3", AudioType.VOICE, false, 1, 0)
    elseif voiceType == VoiceType.FirstWin then
        if trackNumber == 1 then
            audioResult = CommonHelper:Audio_PlayAudioRandom({ AudioName.m_win1_wav, AudioName.f_win1_wav }, AudioType.VOICE, false, 1, 0)
        elseif trackNumber == 2 then
            audioResult = CommonHelper:Audio_PlayAudioRandom({ AudioName.m_win2_wav, AudioName.f_win2_wav }, AudioType.VOICE, false, 1, 0)
        elseif trackNumber == 3 then
            audioResult = CommonHelper:Audio_PlayAudioRandom({ AudioName.m_win3_wav, AudioName.f_win3_wav }, AudioType.VOICE, false, 1, 0)
        elseif trackNumber == 4 then
            audioResult = CommonHelper:Audio_PlayAudioRandom({ AudioName.m_win4_wav, AudioName.f_win4_wav }, AudioType.VOICE, false, 1, 0)
        elseif trackNumber == 5 then
            audioResult = CommonHelper:Audio_PlayAudioRandom({ AudioName.m_win5_wav, AudioName.f_win5_wav }, AudioType.VOICE, false, 1, 0)
        end
    elseif voiceType == VoiceType.Common then
        if paramInt ==VoiceSubType.CommonProtectCrashZoomIn then
            audioResult = CommonHelper:Audio_PlayAudio("protect_slowmotion.wav", AudioType.VOICE, false, 1, 0)
        end
    end
    if audioResult ~= nil then
        if audioResult.clip ~= nil then
            return audioResult.clip.length + 0.5
        end
    end
    return 0.5
end

function RaceHelper.PlayVoiceAudioOld(voiceType, trackNumber, isSelf, paramInt)

    log("voiceType1 = ", voiceType, tostring(trackNumber), paramInt)

    --- 比赛已经进入后半段了！
    if voiceType == VoiceType.Length3_2 then
        if paramInt == 32 then
            CommonHelper:Audio_PlayAudio("voice_1001.mp3", AudioType.VOICE, false, 1, 0)

        elseif paramInt == 21 then
            CommonHelper:Audio_PlayAudio("voice_1010.mp3", AudioType.VOICE, false, 1, 0)
        end
    elseif voiceType == VoiceType.ExitStartSlope then
        --- 一号车一马当先，率先出发！
        CommonHelper:Audio_PlayAudio("voice_1002.mp3", AudioType.VOICE, false, 1, 0)

    elseif voiceType == VoiceType.StartCountDown then
        --- 大家各就各位！READY …… ！ GO！！！
        --CommonHelper:Audio_PlayAudio("voice_1003.mp3", AudioType.VOICE, false, 1, 0)

    elseif voiceType == VoiceType.CameraShowTime then
        CommonHelper:Audio_PlayAudio("voice_1004.mp3", AudioType.VOICE, false, 1, 0)

    elseif voiceType == VoiceType.EnterScene then
        CommonHelper:Audio_PlayAudio("voice_1005.mp3", AudioType.VOICE, false, 1, 0)

    elseif voiceType == VoiceType.LapChange then
        BattleDataManager:Get():OnFirstPlayDone()
        if paramInt == 2 then
            CommonHelper:Audio_PlayAudio("voice_1007.mp3", AudioType.VOICE, false, 1, 0)
        elseif paramInt == 3 then
            CommonHelper:Audio_PlayAudio("voice_1008.mp3", AudioType.VOICE, false, 1, 0)
        elseif paramInt == 4 then
            CommonHelper:Audio_PlayAudio("voice_1009.mp3", AudioType.VOICE, false, 1, 0)

        end

        if paramInt == 33 then

        end

        if paramInt == 55 then

        end

    elseif voiceType == VoiceType.OutOfTrack then

        --- 太可惜了！一号车飞出了赛道！
        if isSelf then
            CommonHelper:Audio_PlayAudio("voice_1017.mp3", AudioType.VOICE, false, 1, 0)
        else
            CommonHelper:Audio_PlayAudio("voice_1013.mp3", AudioType.VOICE, false, 1, 0)

        end
    elseif voiceType == VoiceType.CurveTurnOver then
        if isSelf then
            CommonHelper:Audio_PlayAudio("voice_1017.mp3", AudioType.VOICE, false, 1, 0)
        else
            CommonHelper:Audio_PlayAudio("voice_1013.mp3", AudioType.VOICE, false, 1, 0)

        end
    elseif voiceType == VoiceType.FirstRank then
        --- 一号车保持领先！
        CommonHelper:Audio_PlayAudio("voice_1014.mp3", AudioType.VOICE, false, 1, 0)

    elseif voiceType == VoiceType.Overtake then
        CommonHelper:Audio_PlayAudio("voice_1020.mp3", AudioType.VOICE, false, 1, 0)
    elseif voiceType == VoiceType.PlaySkillVoice then
        audioResult = CommonHelper:Audio_PlayAudioRandom({ "audio_crash_chong1.mp3", "audio_crash_chong2.mp3" }, AudioType.VOICE, false, 1, 0)
    elseif voiceType == VoiceType.PreCrashVoice then
        audioResult = CommonHelper:Audio_PlayAudioRandom({ "audio_crash_gennipinle.mp3", "audio_crash_jiayou.mp3", "audio_crash_zenmele.mp3" }, AudioType.VOICE, false, 1, 0)
    end

    if audioResult == nil or audioResult.clip == nil then
        return 0.5
    end
    return audioResult.clip.length
end

---@param carAudioType CarAudioType
function RaceHelper.GetCarBattleAudioName(carAudioType, motorType)

    if carAudioType == CarAudioType.Line_Engine then
        -- 直线引擎声音
        local num = math.random(3)

        if motorType == MotorType.Speed then
            return "speed_tune.wav"
        elseif num == MotorType.Torque then
            return "power_tune.wav"
        elseif num == MotorType.Other1 then
            return "audio_sfx_line1.wav"
        elseif num == MotorType.Other2 then
            return "audio_sfx_line_xn.wav"
        end
    elseif carAudioType == CarAudioType.UpSlope then
        return "motor_upslope.wav"
    elseif carAudioType == CarAudioType.DownSlope then
        return "motor_downslope.wav"
    elseif carAudioType == CarAudioType.Curve_Engine then
        -- 弯道声音
        --local num = math.random(3)
        if motorType == MotorType.Speed then
            return "4cfd.acb.00001.wav"
        elseif num == MotorType.Torque then
            return "4cfd.acb.00002.wav"
        else
            return "audio_sfx_digital_curve.wav"
        end
        --return "audio_sfx_curvecollsion.wav"
        --if num == 1 then
        --    return "audio_sfx_curve.wav"
        --    elseif num == 2 then
        --        return "audio_sfx_curve1.wav"
        --
        --    else
        --        return "audio_sfx_curve2.wav"
        --end

    elseif carAudioType == CarAudioType.LandDown then
        --  落地的声音
        local num = math.random(2)
        if num == 1 then
            return "audio_sfx_landdown1.wav"
        else
            return "cat_ui_flash.wav"
        end
    elseif carAudioType == CarAudioType.Curve_Collision then
        -- 弯道碰撞声音
        local num = math.random(3)

        if num == 1 then
            return "pengbi_l.wav"
        elseif num == 2 then
            return "pengbi_xl.wav"
        elseif num == 3 then
            return "audio_sfx_curvecollsion.mp3"
        end
    elseif carAudioType == CarAudioType.StartEngine then
        --return "audio_sfx_start_spark.wav"
        --local num = math.random(2)

        if motorType == MotorType.Torque then
            return "high_torque.wav"
        else
            return "idaten.wav"
        end

    elseif carAudioType == CarAudioType.Spectator then
        --return "audio_sfx_spectator.wav"
        --local num = math.random(2)
        --if num == 1 then
        --    return "booing.wav"
        --else
            return "audio_sfx_spectator.wav"
        --end
    elseif carAudioType == CarAudioType.FlyOutDownMotor then
        local num = math.random(2)
        if motorType == MotorType.Speed then
            return "4cfd.acb.00006.wav"
        else
            return "4cfd.acb.00010.wav"
        end
    elseif carAudioType == CarAudioType.SkillShowTime then

        return "skill_showtime.wav"
    elseif carAudioType == CarAudioType.Environment then
        local num = math.random(2)
        return ""
        --[[if num == 1 then
            return "4d85.acb.00014.wav"
        else
            return "booing.wav"
        end]]
    elseif carAudioType == CarAudioType.GuideSlowMotion then

        return "guide_slowmotion.wav"
    end

    return ""
end