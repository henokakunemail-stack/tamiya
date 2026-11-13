

--更换ui色系

function CommonHelper:SetColorSystem_Btn(obj, type) -- 通用按钮
    if obj == nil then return end

    local hover = UIUtil.GetTypeChildWightByParent("hover", obj, typeof(Image))
    local hoverpoint = UIUtil.GetTypeChildWightByParent("hoverpoint", obj, typeof(Image))
    local hoverbian = UIUtil.GetTypeChildWightByParent("hoverbian", obj, typeof(Image))
    if type == UIColor.Pink then
        CommonHelper:SetImageColorRGBA(hover,"f88dc100")
        CommonHelper:SetImageColorRGBA(hoverpoint,"ffabd100")
        CommonHelper:SetImageColorRGBA(hoverbian,"ffabd100")
    end
    if type == UIColor.Blue then
        CommonHelper:SetImageColorRGBA(hover,"78c5f400")
        CommonHelper:SetImageColorRGBA(hoverpoint,"91ddff00")
        CommonHelper:SetImageColorRGBA(hoverbian,"91ddff00")
    end
    if type == UIColor.Green then
        CommonHelper:SetImageColorRGBA(hover,"55d8d800")
        CommonHelper:SetImageColorRGBA(hoverpoint,"77f3f300")
        CommonHelper:SetImageColorRGBA(hoverbian,"77f3f300")
    end
    if type == UIColor.Yellow then
        CommonHelper:SetImageColorRGBA(hover,"f3e15700")
        CommonHelper:SetImageColorRGBA(hoverpoint,"fffebd00")
        CommonHelper:SetImageColorRGBA(hoverbian,"fffebd00")
    end
    if type == UIColor.Orange then
        CommonHelper:SetImageColorRGBA(hover,"fdab5c00")
        CommonHelper:SetImageColorRGBA(hoverpoint,"ffc36500")
        CommonHelper:SetImageColorRGBA(hoverbian,"ffc36500")
    end
    if type == UIColor.Red then
        CommonHelper:SetImageColorRGBA(hover,"ff4f4f00")
        CommonHelper:SetImageColorRGBA(hoverpoint,"ff747400")
        CommonHelper:SetImageColorRGBA(hoverbian,"ff747400")
    end
    if type == UIColor.Prasinous then
        CommonHelper:SetImageColorRGBA(hover,"84e85200")
        CommonHelper:SetImageColorRGBA(hoverpoint,"c0f68600")
        CommonHelper:SetImageColorRGBA(hoverbian,"c0f68600")
    end
end

function CommonHelper:SetColorSystem_Title1(obj, type) -- 一级标题，最大标题

end

function CommonHelper:SetColorSystem_Title2(obj, type) -- 二级标题，弹出框类型的标题
    if obj == nil then return end

    local bgleft = UIUtil.GetTypeChildWightByParent("bgleft", obj, typeof(Image))
    local bgpoint = UIUtil.GetTypeChildWightByParent("bgpoint", obj, typeof(Image))
    local bgright = UIUtil.GetTypeChildWightByParent("bgright", obj, typeof(Image))
    local bgbuttom = UIUtil.GetTypeChildWightByParent("bgbuttom", obj, typeof(Image))
    if type == UIColor.Pink then
        CommonHelper:SetImageColor(bgleft,"662335")
        CommonHelper:SetImageColor(bgpoint,"802B46")
        CommonHelper:SetImageColor(bgright,"802B46")
        CommonHelper:SetImageColor(bgbuttom,"FC9DC9")
    end
    if type == UIColor.Yellow then
        CommonHelper:SetImageColor(bgleft,"332200")
        CommonHelper:SetImageColor(bgpoint,"776511")
        CommonHelper:SetImageColor(bgright,"776511")
        CommonHelper:SetImageColor(bgbuttom,"EED964")
    end
    if type == UIColor.Orange then
        CommonHelper:SetImageColor(bgleft,"1F0900")
        CommonHelper:SetImageColor(bgpoint,"3E1F0D")
        CommonHelper:SetImageColor(bgright,"3E1F0D")
        CommonHelper:SetImageColor(bgbuttom,"FDA55B")
    end
    if type == UIColor.Green then
        CommonHelper:SetImageColor(bgleft,"123230")
        CommonHelper:SetImageColor(bgpoint,"224C4E")
        CommonHelper:SetImageColor(bgright,"224C4E")
        CommonHelper:SetImageColor(bgbuttom,"A9EDE2")
    end
    if type == UIColor.Blue then
        CommonHelper:SetImageColor(bgleft,"002032")
        CommonHelper:SetImageColor(bgpoint,"0A3C6A")
        CommonHelper:SetImageColor(bgright,"0A3C6A")
        CommonHelper:SetImageColor(bgbuttom,"5CCEF1")
    end
    if type == UIColor.Red then
        CommonHelper:SetImageColor(bgleft,"540C0D")
        CommonHelper:SetImageColor(bgpoint,"781011")
        CommonHelper:SetImageColor(bgright,"781011")
        CommonHelper:SetImageColor(bgbuttom,"FF5353")
    end
    if type == UIColor.Prasinous then
        CommonHelper:SetImageColor(bgleft,"103300")
        CommonHelper:SetImageColor(bgpoint,"1E4E0D")
        CommonHelper:SetImageColor(bgright,"1E4E0D")
        CommonHelper:SetImageColor(bgbuttom,"5ADB39")
    end
end

function CommonHelper:SetColorSystem_Title3(obj, type) -- 三级标题，提示框类型的标题

end

function CommonHelper:SetColorSystem_WindowBg1(obj, type) -- 通用提示背景框，色边加纯色底板加大底纹的那种
    if obj == nil then return end

    local bg1 = UIUtil.GetTypeChildWightByParent("bg1", obj, typeof(Image))
    local bg2 = UIUtil.GetTypeChildWightByParent("bg2", obj, typeof(Image))
    local bgpoint = UIUtil.GetTypeChildWightByParent("bgpoint", obj, typeof(RawImage))
    if type == UIColor.Pink then
        CommonHelper:SetImageColor(bg1,"52111B")
        CommonHelper:SetImageColor(bg2,"FACDDA")
        CommonHelper:SetImageColor(bgpoint,"E9AABB")
    end
    if type == UIColor.Yellow then
        CommonHelper:SetImageColor(bg1,"332200")
        CommonHelper:SetImageColor(bg2,"F4DB89")
        CommonHelper:SetImageColor(bgpoint,"EFC744")
    end
    if type == UIColor.Orange then
        CommonHelper:SetImageColor(bg1,"2A1100")
        CommonHelper:SetImageColor(bg2,"FEAA88")
        CommonHelper:SetImageColor(bgpoint,"FAC8B4")
    end
    if type == UIColor.Green then
        CommonHelper:SetImageColor(bg1,"123230")
        CommonHelper:SetImageColor(bg2,"ffffff")
        CommonHelper:SetImageColor(bgpoint,"a8ece1")
    end
    if type == UIColor.Blue then
        CommonHelper:SetImageColor(bg1,"002032")
        CommonHelper:SetImageColor(bg2,"ffffff")
        CommonHelper:SetImageColor(bgpoint,"ddeeff")
    end
    if type == UIColor.Red then
        CommonHelper:SetImageColor(bg1,"540C0D")
        CommonHelper:SetImageColor(bg2,"ffffff")
        CommonHelper:SetImageColor(bgpoint,"ff7474")
    end
    if type == UIColor.Prasinous then
        CommonHelper:SetImageColor(bg1,"103300")
        CommonHelper:SetImageColor(bg2,"ffffff")
        CommonHelper:SetImageColor(bgpoint,"c0f686")
    end
end