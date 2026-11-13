---@class RentAndLendDataManager
RentAndLendDataManager = class("RentAndLendDataManager")

---@class MyBorrowAppData
MyBorrowAppData = class("MyBorrowAppData")

function MyBorrowAppData:initialize()
    self.BorrowType = nil
    self.Rid = nil
    self.OriginRid = nil
    self.PartIndex = nil
    self.FRoleName = nil
    self.FHeadIcon = nil
    self.FIconFrame = nil
    self.FCurLevel = nil
    self.BorrowName = nil
    self.AccessFlag = nil
    self.BorrowPart = {}

end

function MyBorrowAppData:InitBaseData(_type, msg)
    self.BorrowType = _type
    self.Rid = msg.rid
    self.OriginRid = msg.originRid
    self.PartIndex = msg.partInx
    self.FRoleName = msg.fRolename
    self.FHeadIcon = msg.fHeadIcon
    self.FIconFrame = msg.fIconFrame
    self.FCurLevel = msg.fCurLevel
    self.BorrowName = msg.borrowName
    self.AccessFlag = msg.accessFlag      --借者昵称

    local borrowPart = ArticleCell()
    borrowPart:OnInitBorrowPart(msg.applyPart)
    self.BorrowPart = borrowPart
end

function MyBorrowAppData:GetBorrowType()
    return self.BorrowType
end

function MyBorrowAppData:GetRid()
    return self.Rid
end

function MyBorrowAppData:GetOriginRid()
    return self.OriginRid
end

function MyBorrowAppData:GetPartIndex()
    return self.PartIndex
end

function MyBorrowAppData:GetAccessFlag()
    return self.AccessFlag
end

function MyBorrowAppData:GetOppositeName()
    return self.BorrowName
end

---@class MyHireCoinData
MyHireCoinData = class("MyHireCoinData")

function MyHireCoinData:initialize()
    self.ExchCoin = nil
    self.ExchNum = nil
    self.FreshTime = nil
    self.MaxNum = nil
    self.ResidueNum = nil
end

function MyHireCoinData:InitBaseData(msg)
    self.ExchCoin = msg.exchCoin
    self.ExchNum = msg.exchNum
    self.FreshTime = msg.freshTime
    self.MaxNum = msg.maxNum
    self.ResidueNum = msg.maxNum - msg.exchNum
end

function MyHireCoinData:GetExchCoin()
    return self.ExchCoin
end

function MyHireCoinData:GetExchNum()
    return self.ExchNum
end

function MyHireCoinData:GetFreshTime()
    return self.FreshTime
end

function MyHireCoinData:GetMaxNum()
    return self.MaxNum
end

function MyHireCoinData:GetResidueNum()
    return self.ResidueNum
end

---@class MyHireAppData
MyHireAppData = class("MyHireAppData")

function MyHireAppData:initialize()
    self.HireType = nil
    self.Rid = nil
    self.PartInx = nil
    self.PartiID = nil
    self.AccessFla = nil
    self.ExpTime = nil
    self.HireNum = nil
    self.FRoleName = nil
    self.FHeadIcon = nil
    self.FIconFrame = nil
    self.FCurLevel = nil
    self.HireName = nil
    self.PayMoney = nil
    self.OriginRid = nil
    self.Source = nil
    self.HireRid = nil
    self.HExpTime = nil
end

function MyHireAppData:InitBaseData(_type, msg)
    self.HireType = _type
    self.Rid = msg.rid
    self.PartInx = msg.partInx
    self.PartiID = msg.partiId
    self.AccessFlag = msg.accessFlag
    self.ExpTime = msg.exptime
    self.HireNum = msg.hirenum
    self.FRoleName = msg.fRolename
    self.FHeadIcon = msg.fHeadIcon
    self.FIconFrame = msg.fIconFrame
    self.FCurLevel = msg.fCurLevel
    self.HireName = msg.hireName
    self.PayMoney = msg.payMoney
    self.OriginRid = msg.originRid
    self.Source = msg.source
    self.HireRid = msg.hirerid
    self.HExpTime = msg.hexptime
end

function MyHireAppData:GetHireType()
    return self.HireType
end

function MyHireAppData:GetRid()
    return self.Rid
end

function MyHireAppData:GetOriginRid()
    return self.OriginRid
end

function MyHireAppData:GetPartIndex()
    return self.PartInx
end

function MyHireAppData:GetAccessFlag()
    return self.AccessFlag
end

function MyHireAppData:GetPartiID()
    return self.PartiID
end

function MyHireAppData:GetExpTime()
    return self.ExpTime
end

function MyHireAppData:GetHExpTime()
    return self.HExpTime
end

function MyHireAppData:GetOppositeName()
    return self.HireName
end

---------------------------------------------------------------------------------
---------------------------------------------------------------------------------
---------------------------------------------------------------------------------

function RentAndLendDataManager:initialize()

end

---@return RentAndLendDataManager
function RentAndLendDataManager:Get()
    if self._instance == nil then
        self._instance = RentAndLendDataManager()
    end
    return self._instance
end

---@type SC_FriendPart
function RentAndLendDataManager:SetChoosePartData(msg)
    self.ChoosePartData = {}

    for i, v in pairs(msg.parts) do
        local borrowPart = ArticleCell()
        borrowPart:OnInitBorrowPart(v)
        table.insert(self.ChoosePartData, borrowPart)
    end

    self.FriendID = msg.frid
    self.HeadIcon = msg.headicon
    self.RoleName = msg.rolename
    self.IconFrame = msg.iconframe
    self.CurLevel = msg.curlevel
end

function RentAndLendDataManager:RefreshChoosePartDataByPartInx(msg)
    for i, v in pairs(self.ChoosePartData) do
        if v.CellId == msg.partinx then
            local borrowPart = ArticleCell()
            borrowPart:OnInitBorrowPart(msg)
            self.ChoosePartData[i] = borrowPart
        end
    end
end

function RentAndLendDataManager:GetChoosePartData()
    return self.ChoosePartData
end

function RentAndLendDataManager:GetChoosePartFriendID()
    return self.FriendID
end

function RentAndLendDataManager:GetChoosePartHeadIcon()
    return self.HeadIcon
end

function RentAndLendDataManager:GetChoosePartRoleName()
    return self.RoleName
end

function RentAndLendDataManager:GetChoosePartIconFrame()
    return self.IconFrame
end

function RentAndLendDataManager:GetChoosePartCurLevel()
    return self.CurLevel
end

function RentAndLendDataManager:GetChoosePartDataByType(_type)
    local data = {}

    for i, v in pairs(self.ChoosePartData) do
        local partConfig = CommonHelper:GetTableDataByID(ConfigNames.dictpartbase_config, v.CfgId)
        if partConfig.parttype == _type then
            table.insert(data, v)
        end
    end

    return data
end

function RentAndLendDataManager:SetBorrowPartData(msg)
    self.Rid = msg.rid                    --同意借出/雇佣方rid
    self.PartIndex = msg.partInx          --出借方配件索引
    self.FRoleName = msg.fRolename        --
    self.FHeadIcon = msg.fHeadIcon        --
    self.FIconFrame = msg.fIconFrame      --
    self.FCurLevel = msg.fCurLevel        --
    self.BorrowName = msg.borrowName      --借者昵称

    self:RefreshChoosePartDataByPartInx(msg.applyPart)
end

----------------------
function RentAndLendDataManager:InitFriendExchangeData(msg)
    ---@type MyHireCoinData[]
    self.ExchangeCoinData = {}
    self.AllCoinNumData = 0
    self.AllGetCoinNumData = 0
    local _exchangeCoinData = {}

    for i, v in pairs(msg.exchCoins) do
        local CoinData = MyHireCoinData()
        CoinData:InitBaseData(v)
        table.insert(_exchangeCoinData, CoinData)

        self.AllCoinNumData = self.AllCoinNumData + v.maxNum
        self.AllGetCoinNumData = self.AllGetCoinNumData + v.exchNum

    end

    local dicthirecoin_config = ClientDataManager:Get():GetDataTable(ConfigNames.dicthirecoin_config)
    local _exchData = dicthirecoin_config:GetConfigData()

    for i, v in pairs(_exchData) do
        for j, k in pairs(_exchangeCoinData) do
            if k:GetExchCoin() == v.exchcoin then
                table.insert(self.ExchangeCoinData, k)
            end
        end
    end

end

function RentAndLendDataManager:GetFriendExchangeData()
    return self.ExchangeCoinData
end

function RentAndLendDataManager:GetAllCoinNumData()
    return self.AllCoinNumData
end

function RentAndLendDataManager:GetAllGetCoinNumData()
    return self.AllGetCoinNumData
end

---------------------------------------------------------------------------------------------------------------------

---@type SC_MyBorrowApp
function RentAndLendDataManager:InitMyBorrowAppData(msg)
    self.MyBorrowAppData = {}

    if msg.borrowType == 0 then
        for i, v in pairs(msg.curApp) do
            local MyBorrowApp00 = MyBorrowAppData()
            MyBorrowApp00:InitBaseData(msg.borrowType, v)
            table.insert(self.MyBorrowAppData, MyBorrowApp00)
        end
    end

    if msg.borrowType == 1 then
        for i, v in pairs(msg.curApp) do
            local MyBorrowApp11 = MyBorrowAppData()
            MyBorrowApp11:InitBaseData(msg.borrowType, v)
            table.insert(self.MyBorrowAppData, MyBorrowApp11)
        end
    end

end

function RentAndLendDataManager:GetMyBorrowAppDataByType(_type)
    local _data = {}

    for i, v in pairs(self.MyBorrowAppData) do
        if v:GetBorrowType() == _type then
            table.insert(_data, v)
        end
    end

    return _data
end

function RentAndLendDataManager:InitMyBorrowAppOutData(msg)
    self.BorrowAppOutData = {}

    if msg.borrowType == 0 then
        for i, v in pairs(msg.curApp) do
            if v.accessFlag == 2 then
                local BorrowAppOut0 = MyBorrowAppData()
                BorrowAppOut0:InitBaseData(msg.borrowType, v)
                table.insert(self.BorrowAppOutData, BorrowAppOut0)
            end
        end
    end

    if msg.borrowType == 1 then
        for i, v in pairs(msg.curApp) do
            if v.accessFlag == 2 then
                local BorrowAppOut1 = MyBorrowAppData()
                BorrowAppOut1:InitBaseData(msg.borrowType, v)
                table.insert(self.BorrowAppOutData, BorrowAppOut1)
            end
        end
    end

end

function RentAndLendDataManager:GetBorrowAppOutDataByType(_type)
    local _data = {}

    for i, v in pairs(self.BorrowAppOutData) do
        if v:GetBorrowType() == _type then
            table.insert(_data, v)
        end
    end

    return _data
end

function RentAndLendDataManager:SetRentOrLendType(_type)
    self.RentOrLendType = _type
end

function RentAndLendDataManager:GetRentOrLendType()
    return self.RentOrLendType
end

function RentAndLendDataManager:SetMyBorrowAppDataByID(msg, _type)
    for i, v in pairs(self.MyBorrowAppData) do
        if v:GetRid() == msg.rid and v:GetPartIndex() == msg.partInx and v:GetBorrowType() == _type then
            local BorrowApp = MyBorrowAppData()
            BorrowApp:InitBaseData(_type, msg)
            self.MyBorrowAppData[i] = BorrowApp
        end
    end
end

function RentAndLendDataManager:DelMyBorrowAppDataByID(msg, _type)
    for i, v in pairs(self.MyBorrowAppData) do
        if v:GetRid() == msg.rid and v:GetPartIndex() == msg.partInx and v:GetBorrowType() == _type then
            table.remove(self.MyBorrowAppData, i)
        end
    end
end


---------------------------------------------------------------------------------------------------------------------

---@type SC_MyHireApp
function RentAndLendDataManager:InitMyHireAppData(msg)
    self.MyHireAppData = {}

    if msg.hireType == 0 then
        for i, v in pairs(msg.curApp) do
            local MyHireApp00 = MyHireAppData()
            MyHireApp00:InitBaseData(msg.hireType, v)
            table.insert(self.MyHireAppData, MyHireApp00)
        end
    end

    if msg.hireType == 1 then
        for i, v in pairs(msg.curApp) do
            local MyHireApp11 = MyHireAppData()
            MyHireApp11:InitBaseData(msg.hireType, v)
            table.insert(self.MyHireAppData, MyHireApp11)
        end
    end

end

function RentAndLendDataManager:GetMyHireAppDataByType(_type)
    local _data = {}

    for i, v in pairs(self.MyHireAppData) do
        if v:GetHireType() == _type then
            table.insert(_data, v)
        end
    end

    return _data
end

function RentAndLendDataManager:InitMyHireAppOutData(msg)
    self.HireAppOutData = {}

    if msg.hireType == 0 then
        for i, v in pairs(msg.curApp) do
            if v.accessFlag == 2 then
                local hireAppOut0 = MyHireAppData()
                hireAppOut0:InitBaseData(msg.hireType, v)
                table.insert(self.HireAppOutData, hireAppOut0)
            end
        end
    end

    if msg.hireType == 1 then
        for i, v in pairs(msg.curApp) do
            if v.accessFlag == 2 then
                local hireAppOut1 = MyHireAppData()
                hireAppOut1:InitBaseData(msg.hireType, v)
                table.insert(self.HireAppOutData, hireAppOut1)
            end
        end
    end

end

function RentAndLendDataManager:GetHireAppOutDataByType(_type)
    local _data = {}

    for i, v in pairs(self.HireAppOutData) do
        if v:GetHireType() == _type then
            table.insert(_data, v)
        end
    end

    return _data
end

function RentAndLendDataManager:SetMyHireAppDataByID(msg, _type)
    for i, v in pairs(self.MyHireAppData) do
        ---@type MyHireAppData
        if v:GetRid() == msg.rid and v:GetPartIndex() == msg.partInx then
            local hireApp = MyHireAppData()
            hireApp:InitBaseData(_type, msg)
            self.MyHireAppData[i] = hireApp
        end
    end

end

function RentAndLendDataManager:DelMyHireAppDataByID(msg, _type)
    for i, v in pairs(self.MyHireAppData) do
        if v:GetRid() == msg.rid and v:GetPartIndex() == msg.partInx and v:GetHireType() == _type then
            table.remove(self.MyHireAppData, i)
        end
    end
end
