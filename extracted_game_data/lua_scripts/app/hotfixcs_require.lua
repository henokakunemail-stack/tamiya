HotFixList={
    hotfix_test="hotfix_test"
}
function HotFixCsRequire()
    if GameProperties.IsHotFixEnable then
        for k, v in pairs(HotFixList) do
            require("hotfixcs/"..v)
        end
    end
end
HotFixCsRequire()

