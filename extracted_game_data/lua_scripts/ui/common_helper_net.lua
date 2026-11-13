---@param data table<number,string>
function CommonHelper:GetNetSendData(data, tableData)
    local tab = {}

    if tableData ~= nil then
        tab.p10 = tableData
    end
    if #data == 1 then
        tab.p1 = tostring(data[1])
    elseif #data == 2 then
        tab.p1 = tostring(data[1])
        tab.p2 = tostring(data[2])
    elseif #data == 3 then
        tab.p1 = tostring(data[1])
        tab.p2 =tostring( data[2])
        tab.p3 = tostring(data[3])
    elseif #data == 4 then
        tab.p1 = tostring(data[1])
        tab.p2 = tostring(data[2])
        tab.p3 = tostring(data[3])
        tab.p4 = tostring(data[4])
    elseif #data == 5 then
        tab.p1 = tostring(data[1])
        tab.p2 = tostring(data[2])
        tab.p3 = tostring(data[3])
        tab.p4 = tostring(data[4])
        tab.p5 = tostring(data[5])
    elseif #data == 6 then
        tab.p1 = tostring(data[1])
        tab.p2 = tostring(data[2])
        tab.p3 = tostring(data[3])
        tab.p4 = tostring(data[4])
        tab.p5 = tostring(data[5])
        tab.p6 = tostring(data[6])
    elseif #data == 7 then
        tab.p1 = tostring(data[1])
        tab.p2 = tostring(data[2])
        tab.p3 = tostring(data[3])
        tab.p4 = tostring(data[4])
        tab.p5 = tostring(data[5])
        tab.p6 = tostring(data[6])
        tab.p7 = tostring(data[7])
    elseif #data == 8 then
        tab.p1 = tostring(data[1])
        tab.p2 = tostring(data[2])
        tab.p3 = tostring(data[3])
        tab.p4 = tostring(data[4])
        tab.p5 = tostring(data[5])
        tab.p6 = tostring(data[6])
        tab.p7 = tostring(data[7])
        tab.p8 = tostring(data[8])
    elseif #data == 9 then
        tab.p1 = tostring(data[1])
        tab.p2 = tostring(data[2])
        tab.p3 = tostring(data[3])
        tab.p4 = tostring(data[4])
        tab.p5 = tostring(data[5])
        tab.p6 = tostring(data[6])
        tab.p7 = tostring(data[7])
        tab.p8 = tostring(data[8])
        tab.p9 = tostring(data[9])
   elseif #data == 10 then
        tab.p1 = tostring(data[1])
        tab.p2 = tostring(data[2])
        tab.p3 = tostring(data[3])
        tab.p4 = tostring(data[4])
        tab.p5 = tostring(data[5])
        tab.p6 = tostring(data[6])
        tab.p7 = tostring(data[7])
        tab.p8 = tostring(data[8])
        tab.p9 = tostring(data[9])
        tab.p11 = tostring(data[10])
    end
    ---@type SC_BaseC2S
    local msg = assert(Dll_PB.encode("BaseC2S", tab))
    --local msg = assert(Dll_PB.encode("Base", {num=1}))
    return msg
end