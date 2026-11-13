---@class DirectData DirectData
DirectData = class("DirectData")


function DirectData:initialize()
    self.propid = -1
    self.curnum = -1
    self.coinid = -1
    self.ifalert = -1
    self.pay = {}
end

function DirectData:SetData(data)
    self.propid = data.propid
    self.curnum = data.curnum
    self.coinid = data.coinid
    self.ifalert = data.ifalert

    for i, v in ipairs(data.pay) do
        table.insert(self.pay, v)
    end

end

---@type  SC_UserDirect