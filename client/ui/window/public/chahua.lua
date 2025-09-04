-------------------------------------------------------
----文件名		：	chahua.lua
----创建者		：	xuantao@kingsoft.com
----创建时间	：	2012/7/19 18:42:53
----功能描述	：	插画显示界面
--------------------------------------------------------

local uiWnd = Ui:GetClass("chahua")

uiWnd.WND_MAIN = "Main"
uiWnd.PROG_HEAD = "ProgHead" -- 顶部的幕布
uiWnd.PROG_FOOT = "ProgFoot" -- 底部的幕布
uiWnd.IMG_BODY = "ImgBody" -- 主体图片
uiWnd.TXT_TALK = "Z_Txt_Talk" -- 说话内容

uiWnd.tbImgPath = {
  ["a"] = "\\image\\ui\\002a\\chahua\\",
  ["b"] = "\\image\\ui\\002b\\chahua\\",
  ["c"] = "\\image\\ui\\002c\\chahua\\",
  ["d"] = "\\image\\ui\\002d\\chahua\\",
}

uiWnd.tbSteps = {
  [1] = { szFun = "Start", tbParam = {} },
  [2] = { szFun = "_CurtainUp", tbParam = {} },
  [3] = { szFun = "_FadeIn", tbParam = {} },
  [4] = { szFun = "_Talk", tbParam = {} },
  [5] = { szFun = "_Wait", tbParam = {} },
  [6] = { szFun = "_FadeOut", tbParam = {} },
  [7] = { szFun = "_CurtainClose", tbParam = {} },
  [8] = { szFun = "Finish", tbParam = {} },
}

function uiWnd:OnCreate()
  self.nCurStep = 1
  self.nLoops = 1
  self.bPenetrate = 0 -- 是否穿透
end

-- tbParam 参数
-- tbCallBack 结束时回调
function uiWnd:OnOpen(tbParam, tbCallBack)
  tbParam = tbParam or {}

  tbParam.nOpenTime = tbParam.nOpenTime or 400 -- 幕布开启时间
  tbParam.nCloseTime = tbParam.nCloseTime or 400 -- 幕布关闭时间
  tbParam.nFadeinTime = tbParam.nFadeinTime or 1000 -- 主题淡入时间
  tbParam.nFadeoutTime = tbParam.nFadeoutTime or 1000 -- 主体淡出时间
  tbParam.nLastTime = tbParam.nLastTime or 3000 -- 持续时间，一切开始工作都做好了的持续时间
  tbParam.szImage = tbParam.szImage or "" -- 主体图片
  tbParam.szTalk = tbParam.szTalk or "" -- 说话内容
  tbParam.bPenetrate = tbParam.bPenetrate or 0 -- 是否窗口穿透
  self.nLoops = tbParam.nLoops or 1 -- 循环次数
  self.bPenetrate = tbParam.bPenetrate

  self.tbCallBack = tbCallBack
  -- 开始
  self.tbSteps[1].tbParam = { tbParam.szImage, tbParam.bPenetrate }
  -- 开幕
  self.tbSteps[2].tbParam = { tbParam.nOpenTime }
  -- 淡入
  self.tbSteps[3].tbParam = { tbParam.nFadeinTime }
  -- 对话
  self.tbSteps[4].tbParam = { tbParam.szTalk }
  -- 持续时间
  self.tbSteps[5].tbParam = { tbParam.nLastTime }
  -- 淡出
  self.tbSteps[6].tbParam = { tbParam.nFadeoutTime }
  -- 闭幕
  self.tbSteps[7].tbParam = { tbParam.nCloseTime }
  -- 结束
  self.tbSteps[8].tbParam = {}

  --Lib:ShowTB(tbParam);

  if 1 ~= UiManager:WindowVisible(Ui.UI_GUTMODEL) then
    UiManager:SwitchUiModel(2)
  end

  if 0 == self.bPenetrate then
    Wnd_SetExclusive(self.UIGROUP, "Main", 1)
  end

  self.nCurStep = 1
  self:MoveStep()
end

function uiWnd:OnClose()
  if 0 == self.bPenetrate then
    Wnd_SetExclusive(self.UIGROUP, "Main", 0)
  end

  if 1 ~= UiManager:WindowVisible(Ui.UI_GUTMODEL) then
    UiManager:SwitchUiModel(0)
  end
  if self.tbCallBack then
    Lib:CallBack(self.tbCallBack)
  end

  self.tbCallBack = nil
  self.bPenetrate = 0
  self.nLoops = 0
end

function uiWnd:OnButtonClick(szWnd) end

function uiWnd:OnFadeinStarted(szWnd) end

function uiWnd:OnFadeinFinished(szWnd)
  if szWnd == self.IMG_BODY then
    self:MoveStep()
  end
end

function uiWnd:OnProgressFull(szWnd)
  if szWnd == self.PROG_FOOT then
    self:MoveStep()
  end
end

function uiWnd:MoveStep()
  if not self.tbSteps[self.nCurStep] then
    return
  end

  local szFun = self.tbSteps[self.nCurStep].szFun
  local tbParam = self.tbSteps[self.nCurStep].tbParam

  self.nCurStep = self.nCurStep + 1
  self[szFun](self, unpack(tbParam))
end

function uiWnd:GetImage(szImg)
  local szMode = GetUiMode()
  local szPath = self.tbImgPath[szMode]
  if not szPath or not szImg then
    return
  end

  return szPath .. szImg
end
-- 开始
function uiWnd:Start(szImg, bPenetrate)
  local szRealImage = self:GetImage(szImg)
  Img_SetImage(self.UIGROUP, self.IMG_BODY, 1, szRealImage or "")

  Txt_SetTxt(self.UIGROUP, self.TXT_TALK, "")
  Wnd_SetAlpha(self.UIGROUP, self.IMG_BODY, 0)
  Wnd_SetPenetrate(self.UIGROUP, "Main", bPenetrate)
  self:MoveStep()
end
-- 开幕
function uiWnd:_CurtainUp(nTime)
  if nTime <= 0 then
    self:MoveStep()
    return 0
  end
  Prg_SetTime(self.UIGROUP, self.PROG_HEAD, nTime, 0)
  Prg_SetTime(self.UIGROUP, self.PROG_FOOT, nTime, 0)
end
-- 淡入
function uiWnd:_FadeIn(nTime)
  Wnd_FadeIn(self.UIGROUP, self.IMG_BODY, 0, 255, nTime)
end
-- 对话

-- Bổ sung 2 helper functions (giống như trong guttalk_ui.lua)
function uiWnd:GetUTF8CharLength(byte)
  if byte < 128 then
    return 1 -- ASCII
  elseif byte < 224 then
    return 2 -- 2-byte UTF-8
  elseif byte < 240 then
    return 3 -- 3-byte UTF-8 (tiếng Việt thường dùng)
  elseif byte < 248 then
    return 4 -- 4-byte UTF-8
  else
    return 1 -- Fallback
  end
end

function uiWnd:GetNextUTF8Char(text)
  if string.len(text) <= 0 then
    return "", ""
  end

  local firstByte = string.byte(text, 1)
  local charLen = self:GetUTF8CharLength(firstByte)

  -- Đảm bảo không vượt quá độ dài string
  charLen = math.min(charLen, string.len(text))

  local char = string.sub(text, 1, charLen)
  local remaining = string.sub(text, charLen + 1)

  return char, remaining
end

-- Sửa hàm _Talk()
function uiWnd:_Talk(szTalk)
  local szDisplay = ""
  local function _OnTalkTimer()
    local szNowRead = ""
    -- 这里表示显示完了
    if 0 >= string.len(szTalk) then
      self:MoveStep()
      return 0
    end

    -- Xử lý color tags trước
    if string.sub(szTalk, 1, 1) == "<" then
      local nStart, nEnd = string.find(szTalk, ">")
      if nStart and nEnd then
        szNowRead = string.sub(szTalk, 1, nEnd)
        szTalk = string.sub(szTalk, nEnd + 1)
      else
        -- Nếu không tìm thấy tag đóng, lấy ký tự đầu
        szNowRead, szTalk = self:GetNextUTF8Char(szTalk)
      end
    else
      -- Lấy ký tự UTF-8 tiếp theo
      szNowRead, szTalk = self:GetNextUTF8Char(szTalk)
    end

    szDisplay = szDisplay .. szNowRead
    Txt_SetTxt(self.UIGROUP, self.TXT_TALK, szDisplay)
    -- 下一帧继续
    return 1
  end

  if not szTalk or "" == szTalk or 0 >= string.len(szTalk) then
    self:MoveStep()
  else
    Ui.tbLogic.tbTimer:Register(1, _OnTalkTimer, self)
  end
end

-- 等待
function uiWnd:_Wait(nTime)
  if not nTime or nTime <= 0 then
    self:MoveStep()
    return 0
  else
    -- 定个时，待会再回来
    Ui.tbLogic.tbTimer:Register(Lib:Ms2FrameNum(nTime), self._Wait, self, nil)
  end
end
-- 淡出
function uiWnd:_FadeOut(nTime)
  Wnd_FadeIn(self.UIGROUP, self.IMG_BODY, 255, 0, nTime)
end
-- 闭幕
function uiWnd:_CurtainClose(nTime)
  if nTime <= 0 then
    self:MoveStep()
    return 0
  end
  Txt_SetTxt(self.UIGROUP, self.TXT_TALK, "")
  Prg_SetTime(self.UIGROUP, self.PROG_HEAD, nTime, 1)
  Prg_SetTime(self.UIGROUP, self.PROG_FOOT, nTime, 1)
end
-- 结束
function uiWnd:Finish()
  self.nLoops = self.nLoops - 1
  if 0 >= self.nLoops then
    UiManager:CloseWindow(self.UIGROUP)
  else
    -- 重复播放
    self.nCurStep = 1
    self:MoveStep()
  end
end
