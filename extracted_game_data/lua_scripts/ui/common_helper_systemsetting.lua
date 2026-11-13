-----初始化一项设置
--function CommonHelper:InitOneSetting(playerPrefsKey, IntKeyValue, FloatKeyValue, StringKeyValue, hasFunc, notHasFunc)
--    if PlayerPrefs.HasKey(playerPrefsKey) then
--        local value
--        if IntKeyValue then
--            value = PlayerPrefs.GetInt(playerPrefsKey)
--            print("当前的声音值是value")
--        elseif FloatKeyValue then
--            value = PlayerPrefs.GetFloat(playerPrefsKey)
--        elseif StringKeyValue then
--            value = PlayerPrefs.GetString(playerPrefsKey)
--        end
--        if hasFunc~=nil then
--            hasFunc(value)
--        end
--        return value
--    else
--        if notHasFunc ~= nil then
--            notHasFunc()
--        end
--        return nil
--    end
--end
--
--function CommonHelper:InitOneToggleSetting(playerPrefsKey,onFunc,offFunc)
--    local isScreenEffectToggleOn = self:InitOneSetting(playerPrefsKey, true, false, false)
--    if isScreenEffectToggleOn~=nil then
--        if isScreenEffectToggleOn==1 then
--            if onFunc~=nil then
--                onFunc()
--            end
--        else
--            if offFunc~=nil then
--                offFunc()
--            end
--
--        end
--    end
--end
-----初始化所有设置
--function CommonHelper:InitAllSetting()
--    self:InitOneToggleSetting("BackgroundMusicToggle",function()
--        self:InitOneSetting("BackgroundMusicSlider", false, true, false, function(value)
--            CSLuaHelper.SetAudioVolumeByAudioType(AudioType.BGM, value)
--        end)
--    end,function()
--        CSLuaHelper.SetAudioVolumeByAudioType(AudioType.BGM, 0)
--    end)
--
--    self:InitOneToggleSetting("SoundEffectToggle",function()
--        self:InitOneSetting("SoundEffectSlider", false, true, false, function(value)
--            CSLuaHelper.SetAudioVolumeByAudioType(AudioType.SFX, value)
--            CSLuaHelper.SetAudioVolumeByAudioType(AudioType.UI, value)
--        end)
--    end,function()
--        CSLuaHelper.SetAudioVolumeByAudioType(AudioType.SFX, 0)
--        CSLuaHelper.SetAudioVolumeByAudioType(AudioType.UI, 0)
--    end)
--
--    self:InitOneToggleSetting("ScreenEffectToggle", function() end,function() end)
--end
function CommonHelper:InitSound()

    local  _BgmOffOrOn= PlayerPrefsHelper:GetValue_BgmOffOrOn()
    local  _SoundEffectOffOrOn=PlayerPrefsHelper:GetValue_SoundEffectOffOrOn()
    if _BgmOffOrOn ==0 then
        CSLuaHelper.SetAudioVolumeByAudioType(AudioType.BGM, 0)
    else
        local value=PlayerPrefsHelper:GetValue_BgmValue()
        CSLuaHelper.SetAudioVolumeByAudioType(AudioType.BGM, value)
    end
    if _SoundEffectOffOrOn==0 then
        CSLuaHelper.SetAudioVolumeByAudioType(AudioType.SFX, 0)
        CSLuaHelper.SetAudioVolumeByAudioType(AudioType.UI, 0)
    else
        local value=PlayerPrefsHelper:GetValue_SoundEffectValue()
        CSLuaHelper.SetAudioVolumeByAudioType(AudioType.SFX, value)
        CSLuaHelper.SetAudioVolumeByAudioType(AudioType.UI, value)
    end

end
