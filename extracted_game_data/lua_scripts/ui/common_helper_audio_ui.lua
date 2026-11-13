local  _audio_decompose="audio_ui_cost_currery.wav"
---@param id
function CommonHelper:PlaySfxByCostArticle(id)
    if id==CurrencyType.Diamond or id==CurrencyType.Gold then
        CommonHelper:Audio_PlayLocalizeAudio(_audio_decompose, AudioType.SFX, false,1, 0)
    end
end

local  _audio_get_reward="audio_ui_get_reward.wav"
local  _audio_decompose="audio_ui_decompose.wav"

function CommonHelper:PlaySfxByGetRewardType(type)
    if type==GetRewardType.Decompose then
        CommonHelper:Audio_PlayLocalizeAudio(_audio_decompose, AudioType.SFX, false,1, 0)
    else
        CommonHelper:Audio_PlayLocalizeAudio(_audio_get_reward, AudioType.SFX, false,1, 0)
    end
end
