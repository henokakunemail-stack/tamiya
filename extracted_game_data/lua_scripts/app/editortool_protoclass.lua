

local typemap = {}
typemap["int32"] = "number"
typemap["uint32"] = "number"
typemap["fixed32"] = "number"
typemap["sfixed32"] = "number"
typemap["sint32"] = "number"
typemap["int64"] = "number"
typemap["uint64"] = "number"
typemap["fixed64"] = "number"
typemap["sfixed64"] = "number"
typemap["sint64"] = "number"
typemap["double"] = "number"
typemap["float"] = "number"
typemap["string"] = "string"
typemap["bytes"] = "string"
typemap["bool"] = "boolean"


local function read()
    local file = io.output("Assets/LuaProject/net/protoclass/protoclass.lua")


    local pbtypes = {}
    for fullname, basename, type in Dll_PB.types() do
        local temp = {}
        temp[1] = fullname
        temp[2] = basename
        temp[3] = type
        table.insert(pbtypes, temp)
    end
    table.sort(pbtypes,function (a,b)
        return a[2] < b[2]
    end)

    io.write("---------- 协议类结构注释，不require")
    for i = 1, #pbtypes do
        local fullname = pbtypes[i][1]
        local basename = pbtypes[i][2]
        local type = pbtypes[i][3]


        io.write("\n\n")
        local strclass = "---@class SC_"..basename.."\n"
        io.write(strclass)
        for name, idx, type, dufault, flag, oneof in Dll_PB.fields(fullname) do
            local temp1,temp2,temp3 = Dll_PB.type(type)
            --print("---   111", name, idx, type, dufault, flag, oneof,temp1,temp2,temp3)
            local fieldtype = ""
            if flag == "repeated" then
                if temp2 ~= nil then
                    fieldtype = " table<number,SC_"..temp2..">"
                else
                    fieldtype = " table<number,"..typemap[type]..">"
                end
            end

            if flag == "optional" then
                if temp2 ~= nil then
                    fieldtype = " SC_"..temp2
                else
                    if typemap[type] ~= nil then
                        fieldtype = " "..typemap[type]
                    else
                        print("---   waring!!!   缺少基础类型对应表   type = ",type)
                    end
                end
            end

            if flag == "packed" then
                if typemap[type] ~= nil then
                    fieldtype = " table<number,"..typemap[type]..">"
                else
                    print("---   waring!!!   缺少基础类型对应表   type = ",type)
                end
            end
            print("---   waring!!!   fieldtype = nil",fullname, name)
            if fieldtype == "" then
                print("---   waring!!!   fieldtype = nil", name, idx, type, dufault, flag, oneof,temp1,temp2,temp3)
            end

            local strfield = "---@field "..name..fieldtype.."\n"
            io.write(strfield)
        end
    end

    io.close(file)

    print("proto注释刷新成功！！")
end


read()

