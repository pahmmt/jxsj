-- 文件名  : exptask.lua
-- 创建者  : jiazhenwei
-- 创建时间: 2010-07-26
-- 描述    : 经验任务平台

local uiExpTask = Ui:GetClass("exptask")

uiExpTask.NUM_PERPAGE_EVR = 8 --每页显示多少个
uiExpTask.FLAG_VIEW = 1 --显示状态，我的任务还是浏览任务
uiExpTask.NUM_PERPAGE_VIEW = 48 --浏览任务显示的最大数目
uiExpTask.NUM_PERPAGE_MY = 80 --自己发表的任务显示的最大数目
uiExpTask.FABUTIME = 24 --发布时间
uiExpTask.nNumPage = 1 --当前页标
uiExpTask.nTotalPage = 1 --总页数
uiExpTask.nCurCmbIndex = 0 --下拉菜单选项
uiExpTask.nCountSort = 0 --数量排行
uiExpTask.nXingSort = 0 --星级排行
uiExpTask.nCoinSort = 0 --赏金排行
uiExpTask.nCaoZTime = 0 --操作时间
uiExpTask.nJianGeTime = 5 --操作间隔时间

uiExpTask.BtnClose = "BtnClose"
uiExpTask.BtnOtherTask = "BtnOtherTask" --浏览任务
uiExpTask.BtnMyTask = "BtnMyTask" --我的任务
uiExpTask.BtnFaBuTask = "BtnFaBuTask" --发布按钮
uiExpTask.Btn_Up = "Btn_Up" --上页按钮
uiExpTask.Btn_Down = "Btn_Down" --下页按钮

--page
uiExpTask.Txt_Page = "Txt_Page" --页标

uiExpTask.ComBoxItem = "ComBoxItem" --下拉菜单

--information
uiExpTask.Txt_Introduce = "Txt_Introduce"
uiExpTask.Txt_MyInfo = "Txt_MyInfo"

--list title
uiExpTask.BtnGBListBonusSort = "BtnGBListBonusSort"
uiExpTask.BtnGBListXingSort = "BtnGBListXingSort"
uiExpTask.BtnGBListCountSort = "BtnGBListCountSort"

--list
uiExpTask.BGLst_ItemInfo = "BGLst_ItemInfo"
uiExpTask.Obj_TaskItem = "Obj_TaskItem"
uiExpTask.Txt_TaskInfo = "Txt_TaskInfo"
uiExpTask.Btn_Task = "Btn_Task"
uiExpTask.PAGE_SET = {}
for i = 1, uiExpTask.NUM_PERPAGE_EVR do
  uiExpTask.PAGE_SET[i] = {}
  uiExpTask.PAGE_SET[i][uiExpTask.BGLst_ItemInfo] = "BGLst_ItemInfo" .. i - 1
  uiExpTask.PAGE_SET[i][uiExpTask.Obj_TaskItem] = "Obj_TaskItem" .. i - 1
  uiExpTask.PAGE_SET[i][uiExpTask.Txt_TaskInfo] = "Txt_TaskInfo" .. i - 1
  uiExpTask.PAGE_SET[i][uiExpTask.Btn_Task] = "Btn_Task" .. i - 1
end

function uiExpTask:OnOpen()
  self.tbTask = {}
  self.tbOtherTask = {}
  self.tbMyTask = {}
  self.nNumPage = 1
  self.nTotalPage = 1
  self.nCurCmbIndex = 0
  self.nCountSort = 0
  self.nXingSort = 0
  self.nCoinSort = 0
  ComboBoxSelectItem(self.UIGROUP, self.ComBoxItem, 0)
end

function uiExpTask:PreOpen(bServer)
  if not bServer then
    return 1
  end

  me.CallServerScript({ "ApplyOpenTask" })
  return 0
end

function uiExpTask:OnRecvData(nFlag, tbTask)
  self.tbTask = self.tbTask or {}
  self.tbOtherTask = self.tbOtherTask or {}
  if nFlag == 1 then
    self.tbTask = tbTask
    self:MakeTable()
  elseif nFlag == 2 then
    Lib:MergeTable(self.tbMyTask, tbTask)
  end
  --self:GetMyTask(tbTask);
  --self:Get50Task();
  self:UpdateTask()
end

function uiExpTask:MakeTable()
  self.tbOtherTask = {}
  for i, tbTaskEx in ipairs(self.tbTask) do
    self.tbOtherTask[tbTaskEx[1]] = self.tbOtherTask[tbTaskEx[1]] or {}
    table.insert(self.tbOtherTask[tbTaskEx[1]], { tbTaskEx[3], tbTaskEx[4], tbTaskEx[5], tbTaskEx[6], tbTaskEx[2] })
  end
end

function uiExpTask:Get50Task()
  if #self.tbTask <= self.NUM_PERPAGE_VIEW then
    return
  end
  for i = self.NUM_PERPAGE_VIEW + 1, #self.tbTask do
    self.tbTask[i] = nil
  end
end

--分离我的任务
function uiExpTask:GetMyTask(tbTask)
  for nIndex, tbTaskEx in ipairs(tbTask) do
    if tbTaskEx[6] == me.szName then
      table.insert(self.tbMyTask, tbTask[nIndex])
    end
  end
end

--刷新界面
function uiExpTask:UpdateTask()
  if not self.tbTask then
    return
  end

  --激活任务浏览还是我的任务
  if self.FLAG_VIEW == 1 then
    Btn_Check(self.UIGROUP, self.BtnOtherTask, 1)
    Btn_Check(self.UIGROUP, self.BtnMyTask, 0)
  else
    Btn_Check(self.UIGROUP, self.BtnOtherTask, 0)
    Btn_Check(self.UIGROUP, self.BtnMyTask, 1)
  end

  --显示页标
  if self.FLAG_VIEW == 1 then
    if self.nCurCmbIndex == 0 then
      if #self.tbTask > self.NUM_PERPAGE_VIEW then
        self.nTotalPage = math.ceil(self.NUM_PERPAGE_VIEW / self.NUM_PERPAGE_EVR)
      else
        self.nTotalPage = math.ceil(#self.tbTask / self.NUM_PERPAGE_EVR)
      end
    else
      if #self.tbOtherTask[self.nCurCmbIndex] > self.NUM_PERPAGE_VIEW then
        self.nTotalPage = math.ceil(self.NUM_PERPAGE_VIEW / self.NUM_PERPAGE_EVR)
      else
        self.nTotalPage = math.ceil(#self.tbOtherTask[self.nCurCmbIndex] / self.NUM_PERPAGE_EVR)
      end
    end
  else
    if #self.tbMyTask > self.NUM_PERPAGE_MY then
      self.nTotalPage = math.ceil(self.NUM_PERPAGE_MY / self.NUM_PERPAGE_EVR)
    else
      self.nTotalPage = math.ceil(#self.tbMyTask / self.NUM_PERPAGE_EVR)
    end
  end
  if self.nTotalPage <= 0 then
    self.nTotalPage = 1
  end
  Txt_SetTxt(self.UIGROUP, self.Txt_Page, string.format("%s/%s", self.nNumPage, self.nTotalPage))
  Wnd_SetEnable(self.UIGROUP, self.ComBoxItem, 1)

  --显示物品
  for i = 1, 8 do
    local nIndex = (self.nNumPage - 1) * self.NUM_PERPAGE_EVR + i
    local tbItemEx = {}
    Wnd_Visible(self.UIGROUP, self.PAGE_SET[i][self.BGLst_ItemInfo], 1)
    Wnd_Visible(self.UIGROUP, self.PAGE_SET[i][self.Txt_TaskInfo], 1)
    Wnd_Visible(self.UIGROUP, self.PAGE_SET[i][self.Btn_Task], 1)
    if self.FLAG_VIEW == 1 then
      if self.nCurCmbIndex == 0 then
        if not self.tbTask[nIndex] then
          Wnd_Hide(self.UIGROUP, self.PAGE_SET[i][self.BGLst_ItemInfo])
          Wnd_Hide(self.UIGROUP, self.PAGE_SET[i][self.Txt_TaskInfo])
          Wnd_Hide(self.UIGROUP, self.PAGE_SET[i][self.Btn_Task])
        else
          Wnd_Show(self.UIGROUP, self.PAGE_SET[i][self.BGLst_ItemInfo])
          Wnd_Show(self.UIGROUP, self.PAGE_SET[i][self.Txt_TaskInfo])
          Wnd_Show(self.UIGROUP, self.PAGE_SET[i][self.Btn_Task])
          tbItemEx = Task.TaskExp.tbItem[self.tbTask[nIndex][1]][1]
          Txt_SetTxt(self.UIGROUP, self.PAGE_SET[i][self.Txt_TaskInfo], string.format("%s%s%s%s", Lib:StrFillR(self.tbTask[nIndex][3] .. "个", 12), Lib:StrFillR((self.tbTask[nIndex][4] / 2) .. "星", 18), Lib:StrFillR(self:CalculateAword(self.tbTask[nIndex][1], self.tbTask[nIndex][3], self.tbTask[nIndex][4]) .. IVER_g_szBindCoinName_ST, 20), Lib:StrFillR(self:CalculateTime(self.tbTask[nIndex][5]), 12)))
        end
      else
        if not self.tbOtherTask[self.nCurCmbIndex][nIndex] then
          Wnd_Hide(self.UIGROUP, self.PAGE_SET[i][self.BGLst_ItemInfo])
          Wnd_Hide(self.UIGROUP, self.PAGE_SET[i][self.Txt_TaskInfo])
          Wnd_Hide(self.UIGROUP, self.PAGE_SET[i][self.Btn_Task])
        else
          Wnd_Show(self.UIGROUP, self.PAGE_SET[i][self.BGLst_ItemInfo])
          Wnd_Show(self.UIGROUP, self.PAGE_SET[i][self.Txt_TaskInfo])
          Wnd_Show(self.UIGROUP, self.PAGE_SET[i][self.Btn_Task])
          tbItemEx = Task.TaskExp.tbItem[self.nCurCmbIndex][1]
          local tbTask_One = self.tbOtherTask[self.nCurCmbIndex][nIndex]
          Txt_SetTxt(self.UIGROUP, self.PAGE_SET[i][self.Txt_TaskInfo], string.format("%s%s%s%s", Lib:StrFillR(tbTask_One[1] .. "个", 12), Lib:StrFillR((tbTask_One[2] / 2) .. "星", 18), Lib:StrFillR(self:CalculateAword(self.nCurCmbIndex, tbTask_One[1], tbTask_One[2]) .. IVER_g_szBindCoinName_ST, 20), Lib:StrFillR(self:CalculateTime(tbTask_One[3]), 12)))
        end
      end
      Btn_SetTxt(self.UIGROUP, self.PAGE_SET[i][self.Btn_Task], "完成")
    else
      Wnd_SetEnable(self.UIGROUP, self.ComBoxItem, 0)
      if not self.tbMyTask[nIndex] then
        Wnd_Hide(self.UIGROUP, self.PAGE_SET[i][self.BGLst_ItemInfo])
        Wnd_Hide(self.UIGROUP, self.PAGE_SET[i][self.Txt_TaskInfo])
        Wnd_Hide(self.UIGROUP, self.PAGE_SET[i][self.Btn_Task])
      else
        Wnd_Show(self.UIGROUP, self.PAGE_SET[i][self.BGLst_ItemInfo])
        Wnd_Show(self.UIGROUP, self.PAGE_SET[i][self.Txt_TaskInfo])
        Wnd_Show(self.UIGROUP, self.PAGE_SET[i][self.Btn_Task])
        tbItemEx = Task.TaskExp.tbItem[self.tbMyTask[nIndex][1]][1]
        Txt_SetTxt(self.UIGROUP, self.PAGE_SET[i][self.Txt_TaskInfo], string.format("%s%s%s%s", Lib:StrFillR(self.tbMyTask[nIndex][3] .. "个", 12), Lib:StrFillR((self.tbMyTask[nIndex][4] / 2) .. "星", 18), Lib:StrFillR(self:CalculateAword(self.tbMyTask[nIndex][1], self.tbMyTask[nIndex][3], self.tbMyTask[nIndex][4]) .. IVER_g_szBindCoinName_ST, 20), Lib:StrFillR(self:CalculateTime(self.tbMyTask[nIndex][5]), 12)))
      end
      Btn_SetTxt(self.UIGROUP, self.PAGE_SET[i][self.Btn_Task], "取消")
    end
    local pItem = nil
    if tbItemEx and tbItemEx[1] then
      pItem = KItem.CreateTempItem(tonumber(tbItemEx[1]), tonumber(tbItemEx[2]), tonumber(tbItemEx[3]), tonumber(tbItemEx[4]))
    end
    if pItem then
      ObjMx_AddObject(self.UIGROUP, self.PAGE_SET[i][self.Obj_TaskItem], Ui.CGOG_ITEM, pItem.nIndex, 0, 0)
    end
  end

  --左边发布信息

  Txt_SetTxt(self.UIGROUP, self.Txt_Introduce, "\n1、点击发布任务按钮，只需填写需求数量选择星级即可完成收购任务发布。\n2、有其他玩家完成这个任务后，发布人将会收到与收购数量相同的物品。\n3、如果您想要完成别人发布的任务，在该任务后点击完成按钮，按照提示放入收购的物品，即可获得奖金。")

  local nCurCoin = 0
  local szMsg = string.format("\n平台中剩余发布点数：<color=yellow>%s<color>\n您目前拥有的%s数：<color=yellow>%s<color>\n您发布的任务数：<color=yellow>%s<color>", me.GetTask(2130, 4), IVER_g_szCoinName, me.nCoin, #self.tbMyTask)
  if IVER_g_nSdoVersion == 1 then
    szMsg = string.format("\n平台中剩余发布点数：<color=yellow>%s<color>\n您发布的任务数：<color=yellow>%s<color>", me.GetTask(2130, 4), #self.tbMyTask)
  end

  Txt_SetTxt(self.UIGROUP, self.Txt_MyInfo, szMsg)

  --下拉菜单
  ClearComboBoxItem(self.UIGROUP, self.ComBoxItem)
  ComboBoxAddItem(self.UIGROUP, self.ComBoxItem, 0, "全部物品")
  for i = 1, #Task.TaskExp.tbItem do
    ComboBoxAddItem(self.UIGROUP, self.ComBoxItem, i, Task.TaskExp.tbItem[i][2])
  end
end

function uiExpTask:OnButtonClick(szWnd, nParam)
  if szWnd == self.BtnClose then
    UiManager:CloseWindow(Ui.UI_EXPTASK)
  elseif szWnd == self.BtnFaBuTask then
    if GetTime() - self.nCaoZTime < self.nJianGeTime then
      UiManager:OpenWindow(Ui.UI_INFOBOARD, "请不要过快操作！")
    else
      UiManager:OpenWindow(Ui.UI_FABUTASK)
      self.nCaoZTime = GetTime()
    end
  elseif szWnd == self.BtnOtherTask then
    self.FLAG_VIEW = 1
    self.nNumPage = 1
    self:UpdateTask()
  elseif szWnd == self.BtnMyTask then
    self.FLAG_VIEW = 2
    self.nNumPage = 1
    self:UpdateTask()
  elseif szWnd == self.Btn_Up then
    self:UpPage()
  elseif szWnd == self.Btn_Down then
    self:DownPage()
  elseif szWnd == self.BtnGBListCountSort then
    self.nCountSort = 1 - self.nCountSort
    if self.nCountSort == 0 then
      Img_SetImage(self.UIGROUP, self.BtnGBListCountSort, 1, "\\image\\ui\\001a\\auction\\auctionstarsortbtn0.spr")
    else
      Img_SetImage(self.UIGROUP, self.BtnGBListCountSort, 1, "\\image\\ui\\001a\\auction\\auctionstarsortbtn.spr")
    end
    self:SortList(1, self.nCountSort)
  elseif szWnd == self.BtnGBListXingSort then
    self.nXingSort = 1 - self.nXingSort
    if self.nXingSort == 0 then
      Img_SetImage(self.UIGROUP, self.BtnGBListXingSort, 1, "\\image\\ui\\001a\\auction\\auctionstarsortbtn0.spr")
    else
      Img_SetImage(self.UIGROUP, self.BtnGBListXingSort, 1, "\\image\\ui\\001a\\auction\\auctionstarsortbtn.spr")
    end
    self:SortList(2, self.nXingSort)
  elseif szWnd == self.BtnGBListBonusSort then
    self.nCoinSort = 1 - self.nCoinSort
    if self.nCoinSort == 0 then
      Img_SetImage(self.UIGROUP, self.BtnGBListBonusSort, 1, "\\image\\ui\\001a\\auction\\auctionstarsortbtn0.spr")
    else
      Img_SetImage(self.UIGROUP, self.BtnGBListBonusSort, 1, "\\image\\ui\\001a\\auction\\auctionstarsortbtn.spr")
    end
    self:SortList(3, self.nCoinSort)
  else
    for i, tbInfo in pairs(self.PAGE_SET) do
      if szWnd == tbInfo[self.Btn_Task] then
        self:ChangeTaskState(i)
      end
    end
  end
end

--翻下页
function uiExpTask:DownPage()
  self.nNumPage = self.nNumPage + 1
  if self.nNumPage > self.nTotalPage then
    self.nNumPage = self.nTotalPage
  end
  self:UpdateTask()
end

--翻上页
function uiExpTask:UpPage()
  self.nNumPage = self.nNumPage - 1
  if self.nNumPage <= 0 then
    self.nNumPage = 1
  end
  self:UpdateTask()
end

--完成任务或者取消
function uiExpTask:ChangeTaskState(nNum)
  if GetTime() - self.nCaoZTime < self.nJianGeTime then
    UiManager:OpenWindow(Ui.UI_INFOBOARD, "请不要过快操作！")
    return
  end
  if self.FLAG_VIEW == 1 then
    self:FinishTask(nNum)
  else
    self:CancelTask(nNum)
  end
  self.nCaoZTime = GetTime()
end

--完成任务
function uiExpTask:FinishTask(nNum)
  local nIndex = (self.nNumPage - 1) * self.NUM_PERPAGE_EVR + nNum
  if self.nCurCmbIndex == 0 then
    me.CallServerScript({ "ApplyFinishTask", self.tbTask[nIndex][1], self.tbTask[nIndex][2] })
  else
    me.CallServerScript({ "ApplyFinishTask", self.nCurCmbIndex, self.tbOtherTask[self.nCurCmbIndex][nIndex][5] })
  end
end

--取消任务
function uiExpTask:CancelTask(nNum)
  local nIndex = (self.nNumPage - 1) * self.NUM_PERPAGE_EVR + nNum
  me.CallServerScript({ "ApplyCanCelTask", self.tbMyTask[nIndex][1], self.tbMyTask[nIndex][2] })
end

--排序
function uiExpTask:SortList(nType, nTypeEx)
  local tbSortTable = {}
  if self.FLAG_VIEW == 1 then
    if self.nCurCmbIndex == 0 then
      tbSortTable = self.tbTask
      --Lib:ShowTB(tbSortTable)
    else
      tbSortTable = self.tbOtherTask[self.nCurCmbIndex]
    end
  else
    tbSortTable = self.tbMyTask
  end
  if nType < 3 then
    local nDev = 0
    if self.nCurCmbIndex == 0 then
      nDev = 2
    end
    if nTypeEx == 0 then
      table.sort(tbSortTable, function(a, b)
        return a[nType + nDev] > b[nType + nDev]
      end)
    else
      table.sort(tbSortTable, function(a, b)
        return a[nType + nDev] < b[nType + nDev]
      end)
    end
  else
    if self.nCurCmbIndex == 0 then
      if nTypeEx == 0 then
        table.sort(tbSortTable, function(a, b)
          return self:CalculateAword(a[1], a[3], a[4]) > self:CalculateAword(b[1], b[3], b[4])
        end)
      else
        table.sort(tbSortTable, function(a, b)
          return self:CalculateAword(a[1], a[3], a[4]) < self:CalculateAword(b[1], b[3], b[4])
        end)
      end
    else
      if nTypeEx == 0 then
        table.sort(tbSortTable, function(a, b)
          return self:CalculateAword(self.nCurCmbIndex, a[1], a[2]) > self:CalculateAword(self.nCurCmbIndex, b[1], b[2])
        end)
      else
        table.sort(tbSortTable, function(a, b)
          return self:CalculateAword(self.nCurCmbIndex, a[1], a[2]) < self:CalculateAword(self.nCurCmbIndex, b[1], b[2])
        end)
      end
    end
  end
  self:UpdateTask()
  return
end

--显示obj
function uiExpTask:OnObjHover(szWnd, uGenre, uId, nX, nY)
  local pItem = KItem.GetItemObj(uId)
  if pItem then
    Wnd_ShowMouseHoverInfo(self.UIGROUP, szWnd, pItem.GetCompareTip(Item.TIPS_BINDGOLD_SECTION))
  end
end

-- 下拉菜单改变
function uiExpTask:OnComboBoxIndexChange(szWnd, nIndex)
  if szWnd == self.ComBoxItem then
    self.nCurCmbIndex = nIndex
  end
  self:UpdateTask()
end

--计算花费金币
function uiExpTask:CalculateAword(nFormId, nCount, nXing)
  if not Task.TaskExp.tbItem[nFormId] then
    return 0
  end
  return (Task.TaskExp.tbItem[nFormId][3] + Task.TaskExp.tbItem[nFormId][4] * nXing) * nCount
end

function uiExpTask:CalculateTime(nTime)
  if not nTime or nTime <= 0 then
    return ""
  end
  local szTime = ""
  local nHour = math.floor(self.FABUTIME - (GetTime() - nTime) / 3600)
  szTime = string.format("%sH", nHour)
  if nHour <= 0 then
    nHour = math.floor(self.FABUTIME * 60 - (GetTime() - nTime) / 60)
    szTime = string.format("0.%sH", math.ceil(nHour / 6))
    if nHour <= 0 then
      nHour = math.floor(self.FABUTIME * 60 - (GetTime() - nTime) / 60)
      szTime = string.format("0.%sH", math.ceil(nHour / 6))
    end
  end
  return szTime
end

function uiExpTask:RegisterEvent()
  local tbRegEvent = {
    { UiNotify.emCOREEVENT_JBCOIN_CHANGED, self.UpdateTask },
  }
  return tbRegEvent
end
