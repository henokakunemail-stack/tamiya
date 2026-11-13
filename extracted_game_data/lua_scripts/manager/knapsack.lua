

---@class KnapsackData
KnapsackData = class("KnapsackData")


---@param type KnapsackType
function KnapsackData:initialize(type)
    self.Type = type

    ---@type table<number, ArticleCell>
    self.ArticleCells = {}

    ---@type table<number, ArticleCell>
    self.CellIdDict = {}

    ---@type table<number, ArticleCell>
    self.IDDict = {}

    ---@type table<number, number>>
    self.ArticleDict = {}
end

---@param msg SC_UserProp[]
function KnapsackData:SetPropData(msg)
    for i = 1, #msg do
        if msg[i].propid>SegmentMaxId then
            self:SetCellProp(msg[i])
        end
    end
    self:UpdateArticleDict()
end

---@param msg SC_UserPart[]
function KnapsackData:SetPartData(msg,isnew,isSelf)
    for i = 1, #msg do
        self:SetCellPart(msg[i],isnew,isSelf)
    end
    self:UpdateArticleDict()
end
---@param data SC_UserPart
function KnapsackData:SetCellPart(data,isnew,isSelf)
    local cell = self:GetArticleByCellID(data.partinx)
    if cell == nil then
        cell = ArticleCell()
        cell:OnInitPart(data, isnew)
        if self.Type==BagType.Article or self.Type==BagType.Part then
            if cell.DownType==PartDownType.Self or cell.DownType==PartDownType.Lease or cell.DownType==PartDownType.Hire  then
                table.insert(self.ArticleCells, cell)
                self.CellIdDict[cell:GetCellID()] = cell
                self.IDDict[cell:GetID()] = cell
            end
        end
        if self.Type==BagType.TempNewPlayer then
            if cell.DownType==PartDownType.Temp  then
                table.insert(self.ArticleCells, cell)
                self.CellIdDict[cell:GetCellID()] = cell
                self.IDDict[cell:GetID()] = cell
            end
        end
        if self.Type==BagType.TempAssemble then
            if cell.DownType==PartDownType.RaceAssemble  then
                table.insert(self.ArticleCells, cell)
                self.CellIdDict[cell:GetCellID()] = cell
                self.IDDict[cell:GetID()] = cell
            end
        end
        if self.Type==BagType.TempAdd then
            if cell.DownType==PartDownType.Temp  then
                table.insert(self.ArticleCells, cell)
                self.CellIdDict[cell:GetCellID()] = cell
                self.IDDict[cell:GetID()] = cell
            end
        end
    else
        cell:OnInitPart(data,false)
    end
end

---@param data SC_UserProp
function KnapsackData:SetCellProp(data)
    local cell = self:GetArticleByCellID(data.propid)
    if cell == nil then
        cell = ArticleCell()
        cell:OnInitProp(data, true)
        table.insert(self.ArticleCells, cell)
        cell:SetCellId(#self.ArticleCells)
        self.CellIdDict[cell:GetCellID()] = cell
        self.IDDict[cell:GetID()] = cell
    else
        cell:OnInitProp(data,false)
    end

end
---@param props SC_UserProp[]
function KnapsackData:AddProp(props)
    for i = 1, #props do
        if props[i].propid>SegmentMaxId then
            local cell=self:GetArticleByID(props[i].propid)
            if cell then
                cell:SetCount(props[i].propnum)
            else
                self:SetCellProp(props[i])
            end
        end
    end
    self:UpdateArticleDict()
end
---@param parts SC_UserPart[]
function KnapsackData:AddPart(parts,isSelf)
    for i = 1, #parts do
       self:SetCellPart(parts[i],true,isSelf)
    end
end
function KnapsackData:GetArticleByCellID(cellid)
    return self.CellIdDict[cellid]
end
function KnapsackData:GetArticleByIndex(index)
    return self.ArticleCells[index]
end
function KnapsackData:GetArticleByID(id)
    return self.IDDict[id]
end

function KnapsackData:UpdateArticleDict()
    self.ArticleDict = {}
    for i = 1, #self.ArticleCells do
        local data = self.ArticleCells[i]
        if self.ArticleDict[data:GetID()] == nil then
            self.ArticleDict[data:GetID()] = 0
        end
        self.ArticleDict[data:GetID()] = self.ArticleDict[data:GetID()] + data:GetCount()
        WelfareBoxDataManager:Get():RefreshBoxAwardRedPointState(data)
    end

end

---@ param parts number[]
function KnapsackData:DelArticleByPartsId(parts)
    for i = 1, #parts do
        local cell = self:GetArticleByCellID(parts[i])
        if cell then
            cell=nil
        end
    end
    for i = 1, #parts do
        for j = 1, #self.ArticleCells do
            if self.ArticleCells[j].CellId==parts[i] then
                table.remove(self.ArticleCells,j)
                break
            end
        end
    end
end
function KnapsackData:DelArticleByPropsId()

end

function KnapsackData:SortByArticleID()
    table.sort(self.ArticleCells,function (a, b)
        return a:GetID() > b:GetID()
    end)
    return self.ArticleCells
end

function KnapsackData:GetArticleCountByCfgid(id)
    local result = self.ArticleDict[id]
    if result == nil then
        result = 0
    end
    return result
end
function KnapsackData:ClearDict()
    self.ArticleCells = {}
    self.CellIdDict = {}
    self.IDDict = {}
    self.ArticleDict = {}
end





















---@param msg SC_NotifyArticleChange
function KnapsackData:SetData(msg)
    for i = 1, #msg.delList do
        self:RemoveArticleByCellID(msg.delList[i])
    end
    for i = 1, #msg.naList do
        self:SetCell(msg.naList[i], nil)
    end
    for i = 1, #msg.partList do
        self:SetCell(msg.partList[i].articleInfo, msg.partList[i])
    end

    self:UpdateArticleDict()
end

function KnapsackData:GetEquipmentsByGroove(grooveid)
    local result = {}

    ---@type grooveid_config_cell
    local groovecfg = CommonHelper:GetTableDataByID(ConfigNames.grooveid_config, grooveid)
    if groovecfg == nil then return result end

    for i = 1, #self.ArticleCells do
        local temp = self.ArticleCells[i]
        for loop = 1, #groovecfg.NewTypes do
            local type = groovecfg.NewTypes[loop][1]
            local type2 = groovecfg.NewTypes[loop][2]
            local type3 = groovecfg.NewTypes[loop][3]

            if temp:GetPartType() == type then
                if type2 == -1 or temp:GetPartSubType() == type2 then
                    table.insert(result, temp)
                end
            end
        end
    end

    return result
end






function KnapsackData:RemoveArticleByCellID(cellid)
    local cell = self:GetArticleByCellID(cellid)
    if cell == nil then
        print("---   error:RemoveArticleByCellID   RemoveArticleByCellID = nil")
        return
    end

    for i = 1, #self.ArticleCells do
        if self.ArticleCells[i]:GetCellID() == cellid then
            table.remove(self.ArticleCells, i)
            break
        end
    end

    self.CellIdDict[cellid] = nil
    self.IDDict[cell:GetID()] = nil

end




