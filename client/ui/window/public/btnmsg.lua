-- 文件名　：btnmsg.lua
-- 创建者　：jiazhenwei
-- 创建时间：2012-11-08 09:13:34
-- 功能说明：按钮提醒机制

local uiBtnMsg = Ui:GetClass("btnmsg")
uiBtnMsg.Btn_Msg = "Btn_Msg"
function uiBtnMsg:Init()
  self.tbEvent = {}
  self.tbView = {}
end

function uiBtnMsg:OnOpen()
  self:UpDate()
end

function uiBtnMsg:OnButtonClick(szWnd, nParam)
  for i = 1, 3 do
    local nEventNum = self.tbView[i] --显示的跟具体的函数不一致
    local szBtn = self.Btn_Msg .. i
    if szWnd == szBtn and nEventNum and self.tbEvent[nEventNum] then
      loadstring(self.tbEvent[nEventNum][2])()
    end
  end
end

--注册打开一个图标（这里只是个内存注册，需要各自系统自己管理）
--szBtnPic: 按钮图标， tbBackFun：点击按钮后回调函数， nBackType：服务器回调1，客户端回调非1，bAction：图标闪动1 图标不闪动0
function uiBtnMsg:RegisterOpenBtn(szBtnPic, szBackFun, bAction)
  local nIndex = self:FindBlack(szBtnPic, szBackFun)
  if nIndex < 0 then
    return nIndex
  end
  self.tbEvent[nIndex] = { szBtnPic, szBackFun, bAction }
  self:UpDate()
  return nIndex
end

--反注册一个图标
function uiBtnMsg:UnRegisterOpenBtn(nRegisterId)
  if not self.tbEvent[nRegisterId] then
    return -1
  end
  self.tbEvent[nRegisterId] = nil
  self:UpDate()
  return 1
end

--更新界面
function uiBtnMsg:UpDate()
  self.tbView = {}
  local nViewNum = 1
  for i = 1, 3 do
    local tbEvent = self.tbEvent[i]
    if tbEvent then
      Wnd_Show(self.UIGROUP, self.Btn_Msg .. nViewNum)
      Img_SetImage(self.UIGROUP, self.Btn_Msg .. nViewNum, 1, tbEvent[1])
      if tbEvent[3] > 0 then
        Img_PlayAnimation(self.UIGROUP, self.Btn_Msg .. nViewNum, 1, 400)
      else
        Img_StopAnimation(self.UIGROUP, self.Btn_Msg .. nViewNum)
      end
      nViewNum = nViewNum + 1
      table.insert(self.tbView, i)
    end
  end
  --把剩下没有显示的空间置为不可用不可见
  for i = nViewNum, 3 do
    Img_StopAnimation(self.UIGROUP, self.Btn_Msg .. i)
    Wnd_Hide(self.UIGROUP, self.Btn_Msg .. i)
  end
end

function uiBtnMsg:FindBlack(szBtnPic, szBackFun)
  if Lib:CountTB(self.tbEvent) >= 3 then
    return -1
  end
  local nBlack = -1
  for i = 1, 3 do
    if self.tbEvent[i] and self.tbEvent[i][1] == szBtnPic and self.tbEvent[i][2] == szBackFun then
      return -1
    elseif not self.tbEvent[i] and nBlack <= 0 then
      nBlack = i
    end
  end
  return nBlack
end
