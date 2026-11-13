
AudioNameCN = {
    m_half_wav = "m_half_cn.mp3",
    f_half_wav = "f_half_cn.mp3",

    m_cheer1_wav = "m_cheer1_cn.mp3",
    m_cheer2_wav = "m_cheer2_cn.mp3",
    m_cheer3_wav = "m_cheer3_cn.mp3",
    f_cheer1_wav = "f_cheer1_cn.mp3",
    f_cheer2_wav = "f_cheer2_cn.mp3",
    f_cheer3_wav = "f_cheer3_cn.mp3",

    m_go1_wav = "m_go1_cn.mp3",
    m_go2_wav = "m_go2_cn.mp3",
    m_go3_wav = "m_go3_cn.mp3",
    m_go4_wav = "m_go4_cn.mp3",
    m_go5_wav = "m_go5_cn.mp3",
    f_go1_wav = "f_go1_cn.mp3",
    f_go2_wav = "f_go2_cn.mp3",
    f_go3_wav = "f_go3_cn.mp3",
    f_go4_wav = "f_go4_cn.mp3",
    f_go5_wav = "f_go5_cn.mp3",

    m_open1_1_wav = "m_open1_1_cn.mp3",
    m_open1_2_wav = "m_open1_2_cn.mp3",
    m_open2_1_wav = "m_open2_1_cn.mp3",
    m_open2_2_wav = "m_open2_2_cn.mp3",
    f_open1_1_wav = "f_open1_1_cn.mp3",
    f_open1_2_wav = "f_open1_2_cn.mp3",
    f_open2_1_wav = "f_open2_1_cn.mp3",
    f_open2_2_wav = "f_open2_2_cn.mp3",

    voice_1004_wav = "voice_1004_cn.mp3",
    voice_1013_wav = "voice_1013_cn.mp3",
    voice_1017_wav = "voice_1017_cn.mp3",

    m_final_wav = "m_final_cn.mp3",
    f_final_wav = "f_final_cn.mp3",

    m_fail1_wav = "m_fail1_cn.mp3",
    m_fail2_wav = "m_fail2_cn.mp3",
    m_fail3_wav = "m_fail3_cn.mp3",
    m_fail4_wav = "m_fail4_cn.mp3",
    m_fail5_wav = "m_fail5_cn.mp3",
    f_fail1_wav = "f_fail1_cn.mp3",
    f_fail2_wav = "f_fail2_cn.mp3",
    f_fail3_wav = "f_fail3_cn.mp3",
    f_fail4_wav = "f_fail4_cn.mp3",
    f_fail5_wav = "f_fail5_cn.mp3",

    m_win1_wav = "m_win1_cn.mp3",
    m_win2_wav = "m_win2_cn.mp3",
    m_win3_wav = "m_win3_cn.mp3",
    m_win4_wav = "m_win4_cn.mp3",
    m_win5_wav = "m_win5_cn.mp3",
    f_win1_wav = "f_win1_cn.mp3",
    f_win2_wav = "f_win2_cn.mp3",
    f_win3_wav = "f_win3_cn.mp3",
    f_win4_wav = "f_win4_cn.mp3",
    f_win5_wav = "f_win5_cn.mp3",


    m_first1_wav = "m_first1_cn.mp3",
    m_first2_wav = "m_first2_cn.mp3",
    m_first3_wav = "m_first3_cn.mp3",
    m_first4_wav = "m_first4_cn.mp3",
    m_first5_wav = "m_first5_cn.mp3",
    f_first1_wav = "f_first1_cn.mp3",
    f_first2_wav = "f_first2_cn.mp3",
    f_first3_wav = "f_first3_cn.mp3",
    f_first4_wav = "f_first4_cn.mp3",
    f_first5_wav = "f_first5_cn.mp3",
}

local overTackCount =0
function RaceHelper:PlayCNVoiceAudio(voiceType, trackNumber, isSelf, paramInt, floatParam)
    if PlayerPrefsHelper:GetValue_BattleBgmOffOrOn()==0 then
        return
    end

    local audioResult = nil
    log("voiceType0 = ", voiceType, tostring(trackNumber), paramInt)
    local value=PlayerPrefsHelper:GetValue_BattleBgmValue()
    CSLuaHelper.SetAudioVolumeByAudioType(AudioType.VOICE, value)
    --- 比赛已经进入后半段了！
    if voiceType == VoiceType.Length3_2 then
        logError("length32" .. tostring(paramInt))
        if paramInt == 32 then
            audioResult = CommonHelper:Audio_PlayAudioRandom({ AudioNameCN.m_half_wav, AudioNameCN.f_half_wav }, AudioType.VOICE, false, 1, 0)
        elseif paramInt == 21 then
            local num = math.random(4)
            if num == 1 then
                audioResult = CommonHelper:Audio_PlayAudioRandom({ AudioNameCN.m_cheer3_wav, AudioNameCN.f_cheer3_wav }, AudioType.VOICE, false, 1, 0)
            elseif num == 2 then
                audioResult =  CommonHelper:Audio_PlayAudioRandom({ AudioNameCN.m_cheer1_wav, AudioNameCN.f_cheer1_wav }, AudioType.VOICE, false, 1, 0)
            elseif num == 3 then
                audioResult =  CommonHelper:Audio_PlayAudioRandom({ AudioNameCN.m_cheer2_wav, AudioNameCN.f_cheer2_wav }, AudioType.VOICE, false, 1, 0)
            else
                audioResult = CommonHelper:Audio_PlayAudioRandom({ AudioNameCN.m_half_wav, AudioNameCN.f_half_wav }, AudioType.VOICE, false, 1, 0)
            end
        end
    elseif voiceType == VoiceType.ExitStartSlope then
        --- 一号车一马当先，率先出发！
        --CommonHelper:Audio_PlayAudio("voice_1002.mp3", AudioType.VOICE, false, 1, 0)
        if trackNumber == 1 then
            audioResult = CommonHelper:Audio_PlayAudioRandom({ AudioNameCN.m_go1_wav, AudioNameCN.f_go1_wav }, AudioType.VOICE, false, 1, 0)
        elseif trackNumber == 2 then
            audioResult = CommonHelper:Audio_PlayAudioRandom({ AudioNameCN.m_go2_wav, AudioNameCN.f_go2_wav }, AudioType.VOICE, false, 1, 0)
        elseif trackNumber == 3 then
            audioResult = CommonHelper:Audio_PlayAudioRandom({ AudioNameCN.m_go3_wav, AudioNameCN.f_go3_wav }, AudioType.VOICE, false, 1, 0)
        elseif trackNumber == 4 then
            audioResult = CommonHelper:Audio_PlayAudioRandom({ AudioNameCN.m_go4_wav, AudioNameCN.f_go4_wav }, AudioType.VOICE, false, 1, 0)
        elseif trackNumber == 5 then
            audioResult = CommonHelper:Audio_PlayAudioRandom({ AudioNameCN.m_go5_wav, AudioNameCN.f_go5_wav }, AudioType.VOICE, false, 1, 0)
        end
    elseif voiceType == VoiceType.StartCountDown then
        --- 大家各就各位！READY …… ！ GO！！！
        --CommonHelper:Audio_PlayAudio("voice_1003.mp3", AudioType.VOICE, false, 1, 0)
        -- CommonHelper:Audio_PlayAudio("m_ready.wav", AudioType.VOICE, false, 1, 0)
        local num = math.random(3)
        if num == 1 then
            audioResult = CommonHelper:Audio_PlayAudioRandom({ AudioNameCN.m_open1_1_wav, AudioNameCN.f_open1_1_wav }, AudioType.VOICE, false, 1, 0)
        elseif num == 2 then
            audioResult = CommonHelper:Audio_PlayAudioRandom({ AudioNameCN.m_open2_2_wav, AudioNameCN.f_open2_2_wav }, AudioType.VOICE, false, 1, 0)
        end
    elseif voiceType == VoiceType.CameraShowTime then
        audioResult = CommonHelper:Audio_PlayAudio("voice_1004.wav", AudioType.VOICE, false, 1, 0)
    elseif voiceType == VoiceType.EnterScene then
        local num = math.random(3)
        --if trackNumber == 3 then
        --    num = math.random(12)
        --end
        if num == 1 then
            audioResult = CommonHelper:Audio_PlayAudioRandom({ AudioNameCN.m_open1_1_wav, AudioNameCN.f_open1_1_wav }, AudioType.VOICE, false, 1, 0)
        elseif num == 2 then
            audioResult = CommonHelper:Audio_PlayAudioRandom({ AudioNameCN.m_open2_1_wav, AudioNameCN.f_open2_1_wav }, AudioType.VOICE, false, 1, 0)
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
                audioResult = CommonHelper:Audio_PlayAudioRandom({ AudioNameCN.m_final_wav, AudioNameCN.f_final_wav }, AudioType.VOICE, false, 1, 0)
            else
                audioResult = CommonHelper:Audio_PlayAudioRandom({ AudioNameCN.m_final_wav, AudioNameCN.f_final_wav }, AudioType.VOICE, false, 1, 0)
            end
        end
        if paramInt == 55 then
            BattleDataManager:Get():OnFirstPlayDone()
            if num > 5 then
                audioResult = CommonHelper:Audio_PlayAudioRandom({ AudioNameCN.m_final_wav, AudioNameCN.f_final_wav }, AudioType.VOICE, false, 1, 0)
            else
                audioResult = CommonHelper:Audio_PlayAudioRandom({ AudioNameCN.m_final_wav, AudioNameCN.f_final_wav }, AudioType.VOICE, false, 1, 0)
            end
        end
    elseif voiceType == VoiceType.OutOfTrack then
        if trackNumber == 1 then
            audioResult = CommonHelper:Audio_PlayAudioRandom({ AudioNameCN.m_fail1_wav, AudioNameCN.f_fail1_wav }, AudioType.VOICE, false, 1, 0)
        elseif trackNumber == 2 then
            audioResult = CommonHelper:Audio_PlayAudioRandom({ AudioNameCN.m_fail2_wav, AudioNameCN.f_fail2_wav }, AudioType.VOICE, false, 1, 0)
        elseif trackNumber == 3 then
            audioResult = CommonHelper:Audio_PlayAudioRandom({ AudioNameCN.m_fail3_wav, AudioNameCN.f_fail3_wav }, AudioType.VOICE, false, 1, 0)
        elseif trackNumber == 4 then
            audioResult = CommonHelper:Audio_PlayAudioRandom({ AudioNameCN.m_fail4_wav, AudioNameCN.f_fail4_wav }, AudioType.VOICE, false, 1, 0)
        elseif trackNumber == 5 then
            audioResult = CommonHelper:Audio_PlayAudioRandom({ AudioNameCN.m_fail5_wav, AudioNameCN.f_fail5_wav }, AudioType.VOICE, false, 1, 0)
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
            audioResult = CommonHelper:Audio_PlayAudioRandom({ AudioNameCN.m_first1_wav, AudioNameCN.f_first1_wav }, AudioType.VOICE, false, 1, 0)
        elseif trackNumber == 2 then
            audioResult = CommonHelper:Audio_PlayAudioRandom({ AudioNameCN.m_first2_wav, AudioNameCN.f_first2_wav }, AudioType.VOICE, false, 1, 0)
        elseif trackNumber == 3 then
            audioResult = CommonHelper:Audio_PlayAudioRandom({ AudioNameCN.m_first3_wav, AudioNameCN.f_first3_wav }, AudioType.VOICE, false, 1, 0)
        elseif trackNumber == 4 then
            audioResult = CommonHelper:Audio_PlayAudioRandom({ AudioNameCN.m_first4_wav, AudioNameCN.f_first4_wav }, AudioType.VOICE, false, 1, 0)
        elseif trackNumber == 5 then
            audioResult = CommonHelper:Audio_PlayAudioRandom({ AudioNameCN.m_first5_wav, AudioNameCN.f_first5_wav }, AudioType.VOICE, false, 1, 0)
        end
    elseif voiceType == VoiceType.Overtake then
        --CommonHelper:Audio_PlayAudio("voice_1020.mp3", AudioType.VOICE, false, 1, 0)
    elseif voiceType == VoiceType.FirstWin then
        if trackNumber == 1 then
            audioResult = CommonHelper:Audio_PlayAudioRandom({ AudioNameCN.m_win1_wav, AudioNameCN.f_win1_wav }, AudioType.VOICE, false, 1, 0)
        elseif trackNumber == 2 then
            audioResult = CommonHelper:Audio_PlayAudioRandom({ AudioNameCN.m_win2_wav, AudioNameCN.f_win2_wav }, AudioType.VOICE, false, 1, 0)
        elseif trackNumber == 3 then
            audioResult = CommonHelper:Audio_PlayAudioRandom({ AudioNameCN.m_win3_wav, AudioNameCN.f_win3_wav }, AudioType.VOICE, false, 1, 0)
        elseif trackNumber == 4 then
            audioResult = CommonHelper:Audio_PlayAudioRandom({ AudioNameCN.m_win4_wav, AudioNameCN.f_win4_wav }, AudioType.VOICE, false, 1, 0)
        elseif trackNumber == 5 then
            audioResult = CommonHelper:Audio_PlayAudioRandom({ AudioNameCN.m_win5_wav, AudioNameCN.f_win5_wav }, AudioType.VOICE, false, 1, 0)
        end
    elseif voiceType == VoiceType.PlaySkillVoice then
        audioResult = CommonHelper:Audio_PlayAudioRandom({ "audio_crash_chong1.mp3", "audio_crash_chong2.mp3" }, AudioType.VOICE, false, 1, 0)
    elseif voiceType == VoiceType.PreCrashVoice then
        audioResult = CommonHelper:Audio_PlayAudioRandom({ "audio_crash_gennipinle.mp3", "audio_crash_jiayou.mp3", "audio_crash_zenmele.mp3" }, AudioType.VOICE, false, 1, 0)
    elseif voiceType == VoiceType.Common then

        if paramInt ==VoiceSubType.CommonProtectCrashZoomIn then
            audioResult = CommonHelper:Audio_PlayAudio("protect_slowmotion.wav", AudioType.VOICE, false, 1, 0)
        end
    end

    return audioResult
end
