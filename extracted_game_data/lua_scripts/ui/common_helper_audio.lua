---0 表示男解说 1表示女解说
local audio_sex = 0
---@param audioNames table<number,string>
function CommonHelper:Audio_PlayAudioRandom(audioNames, type, loop, volumn, fromtime)
    local result = nil
    if audio_sex == 0 then
        result = CommonHelper:Audio_PlayLocalizeAudio(audioNames[1], type, loop, volumn, fromtime)
    else
        result = CommonHelper:Audio_PlayLocalizeAudio(audioNames[2], type, loop, volumn, fromtime)
    end
    audio_sex = audio_sex == 0 and 1 or 0

    return result
end

---@param AudioType AudioType
function CommonHelper:Audio_PlayAudio(audioName, type, loop, volumn, fromtime)
    if loop == nil then
        loop = false
    end
    if volumn == nil then
        volumn = 1
    end
    if fromtime == nil then
        fromtime = 0
    end

    local audiotype = monoHAudioType.VOICE
    if type == AudioType.VOICE then
        audiotype = monoHAudioType.VOICE
    end
    if type == AudioType.SFX then
        audiotype = monoHAudioType.SFX
    end
    if type == AudioType.BGM then
        audiotype = monoHAudioType.BGM
    end
    if type == AudioType.UI then
        audiotype = monoHAudioType.UI
    end
    --print("---------   ",audioName, audiotype, loop, volumn, fromtime)
    return AudioManager:PlayAudio(audioName, audiotype, loop, volumn, fromtime)
end


---@param AudioType AudioType
function CommonHelper:Audio_PlayLocalizeAudio(audioName, type, loop, volumn, fromtime)
    if loop == nil then
        loop = false
    end
    if volumn == nil then
        volumn = 1
    end
    if fromtime == nil then
        fromtime = 0
    end

    local audiotype = monoHAudioType.VOICE
    if type == AudioType.VOICE then
        audiotype = monoHAudioType.VOICE
    end
    if type == AudioType.SFX then
        audiotype = monoHAudioType.SFX
    end
    if type == AudioType.BGM then
        audiotype = monoHAudioType.BGM
    end
    if type == AudioType.UI then
        audiotype = monoHAudioType.UI
    end
    if tostring(audioName)=="0"  then
        return
    end
    print("---------   ",audioName, audiotype, loop, volumn, fromtime)
    return AudioManager:PlayAudio(audioName, audiotype, loop, volumn, fromtime)
end

function CommonHelper:IsRaceType_Time()
    local raceType = BattleDataManager:Get():GetRaceStyleTypeType()
    return raceType == RaceStyleType.Limit
end

function CommonHelper:IsRaceType_Relay()
    local raceType = BattleDataManager:Get():GetRaceStyleTypeType()
    return raceType == RaceStyleType.Relay
end

function CommonHelper:IsRaceType_Normal()
    local raceType = BattleDataManager:Get():GetRaceStyleTypeType()
    return raceType == RaceStyleType.Normal
end


function CommonHelper:Audio_PlayLocalizeAudioByConfig(soundEffectConfig, type, loop, volumn, fromtime, carShellId,trackNumber, forcePlay)
    if soundEffectConfig == nil then
        return 0.5
    end

    forcePlay = forcePlay or false

    if CommonHelper:IsRaceType_Time() or CommonHelper:IsRaceType_Relay() then
        if not forcePlay then
            return 0.5
        end
    end

    local soundName = soundEffectConfig.name
    local mixType = soundEffectConfig.mixtype
    if GameProperties.AreaType == AreaType.AreaTypeKR then
        soundName = soundEffectConfig.name_kr
        mixType = VoiceMixType.None
    end

    --soundEffectConfig.mixtype = VoiceMixType.TrackColorPrefix
    --soundEffectConfig.mixtype = VoiceMixType.TrackNumber
    if mixType == VoiceMixType.None then
        local audioSource = CommonHelper:Audio_PlayLocalizeAudio(soundName, type, loop, volumn, fromtime)
        if audioSource ~= nil and audioSource.clip ~= nil then

            --print("PlayJpVoiceAudio2_2 ", audioSource.clip.length,  audioSource.clip.name)
            return audioSource.clip.length
        end
    elseif mixType == VoiceMixType.TrackNumber then
        --local audioSequenceNames = {}
        --table.insert(audioSequenceNames, soundEffectConfig.name)
        --table.insert(audioSequenceNames, CommonHelper:GetPrefixRaceAudioName(soundEffectConfig.mixtype, trackNumber))
        --return RaceAudioSequence.PlaySequence(audioSequenceNames)
    elseif mixType == VoiceMixType.TrackColorPrefix then
        local audioSequenceNames = {}
        local trackNumberName = CommonHelper:GetPrefixRaceAudioName2(soundEffectConfig.mixtype, trackNumber)
        --print("音频播放 : ",trackNumber,trackNumberName, soundEffectConfig.name, debug.traceback())
        if trackNumberName ~= nil and trackNumberName ~= "" then
            table.insert(audioSequenceNames, trackNumberName)
            table.insert(audioSequenceNames, soundName)
        else
            audioSequenceNames = nil
        end

        return RaceAudioSequence.PlaySequence(audioSequenceNames)
    elseif mixType == VoiceMixType.TrackColorBack then
        local audioSequenceNames = {}

        local trackNumberName = CommonHelper:GetPrefixRaceAudioName2(soundEffectConfig.mixtype, trackNumber)

        if trackNumberName ~= nil and trackNumberName ~= "" then
            table.insert(audioSequenceNames, soundName)
            table.insert(audioSequenceNames, trackNumberName)
        else
            audioSequenceNames = nil
        end

        return RaceAudioSequence.PlaySequence(audioSequenceNames)
    elseif mixType == VoiceMixType.HeroNameBack then
        local audioSequenceNames = {}
        table.insert(audioSequenceNames, soundName)
        local heroName = CommonHelper:GetPrefixRaceAudioName(soundEffectConfig.mixtype,carShellId)
        if heroName ~= nil and heroName ~= "" then
            table.insert(audioSequenceNames,heroName)
        else
            audioSequenceNames = nil
        end

        return RaceAudioSequence.PlaySequence(audioSequenceNames)
    elseif mixType == VoiceMixType.HeroNamePrefix then
        local audioSequenceNames = {}
        local heroName = CommonHelper:GetPrefixRaceAudioName(soundEffectConfig.mixtype,carShellId)
        if heroName ~= nil and heroName ~= "" then
            table.insert(audioSequenceNames,heroName)
            table.insert(audioSequenceNames, soundName)
        else
            audioSequenceNames = nil
        end

        return RaceAudioSequence.PlaySequence(audioSequenceNames)
    end

    return 0.5
end

function CommonHelper:GetPrefixRaceAudioName(mixtype, param)
    if mixtype == VoiceMixType.TrackNumber then
        return ""
    elseif mixtype == VoiceMixType.TrackColor then
        return ""
    elseif mixtype == VoiceMixType.HeroNameBack then
        local shellId = param
        local shellTable = ClientDataManager:Get():GetDataTable(ConfigNames.dictpartcell_config)
        local shellConfig = shellTable.GetById(shellId)

        if shellConfig ~= nil then
            local soundId =shellConfig.cellcv
            if soundId == 0 then
                return ""
            end
            local table = ClientDataManager:Get():GetDataTable(ConfigNames.soundeffect_config)
            local sound = table.GetById(soundId)
            if sound == nil then
                return ""
            end
            return sound.name
        end
    end

    return ""
end


function CommonHelper:GetPrefixRaceAudioName2(mixtype, trackNumber)
    if mixtype == VoiceMixType.TrackNumber then
        return ""
    elseif mixtype == VoiceMixType.TrackColorPrefix or mixtype == VoiceMixType.TrackColorBack then

        local dictConfig = ClientDataManager:Get():GetDataTable(ConfigNames.dictcalc_config)
        local config = nil

        local dictId = 0
        if trackNumber > 5000 then
            if trackNumber == 5001 then
                dictId =175
            elseif trackNumber == 5002 then
                dictId =176
            elseif trackNumber == 5003 then
                dictId =177
            elseif trackNumber == 5004 then
                dictId =178
            elseif trackNumber == 5005 then
                dictId =179
            end
        else
            if trackNumber == 3001 then
                dictId = 172
            elseif trackNumber == 3002 then
                dictId = 173
            elseif trackNumber == 3003 then
                dictId = 174
            end
        end

        if dictId ~= 0 then
            local shellConfig = dictConfig.GetById(dictId)
            local audioId = tonumber( shellConfig.varval)
            local table = ClientDataManager:Get():GetDataTable(ConfigNames.soundeffect_config)
            local sound = table.GetById(audioId)

            print("音频播放2 : ",trackNumber,dictId, sound ~= nil, audioId)
            if sound ~= nil then
                return sound.name
            end
        end

        if config == nil then
            return ""
        end

        return ""
    elseif mixtype == VoiceMixType.HeroNameBack then

    end

    return ""
end


function CommonHelper:Audio_StopAudio(audioSource)
    if audioSource then
        AudioManager:StopAudio(audioSource)
    end
end
function CommonHelper:Audio_StopAudioByName(audioName)
    if audioName then
        AudioManager:StopOnlyAudioByName(audioName)
    end
end

function CommonHelper:Audio_PauseBGM()
    AudioManager:PauseBGM()
end

function CommonHelper:Audio_PlayerOnShotById(id)
    --local sound=CommonHelper:GetTableDataByID(,id)
    -- AudioManager:PlayOneShot(sound)
end





