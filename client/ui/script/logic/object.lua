-- UI Object显示逻辑

Ui.tbLogic.tbObject = {}
local tbObject = Ui.tbLogic.tbObject

------------------------------------------------------------------------------------------

-- Object数据结构符号表
tbObject.TYPE_SYMBOLS = { --    变量名			类型			是否可选
  [Ui.OBJ_NPC] = {
    { "pNpc", "userdata", 0 }, -- NPC对象
  },
  [Ui.OBJ_NPCRES] = {
    { "nTemplateId", "number", 0 }, -- 模板ID
    { "nAction", "number", 0 }, -- 动作
    { "tbPart", "table", 0 }, -- 部件信息列表
    { "nDir", "number", 0 }, -- 方向
    { "bRideHorse", "number", 1 }, -- 是否骑马
  },
  [Ui.OBJ_ITEM] = {
    { "pItem", "userdata", 0 }, -- 道具对象
  },
  [Ui.OBJ_TEMPITEM] = {
    { "pItem", "userdata", 0 }, -- 临时道具对象
  },
  [Ui.OBJ_OWNITEM] = {
    { "nRoom", "number", 0 }, -- 所在玩家身上空间
    { "nX", "number", 0 }, -- 所在空间X坐标
    { "nY", "number", 0 }, -- 所在空间Y坐标
  },
  [Ui.OBJ_FIGHTSKILL] = {
    { "nSkillId", "number", 0 }, -- 战斗技能ID
  },
  [Ui.OBJ_LIFESKILL] = {
    { "nSkillId", "number", 0 }, -- 生活技能ID
  },
  [Ui.OBJ_PORTRAIT] = {
    { "nPortraitId", "number", 0 }, -- 头像ID
    { "bSex", "number", 0 }, -- 头像性别
    { "bSmall", "number", 1 }, -- 是否小图标
  },
  [Ui.OBJ_BUFF] = {
    { "nBuffId", "number", 0 }, -- BUFF ID
  },
  [Ui.OBJ_TASKICON] = {
    { "nIndex", "number", 0 }, -- 任务图标索引
    { "nCount", "number", 1 }, -- 下标数字
    { "szTip", "string", 1 }, -- Tip字符串
  },
}

function tbObject:Init()
  self.tbContClass = { base = {} } -- 容器类表
  self.tbContainer = {} -- 容器总表
  self.nLastContId = 0
end

function tbObject:NewContainerClass(szClass, szParent)
  if self.tbContClass[szClass] then
    return self.tbContClass[szClass]
  end
  local tbParent = nil
  if szParent then
    tbParent = self.tbContClass[szParent]
  end
  local tbClass = Lib:NewClass(tbParent or self.tbContClass.base)
  self.tbContClass[szClass] = tbClass
  return tbClass
end

function tbObject:IsContainerClass(tbContainer, szClass)
  if (not tbContainer) or not szClass then
    return 0
  end
  local tbBase = self.tbContClass[szClass]
  return Lib:IsDerived(tbContainer, tbBase)
end

-- 注册一个容器，需要指明UIGROUP、ObjGrid控件、列数、行数和基类
function tbObject:RegisterContainer(szUiGroup, szObjGrid, nRow, nLine, tbNew, szClass)
  local tbBase = self.tbContClass[szClass or "base"]
  if not tbBase then
    tbBase = self.tbContClass.base
  end
  local tbContainer = Lib:NewClass(tbBase) -- 新容器从基类继承
  self.nLastContId = self.nLastContId + 1 -- 分配ID
  self.tbContainer[self.nLastContId] = tbContainer
  tbContainer.szUiGroup = szUiGroup
  tbContainer.szObjGrid = szObjGrid
  tbContainer.nRow = nRow or 1
  tbContainer.nLine = nLine or 1
  if tbNew then
    for varIdx, varVal in pairs(tbNew) do
      tbContainer[varIdx] = varVal -- 复制tbNew中的字段，覆盖基类字段
    end
  end
  return tbContainer
end

-- 注销一个容器
function tbObject:UnregContainer(tbContainer)
  for nId, tbReg in pairs(self.tbContainer) do
    if tbReg == tbContainer then
      tbReg:ClearObj() -- 清除和销毁Object
      self.tbContainer[nId] = nil
      return 1
    end
  end
  return 0
end

-- 检查一个容器的有效性
function tbObject:CheckContainer(tbContainer)
  for _, tbReg in pairs(self.tbContainer) do
    if tbReg == tbContainer then
      return 1
    end
  end
  return 0
end

-- 检查一个Object结构是否合法
function tbObject:CheckObj(tbObj)
  if (type(tbObj) ~= "table") or (type(tbObj.nType) ~= "number") then
    return 0
  end
  local tbSymbols = self.TYPE_SYMBOLS[tbObj.nType]
  if not tbSymbols then
    return 0 -- Object类型不存在
  end
  for _, tbSymb in ipairs(tbSymbols) do
    local szSymbol = tbSymb[1]
    local szType = tbSymb[2]
    local bOptional = tbSymb[3]
    local var = tbObj[szSymbol]
    -- 对于可选符号，只有符号存在时才检查类型当
    if (szType ~= "") and ((bOptional ~= 1) and true or var) then
      if type(var) ~= szType then
        return 0 -- 符号类型不符
      end
    end
  end
  return 1
end

function tbObject:DestroyObj(tbObj)
  if tbObj and (tbObj.nType == Ui.OBJ_TEMPITEM) then
    Ui.tbLogic.tbTempItem:Destroy(tbObj.pItem)
  end
end

-- TODO: xyf 获得鼠标Object的图素，设计的很垃圾，看有没有更合理的方式搞定
function tbObject:GetObjImage(tbObj)
  if tbObj.nType == Ui.OBJ_NPC then
    return ""
  end
  if (tbObj.nType == Ui.OBJ_ITEM) or (tbObj.nType == Ui.OBJ_TEMPITEM) then
    return tbObj.pItem.szIconImage
  end
  if tbObj.nType == Ui.OBJ_OWNITEM then
    local pItem = me.GetItem(tbObj.nRoom, tbObj.nX, tbObj.nY)
    if not pItem then
      return ""
    else
      return pItem.szIconImage
    end
  end
  if tbObj.nType == Ui.OBJ_FIGHTSKILL then
    return KFightSkill.GetSkillIcon(tbObj.nSkillId)
  end
  if tbObj.nType == Ui.OBJ_LIFESKILL then
    local tbInfo = me.GetLifeSkillInfo(tbObj.nSkillId)
    if not tbInfo then
      return ""
    end
    return tbInfo.szIcon
  end
  if tbObj.nType == Ui.OBJ_PORTRAIT then
    return GetPortraitSpr(tbObj.nIndex, tbObj.bSex, (tbObj.bSmall == 1) and 1 or 0)
  end
  if tbObj.nType == Ui.OBJ_BUFF then
    local tbInfo = me.GetBuffInfo(tbObj.nBuffId)
    if not tbInfo then
      return ""
    end
    return tbInfo.szIcon
  end
  if tbObj.nType == Ui.OBJ_TASKICON then
    return KTask.GetIconPath(tbObj.nIndex)
  end
end

------------------------------------------------------------------------------------------
