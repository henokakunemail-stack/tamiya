---@class LuaVector3
LuaVector3=class("LuaVector3")

function LuaVector3:initialize(x,y,z)
    self.X=x
    self.Y=y
    self.Z=z
end
function LuaVector3:GetX()
    return self.X
end
function LuaVector3:GetY()
    return self.Y
end
function LuaVector3:GetZ()
    return self.Z
end

function LuaVector3:GetData()
    return self.X,self.Y,self.Z
end
function LuaVector3:Add(value)
    if value then
        return LuaVector3(self.X+value:GetX(),self.Y+value:GetY(),self.Z+value:GetZ())
    else
        return LuaVector3(self.X,self.Y,self.Z)
    end
end