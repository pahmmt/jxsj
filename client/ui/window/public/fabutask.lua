-- 文件名  : fabutask.lua
-- 创建者  : jiazhenwei
-- 创建时间: 2010-08-02 15:21:23
-- 描述    : 发布任务

local uiFaBuTask = Ui:GetClass("fabutask")

uiFaBuTask.MAXXING = 20 --最大星
uiFaBuTask.MINXING = 1 --最小星
uiFaBuTask.MAXCOUNT = 10 --最大数量
uiFaBuTask.nCurCmbIndex_Item = 1 --下拉菜单选项 物品
uiFaBuTask.nCurCmbIndex_Xing = 1 --下拉菜单选项 星
uiFaBuTask.nItemCount = 1 --收购的物品数目

--txt
uiFaBuTask.Txt_Infomation = "Txt_Infomation" --小提示
uiFaBuTask.Txt_CoinInfo = "Txt_CoinInfo" --金币信息
uiFaBuTask.Txt_Xing = "Txt_Xing" --星级

--combox
--uiFaBuTask.ComBox_Xing	= "ComBox_Xing";		--下拉菜单 星
uiFaBuTask.ComBox_Item = "ComBox_Item" --下拉菜单 物品

--edt
uiFaBuTask.Edt_Count = "Edt_Count" --编辑框  数目

--btn
uiFaBuTask.Btn_Ok = "Btn_Ok" --确认按钮
uiFaBuTask.Btn_CanCel = "Btn_CanCel" --取消按钮
uiFaBuTask.BtnClose = "BtnClose" --关闭按钮
uiFaBuTask.BtnInc = "BtnInc" --加
uiFaBuTask.BtnDec = "BtnDec" --减

function uiFaBuTask:OnOpen()
  self.nCurCmbIndex_Item = 1
  self.nCurCmbIndex_Xing = 1
  self.nItemCount = 1
  ComboBoxSelectItem(self.UIGROUP, self.ComBox_Item, 0)
  self:Update()
  --Txt_tishi
  TxtEx_SetText(self.UIGROUP, self.Txt_Infomation, string.format("1、每种物品都有一个基础价格。\n2、优先级每提升半星，收购物品单价增加一定%s。\n(星级越高您就可能比其他人更优先得到您想收购的物品)\n<color=yellow>3、合计%s=（物品基础价格+优先星级价格）* 收购数量<color>", IVER_g_szCoinName, IVER_g_szCoinName))
end

function uiFaBuTask:OnButtonClick(szWnd, nParam)
  if szWnd == self.BtnClose then
    UiManager:CloseWindow(Ui.UI_FABUTASK)
  elseif szWnd == self.Btn_Ok then
    if self:CheckFabuTask() == 1 then
      local tbMsg = {}
      tbMsg.szMsg = string.format("您将以<color=yellow>%s<color>星级收购<color=yellow>%s<color>个<color=yellow>%s<color>", self.nCurCmbIndex_Xing / 2, self.nItemCount, Task.TaskExp.tbItem[self.nCurCmbIndex_Item][2])
      tbMsg.nOptCount = 2
      local nCurCmbIndex_ItemEx = self.nCurCmbIndex_Item
      local nItemCountEx = self.nItemCount
      local nCurCmbIndex_XingEx = self.nCurCmbIndex_Xing
      function tbMsg:Callback(nOptIndex)
        if nOptIndex == 2 then
          me.CallServerScript({ "ApplyFaBuTask", nCurCmbIndex_ItemEx, nItemCountEx, nCurCmbIndex_XingEx })
          UiManager:CloseWindow(Ui.UI_FABUTASK)
        end
      end
      UiManager:OpenWindow(Ui.UI_MSGBOX, tbMsg)
    end
  elseif szWnd == self.Btn_CanCel then
    UiManager:CloseWindow(Ui.UI_FABUTASK)
  elseif szWnd == self.BtnInc then
    self:IncreaseXing()
  elseif szWnd == self.BtnDec then
    self:DecreaseXing()
  end
end

function uiFaBuTask:IncreaseXing()
  if self.nCurCmbIndex_Xing >= 20 then
    return
  end
  self.nCurCmbIndex_Xing = self.nCurCmbIndex_Xing + 1
  self:Update()
end

function uiFaBuTask:DecreaseXing()
  if self.nCurCmbIndex_Xing <= 1 then
    return
  end
  self.nCurCmbIndex_Xing = self.nCurCmbIndex_Xing - 1
  self:Update()
end

--检查输入和下拉框选择
function uiFaBuTask:CheckFabuTask()
  if self.nCurCmbIndex_Xing < 0 then
    self:OpenDialogEx("您没有选择星级！")
    return 0
  end
  if self.nCurCmbIndex_Item < 0 then
    self:OpenDialogEx("您没有选择要收购的物品！")
    return 0
  end
  if self.nItemCount <= 0 then
    self:OpenDialogEx("请输入收购的数量！")
    return 0
  end
  return 1
end

--提示信息
function uiFaBuTask:OpenDialogEx(szMsg)
  local tbMsg = {}
  tbMsg.szMsg = szMsg
  tbMsg.nOptCount = 1
  UiManager:OpenWindow(Ui.UI_MSGBOX, tbMsg)
  return 0
end

function uiFaBuTask:Update()
  --下拉菜单 物品
  ClearComboBoxItem(self.UIGROUP, self.ComBox_Item)
  for i = 1, #Task.TaskExp.tbItem do
    ComboBoxAddItem(self.UIGROUP, self.ComBox_Item, i, Task.TaskExp.tbItem[i][2])
  end

  --Txt_Xing
  Txt_SetTxt(self.UIGROUP, self.Txt_Xing, self.nCurCmbIndex_Xing / 2)

  --Txt_coin

  local szMsg = string.format("现有%s：<color=yellow>%s<color>", IVER_g_szCoinName, me.nCoin)
  if self.nCurCmbIndex_Xing <= 0 or self.nCurCmbIndex_Item <= 0 or self.nItemCount <= 0 then
    szMsg = string.format("合计%s: 0          ", IVER_g_szCoinName) .. szMsg
  else
    szMsg = string.format("合计%s: <color=yellow>%s<color>      ", IVER_g_szCoinName, self:CalculateAword(self.nCurCmbIndex_Item, self.nItemCount, self.nCurCmbIndex_Xing)) .. szMsg
  end

  -- 盛大版
  if IVER_g_nSdoVersion == 1 then
    local nCurPoint = me.GetTask(2130, 4)
    szMsg = string.format("现有发布点数：<color=yellow>%s<color>", nCurPoint)
    if self.nCurCmbIndex_Xing <= 0 or self.nCurCmbIndex_Item <= 0 or self.nItemCount <= 0 then
      szMsg = string.format("合计发布点数: 0          ") .. szMsg
    else
      szMsg = string.format("合计发布点数: <color=yellow>%s<color>      ", self:CalculateAword(self.nCurCmbIndex_Item, self.nItemCount, self.nCurCmbIndex_Xing)) .. szMsg
    end
  end

  Txt_SetTxt(self.UIGROUP, self.Txt_CoinInfo, szMsg)
end

-- 下拉菜单改变
function uiFaBuTask:OnComboBoxIndexChange(szWnd, nIndex)
  if szWnd == self.ComBox_Xing then
    self.nCurCmbIndex_Item = nIndex + 1
  end
  self:Update()
end

--edt
function uiFaBuTask:OnEditChange(szWnd, nParam)
  if szWnd == self.Edt_Count then
    local nMaxPlayer = Edt_GetInt(self.UIGROUP, self.Edt_Count)
    if nMaxPlayer and nMaxPlayer <= 10 then
      self.nItemCount = nMaxPlayer
    else
      Edt_SetTxt(self.UIGROUP, self.Edt_Count, 10)
      self.nItemCount = 10
    end
    self:Update()
  end
end

--计算花费金币
function uiFaBuTask:CalculateAword(nFormId, nCount, nXing)
  if not Task.TaskExp.tbItem[nFormId] or nCount <= 0 or nXing <= 0 then
    return 0
  end
  return (Task.TaskExp.tbItem[nFormId][3] + Task.TaskExp.tbItem[nFormId][4] * nXing) * nCount
end
