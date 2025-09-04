local uiFubenInfo = Ui:GetClass("fubeninfo")

uiFubenInfo.BTN_CLOSE = "BtnClose"
uiFubenInfo.PAGE_MAINSET = "PageSetMain"
uiFubenInfo.PAGE_PVEINFO = "PagePVEInfo"
uiFubenInfo.PAGE_PVPINFO = "PagePVPInfo"
-- 藏宝图
uiFubenInfo.IMG_TREASURECOMMON = "ImageTreasureCommon"
uiFubenInfo.IMG_DAMOGUCHENG = "ImageDamogucheng"
uiFubenInfo.IMG_LONGMENFEIJIAN = "ImageLongmenfeijian"
uiFubenInfo.IMG_TAOZHUGONG = "ImageTaozhugong"
uiFubenInfo.IMG_WANHUAGU = "ImageWanhugu"
uiFubenInfo.IMG_QIANQIONGGONG = "ImageQianqiongong"
uiFubenInfo.IMG_BILUOGU = "ImageBiluogu"
uiFubenInfo.TXT_TREASURECOMMON_TIMES = "TxtTreasureCommonCount" -- 通用令牌
uiFubenInfo.TXT_QIANQIONG_TIMES = "TxtQianqionggongCount" -- 千琼宫
uiFubenInfo.TXT_LONGMENGFEIJIAN_TIMES = "TxtLongmenfeijianCount" -- 龙门飞剑
uiFubenInfo.TXT_DAMOGUCHENG_TIMES = "TxtDamoguchengCount" -- 大漠古城
uiFubenInfo.TXT_TAOZHUGONG_TIMES = "TxtTaozhugongCount" -- 陶朱公
uiFubenInfo.TXT_WANHUAGU_TIMES = "TxtWanhuaguCount" -- 万花谷
uiFubenInfo.TXT_BILUOGU_TIMES = "TxtBiluoguCount" -- 碧落谷
uiFubenInfo.BTN_TREASURE_GETWEEKTIMES = "BtnTreasureGetWeekTimes" -- 领取通用令牌
uiFubenInfo.BTN_TREASURE_GETDAYTIMES = "BtnTreasureGetDayTimes" -- 领取每日次数
uiFubenInfo.BTN_TREASURE_ENTER = "BtnTreasureEnter" -- 副本报名点
-- 逍遥谷
uiFubenInfo.TXT_XIAOYAO_CARDRANK = "TxtXiaoyaoRank" -- 逍遥录排名
uiFubenInfo.TXT_XIAOYAO_CARDNUM = "TxtXiaoyaoCard" -- 逍遥录卡片数量
uiFubenInfo.TXT_XIAOYAO_TIMES = "TxtXiaoyaoTimes" -- 逍遥可参加次数
uiFubenInfo.BTN_XIAOYAO_ENTER = "BtnXiaoyaoEnter" -- 逍遥谷报名点
-- 军营副本
uiFubenInfo.TXT_ARMYCAMP_TIMES = "TxtArmyTimes" -- 军营可进次数
uiFubenInfo.BTN_ARMYCAMP_ENTER = "BtnArmyEnter" -- 军营报名点
-- 高级副本
uiFubenInfo.IMG_SHIGUANGLING = "ImageShiguangling"
uiFubenInfo.IMG_CHENCHONGZHEN = "ImageChenchongzhen"
uiFubenInfo.TXT_CHENCHONGZHEN_TIMES = "TxtChenchongzhenCount" -- 辰虫阵
uiFubenInfo.TXT_SHIGUANGLING_TIMES = "TxtShiguanglingCount" -- 时光令
uiFubenInfo.BTN_HIGHTREASURE_ENTER = "BtnHighTreasureEnter" -- 高级副本入口
uiFubenInfo.BTN_HIGHTREASURE_GETLINGPAI = "BtnHighTreasuregGetLingpai"
-- 跨服宋金
uiFubenInfo.TXT_GLOBALSONGJIN_ATTEND = "TxtGlobalSongjinTimes" -- 今日参加次数
uiFubenInfo.TXT_GLOBALSONGJIN_QUEUE = "TxtGlobalSongjinSignNum" -- 报名人数
uiFubenInfo.TXT_GLOBALSONGJIN_STATE = "TxtGlobalSongjinPlayerState" -- 玩家的报名状态/
uiFubenInfo.BTN_GLOBALSONGJIN_ENTER = "BtnGlobalSongjinEnter" -- 传送英雄岛
uiFubenInfo.BTN_GLOBALSONGJIN_JOIN = "BtnGlobalSongjinJoin"
uiFubenInfo.BTN_GLOBALSONGJIN_CANCEL = "BtnGlobalSongjinCancel"
uiFubenInfo.BTN_GLOBALSONGJIN_AREA = "BtnGlobalSongjinArea"
-- 本服宋金
uiFubenInfo.BTN_SONGJIN_ENTER = "BtnSongjinEnter" -- 宋金报名点
-- 白虎堂
uiFubenInfo.TXT_BAIHUTANG_TIMES = "TxtBaihutangTimes" -- 白虎堂参与次数
uiFubenInfo.BTN_BAIHUTANG_ENTER = "BtnBaihutangEnter" -- 白虎堂报名点
-- 趣味活动
uiFubenInfo.TXT_SPORT_REMAINTIMES = "TxtSportRemainTimes" -- 剩余次数
uiFubenInfo.TXT_SPORT_MONTHNAME = "TxtSportMonthName" -- 月活动名字
uiFubenInfo.TXT_SPORT_MONTHPOINT = "TxtSportMonthPoint" -- 月积分
uiFubenInfo.BTN_SPORT_ENTER = "BtnSportsEnter" -- 报名点

uiFubenInfo.BTN_CALENDAR_INFO = "BtnCalendarInfo"

function uiFubenInfo:OnOpen(nXiaoYaoRank, nSportMemGrade)
  self.nXiaoYaoRank = nXiaoYaoRank or 0
  self.nSportMemGrade = nSportMemGrade or 0
  self:UpdateTreasure()
  self:UpdateXiaoYao()
  self:UpdateArmyCamp()
  self:UpdateHighTreasure()
  self:UpdateGlobalSongJin()
  self:UpdateBaiHuTang()
  self:UpdateMonthSport()
  PgSet_ActivePage(self.UIGROUP, self.PAGE_MAINSET, self.PAGE_PVEINFO)
  --me.CallServerScript({"ApplySuperBattlePlayerState"});
  if self.nTimerRefresh then
    Timer:Close(self.nTimerRefresh)
    self.nTimerRefresh = nil
  end
  self.nTimerRefresh = Timer:Register(18, self.OnTimer_Refresh, self)
end

function uiFubenInfo:OnClose()
  self.nXiaoYaoRank = nil
  self.nGlobalSongJinOpen = nil
  self.nGlobalSongJinAttend = nil
  self.nGlobalSongJinQueue = nil
  self.nGlobalSongJinState = nil
  self.nGlobalSongJinTime = 0
  if self.nTimerRefresh then
    Timer:Close(self.nTimerRefresh)
    self.nTimerRefresh = nil
  end
end

function uiFubenInfo:OnTimer_Refresh()
  if UiManager:WindowVisible(Ui.UI_FUBEN_INFO) ~= 1 then
    return 0
  end
  if self.nGlobalSongJinTime and self.nGlobalSongJinTime > 0 then
    self.nGlobalSongJinTime = self.nGlobalSongJinTime - 1
  end
  self:UpdateTreasure()
  self:UpdateXiaoYao()
  self:UpdateArmyCamp()
  self:UpdateHighTreasure()
  self:UpdateGlobalSongJin()
  self:UpdateBaiHuTang()
  self:UpdateMonthSport()
  return 18
end

function uiFubenInfo:OnButtonClick(szWnd, nParam)
  if szWnd == self.BTN_CLOSE then
    UiManager:CloseWindow(self.UIGROUP)
  -- 藏宝图
  elseif szWnd == self.BTN_TREASURE_GETWEEKTIMES then
    me.CallServerScript({ "PlayerCmd", "GetTreasureTimes", 1 })
  elseif szWnd == self.BTN_TREASURE_GETDAYTIMES then
    me.CallServerScript({ "PlayerCmd", "GetTreasureTimes", 2 })
  elseif szWnd == self.BTN_TREASURE_ENTER then
    me.CallServerScript({ "PlayerCmd", "GoFubenEnter", 0, 1 })
  -- 逍遥谷
  elseif szWnd == self.BTN_XIAOYAO_ENTER then
    me.CallServerScript({ "PlayerCmd", "GoFubenEnter", 1, 1 })
  -- 军营副本
  elseif szWnd == self.BTN_ARMYCAMP_ENTER then
    me.CallServerScript({ "PlayerCmd", "GoFubenEnter", 1, 2 })
  -- 高级副本
  elseif szWnd == self.BTN_HIGHTREASURE_ENTER then
    me.CallServerScript({ "PlayerCmd", "GoFubenEnter", 0, 2 })
  elseif szWnd == self.BTN_HIGHTREASURE_GETLINGPAI then
    me.CallServerScript({ "PlayerCmd", "GetTreasureTimes", 3 })
  -- 跨服宋金
  elseif szWnd == self.BTN_GLOBALSONGJIN_ENTER then
    me.CallServerScript({ "ApplySuperBattleTrans" })
    UiManager:CloseWindow(self.UIGROUP)
  elseif szWnd == self.BTN_GLOBALSONGJIN_JOIN then
    me.CallServerScript({ "ApplySuperBattleJoin" })
    UiManager:CloseWindow(self.UIGROUP)
  elseif szWnd == self.BTN_GLOBALSONGJIN_CANCEL then
    me.CallServerScript({ "ApplySuperBattleCancel" })
    UiManager:CloseWindow(self.UIGROUP)
  elseif szWnd == self.BTN_GLOBALSONGJIN_AREA then
    UiManager:OpenWindow(Ui.UI_GLOBAL_AREA)
  -- 本服宋金
  elseif szWnd == self.BTN_SONGJIN_ENTER then
    me.CallServerScript({ "PlayerCmd", "GoFubenEnter", 1, 3 })
  -- 白虎堂
  elseif szWnd == self.BTN_BAIHUTANG_ENTER then
    me.CallServerScript({ "PlayerCmd", "GoFubenEnter", 1, 4 })
  -- 家族竞技
  elseif szWnd == self.BTN_SPORT_ENTER then
    me.CallServerScript({ "PlayerCmd", "GoFubenEnter", 0, 3 })
  elseif szWnd == self.BTN_CALENDAR_INFO then
    UiManager:OpenWindow(Ui.UI_CALENDAR)
    UiManager:CloseWindow(self.UIGROUP)
  end
end

-- 藏宝图
function uiFubenInfo:UpdateTreasure()
  Txt_SetTxt(self.UIGROUP, self.TXT_TREASURECOMMON_TIMES, me.GetTask(2203, 3))
  Txt_SetTxt(self.UIGROUP, self.TXT_QIANQIONG_TIMES, me.GetTask(2203, 7))
  Txt_SetTxt(self.UIGROUP, self.TXT_LONGMENGFEIJIAN_TIMES, me.GetTask(2203, 8))
  Txt_SetTxt(self.UIGROUP, self.TXT_DAMOGUCHENG_TIMES, me.GetTask(2203, 5))
  Txt_SetTxt(self.UIGROUP, self.TXT_TAOZHUGONG_TIMES, me.GetTask(2203, 4))
  Txt_SetTxt(self.UIGROUP, self.TXT_WANHUAGU_TIMES, me.GetTask(2203, 6))
  Txt_SetTxt(self.UIGROUP, self.TXT_BILUOGU_TIMES, me.GetTask(2203, 9))
  local nWeek = Lib:GetLocalWeek()
  local nDay = Lib:GetLocalDay()
  if nWeek == me.GetTask(2203, 1) then
    Wnd_SetEnable(self.UIGROUP, self.BTN_TREASURE_GETWEEKTIMES, 0)
    Btn_SetTxt(self.UIGROUP, self.BTN_TREASURE_GETWEEKTIMES, "本周次数已领取")
  else
    Wnd_SetEnable(self.UIGROUP, self.BTN_TREASURE_GETWEEKTIMES, 1)
    Btn_SetTxt(self.UIGROUP, self.BTN_TREASURE_GETWEEKTIMES, "领取本周通用次数")
  end
  if nDay == me.GetTask(2203, 2) then
    Wnd_SetEnable(self.UIGROUP, self.BTN_TREASURE_GETDAYTIMES, 0)
    Btn_SetTxt(self.UIGROUP, self.BTN_TREASURE_GETDAYTIMES, "今日次数已领取")
  else
    Wnd_SetEnable(self.UIGROUP, self.BTN_TREASURE_GETDAYTIMES, 1)
    Btn_SetTxt(self.UIGROUP, self.BTN_TREASURE_GETDAYTIMES, "领取本日次数")
  end
end

-- 逍遥谷
function uiFubenInfo:UpdateXiaoYao()
  Txt_SetTxt(self.UIGROUP, self.TXT_XIAOYAO_CARDRANK, string.format("逍遥录排名：%s", self.nXiaoYaoRank))
  local szCardNumDesc = XoyoGame.XoyoChallenge:GetGatheredCardNum(me) .. "/" .. XoyoGame.XoyoChallenge:GetTotalCardNum()
  Txt_SetTxt(self.UIGROUP, self.TXT_XIAOYAO_CARDNUM, string.format("逍遥录：%s", szCardNumDesc))
  local nTimes = XoyoGame:GetPlayerTimes(me)
  Txt_SetTxt(self.UIGROUP, self.TXT_XIAOYAO_TIMES, string.format("本日剩余次数：%s", nTimes))
end

-- 军营
function uiFubenInfo:UpdateArmyCamp()
  local nDayEnterFB = Task.tbArmyCampInstancingManager:EnterInstancingThisDay(1, me.nId)
  Txt_SetTxt(self.UIGROUP, self.TXT_ARMYCAMP_TIMES, string.format("本日剩余次数：%s", nDayEnterFB))
end

-- 高级藏宝图
function uiFubenInfo:UpdateHighTreasure()
  local tbFind = me.FindItemInBags(18, 1, 1451, 1)
  Txt_SetTxt(self.UIGROUP, self.TXT_SHIGUANGLING_TIMES, #tbFind)
  tbFind = me.FindItemInBags(18, 1, 1695, 1)
  Txt_SetTxt(self.UIGROUP, self.TXT_CHENCHONGZHEN_TIMES, #tbFind)
end

-- 跨服宋金
function uiFubenInfo:UpdateGlobalSongJin()
  local szState = "尚未加入队列"
  if self.nGlobalSongJinState == 1 then
    szState = "尚未加入队列"
  elseif self.nGlobalSongJinState == 2 then
    szState = "已在等待队列中..."
  elseif self.nGlobalSongJinState == 3 then
    Wnd_Hide(self.UIGROUP, self.BTN_GLOBALSONGJIN_JOIN)
    Wnd_Hide(self.UIGROUP, self.BTN_GLOBALSONGJIN_CANCEL)
    Wnd_Hide(self.UIGROUP, self.TXT_GLOBALSONGJIN_ATTEND)
    Wnd_Hide(self.UIGROUP, self.TXT_GLOBALSONGJIN_STATE)
    Txt_SetTxt(self.UIGROUP, self.TXT_GLOBALSONGJIN_QUEUE, string.format("剩余进入战场时间：<color=cyan>%s秒<color>", self.nGlobalSongJinTime or 0))
    return
  end
  Wnd_Show(self.UIGROUP, self.BTN_GLOBALSONGJIN_JOIN)
  Wnd_Show(self.UIGROUP, self.BTN_GLOBALSONGJIN_CANCEL)
  Wnd_Show(self.UIGROUP, self.TXT_GLOBALSONGJIN_ATTEND)
  Wnd_Show(self.UIGROUP, self.TXT_GLOBALSONGJIN_STATE)
  Txt_SetTxt(self.UIGROUP, self.TXT_GLOBALSONGJIN_ATTEND, string.format("参与次数：%s/2", self.nGlobalSongJinAttend or 0))
  Txt_SetTxt(self.UIGROUP, self.TXT_GLOBALSONGJIN_QUEUE, string.format("战场情况：%s/160", self.nGlobalSongJinQueue or 0))
  Txt_SetTxt(self.UIGROUP, self.TXT_GLOBALSONGJIN_STATE, string.format("个人状态：<color=yellow>%s<color>", szState))
  if self.nGlobalSongJinOpen ~= 1 then
    Wnd_SetEnable(self.UIGROUP, self.BTN_GLOBALSONGJIN_JOIN, 0)
    Wnd_SetEnable(self.UIGROUP, self.BTN_GLOBALSONGJIN_CANCEL, 0)
  elseif self.nGlobalSongJinState == 1 then
    Wnd_SetEnable(self.UIGROUP, self.BTN_GLOBALSONGJIN_JOIN, 1)
    Wnd_SetEnable(self.UIGROUP, self.BTN_GLOBALSONGJIN_CANCEL, 0)
  elseif self.nGlobalSongJinState == 2 then
    Wnd_SetEnable(self.UIGROUP, self.BTN_GLOBALSONGJIN_JOIN, 0)
    Wnd_SetEnable(self.UIGROUP, self.BTN_GLOBALSONGJIN_CANCEL, 1)
  elseif self.nGlobalSongJinState == 3 then
    Wnd_SetEnable(self.UIGROUP, self.BTN_GLOBALSONGJIN_JOIN, 0)
    Wnd_SetEnable(self.UIGROUP, self.BTN_GLOBALSONGJIN_CANCEL, 0)
  end
end

-- 跨服宋金服务器回调更新
function uiFubenInfo:OnGlobalSongJinUpdate(nOpen, nAttend, nQueue, nState, nTime)
  if UiManager:WindowVisible(Ui.UI_FUBEN_INFO) ~= 1 then
    return
  end
  self.nGlobalSongJinOpen = nOpen
  self.nGlobalSongJinAttend = nAttend
  self.nGlobalSongJinQueue = nQueue
  self.nGlobalSongJinState = nState
  self.nGlobalSongJinTime = nTime
  self:UpdateGlobalSongJin()
end

-- 白虎堂
function uiFubenInfo:UpdateBaiHuTang()
  local nTimes = Ui(Ui.UI_HELPSPRITE):GetBaihutangCount()
  Txt_SetTxt(self.UIGROUP, self.TXT_BAIHUTANG_TIMES, string.format("参与次数：%s/3", nTimes))
end

-- 家族竞技
function uiFubenInfo:UpdateMonthSport()
  local nAttendCount = me.GetTask(2179, 4)
  Txt_SetTxt(self.UIGROUP, self.TXT_SPORT_REMAINTIMES, string.format("当天可参加次数：%s", nAttendCount))
  local tbEventName = { "赛龙舟", "打雪仗", "守护先祖之魂", "夜岚关" }
  local nState = KGblTask.SCGetDbTaskInt(DBTASD_NEWPLATEVENT_SESSION)
  local szEventName = tbEventName[nState] or ""
  Txt_SetTxt(self.UIGROUP, self.TXT_SPORT_MONTHNAME, string.format("本周竞技活动：%s", szEventName))
  Txt_SetTxt(self.UIGROUP, self.TXT_SPORT_MONTHPOINT, string.format("本月个人积分：%d", self.nSportMemGrade or 0))
end

function uiFubenInfo:OnMouseEnter(szWnd)
  local szTip = ""
  local szTreasureDesc = "<color=blue>达到等级的侠客可以挑战下列对应星级的藏宝图<color><enter><color=yellow>%s藏宝图准入等级<color>"
  local szStarDesc = "<enter><color=yellow>%s星：<color>%s级"
  local tbLevelInfo = nil
  local szTreasureName = nil
  if szWnd == self.IMG_TREASURECOMMON or szWnd == self.TXT_TREASURECOMMON_TIMES then
    szTip = "通用藏宝图令牌：<enter>可前去义军军需官处挑战任何藏宝图<enter>侠客可挑战的星级根据侠客等级确定"
  elseif szWnd == self.IMG_DAMOGUCHENG or szWnd == self.TXT_DAMOGUCHENG_TIMES then
    tbLevelInfo = { 70, 80, 130 }
    szTreasureName = "大漠古城"
  elseif szWnd == self.IMG_LONGMENFEIJIAN or szWnd == self.TXT_LONGMENGFEIJIAN_TIMES then
    tbLevelInfo = { 50, 100, 130 }
    szTreasureName = "龙门飞剑"
  elseif szWnd == self.IMG_TAOZHUGONG or szWnd == self.TXT_TAOZHUGONG_TIMES then
    tbLevelInfo = { 70, 80, 130 }
    szTreasureName = "陶朱公"
  elseif szWnd == self.IMG_WANHUAGU or szWnd == self.TXT_WANHUAGU_TIMES then
    tbLevelInfo = { 90, 100, 130 }
    szTreasureName = "万花谷"
  elseif szWnd == self.IMG_QIANQIONGGONG or szWnd == self.TXT_QIANQIONG_TIMES then
    tbLevelInfo = { 90, 100, 130 }
    szTreasureName = "千琼宫"
  elseif szWnd == self.IMG_BILUOGU or szWnd == self.TXT_BILUOGU_TIMES then
    tbLevelInfo = { 25, 50, 130 }
    szTreasureName = "碧落谷"
  elseif szWnd == self.IMG_SHIGUANGLING or szWnd == self.TXT_SHIGUANGLING_TIMES then
    szTip = "时光令：<enter>持此令牌可进入阴阳家的神秘领地“阴阳时光殿”。上面画着奇怪的纹样"
  elseif szWnd == self.IMG_CHENCHONGZHEN or szWnd == self.TXT_CHENCHONGZHEN_TIMES then
    szTip = "辰虫镇辟魑锁：<enter>由西夏境内兀剌海城处进入辰虫镇副本，建议[雏凤]阶以上玩家组队前往"
  end
  if tbLevelInfo then
    local nPlayerLevel = me.nLevel
    szTip = string.format(szTreasureDesc, szTreasureName)
    for i, nLevel in ipairs(tbLevelInfo) do
      local szTemp = string.format(szStarDesc, i, nLevel)
      if nPlayerLevel < nLevel then
        szTemp = "<color=red>" .. szTemp .. "<color>"
      end
      szTip = szTip .. szTemp
    end
  end
  if szTip ~= "" then
    Wnd_ShowMouseHoverInfo(self.UIGROUP, szWnd, "", szTip)
  end
end
