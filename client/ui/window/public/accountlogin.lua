local tbAccountLogin = Ui:GetClass("accountlogin")
local tbSaveData = Ui.tbLogic.tbSaveData
local tbMusic = Ui.tbLogic.tbMusic

tbAccountLogin.CHECK_VIRKEYBOARD = "VirtualKeyboard"
tbAccountLogin.CHECK_INVISIBLE = "Invisible"
tbAccountLogin.CHECK_REMBERACCOUNT = "Remember"
tbAccountLogin.CHECK_AGREE = "Agreement"
tbAccountLogin.EDIT_ACCOUNT = "Account"
tbAccountLogin.EDIT_PASSWORD = "Password"
tbAccountLogin.BUTTON_LOGIN = "Login"
tbAccountLogin.BUTTON_VIEWAGREE = "ViewAgreement"
tbAccountLogin.BUTTON_ECARD = "ECard"
tbAccountLogin.BUTTON_EKEY = "EKey"
tbAccountLogin.BUTTON_PASSPORT = "Passport"
tbAccountLogin.BUTTON_REGIST = "BtnRegist"
tbAccountLogin.BUTTON_FORGETPASS = "BtnForget"
tbAccountLogin.BUTTON_WEBHOME = "WebHome"
tbAccountLogin.BUTTON_EXIT = "ExitGame"
tbAccountLogin.BUTTON_SELSVR = "BtnSelSvr"
tbAccountLogin.BUTTON_PLAYREC = "BtnPlayRec"
tbAccountLogin.BUTTON_PAY = "BtnPay"
tbAccountLogin.BUTTON_SAFE = "BtnSafe"
tbAccountLogin.TXT_CURSVR = "TxtCurSvr"
tbAccountLogin.IMG_LOGINBG = "ImgLoginBg"
tbAccountLogin.BUTTON_YY_LOGIN = "BtnYyLogin"
tbAccountLogin.BUTTON_THEMEMUSIC = "BtnthemeMusic"

tbAccountLogin.IMG_YY_LOGINBG = "ImgYyLoginBg"
tbAccountLogin.BUTTON_YY_VIEWAGREE = "YyViewAgreement"
tbAccountLogin.CHECK_YY_INVISIBLE = "YyInvisible"
tbAccountLogin.CHECK_YY_AGREE = "YyAgreement"
tbAccountLogin.BUTTON_KS_LOGIN = "BtnKingsoftLogin"

-- todo Đại Phi chú ý sửa đổi địa chỉ liên kết cho nhiều phiên bản
tbAccountLogin.szAccountUrl = "https://pass.kingsoft.com/register-reg"
tbAccountLogin.szPwdUrl = "http://pass.kingsoft.com/ksgweb/jsp/login/password.jsp"
tbAccountLogin.szHomeUrl = "http://jxsj.xoyo.com"
tbAccountLogin.szEKeyUrl = "http://ekey.xoyo.com"
tbAccountLogin.szECardUrl = "http://ecard.xoyo.com"
tbAccountLogin.szLimitedUrl = "http://pass.kingsoft.com"
tbAccountLogin.szPayUrl = "http://pay.xoyo.com/recharge/select_channel/jxsj"
tbAccountLogin.szSafeUrl = "http://kefu.xoyo.com/index.php?act=help.index&type=zhaq"
tbAccountLogin.szIpFile = "\\setting\\misc\\iparea.txt"

-- Dùng để thiết lập tiêu điểm sau khi mở và đóng bàn phím ảo
local LASTFOCUS_ACCOUNT = 1
local LASTFOCUS_PASSWORD = 2

local tbTimer = Ui.tbLogic.tbTimer
local TIMER_TICK = 2 * Env.GAME_FPS -- Đơn vị nhỏ nhất của bộ đếm giờ, 1 giây
local CHECK_TIMER_TICK = 1 * Env.GAME_FPS -- Kiểm tra xem YY đã khởi tạo hoàn tất chưa

local tbLogin = Ui.tbLogic.tbLogin

-- Vị trí của YY Picture-in-Picture
local tbYyWindow = { a = { 267, 220 }, b = { 379, 258 }, c = { 490, 240 } }

tbAccountLogin.tbIpArea = nil

function tbAccountLogin:OnLoadIpFile()
  local tbFile = Lib:LoadTabFile(self.szIpFile)
  if not tbFile then
    return
  end
  self.tbIpArea = {}
  for nId, tbParam in ipairs(tbFile) do
    local nStart = tonumber(tbParam["START"])
    local nEnd = tonumber(tbParam["END"])
    self.tbIpArea[#self.tbIpArea + 1] = { nStart, nEnd }
  end
  table.sort(self.tbIpArea, function(a, b)
    return a[1] < b[2]
  end)
end

function tbAccountLogin:OnOpen(nLoginWay)
  if Flash_CheckVersion(10) == 0 then -- Yêu cầu tối thiểu flash10
    local tbMsg = { tbOptTitle = { "Xác nhận" } }
    tbMsg.szMsg = "Phiên bản Flash Player trên máy của bạn quá thấp, vui lòng truy cập www.adobe.com/cn/ để tải phiên bản Flash Player mới nhất."
    UiManager:OpenWindow(Ui.UI_MSG_PROCESSING, tbMsg)
  end

  -- Lấy trạng thái lựa chọn của nhân vật từ CPP: bàn phím ảo, đăng nhập ẩn, ghi nhớ tài khoản
  local bUseVirKeyboard, bInVisibleLogin, bRememberAccount, szAccount = GetPlayerChoise()
  -- Lấy trạng thái đồng ý thỏa thuận từ agreement
  Btn_Check(self.UIGROUP, self.CHECK_INVISIBLE, bInVisibleLogin)

  if szAccount ~= nil then -- Nếu có tài khoản, đặt tiêu điểm vào ô mật khẩu
    Edt_SetTxt(self.UIGROUP, self.EDIT_ACCOUNT, szAccount)
    Wnd_SetFocus(self.UIGROUP, self.EDIT_PASSWORD)
    self.nLastFocus = LASTFOCUS_PASSWORD
  else
    Wnd_SetFocus(self.UIGROUP, self.EDIT_ACCOUNT)
    self.nLastFocus = LASTFOCUS_ACCOUNT
  end

  Btn_Check(self.UIGROUP, self.CHECK_REMBERACCOUNT, bRememberAccount)

  if bUseVirKeyboard == 1 then
    Btn_Check(self.UIGROUP, self.CHECK_VIRKEYBOARD, bUseVirKeyboard)
    if self.nLastFocus == LASTFOCUS_PASSWORD then -- Nếu có tài khoản, đặt tiêu điểm vào ô mật khẩu
      AttachVirKeyboard(self.UIGROUP, self.EDIT_PASSWORD)
    else
      AttachVirKeyboard(self.UIGROUP, self.EDIT_ACCOUNT)
    end
  end
  -- Tùy chọn đồng ý thỏa thuận
  local bAgree = Ui.tbLogic.tbAgreementMgr:IsAgree()
  if bAgree == 1 then
    Btn_Check(self.UIGROUP, self.CHECK_AGREE, 1)
  else
    Btn_Check(self.UIGROUP, self.CHECK_AGREE, 0)
  end
  -- Thực hiện chức năng nút đăng nhập
  -- Bỏ nút hủy
  -- Thực hiện chức năng mở trang web

  -- Chọn máy chủ
  local szSvrTitle = GetLastSvrTitle() -- Nếu không có chuỗi thì sao, hiện hộp thoại chọn
  Txt_SetTxt(self.UIGROUP, self.TXT_CURSVR, szSvrTitle)

  --self:AutoSelSvr();			-- Đề cử chọn máy chủ
  self.nTimerId = tbTimer:Register(TIMER_TICK, self.OnTimer, self) -- Bật bộ đếm giờ

  self:ChangeLoginWay(tbLogin.nLoginWay)

  if MULTI_LOGINWAY then -- Nếu là client YY, hiển thị nút đăng nhập
    Wnd_Show(self.UIGROUP, self.BUTTON_YY_LOGIN)
  else
    Wnd_Hide(self.UIGROUP, self.BUTTON_YY_LOGIN)
  end

  self.nCheckYyTimerId = 0
  self.nInitCheckTimes = 0 -- Dùng để kiểm tra thời gian chờ khởi tạo YY
  -- Nếu không có tài khoản, hiện cửa sổ đăng ký
  --	if (szAccount == nil and MINI_CLIENT) then
  --		UiManager:OpenWindow(Ui.UI_QUICK_REGISTER);
  --	end
  if tbMusic.nCloseMusic == 1 then
    Img_SetFrame(self.UIGROUP, self.BUTTON_THEMEMUSIC, 4)
    SetMusicVolume(0)
  else
    Img_SetFrame(self.UIGROUP, self.BUTTON_THEMEMUSIC, 0)
    SetMusicVolume(tbMusic.nMusicVolum * 7)
  end
  local tbMusicEx = tbMusic.tbMusciList[tbMusic.nSelectNum]
  if tbMusicEx then
    PlayAMusic(tbMusicEx[2], 1)
  end
end

function tbAccountLogin:OnButtonClick(szWnd, nParam)
  if szWnd == self.CHECK_VIRKEYBOARD then
    local bCheck = Btn_GetCheck(self.UIGROUP, self.CHECK_VIRKEYBOARD)
    if bCheck == 1 then
      self:OpenVirKeyboard()
    else
      AttachVirKeyboard() -- Tắt bàn phím ảo
    end
    SetUseVirKeyboard(bCheck)
  elseif szWnd == self.BUTTON_LOGIN then -- Nút đăng nhập
    if Btn_GetCheck(self.UIGROUP, self.CHECK_AGREE) ~= 1 then
      local tbMsg = { szMsg = "Để đăng nhập Kiếm Thế, bạn phải đồng ý với thỏa thuận." }
      UiManager:OpenWindow(Ui.UI_MSG_PROCESSING, tbMsg)
      return
    end
    self:Login()
  elseif szWnd == self.BUTTON_VIEWAGREE or szWnd == self.BUTTON_YY_VIEWAGREE then -- Nút xem thỏa thuận
    UiManager:CloseWindow(self.UIGROUP)
    SetLoginStatus(Ui.tbLogic.tbLogin.emLOGINSTATUS_AGREE)
  elseif szWnd == self.CHECK_REMBERACCOUNT then
    local bCheck = Btn_GetCheck(self.UIGROUP, self.CHECK_REMBERACCOUNT)
    SetRememberAccount(bCheck)
  elseif szWnd == self.CHECK_INVISIBLE then
    local bCheck = Btn_GetCheck(self.UIGROUP, self.CHECK_INVISIBLE)
    SetInVisibleLogin(bCheck)
  elseif szWnd == self.CHECK_YY_INVISIBLE then
    local bCheck = Btn_GetCheck(self.UIGROUP, self.CHECK_YY_INVISIBLE)
    SetInVisibleLogin(bCheck)
  elseif szWnd == self.CHECK_AGREE then
    local bCheck = Btn_GetCheck(self.UIGROUP, self.CHECK_AGREE)
    Ui.tbLogic.tbAgreementMgr:SetAgree(bCheck)
  elseif szWnd == self.CHECK_YY_AGREE then
    local bCheck = Btn_GetCheck(self.UIGROUP, self.CHECK_YY_AGREE)
    Ui.tbLogic.tbAgreementMgr:SetAgree(bCheck)
  elseif szWnd == self.BUTTON_ECARD then
    ShellExecute(self.szECardUrl)
  elseif szWnd == self.BUTTON_EKEY then
    ShellExecute(self.szEKeyUrl)
  elseif szWnd == self.BUTTON_PASSPORT then
    ShellExecute(self.szLimitedUrl)
  elseif szWnd == self.BUTTON_REGIST then
    --ShellExecute(self.szAccountUrl);
    UiManager:OpenWindow(Ui.UI_QUICK_REGISTER)
  elseif szWnd == self.BUTTON_FORGETPASS then
    ShellExecute(self.szPwdUrl)
  elseif szWnd == self.BUTTON_WEBHOME then
    ShellExecute(self.szHomeUrl)
  elseif szWnd == self.BUTTON_PAY then
    ShellExecute(self.szPayUrl)
  elseif szWnd == self.BUTTON_SAFE then
    ShellExecute(self.szSafeUrl)
  elseif szWnd == self.BUTTON_PLAYREC then
    PlayRec()
  elseif szWnd == self.BUTTON_EXIT then
    Exit()
  elseif szWnd == self.BUTTON_SELSVR then -- Mở cửa sổ chọn máy chủ, không đóng cửa sổ hiện tại, nếu không sẽ mất tài khoản và mật khẩu
    UiManager:OpenWindow(Ui.UI_SELECT_SERVER, 0)
  elseif szWnd == self.BUTTON_KS_LOGIN then -- Chuyển sang đăng nhập Kingsoft
    self:ChangeLoginWay(tbLogin.LOGINWAY_KS)
  elseif szWnd == self.BUTTON_YY_LOGIN then -- Chuyển sang đăng nhập YY
    self:ChangeLoginWay(tbLogin.LOGINWAY_YY)
  elseif szWnd == self.BUTTON_THEMEMUSIC then
    self:ChangeMusic()
  end
end

function tbAccountLogin:OnEditFocus(szWndName)
  if szWndName == self.EDIT_ACCOUNT then
    self.nLastFocus = LASTFOCUS_ACCOUNT
  elseif szWndName == self.EDIT_PASSWORD then
    self.nLastFocus = LASTFOCUS_PASSWORD
  end
  if Btn_GetCheck(self.UIGROUP, self.CHECK_VIRKEYBOARD) == 1 then -- Nếu bàn phím ảo đang mở
    self:OpenVirKeyboard()
  end
  --print(Edt_GetTxt(self.UIGROUP, self.EDIT_PASSWORD));
end

-- Mở bàn phím ảo, dựa vào trạng thái, gán vào ô nhập liệu cần thiết
function tbAccountLogin:OpenVirKeyboard()
  if self.nLastFocus == LASTFOCUS_PASSWORD then -- Nếu có tài khoản, đặt tiêu điểm vào ô mật khẩu
    AttachVirKeyboard(self.UIGROUP, self.EDIT_PASSWORD)
  else
    AttachVirKeyboard(self.UIGROUP, self.EDIT_ACCOUNT)
  end
end

function tbAccountLogin:OnSpecialKeyDown(szWndName, nParam)
  if szWndName == self.EDIT_ACCOUNT then
    if (nParam == Ui.MSG_VK_TAB) or (nParam == Ui.MSG_VK_RETURN) then
      Wnd_SetFocus(self.UIGROUP, self.EDIT_PASSWORD)
    end
  elseif szWndName == self.EDIT_PASSWORD then
    if nParam == Ui.MSG_VK_TAB then
      Wnd_SetFocus(self.UIGROUP, self.EDIT_ACCOUNT)
    elseif nParam == Ui.MSG_VK_RETURN then
      self:Login()
    end
  end
end

-- Thao tác sau khi nhấn nút đăng nhập
function tbAccountLogin:Login()
  local tbMsg = { tbOptTitle = { "Xác nhận" } }
  local bRet, szMsg = self:CheckCanLogin()
  if bRet == 0 then
    tbMsg.szMsg = szMsg
    UiManager:OpenWindow(Ui.UI_MSG_PROCESSING, tbMsg)
    return
  end
  local szPlayerAccount = Edt_GetTxt(self.UIGROUP, self.EDIT_ACCOUNT)
  if szPlayerAccount then
    szPlayerAccount = string.lower(szPlayerAccount)
  end
  bRet = PreLoginSecret(self.UIGROUP, self.EDIT_PASSWORD, szPlayerAccount)
  if bRet == 0 then
    tbMsg.szMsg = "Đăng nhập thất bại: Lưu tài khoản bất thường."
    UiManager:OpenWindow(Ui.UI_MSG_PROCESSING, tbMsg)
    return
  end
  local szSvrTitle = Txt_GetTxt(self.UIGROUP, self.TXT_CURSVR)
  if szSvrTitle == "" then -- Nếu chưa chọn máy chủ thì chọn
    UiManager:OpenWindow(Ui.UI_SELECT_SERVER, 1)
    return
  end

  local nStart, nEnd = string.find(szSvrTitle, "Mới mở")
  if nStart and nStart > 0 then
    szSvrTitle = string.sub(szSvrTitle, 1, nStart - 1)
  end

  local nStart, nEnd = string.find(szSvrTitle, "Đề cử")
  if nStart and nStart > 0 then
    szSvrTitle = string.sub(szSvrTitle, 1, nStart - 1)
  end
  if self:LimitLogin(szSvrTitle) == 0 then
    return
  end
  bRet = AccountLoginSecret(szSvrTitle)

  UiManager:CloseWindow(self.UIGROUP)
end

function tbAccountLogin:LimitLogin(szSvrTitle)
  local nFlag = 0
  for _, tbTitle in ipairs(Ui.tbLogic.tbLogin.tbLimitLogin_YY) do
    if string.find(szSvrTitle, tbTitle[1]) and string.find(szSvrTitle, tbTitle[2]) then
      nFlag = 1
      break
    end
  end
  if nFlag == 0 and Ui.tbLogic.tbLogin.nLoginWay == Ui.tbLogic.tbLogin.LOGINWAY_YY then
    local tbMsg = {
      szMsg = "Máy chủ này chưa mở đăng nhập bằng tài khoản YY",
      tbOptTitle = { "Xác nhận" },
      Callback = Ui.tbLogic.tbLogin.OnGameIdle,
      CallbackSelf = Ui.tbLogic.tbLogin,
    }
    UiManager:OpenWindow(Ui.UI_MSG_PROCESSING, tbMsg)
    return 0
  end
  return 1
end

function tbAccountLogin:OnClose()
  if Btn_GetCheck(self.UIGROUP, self.CHECK_VIRKEYBOARD) == 1 then -- Tắt bàn phím ảo
    AttachVirKeyboard()
  end
  if self.nTimerId > 0 then
    tbTimer:Close(self.nTimerId)
    self.nTimerId = 0
  end
  if tbLogin.nLoginWay == tbLogin.LOGINWAY_YY then
    self:ShowYyWnd(0)
  end
end

function tbAccountLogin:CheckCanLogin()
  local szAccount = Edt_GetTxt(self.UIGROUP, self.EDIT_ACCOUNT)
  if szAccount == "" then
    return 0, "Vui lòng nhập tài khoản"
  end
  local szPassword = Edt_GetTxt(self.UIGROUP, self.EDIT_PASSWORD)
  if szPassword == "" then
    return 0, "Vui lòng nhập mật khẩu"
  end
  return 1
end

function tbAccountLogin:UpdateSelSvr()
  local szSvrTitle = GetLastSvrTitle() -- Nếu không có chuỗi thì sao, hiện hộp thoại chọn
  Txt_SetTxt(self.UIGROUP, self.TXT_CURSVR, szSvrTitle)
end

function tbAccountLogin:OnTimer()
  local nBet = self:AutoSelSvr()
  if nBet == 0 then
    if self.nTimerId > 0 then
      tbTimer:Close(self.nTimerId)
      self.nTimerId = 0
    end
    return nBet
  end
  return nBet
end

function tbAccountLogin:CheckIpArea(szIp)
  local nResult = 1
  local nIp = 0
  local szLastIp = szIp
  local nStart, nEnd = string.find(szLastIp, "%.")
  local szSubStr = string.sub(szIp, 1, nStart - 1)
  szLastIp = string.sub(szLastIp, nEnd + 1)
  nIp = KLib.SetByte(nIp, 4, tonumber(szSubStr))

  nStart, nEnd = string.find(szLastIp, "%.")
  szSubStr = string.sub(szLastIp, 1, nStart - 1)
  szLastIp = string.sub(szLastIp, nEnd + 1)
  nIp = KLib.SetByte(nIp, 3, tonumber(szSubStr))

  nStart, nEnd = string.find(szLastIp, "%.")
  szSubStr = string.sub(szLastIp, 1, nStart - 1)
  szLastIp = string.sub(szLastIp, nEnd + 1)
  nIp = KLib.SetByte(nIp, 2, tonumber(szSubStr))

  nIp = KLib.SetByte(nIp, 1, tonumber(szLastIp))

  for i, tbIp in pairs(self.tbIpArea) do
    if nIp >= tbIp[1] and nIp <= tbIp[2] then
      nResult = 2
      break
    end

    if nIp < tbIp[1] then
      break
    end
  end

  return nResult
end

function tbAccountLogin:GetOutIp()
  return GetOutIp()
end

-- Tự động chọn máy chủ
function tbAccountLogin:AutoSelSvr(nSelAutoSvrFlag)
  -- Phiên bản tạm thời cho máy chủ thử nghiệm
  local szLastSvrTitle = GetLastSvrTitle()
  if szLastSvrTitle == "" or (nSelAutoSvrFlag and nSelAutoSvrFlag == 1) then
    local _, tbRealRegion = GetServerList(2)
    if not self.tbIpArea then
      self:OnLoadIpFile()
    end

    local szIp = self:GetOutIp()
    if not szIp then
      return
    end
    local nIpArea = self:CheckIpArea(szIp)
    local tbTuijian = {}
    for i, tbInfoList in pairs(tbRealRegion or {}) do
      for j, tbInfo in pairs(tbInfoList) do
        if KLib.BitOperate(tbInfo.ServerType, "&", 2) == 2 then
          tbTuijian[#tbTuijian + 1] = tbInfo
        end
      end
    end
    local tbRank = {
      ["Tốt"] = 1,
      ["Đông"] = 2,
      ["Đầy"] = 3,
    }
    local tbSortState = {}
    if tbTuijian and #tbTuijian > 0 then
      for _, tbSvr in ipairs(tbTuijian) do
        if type(tbSvr) == "table" then
          local tbInfo = {}
          tbInfo.szTitle = tbSvr.Title
          local nState = 4
          if tbRank[tbSvr.State] then
            nState = tbRank[tbSvr.State]
          end
          tbInfo.nState = nState
          local nFlag = 1
          local nS, nE = string.find(tbSvr.Title, "Netcom")
          if nS and nS > 0 then
            nFlag = 2
          end

          if nFlag == nIpArea then
            tbSortState[#tbSortState + 1] = tbInfo
          end
        end
      end
      table.sort(tbSortState, function(a, b)
        return a.nState < b.nState
      end)
      if tbSortState[1] and tbSortState[1].szTitle then
        SetLastSvrTitle(tbSortState[1].szTitle)
        self:UpdateSelSvr()
      end
    end
  else
    local szTitle = GetLastSvrTitle()
    local _, tbRealRegion = GetServerList()
    for i, tbInfoList in pairs(tbRealRegion) do
      if type(tbInfoList) == "table" then
        for j, tbInfo in pairs(tbInfoList) do
          if tbInfo.Title == szTitle then
            return 0
          end
        end
      end
    end
    Txt_SetTxt(self.UIGROUP, self.TXT_CURSVR, "")
    self:AutoSelSvr(1)
    return 0
  end
  return
end

-- Thiết lập tài khoản người dùng
function tbAccountLogin:SetAccount(szAccount)
  Edt_SetTxt(self.UIGROUP, self.EDIT_ACCOUNT, szAccount)
  Wnd_SetFocus(self.UIGROUP, self.EDIT_PASSWORD)
  self.nLastFocus = LASTFOCUS_PASSWORD
end

-- Bắt đầu quy trình đăng nhập YY, kết nối bishop
function tbAccountLogin:YyBeginLogin()
  local szSvrTitle = GetLastSvrTitle()
  if szSvrTitle == "" then -- Nếu chưa chọn máy chủ thì chọn
    UiManager:OpenWindow(Ui.UI_SELECT_SERVER, 3)
    return
  end
  local bRet = ConnectGateway(szSvrTitle)
  if bRet == 0 then
    local tbMsg = {
      szMsg = "Đăng nhập thất bại: Nguyên nhân không xác định.",
      tbOptTitle = { "Xác nhận" },
      Callback = tbLoginLogic.OnGameIdle,
      CallbackSelf = tbLoginLogic,
    }
    UiManager:OpenWindow(Ui.UI_MSG_PROCESSING, tbMsg)
    return
  end
  UiManager:CloseWindow(self.UIGROUP)
end

function tbAccountLogin:ShowYyWnd(bShow)
  if bShow == 1 then
    YY_SetShow(0)
    YY_SetMsgShow(0)
    return YY_SetShowOpenID(1, unpack(tbYyWindow[Ui.szMode] or { 258, 190 }))
  else
    YY_SetShow(0)
    YY_SetMsgShow(0)
    return YY_SetShowOpenID(0)
  end
end

function tbAccountLogin:OnCheckYyInit()
  -- Kiểm tra xem có thể gọi giao diện không, nếu có thì đóng cửa sổ xử lý, nếu không thì tiếp tục chờ
  self.nInitCheckTimes = self.nInitCheckTimes + 1
  if YY_SetShowMouse(0) ~= 0 then -- Chứng tỏ chưa hoàn tất khởi tạo, hiển thị giao diện chờ
    if self.nInitCheckTimes >= 30 then -- 30 giây chờ
      if self.nCheckYyTimerId > 0 then
        tbTimer:Close(self.nCheckYyTimerId)
        self.nCheckYyTimerId = 0
      end
      self.nInitCheckTimes = 0
      local tbMsg = {
        szMsg = "Khởi tạo YY Picture-in-Picture thất bại, sẽ chuyển sang đăng nhập bằng tài khoản Kingsoft.",
        tbOptTitle = { "Xác nhận" },
        Callback = self.ChangeLoginWay,
        CallbackSelf = self,
      }
      UiManager:OpenWindow(Ui.UI_MSG_PROCESSING, tbMsg, tbLogin.LOGINWAY_KS)
    end
    return
  else
    UiManager:CloseWindow(Ui.UI_MSG_PROCESSING)
    self:ShowYyLoginBg(1)
    -- Thiết lập một bộ đếm giờ để đóng hộp thoại
    if self.nCheckYyTimerId > 0 then
      tbTimer:Close(self.nCheckYyTimerId)
      self.nCheckYyTimerId = 0
    end
  end
end

function tbAccountLogin:InitYyLogin()
  local nRet = tbLogin:SetLoginWay(tbLogin.LOGINWAY_YY)
  if nRet == 0 then -- Chuyển đổi thành công, hiển thị picture-in-picture
    if YY_SetShowMouse(0) ~= 0 then -- Chứng tỏ chưa hoàn tất khởi tạo, hiển thị giao diện chờ
      local tbMsg = { szMsg = "Đang khởi tạo YY voice...", nOptCount = 0 }
      UiManager:OpenWindow(Ui.UI_MSG_PROCESSING, tbMsg)
      -- Thiết lập một bộ đếm giờ để đóng hộp thoại
      self.nCheckYyTimerId = tbTimer:Register(CHECK_TIMER_TICK, self.OnCheckYyInit, self) -- Bật bộ đếm giờ
      return
    else
      self:ShowYyLoginBg(1)
    end
    return
  elseif nRet == -1 then -- Khởi tạo YYAGENT thất bại, quay lại đăng nhập Kingsoft
    -- Thông báo cho người dùng, chuyển sang đăng nhập Kingsoft
    local tbMsg = {
      szMsg = "Kết nối máy chủ xác thực thất bại, chuyển sang đăng nhập bằng tài khoản Kingsoft.",
      tbOptTitle = { "Xác nhận" },
      Callback = self.ChangeLoginWay,
      CallbackSelf = self,
    }
    UiManager:OpenWindow(Ui.UI_MSG_PROCESSING, tbMsg, tbLogin.LOGINWAY_KS)
    return
  else -- Bất thường, quay lại đăng nhập Kingsoft
    local tbMsg = {
      szMsg = "Khởi tạo YY Picture-in-Picture thất bại, chuyển sang đăng nhập bằng tài khoản Kingsoft.",
      tbOptTitle = { "Xác nhận" },
      Callback = self.ChangeLoginWay,
      CallbackSelf = self,
    }
    UiManager:OpenWindow(Ui.UI_MSG_PROCESSING, tbMsg, tbLogin.LOGINWAY_KS)
    return
  end
end

function tbAccountLogin:ChangeLoginWay(nLoginWay)
  if nLoginWay == tbLogin.LOGINWAY_KS then
    if tbLogin.nLoginWay == tbLogin.LOGINWAY_YY then
      Edt_SetTxt(self.UIGROUP, self.EDIT_ACCOUNT, "")
      Wnd_SetFocus(self.UIGROUP, self.EDIT_ACCOUNT)
      self.nLastFocus = LASTFOCUS_ACCOUNT
    end
    -- Tắt cờ client YY
    local nRet = tbLogin:SetLoginWay(tbLogin.LOGINWAY_KS)
    if nRet ~= 0 then
      return
    end
    -- Ẩn picture-in-picture
    self:ShowYyLoginBg(0)
    -- Hiển thị nút nạp thẻ
    Wnd_Show(self.UIGROUP, self.BUTTON_PAY)

    -- Hiển thị đăng nhập tài khoản Kingsoft
    Wnd_Show(self.UIGROUP, self.IMG_LOGINBG)
    Wnd_Hide(self.UIGROUP, self.IMG_YY_LOGINBG)
    -- Đồng bộ trạng thái lựa chọn hiện tại
    local bCheck = GetInvisibleLogin()
    Btn_Check(self.UIGROUP, self.CHECK_INVISIBLE, bCheck)
    local bAgree = Ui.tbLogic.tbAgreementMgr:IsAgree()
    Btn_Check(self.UIGROUP, self.CHECK_AGREE, bAgree)
  elseif nLoginWay == tbLogin.LOGINWAY_YY then
    Wnd_Hide(self.UIGROUP, self.IMG_LOGINBG)
    Wnd_Hide(self.UIGROUP, self.BUTTON_PAY)
    if YY_Update() == 0 then
      -- Quay lại đăng nhập Kingsoft
      local tbMsg = {
        szMsg = "Cập nhật YY thất bại, chuyển sang đăng nhập bằng tài khoản Kingsoft.",
        tbOptTitle = { "Xác nhận" },
        Callback = self.ChangeLoginWay,
        CallbackSelf = self,
      }
      UiManager:OpenWindow(Ui.UI_MSG_PROCESSING, tbMsg, tbLogin.LOGINWAY_KS)
      return
    end
    -- Ở đây chỉ đánh dấu phương thức đăng nhập, không thực sự khởi tạo YY
    tbLogin:SetLoginWay(tbLogin.LOGINWAY_YY, 1)
    -- Hiển thị giao diện cập nhật
    UiManager:OpenWindow(Ui.UI_YY_UPDATE)
  end
end

-- Hiển thị nền đăng nhập YY
function tbAccountLogin:ShowYyLoginBg(bShow)
  if bShow == 1 then
    if self:ShowYyWnd(1) ~= 0 then
      return self:ChangeLoginWay(tbLogin.LOGINWAY_KS)
    end
    YY_SetShowMouse(0)
    Wnd_Show(self.UIGROUP, self.IMG_YY_LOGINBG)
    -- Đồng bộ trạng thái lựa chọn hiện tại
    local bCheck = GetInvisibleLogin()
    Btn_Check(self.UIGROUP, self.CHECK_YY_INVISIBLE, bCheck)
    local bAgree = Ui.tbLogic.tbAgreementMgr:IsAgree()
    Btn_Check(self.UIGROUP, self.CHECK_YY_AGREE, bAgree)
  else
    Wnd_Hide(self.UIGROUP, self.IMG_YY_LOGINBG)
    self:ShowYyWnd(0)
  end
end

-- Một số kiểm tra cần thiết trước khi đăng nhập YY
function tbAccountLogin:PreYyLogin()
  if Btn_GetCheck(self.UIGROUP, self.CHECK_YY_AGREE) ~= 1 then
    self:ShowYyLoginBg(0) -- Ẩn nền đăng nhập YY
    self:ShowYyWnd(0) -- Ẩn YY picture-in-picture trước, nếu không hộp thoại thông báo sẽ bị che
    local tbMsg = {
      szMsg = "Để đăng nhập Kiếm Thế, bạn phải đồng ý với thỏa thuận.",
      tbOptTitle = { "Xác nhận" },
      Callback = self.ShowYyLoginBg,
      CallbackSelf = self,
    }
    UiManager:OpenWindow(Ui.UI_MSG_PROCESSING, tbMsg, 1)
    return 0
  end
  Wnd_Hide(self.UIGROUP, self.IMG_YY_LOGINBG) -- Ẩn nền đăng nhập
  return 1
end

-- Đăng nhập YY quá thời gian
function tbAccountLogin:YyLoginFail(nErrCode)
  if tbLogin:GetLoginWay() == tbLogin.LOGINWAY_YY then
    Wnd_Show(self.UIGROUP, self.IMG_YY_LOGINBG) -- Hiển thị nền đăng nhập
  end
end

function tbAccountLogin:OnButtonRDown(szWndName)
  if szWndName == self.BUTTON_THEMEMUSIC then
    UiManager:OpenWindow(Ui.UI_THEMEMUSIC)
  end
end

function tbAccountLogin:OnButtonDown(szWndName)
  if szWndName == self.BUTTON_THEMEMUSIC then
    if tbMusic.nCloseMusic == 1 then
      Img_SetFrame(self.UIGROUP, self.BUTTON_THEMEMUSIC, 6)
    else
      Img_SetFrame(self.UIGROUP, self.BUTTON_THEMEMUSIC, 2)
    end
  end
end

function tbAccountLogin:OnMouseEnter(szWndName)
  if szWndName == self.BUTTON_THEMEMUSIC then
    if tbMusic.nCloseMusic == 1 then
      Img_SetFrame(self.UIGROUP, self.BUTTON_THEMEMUSIC, 5)
    else
      Img_SetFrame(self.UIGROUP, self.BUTTON_THEMEMUSIC, 1)
    end
  end
end

function tbAccountLogin:OnMouseLeave(szWndName)
  if szWndName == self.BUTTON_THEMEMUSIC then
    if tbMusic.nCloseMusic == 1 then
      Img_SetFrame(self.UIGROUP, self.BUTTON_THEMEMUSIC, 4)
    else
      Img_SetFrame(self.UIGROUP, self.BUTTON_THEMEMUSIC, 0)
    end
  end
end

function tbAccountLogin:ChangeMusic()
  if tbMusic.nCloseMusic == 0 then
    Img_SetFrame(self.UIGROUP, self.BUTTON_THEMEMUSIC, 4)
    SetMusicVolume(0)
    tbMusic.nCloseMusic = 1
  else
    Img_SetFrame(self.UIGROUP, self.BUTTON_THEMEMUSIC, 0)
    SetMusicVolume(tbMusic.nMusicVolum * 7)
    tbMusic.nCloseMusic = 0
  end
  local tbSaveSetting = {}
  tbSaveSetting.nCloseMusic = tbMusic.nCloseMusic
  tbSaveSetting.nMusicVolum = tbMusic.nMusicVolum
  tbSaveSetting.nSelectNum = tbMusic.nSelectNum
  tbSaveData:Save("ThemeSetting", tbSaveSetting)
end
