


---@class RaceAudioSequence:
RaceAudioSequence= class("RaceAudioSequence")

local isPlaying
local assetCache
function RaceAudioSequence.PlaySequence(audioNames)
    local length = 0.5
    if isPlaying then
        print("ERROR :the audio sequence is playing" )
        return length
    end

    --print("print audio name0 ".. tostring(#audioNames) )
    assetCache = {}
    isPlaying = false
    if audioNames ~= nil then
        for i = 1, #audioNames do
            local audioName = audioNames[i]

            local asset = AssetsManager.Load(audioName, typeof(AudioClip))
            if asset ~= nil and asset.asset~= nil then
                length = length + asset.asset.length
            end
            --print("print audio name ".. audioName )
            table.insert(  assetCache, asset)
        end

        RaceAudioSequence.WaitingPlaySequence(audioNames)
    end


    return length
end

function RaceAudioSequence.WaitingPlaySequence(audioNames)
    isPlaying = true
    cs_coroutine.start(function()
        for i = 1, #audioNames do
            --print("print audio name2 ".. audioNames[i] )
            audioResult = CommonHelper:Audio_PlayLocalizeAudio(audioNames[i], AudioType.VOICE, false, 1, 0)
            if audioResult ~= nil and audioResult.clip ~= nil then
                coroutine.yield(CS.UnityEngine.WaitForSecondsRealtime(audioResult.clip.length))
            end
        end

        for i = 1, #assetCache do
            AssetsManager.Unload(assetCache[i])
        end
        assetCache = nil
        coroutine.yield()
        isPlaying = false
    end
    )
end

