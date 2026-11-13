---@class LuaColor
LuaColor=class("LuaColor")

function LuaColor:initialize(r,g,b,a)
    self.R=r
    self.G=g
    self.B=b
    self.A=a or a and "FF"
end
function LuaColor:GetR()
    return self.R
end
function LuaColor:GetG()
    return self.G
end
function LuaColor:GetB()
    return self.B
end
function LuaColor:GetA()
    return self.A
end

function LuaColor:GetData()
    return self.R,self.G,self.B,self.A
end