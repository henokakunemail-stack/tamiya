---@class Stack
Stack=class("Stack")

function Stack:initialize()
    self.List={}
    self.Top=0
    self.Bottom=1
    self.Size=0
end

function Stack:Push(value)
    self.Top=self.Top+1
    self.List[self.Top]=value
    self.Size=self.Size+1
end

function Stack:Pop()
    if self.Top==0 then
        logError("Stack is empty")
        return nil
    end
    local value=self.List[self.Top]
    self.Top=self.Top-1
    self.Size=self.Size-1
    return value
end
function Stack:GetSize()
    return self.Size
end

function Stack:Print(func)
    for i = self.Bottom, self.Top do
        func(i,self.List[i])
    end
end

function Stack:Clear()
    self.List={}
    self.Top=0
    self.Bottom=1
    self.Size=0
end