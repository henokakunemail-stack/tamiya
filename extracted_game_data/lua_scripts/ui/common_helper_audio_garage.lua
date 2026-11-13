local _AudioGrooveIdTable={
    [0]="audio_ui_part_other.wav",
    [PartGrooveID.Chassis]="audio_ui_part_chassis.wav",
    [PartGrooveID.FTyre]="audio_ui_part_tyre.wav",
    [PartGrooveID.BTyre]="audio_ui_part_tyre.wav",
    [PartGrooveID.PulleyFrontCenter]="audio_ui_part_pulley.wav",
    [PartGrooveID.PulleyFrontButtom]="audio_ui_part_pulley.wav",
    [PartGrooveID.PulleyFrontMinus]="audio_ui_part_pulley.wav",
    [PartGrooveID.PulleyMiddleCenter]="audio_ui_part_pulley.wav",
    [PartGrooveID.PulleyMiddleButtom1]="audio_ui_part_pulley.wav",
    [PartGrooveID.PulleyMiddleMinus]="audio_ui_part_pulley.wav",
    [PartGrooveID.PulleyRearCenter]="audio_ui_part_pulley.wav",
    [PartGrooveID.PulleyRearButtom]="audio_ui_part_pulley.wav",
    [PartGrooveID.PulleyRearMinus]="audio_ui_part_pulley.wav",
}
local _AudioReformTable={
    [0]="audio_ui_reform_fail.wav",
    [1]="audio_ui_reform_1.wav",
    [2]="audio_ui_reform_2.wav",
    [3]="audio_ui_reform_3.wav",
}
local _CarBuilderFinish={
    [1]="audie_ui_car_finish.wav",
    [2]="audie_ui_car_finish2.wav",
}

---@param id PartGrooveID
function CommonHelper:PlaySfxByGrooveId(id)
    local audioName=_AudioGrooveIdTable[0]
    if _AudioGrooveIdTable[id] then
        audioName=_AudioGrooveIdTable[id]
    end
    CommonHelper:Audio_PlayLocalizeAudio(audioName, AudioType.SFX, false,1, 0)
end
---@param id PartGrooveID
function CommonHelper:PlaySfxByReform(id)
    local audioName=_AudioReformTable[id]
    CommonHelper:Audio_PlayLocalizeAudio(audioName, AudioType.SFX, false,1, 0)
end

---@param id PartGrooveID
function CommonHelper:PlayCarBuildFinishRandom()
    local audioName=_CarBuilderFinish[math.random(1,#_CarBuilderFinish)]
    CommonHelper:Audio_PlayLocalizeAudio(audioName, AudioType.SFX, false,1, 0)
end

