
AudioNameJp = {
    m_half_wav = "m_half.wav",

    m_cheer1_wav = "jp_m_cheer%d.wav",

    m_go1_wav = "jp_m_go1.wav",
    m_go2_wav = "jp_m_go2.wav",
    m_go3_wav = "jp_m_go3.wav",
    m_go4_wav = "jp_m_go4.wav",
    m_go5_wav = "jp_m_cheer8.wav",

    m_open1_1_wav = "jp_m_open%d.wav",
    m_final_wav = "jp_m_last%d.wav",

    m_fail1_wav = "jp_m_fail%d.wav",

    m_win1_wav = "jp_m_win%d.wav",

    m_overtake_wav = "jp_m_special%d"
}

local overTackCount =0
function RaceHelper:PlayJpVoiceAudio(voiceType, trackNumber, isSelf, paramInt)
    local audioResult = nil
    if PlayerPrefsHelper:GetValue_BattleBgmOffOrOn()==0 then
        return 0.5
    end

    log("voiceType0 = ", voiceType, tostring(trackNumber), paramInt)
    local value=PlayerPrefsHelper:GetValue_BattleBgmValue()
    CSLuaHelper.SetAudioVolumeByAudioType(AudioType.VOICE, value)
    --- 比赛已经进入后半段了！
    if voiceType == VoiceType.Length3_2 then
        logError("length32" .. tostring(paramInt))
        if paramInt == 32 then
            --CommonHelper:Audio_PlayAudioRandom({ AudioNameJp.m_half_wav, AudioNameJp.m_half_wav }, AudioType.VOICE, false, 1, 0)
        elseif paramInt == 21 then
            local num = math.random(15)
            local formatName = string.format(AudioNameJp.m_cheer1_wav, num)
            audioResult = CommonHelper:Audio_PlayLocalizeAudio(formatName, AudioType.VOICE, false, 1, 0)

        end
    elseif voiceType == VoiceType.ExitStartSlope then
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
    elseif voiceType == VoiceType.StartCountDown then
        --- 大家各就各位！READY …… ！ GO！！！
        --CommonHelper:Audio_PlayAudio("voice_1003.mp3", AudioType.VOICE, false, 1, 0)
        -- CommonHelper:Audio_PlayAudio("m_ready.wav", AudioType.VOICE, false, 1, 0)
        local num = math.random(3)
        local formatName = string.format(AudioNameJp.m_open1_1_wav, num)
        audioResult = CommonHelper:Audio_PlayLocalizeAudio(formatName, AudioType.VOICE, false, 1, 0)

    elseif voiceType == VoiceType.CameraShowTime then
        audioResult = CommonHelper:Audio_PlayAudio("voice_1004.wav", AudioType.VOICE, false, 1, 0)
    elseif voiceType == VoiceType.EnterScene then
        local num = math.random(3)
        --if trackNumber == 3 then
        --    num = math.random(12)
        --end
        local num = math.random(4,5)
        local formatName = string.format(AudioNameJp.m_open1_1_wav, num)
        audioResult = CommonHelper:Audio_PlayLocalizeAudio(formatName, AudioType.VOICE, false, 1, 0)
    elseif voiceType == VoiceType.LapChange then
        --if paramInt == 2 then
        --    CommonHelper:Audio_PlayAudio("voice_1007.mp3", AudioType.VOICE, false, 1, 0)
        --elseif paramInt == 3 then
        --    CommonHelper:Audio_PlayAudio("voice_1008.mp3", AudioType.VOICE, false, 1, 0)
        --elseif paramInt == 4 then
        --    CommonHelper:Audio_PlayAudio("voice_1009.mp3", AudioType.VOICE, false, 1, 0)
        --
        --end

        local num = math.random(3)
        local formatName = string.format(AudioNameJp.m_final_wav, num)
        if paramInt == 33 then
            BattleDataManager:Get():OnFirstPlayDone()
            audioResult = CommonHelper:Audio_PlayLocalizeAudio(formatName, AudioType.VOICE, false, 1, 0)
        end
        if paramInt == 55 then
            BattleDataManager:Get():OnFirstPlayDone()
            audioResult = CommonHelper:Audio_PlayLocalizeAudio(formatName, AudioType.VOICE, false, 1, 0)
        end
    elseif voiceType == VoiceType.OutOfTrack then
        local num = math.random(3,4)
        local formatName = string.format(AudioNameJp.m_fail1_wav, num)
        audioResult = CommonHelper:Audio_PlayLocalizeAudio(formatName, AudioType.VOICE, false, 1, 0)

        --- 太可惜了！一号车飞出了赛道！
        --if isSelf then
        --    CommonHelper:Audio_PlayAudio("voice_1017.mp3", AudioType.VOICE, false, 1, 0)
        --else
        --    CommonHelper:Audio_PlayAudio("voice_1013.mp3", AudioType.VOICE, false, 1, 0)
    elseif voiceType == VoiceType.CurveTurnOver or voiceType == VoiceType.BattleFail then
        local num = math.random(3)
        local formatName = string.format(AudioNameJp.m_fail1_wav, num)
        audioResult = CommonHelper:Audio_PlayLocalizeAudio(formatName, AudioType.VOICE, false, 1, 0)
    elseif voiceType == VoiceType.BattleFail then

        if isSelf then

        end

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

        overTackCount = overTackCount +1

        local result = overTackCount % 5
        if result == 0 then
            local num = math.random(3)
            local formatName = string.format(AudioNameJp.m_overtake_wav, num)
            audioResult = CommonHelper:Audio_PlayLocalizeAudio(formatName, AudioType.VOICE, false, 1, 0)
        end

        --CommonHelper:Audio_PlayAudio("voice_1020.mp3", AudioType.VOICE, false, 1, 0)
    elseif voiceType == VoiceType.FirstWin then
        --log("voiceType0 =1111111 ", voiceType, tostring(trackNumber), paramInt)
        --if paramInt ~= 0 then
            local num = math.random(5)
            local formatName = string.format(AudioNameJp.m_win1_wav, num)


            audioResult = CommonHelper:Audio_PlayLocalizeAudio(formatName, AudioType.VOICE, false, 1, 0)
        --end
    elseif voiceType == VoiceType.PlaySkillVoice then
        audioResult = CommonHelper:Audio_PlayAudioRandom({ "audio_crash_chong1.mp3", "audio_crash_chong2.mp3" }, AudioType.VOICE, false, 1, 0)
    elseif voiceType == VoiceType.PreCrashVoice then
        audioResult = CommonHelper:Audio_PlayAudioRandom({ "audio_crash_gennipinle.mp3", "audio_crash_jiayou.mp3", "audio_crash_zenmele.mp3" }, AudioType.VOICE, false, 1, 0)
    elseif voiceType == VoiceType.Common then

        if paramInt ==VoiceSubType.CommonProtectCrashZoomIn then
            audioResult = CommonHelper:Audio_PlayAudio("protect_slowmotion.wav", AudioType.VOICE, false, 1, 0)
        end
    elseif voiceType == VoiceType.SegmentType then
        logError("VoiceType.SegmentType", paramInt)
    end

    if audioResult ~= nil then
        if audioResult.clip ~= nil then
            return audioResult.clip.length + 0.5
        end
    end
    return 0.5
end
