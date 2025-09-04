-- 文件名　：cardview.lua
-- 创建者　：furuilei
-- 创建时间：2010-05-19 09:48:47
-- 功能描述：卡片浏览界面，通用
-- 注意：	  onopen传入参数见最后的示例

local uiCardView = Ui:GetClass("cardview")
local tbObject = Ui.tbLogic.tbObject
local tbTempItem = Ui.tbLogic.tbTempItem
local tbAwardInfo = Ui.tbLogic.tbAwardInfo

--===================================================

uiCardView.MAXNUM_PERPAGE = 35 -- 每页最多显示35个物品
uiCardView.MAXNUM_BUTTON = 4 -- 最多四个按钮
uiCardView.MANNUM_LINE = 5 -- 最多5行
uiCardView.MANNUM_COL = 7 -- 最多7列

uiCardView.TXT_TITLE = "Txt_Title"
uiCardView.TXT_DESC = "Txt_Desc"
uiCardView.BTN_PREPAGE = "Btn_PrePage"
uiCardView.BTN_NEXTPAGE = "Btn_NextPage"
uiCardView.TXT_CURPAGE = "Txt_CurPage"
uiCardView.BTN_CLOSE = "Btn_Close"
uiCardView.IMG_GRID = "ImgGrid"

uiCardView.BTN_TB = {}
for i = 1, uiCardView.MAXNUM_BUTTON do
  uiCardView.BTN_TB[i] = "Btn_" .. i
end

-- 35 grid
uiCardView.OBJ_GRID = {}
for i = 1, uiCardView.MAXNUM_PERPAGE do
  uiCardView.OBJ_GRID[i] = "ObjGrid" .. i
end

-- obj name to index
uiCardView.OBJ_INDEX = {}
for i = 1, uiCardView.MAXNUM_PERPAGE do
  uiCardView.OBJ_INDEX["ObjGrid" .. i] = i
end

uiCardView.nTotalPage = 1
uiCardView.nCurPage = 1
uiCardView.tbInfo = {}

-- 不同等级的特效
uiCardView.IMG_EFFECT_SPR = {
  [1] = "",
  [2] = "\\image\\effect\\other\\new_cheng1.spr",
  [3] = "\\image\\effect\\other\\new_cheng2.spr",
  [4] = "\\image\\effect\\other\\new_jin1.spr",
  [5] = "\\image\\effect\\other\\new_jin2.spr",
  [6] = "\\image\\effect\\other\\new_jin3.spr",
}

--===================================================

function uiCardView:Init()
  self.nTotalPage = 1
  self.nCurPage = 1
  self.tbInfo = {}
end

function uiCardView:OnOpen(tbInfo)
  if not tbInfo then
    return
  end

  self.szTitle = tbInfo.szTitle or ""
  self.szDesc = tbInfo.szDesc or ""
  self.tbBtnInfo = {}
  table.insert(self.tbBtnInfo, tbInfo.tbBtn1 or {})
  table.insert(self.tbBtnInfo, tbInfo.tbBtn2 or {})
  table.insert(self.tbBtnInfo, tbInfo.tbBtn3 or {})
  table.insert(self.tbBtnInfo, tbInfo.tbBtn4 or {})
  self.tbItemInfo = tbInfo.tbItemInfo or {}
  local nTotalItemNum = #self.tbItemInfo
  self.nTotalPage = math.ceil(nTotalItemNum / self.MAXNUM_PERPAGE)
  if self.nTotalPage <= 0 then
    self.nTotalPage = 1
  end
  self.nCurPage = 1

  self:UpdateInfo()
end

-- on create
function uiCardView:OnCreate()
  self.tbGridCont = {}
  for i, szGrid in pairs(self.OBJ_GRID) do
    self.tbGridCont[i] = tbObject:RegisterContainer(self.UIGROUP, szGrid, 1, 1, nil, "award")
    self.tbGridCont[i].OnObjGridEnter = self.OnObjGridEnter
  end
end

-- on destroy
function uiCardView:OnDestroy()
  for _, tbCont in pairs(self.tbGridCont) do
    tbObject:UnregContainer(tbCont)
  end
end

function uiCardView:OnObjGridEnter(szWnd, nX, nY)
  local nIndex = self.OBJ_INDEX[szWnd]
  local tbObj = self.tbGridCont[nIndex]:GetObj(nX, nY)

  if not tbObj then
    return 0
  end

  local pItem = tbObj.pItem
  if not pItem then
    return 0
  end

  Wnd_ShowMouseHoverInfo(self.UIGROUP, szWnd, pItem.GetCompareTip(Item.TIPS_NORMAL, ""))
end

--===================================================

function uiCardView:OnButtonClick(szWnd, nParam)
  if not szWnd then
    return
  end
  if szWnd == self.BTN_CLOSE then
    UiManager:CloseWindow(self.UIGROUP)
  elseif szWnd == self.BTN_PREPAGE then
    self:PrePage()
  elseif szWnd == self.BTN_NEXTPAGE then
    self:NextPage()
  else
    for i = 1, self.MAXNUM_BUTTON do
      if szWnd == self.BTN_TB[i] then
        self:BtnClick(i)
      end
    end
  end
end

-- 上一页
function uiCardView:PrePage()
  if self.nCurPage <= 1 then
    return
  end
  self.nCurPage = self.nCurPage - 1
  self:ClearGrid()
  self:UpdateInfo()
end

-- 下一页
function uiCardView:NextPage()
  if self.nTotalPage <= 1 then
    return
  end
  if self.nCurPage >= self.nTotalPage then
    return
  end
  self.nCurPage = self.nCurPage + 1
  self:ClearGrid()
  self:UpdateInfo()
end

-- 点击按钮回调事件
function uiCardView:BtnClick(nBtnIndex)
  if not nBtnIndex or nBtnIndex <= 0 or nBtnIndex > self.MAXNUM_BUTTON then
    return
  end
  local tbBtnInfo = self.tbBtnInfo[nBtnIndex] or {}
  if not tbBtnInfo or not tbBtnInfo.szCallBack then
    UiManager:CloseWindow(self.UIGROUP)
    return
  end

  loadstring(tbBtnInfo.szCallBack)()
end

--===================================================

function uiCardView:UpdateInfo()
  Txt_SetTxt(self.UIGROUP, self.TXT_TITLE, self.szTitle or "")
  Txt_SetTxt(self.UIGROUP, self.TXT_DESC, self.szDesc or "")

  self:Update_But()
  self:Update_ShowObj()
  self:Update_ShowPage()
end

function uiCardView:Update_But()
  local tbBtnInfo = self.tbBtnInfo or {}
  for i = 1, self.MAXNUM_BUTTON do
    if Lib:CountTB(tbBtnInfo[i]) == 0 then
      Wnd_Hide(self.UIGROUP, self.BTN_TB[i])
    end
  end

  tbBtnInfo[1] = tbBtnInfo[1] or {}
  tbBtnInfo[2] = tbBtnInfo[2] or {}
  tbBtnInfo[3] = tbBtnInfo[3] or {}
  tbBtnInfo[4] = tbBtnInfo[4] or {}
  Btn_SetTxt(self.UIGROUP, self.BTN_TB[1], tbBtnInfo[1].szName or "")
  Btn_SetTxt(self.UIGROUP, self.BTN_TB[2], tbBtnInfo[2].szName or "")
  Btn_SetTxt(self.UIGROUP, self.BTN_TB[3], tbBtnInfo[3].szName or "")
  Btn_SetTxt(self.UIGROUP, self.BTN_TB[4], tbBtnInfo[4].szName or "")
end

function uiCardView:Update_ShowObj()
  local tbObjList = self:GetObjList()
  if #tbObjList <= 0 then
    return
  end

  for i, tbItem in pairs(tbObjList) do
    if type(tbItem) == "table" then
      local tbObj = self:CreateTempItem(unpack(tbItem.tbGDPL))
      if tbObj then
        self.tbGridCont[i]:SetObj(tbObj)

        local nEffectId = tbItem.nEffectId or 1
        if self.IMG_EFFECT_SPR[nEffectId] and self.IMG_EFFECT_SPR[nEffectId] ~= "" then
          ObjGrid_SetTransparency(self.UIGROUP, self.OBJ_GRID[i], self.IMG_EFFECT_SPR[nEffectId], 0, 0)
        end

        local nCount = tbItem.nCount or 0
        ObjGrid_ShowSubScript(self.UIGROUP, self.OBJ_GRID[i], 1, 0, 0)
        ObjGrid_ChangeSubScript(self.UIGROUP, self.OBJ_GRID[i], tostring(nCount), 0, 0)

        Wnd_Show(self.UIGROUP, self.OBJ_GRID[i])
      end
    end
  end
end

function uiCardView:Update_ShowPage()
  local nCurPage = self.nCurPage or 1
  local szCurPage = string.format("第%s页", nCurPage)
  Txt_SetTxt(self.UIGROUP, self.TXT_CURPAGE, szCurPage or "")
end

function uiCardView:GetObjList()
  local tbRet = {}
  local nCurPage = self.nCurPage or 1
  local tbItemInfo = self.tbItemInfo or {}
  if Lib:CountTB(tbItemInfo) <= 0 then
    return tbRet
  end

  local nBeginIndex = (nCurPage - 1) * self.MAXNUM_PERPAGE + 1
  for nIndex = nBeginIndex, nBeginIndex + self.MAXNUM_PERPAGE - 1 do
    if tbItemInfo[nIndex] then
      table.insert(tbRet, tbItemInfo[nIndex])
    else
      break
    end
  end
  return tbRet
end

-- create temp item
function uiCardView:CreateTempItem(nGenre, nDetail, nParticular, nLevel)
  local pItem = tbTempItem:Create(nGenre, nDetail, nParticular, nLevel, -1)
  if not pItem then
    return
  end

  local tbObj = {}
  tbObj.nType = Ui.OBJ_TEMPITEM
  tbObj.pItem = pItem
  tbObj.nCount = 1

  return tbObj
end

-- clear all grid obj
function uiCardView:ClearGrid()
  for i = 1, self.MAXNUM_PERPAGE do
    local tbObj = self.tbGridCont[i]:GetObj()
    -- tbAwardInfo:DelAwardInfoObj(tbObj);
    self.tbGridCont[i]:SetObj(nil)
    Wnd_Hide(self.UIGROUP, self.OBJ_GRID[i])
  end
end

--============================================
-- 传入参数示例

--	local tbInfo = {
--		szTitle = "标题",
--		szDesc = "描述信息",
--		tbBtn1 = {
--			szName = "按钮一",
--			szCallBack = "print('Hello1!!!')"
--			},
--		tbBtn2 = {
--			szName = "按钮二",
--			szCallBack = "print('Hello2!!!')"
--			},
--		tbBtn3 = {
--			szName = "按钮三",
--			szCallBack = "print('Hello3!!!')"
--			},
--		tbItemInfo = {
--			-- tbGDPL, nEffectId, nCount 分别表示要显示物品的GDPL， 需要显示的特效， 物品的数量
--			-- 其中tbGDPL 是必须的，另外两个可选
--			{tbGDPL = {18, 1, 1, 1}, nEffectId = 1, nCount = 1},
--			{tbGDPL = {18, 1, 1, 2}, nEffectId = 2, nCount = 2},
--			{tbGDPL = {18, 1, 1, 3}, nEffectId = 3, nCount = 3},
--			{tbGDPL = {18, 1, 1, 4}, nEffectId = 4, nCount = 4},
--			{tbGDPL = {18, 1, 1, 5}, nEffectId = 5, nCount = 5},
--			{tbGDPL = {18, 1, 1, 6}, nEffectId = 6, nCount = 6},
--			{tbGDPL = {18, 1, 1, 7}, nEffectId = 1, nCount = 7},
--			{tbGDPL = {18, 1, 1, 8}, },
--			{tbGDPL = {18, 1, 1, 9}, nEffectId = 3, nCount = 9},
--			{tbGDPL = {18, 1, 1, 10}, nEffectId = 4, nCount = 10},
--			{tbGDPL = {18, 1, 1, 11}, nCount = 11},
--			{tbGDPL = {18, 1, 1, 12}, nEffectId = 6},
--			},
--		};
