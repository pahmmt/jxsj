local uiDaily = Ui:GetClass("daily")
local BTN_CLOSE = "BtnClose"
local IE_WND = "IEWnd"
local DATA_KEY = "DailyDate"
local tbSaveData = Ui.tbLogic.tbSaveData
local tbDaily = Ui.tbLogic.tbDaily

function uiDaily:Init() end

function uiDaily:PreOpen()
  if tbDaily:IsFreeDaily() == 0 then
    me.Msg("暂不开放日报！")
    return 0
  end
  return 1
end

function uiDaily:OnOpen()
  Wnd_Show(self.UIGROUP, IE_WND)
  self:OnEnterUrl()
  SetDailyNewFlag(0)
end

function uiDaily:OnEscExclusiveWnd()
  UiManager:CloseWindow(self.UIGROUP)
end

function uiDaily:OnButtonClick(szWnd, nParam)
  if szWnd == BTN_CLOSE then
    UiManager:CloseWindow(self.UIGROUP)
  end
end

function uiDaily:OnIeComplete(szWnd, szUrl)
  if szWnd == IE_WND then
    local nStart, nEnd = string.find(szUrl, "newsid=")
    if nStart then
      local szTemp
      szTemp = string.sub(szUrl, nStart)
      nStart = 0
      nEnd = string.find(szUrl, "&")
      if nEnd then
        self.szNewsId = string.sub(szTemp, nStart + 8, nEnd - 1)
      else
        self.szNewsId = string.sub(szTemp, nStart + 8)
      end
    else
      self.szNewsId = nil
    end

    if self.szNewsId then
      --- 获取本地的newsid
      local tbDailySetting = tbSaveData:Load(DATA_KEY)
      if tbDailySetting[1] then
        self.nLocalNewsId = tonumber(tbDailySetting[1])
        if not self.nLocalNewsId then
          self.nLocalNewsId = 0
        end
      else
        self.nLocalNewsId = 0
      end
      -- 获取新的newsid
      self.nNewsId = tonumber(self.szNewsId)
      if not self.nNewsId then
        return
      end

      if UiManager:WindowVisible(self.UIGROUP) == 0 then -- 很龊的偷偷去访问网页 判断有没有更新
        if self.nLocalNewsId < self.nNewsId then
          SetDailyNewFlag(1) -- 通知那个图标闪
          return
        end
      end
      -- 保存新的newsid到本地
      if self.nNewsId > self.nLocalNewsId then
        local tbTemp = {}
        tbTemp[1] = self.szNewsId
        tbSaveData:Save(DATA_KEY, tbTemp)
      end
    end
  end
end

function uiDaily:OnEnterUrl()
  IE_Navigate(self.UIGROUP, IE_WND, UiManager.IVER_JXDAILY_OPEN_URL)
end

function uiDaily:OnEnterUrlHide()
  IE_Navigate(self.UIGROUP, IE_WND, UiManager.IVER_JXDAILY_OPEN_HIDE)
end
