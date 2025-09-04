-----------------------------------------------------
--文件名		：	guttalk.lua
--创建者		：	tongxuehu@kingsoft.net
--创建时间	：	2007-02-06
--功能描述	：	对话面板。

-- 佩雷斯于 2007/11/15 PM 03:41 新增文字计时功能
------------------------------------------------------

local uiGutTalk = Ui:GetClass("guttalk")
local tbTimer = Ui.tbLogic.tbTimer

local IMAGE_PORTRAIT = "ImgPortrait"
local TEXT_DIALOG = "TxtDialog"
local DEFAULT_PORTRAIT = ""

function uiGutTalk:Init()
  self.tbTalkContent = {}
  self.szOrgText = ""
  self.szMainText = ""
  self.szShowText = ""
  self.szPlayerPortrait = DEFAULT_PORTRAIT
  self.nCurrentSentence = 1
  self.nTimerId = 0
  self.nChahuaStep = 0
  self.tbChahua = nil
end

function uiGutTalk:OnOpen()
  Img_SetImage(self.UIGROUP, IMAGE_PORTRAIT, 1, "")
  Txt_SetTxt(self.UIGROUP, TEXT_DIALOG, "")
  self.tbTalkContent = me.GetTalk()

  local function _delay()
    self:ShowNextSentence()
    return 0
  end
  tbTimer:Register(1, _delay)
end

function uiGutTalk:OnClose()
  me.EndTalk()
  if self.nTimerId and (self.nTimerId ~= 0) then
    tbTimer:Close(self.nTimerId)
    self.nTimerId = 0
  end
end

function uiGutTalk:OnButtonClick(szWndName, nParam)
  if self.nTimerId == 0 then
    self:ShowNextSentence()
  else
    if self.nTimerId and (self.nTimerId ~= 0) then
      tbTimer:Close(self.nTimerId)
      self.nTimerId = 0
    end
    Txt_SetTxt(self.UIGROUP, TEXT_DIALOG, self.szOrgText)
  end
end

function uiGutTalk:ShowNextSentence()
  local szPic = ""
  local tbChahua = nil
  szPic, self.szMainText, tbChahua = self:GetNextSentence()
  self.szOrgText = self.szMainText
  if tbChahua then
    local tbParam = {}
    tbParam.nOpenTime = 1
    tbParam.nCloseTime = 1
    tbParam.nFadeinTime = tbChahua.nFadeIn
    tbParam.nFadeoutTime = tbChahua.nFadeOut
    tbParam.nLastTime = tbChahua.nContinue
    tbParam.szImage = tbChahua.szImage
    tbParam.szTalk = self.szMainText

    Txt_SetTxt(self.UIGROUP, TEXT_DIALOG, "")
    Img_SetImage(self.UIGROUP, IMAGE_PORTRAIT, 1, "")
    UiManager:OpenWindow(Ui.UI_CHAHUA, tbParam, { self.ShowNextSentence, self })
  elseif szPic and self.szMainText then
    Img_SetImage(self.UIGROUP, IMAGE_PORTRAIT, 1, szPic)
    self.szShowText = ""
    Txt_SetTxt(self.UIGROUP, TEXT_DIALOG, "")
    if (not self.nTimerId) or (self.nTimerId == 0) then
      self.nTimerId = tbTimer:Register(1, self.OnTimer, self)
    end
  else
    UiManager:CloseWindow(self.UIGROUP)
  end
end

function uiGutTalk:GetNextSentence()
  if self.tbTalkContent == nil then
    return
  end

  if self.nCurrentSentence > #self.tbTalkContent then
    return
  end

  -- 是否包含插画
  local szChahua = string.match(self.tbTalkContent[self.nCurrentSentence], "<Chahua:(.-)>")
  local tbChahua = nil
  if szChahua and "" ~= szChahua then
    -- 清掉插画内容
    self.tbTalkContent[self.nCurrentSentence] = string.gsub(self.tbTalkContent[self.nCurrentSentence], "<Chahua:(.-)>", "")

    local tbTemp = Lib:SplitStr(szChahua, ",")
    print(szChahua)
    Lib:ShowTB(tbTemp)
    if #tbTemp > 0 then
      tbChahua = {}
      --tbChahua.szImage = self:GetChahuaImage(tbTemp[1]);
      tbChahua.szImage = tbTemp[1]
      tbChahua.nFadeIn = tonumber(tbTemp[2] or "")
      tbChahua.nContinue = tonumber(tbTemp[3] or "")
      tbChahua.nFadeOut = tonumber(tbTemp[4] or "")
      if not tbChahua.szImage or "" == tbChahua.szImage then
        tbChahua = nil
      end
    end
  end

  local m, n, szPic
  local i, j, szSentence = string.find(self.tbTalkContent[self.nCurrentSentence], "<Player>")
  if i and j then
    szPic = self.szPlayerPortrait
    m = j
  else
    i, j = string.find(self.tbTalkContent[self.nCurrentSentence], "<Pic:")
    if i and j then
      m, n = string.find(self.tbTalkContent[self.nCurrentSentence], ">")
      szPic = string.sub(self.tbTalkContent[self.nCurrentSentence], j + 1, m - 1)
      if not szPic then
        szPic = DEFAULT_PORTRAIT
        Ui:Output("[ERR] 找不到图片路径")
      end
    else
      szPic = DEFAULT_PORTRAIT
      m = 0
    end
  end

  szSentence = string.sub(self.tbTalkContent[self.nCurrentSentence], m + 1, -1)
  self.nCurrentSentence = self.nCurrentSentence + 1
  return szPic, szSentence, tbChahua
end

function uiGutTalk:OnStartTalk()
  UiManager:OpenWindow(self.UIGROUP)
end

-- Hàm helper để lấy độ dài ký tự UTF-8
function uiGutTalk:GetUTF8CharLength(byte)
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

-- Hàm lấy ký tự UTF-8 tiếp theo
function uiGutTalk:GetNextUTF8Char(text)
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

-- Hàm OnTimer được cập nhật
function uiGutTalk:OnTimer()
  local szNowRead, szShowText = "", ""

  if string.len(self.szMainText) <= 0 then
    if self.nTimerId and (self.nTimerId ~= 0) then
      tbTimer:Close(self.nTimerId)
      self.nTimerId = 0
    end
    return
  end

  -- Xử lý color tags trước
  if string.sub(self.szMainText, 1, 1) == "<" then
    local nStart, nEnd = string.find(self.szMainText, ">")
    if nStart and nEnd then
      szNowRead = string.sub(self.szMainText, 1, nEnd)
      self.szMainText = string.sub(self.szMainText, nEnd + 1)
    else
      -- Nếu không tìm thấy tag đóng, lấy ký tự đầu
      szNowRead, self.szMainText = self:GetNextUTF8Char(self.szMainText)
    end
  else
    -- Lấy ký tự UTF-8 tiếp theo
    szNowRead, self.szMainText = self:GetNextUTF8Char(self.szMainText)
  end

  self.szShowText = self.szShowText .. szNowRead
  Txt_SetTxt(self.UIGROUP, TEXT_DIALOG, self.szShowText)
end

function uiGutTalk:RegisterEvent()
  local tbRegEvent = {
    { UiNotify.emCOREEVENT_TALK, self.OnStartTalk },
  }
  return tbRegEvent
end
