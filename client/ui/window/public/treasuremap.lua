-- 文件名　：treasuremap.lua
-- 创建者　：LQY
-- 创建时间：2012-11-27 09:26:40
-- 说　　明：藏宝图系统UI
local uiTreasuremap = Ui:GetClass("treasuremap")
local TreasureMapEx = TreasureMap.TreasureMapEx
--常量
uiTreasuremap.tbGJ = {
  [1] = "辰虫镇",
  [2] = "阴阳时光殿",
}
-- 窗口标识
uiTreasuremap.PIC_STARPIC = "pic_putongstar" --星级图片

uiTreasuremap.TXT_MAPNAME = "txt_mapname" --已开启地图名字
uiTreasuremap.TXT_SUIJINEIRONG = "txt_suijineirong" --随机副本介绍
uiTreasuremap.TXT_PUTONGTISHI = "txt_putongtishi" --普通提示
uiTreasuremap.TXT_MYCOUNT = "txt_mycount" --我的藏宝图次数
uiTreasuremap.TXT_MYMIJING = "txt_mj_time" --我的秘境时间
uiTreasuremap.TXT_CCZLP = "txt_cczlingpai" --辰虫镇令牌
uiTreasuremap.TXT_SGDLP = "txt_sgdlingpai" --时光殿令牌
uiTreasuremap.TXT_MJDT = "txt_mijingditu" --秘籍地图

uiTreasuremap.BTN_DEYUEFANG1 = "btn_deyuefang1" --得月舫1
uiTreasuremap.BTN_DEYUEFANG2 = "btn_deyuefang2" --得月舫1
uiTreasuremap.BTN_ZHIDING = "btn_kaiqizhiding" --开启指定副本
uiTreasuremap.BTN_SUIJI = "btn_kaiqisuiji" --开启随机副本
uiTreasuremap.BTN_ENTER = "btn_entermap" --进入副本
uiTreasuremap.BTN_PTZHIDING = "btn_ptputong" --指定按钮
uiTreasuremap.BTN_CLOSE = "BtnExit" --关闭按钮
uiTreasuremap.BTN_OPENMJ = "btn_kaiqimijing" --开启秘境

uiTreasuremap.BTN_BAOMINGDIANSGD = "btn_sgdbmd" --去报名点
uiTreasuremap.BTN_BAOMINGDIANCCZ = "btn_cczbmd" --去报名点

uiTreasuremap.BTN_GETCCZ = "btn_getccz" --领取辰虫镇令牌
uiTreasuremap.BTN_GETSGD = "btn_getsgd" --领取时光殿令牌

uiTreasuremap.LIS_MAPSLIST = "lis_fubenlist" --所有可参与副本

uiTreasuremap.PSET_MAIN = "ps_mainpageset" --主页面分页管理
uiTreasuremap.PG_PUTONG = "pg_putong" --普通副本分页
uiTreasuremap.PG_GAOJI = "pg_gaoji" --高级副本分页
uiTreasuremap.PG_MIJING = "pg_mijing" --秘境副本分页

uiTreasuremap.PSET_PUTONG = "ps_putong" --普通藏宝图分页管理
uiTreasuremap.PG_SUIJI = "pg_pt_suiji" --随机分页
uiTreasuremap.PG_ZHIDING = "pg_pt_zhiding" --指定分页

uiTreasuremap.BTN_SELECTCBT = "btn_selectCBT" --藏宝图选中按钮
uiTreasuremap.TXT_SELECTCBTNAME = "txt_CBT_name" --藏宝图选择名称
uiTreasuremap.TXT_SELECTCBTLINK = "txt_CBT_map" --藏宝图选择地图
uiTreasuremap.BTN_SELECTMJ = "btn_selectMJ" --秘境选中按钮
uiTreasuremap.TXT_SELECTMJNAME = "txt_MJ_name" --秘境选择名称
uiTreasuremap.TXT_SELECTMJLINK = "txt_mj_map" --秘境选择地图

uiTreasuremap.COMB_STARSELECT = "com_starselect" --星级选择框
-- end

------ 功能定义 ------
function uiTreasuremap:Init()
  self.nMATCHTIMES = {}
end

-- 基本功能
function uiTreasuremap:Initialization() end
function uiTreasuremap:OnClose()
  self.bOpened = 0
end

function uiTreasuremap:OnOpen()
  self.bOpened = 1
  self.nGjSelect = 1
  PgSet_ActivePage(self.UIGROUP, self.PSET_MAIN, self.PG_PUTONG)
  PgSet_ActivePage(self.UIGROUP, self.PSET_PUTONG, self.PG_SUIJI)
  PgSet_ActivePage(self.UIGROUP, "ps_gaoji", "pg_gj_ccz")
  TxtEx_SetText(self.UIGROUP, self.TXT_CCZLP, "<item=18,1,1695,1>")
  TxtEx_SetText(self.UIGROUP, self.TXT_SGDLP, "<item=18,1,1451,1>")
  TxtEx_SetText(self.UIGROUP, self.TXT_MJDT, "<item=18,1,251,1>")
  me.CallServerScript({ "PlayerCmd", "ApplyTreasuremapInfo" }) --更新一次信息
end

function uiTreasuremap:OnComboBoxIndexChange(szWnd, nIndex)
  if szWnd == self.COMB_STARSELECT then
    self.nSelectStar = nIndex
    self:UpdateList(1)
  end
end
-- 单击列表
function uiTreasuremap:OnListSel(szWnd, nParam)
  if szWnd == self.LIS_MAPSLIST and nParam then
    self.nSeleteMap = nParam
  end
  if szWnd == self.LIS_SENLIST and nParam then
  end
end

function uiTreasuremap:OnButtonClick(szWnd, nParam)
  if szWnd == self.BTN_PTZHIDING then
    Lst_SetCurKey(self.UIGROUP, self.LIS_MAPSLIST, 1)
  elseif szWnd == self.BTN_ZHIDING then
    self:SignMap()
  elseif szWnd == self.BTN_SUIJI then
    self:SignRand()
  elseif szWnd == self.BTN_CLOSE then
    UiManager:CloseWindow(self.UIGROUP)
  elseif szWnd == self.BTN_SELECTCBT then
    Btn_Check(self.UIGROUP, self.BTN_SELECTCBT, 1)
    Btn_Check(self.UIGROUP, self.BTN_SELECTMJ, 0)
    Wnd_SetTip(self.UIGROUP, self.BTN_ENTER, "进入藏宝图副本")
    self:UpdateSelect()
  elseif szWnd == self.BTN_SELECTMJ then
    Btn_Check(self.UIGROUP, self.BTN_SELECTCBT, 0)
    Btn_Check(self.UIGROUP, self.BTN_SELECTMJ, 1)
    Wnd_SetTip(self.UIGROUP, self.BTN_ENTER, "进入秘境副本")
    self:UpdateSelect()
  elseif szWnd == self.BTN_ENTER then
    self:EnterMap()
  elseif szWnd == self.BTN_DEYUEFANG1 or szWnd == self.BTN_DEYUEFANG2 then
    self:EnterDeyuefang()
  elseif szWnd == self.BTN_BAOMINGDIANCCZ then
    self.nGjSelect = 1
    self:Move2Senior()
  elseif szWnd == self.BTN_BAOMINGDIANSGD then
    self.nGjSelect = 2
    self:Move2Senior()
  elseif szWnd == self.BTN_GETCCZ then
    me.CallServerScript({ "PlayerCmd", "GetTreasureTimes", 3, 1 })
  elseif szWnd == self.BTN_GETSGD then
    me.CallServerScript({ "PlayerCmd", "GetTreasureTimes", 3, 2 })
  elseif szWnd == self.BTN_OPENMJ then
    self:SignFourfold()
  end
end
--移动到高级报名点
function uiTreasuremap:Move2Senior(nType, nNum)
  if not nType then
    Dialog:MsgBox("你确定要移动到" .. self.tbGJ[self.nGjSelect] .. "报名点?", "报名点", 2, self.Move2Senior, self.nGjSelect)
  end
  if nType == 2 then
    me.CallServerScript({ "PlayerCmd", "GoFubenEnter", 0, 2, nNum })
    UiManager:CloseWindow(Ui.UI_TREASUREMAP)
  end
end

function uiTreasuremap:UpdateSelect()
  local bCbt = Btn_GetCheck(self.UIGROUP, self.BTN_SELECTCBT)
  local bMj = Btn_GetCheck(self.UIGROUP, self.BTN_SELECTMJ)
  if bCbt == 0 and bMj == 0 then
    Wnd_SetEnable(self.UIGROUP, self.BTN_ENTER, 0)
    return
  end
  Wnd_SetEnable(self.UIGROUP, self.BTN_ENTER, 1)
  self.nSeleteFuben = (bCbt == 1) and 1 or 2 --1是藏宝图，2是秘境
end
--报名参加一个随机藏宝图
function uiTreasuremap:SignRand(nType)
  if me.nTeamId <= 0 then
    local szMsg = "你<color=yellow>必须组队<color>并且是<color=yellow>队长<color>，才能开启藏宝图副本。"
    Dialog:MsgBox(szMsg)
    return 0
  end
  if nType then
    if nType == 2 then
      me.CallServerScript({ "PlayerCmd", "SignTreasure" })
    end
    return
  end
  local szMsg = string.format("确定要报名挑战随机<color=yellow>（%d星）<color>藏宝图。", self.nStar)
  Dialog:MsgBox(szMsg, nil, 2, self.SignRand)
end

--报名参加一个指定藏宝图
function uiTreasuremap:SignMap(nType, tbSelf)
  self = tbSelf or self
  if self:CheckPos() == 0 then
    return
  end
  if nType then
    if nType == 2 then
      me.CallServerScript({ "PlayerCmd", "SignTreasure", self.tbMapsInfo[self.nSeleteMap].TypeName, self.nSelectStar })
    end
    return
  end
  if me.nTeamId <= 0 then
    local szMsg = "你<color=yellow>必须组队<color>并且是<color=yellow>队长<color>，才能开启藏宝图副本。"
    Dialog:MsgBox(szMsg)
    return 0
  end
  local szMsg = string.format("确定要报名参加藏宝图:\n          <color=yellow>%s<color><color=blue> (%d星)<color>", self.tbMapsInfo[self.nSeleteMap].Name, self.nSelectStar)
  Dialog:MsgBox(szMsg, nil, 2, self.SignMap, self)
end
--进入副本
function uiTreasuremap:EnterMap()
  if self:CheckPos() == 0 then
    return
  end
  if self.nSeleteFuben ~= 1 and self.nSeleteFuben ~= 2 then
    Dialog:MsgBox("参数错误，进入失败")
    return
  end
  if self.nSeleteFuben == 1 then --进入藏宝图
    if self.nTreasureId == -1 then
      Dialog:MsgBox("没有可以进入的藏宝图副本！")
      return
    end
    if self.nMapId ~= me.nMapId then
      local szWorldName = GetMapNameFormId(self.nMapId)
      local szMsg = string.format("您的队伍在<color=yellow>%s<color>开启了藏宝图副本，请到<color=yellow>%s<color>的义军军需官处进入藏宝图副本。", szWorldName, szWorldName)
      Dialog:MsgBox(szMsg)
      return
    end
    local tbMapInfo = TreasureMapEx:Id2MapInfo(self.nTreasureId)
    if not tbMapInfo then
      return
    end
    Dialog:MsgBox(string.format("确定要进入 %s<color=yellow>（%d星）<color> 副本么？", tbMapInfo.szName, self.nOpenStar), "进入藏宝图", 2, self.EnterCBT)
  end
  if self.nSeleteFuben == 2 then --进入秘境
    if self.nMiJingMap == -1 then
      Dialog:MsgBox("没有可以进入的秘境！")
      return
    end
    if self.nMiJingMap ~= me.nMapId then
      local szWorldName = GetMapNameFormId(self.nMiJingMap)
      local szMsg = string.format("您的队伍在<color=yellow>%s<color>开启了秘境副本，请到<color=yellow>%s<color>的义军军需官处进入秘境。", szWorldName, szWorldName)
      Dialog:MsgBox(szMsg)
      return
    end
    Dialog:MsgBox("确定要进入秘境？", "进入秘境", 2, self.EnterMJ)
  end
end

--执行进入秘境
function uiTreasuremap:EnterMJ(nType)
  if nType == 2 then
    me.CallServerScript({ "PlayerCmd", "EnterFourfold" })
    UiManager:CloseWindow(Ui.UI_TREASUREMAP)
  end
end

--执行进入藏宝图
function uiTreasuremap:EnterCBT(nType)
  if nType == 2 then
    me.CallServerScript({ "PlayerCmd", "EnterTreasure" })
    UiManager:CloseWindow(Ui.UI_TREASUREMAP)
  end
end

--位置检测
function uiTreasuremap:CheckPos()
  local tbNpc = KNpc.GetAroundNpcList(me, 20)
  if not tbNpc then
    Dialog:MsgBox("距离军需官太远了，请站在各大城市义军军需官旁边！")
    return 0
  end
  local pFind = 0
  for _, pNpc in pairs(tbNpc) do
    if pNpc.nTemplateId == 2711 then
      pFind = pNpc
      break
    end
  end
  if pFind == 0 then
    Dialog:MsgBox("距离军需官太远了，请站在各大城市义军军需官旁边！")
    return 0
  end
  return 1
end

--开启秘境
function uiTreasuremap:SignFourfold()
  if self:CheckPos() == 0 then
    return
  end
  if me.nLevel < EventManager.IVER_nFourfoldMapLevel then
    Dialog:MsgBox(string.format("必须等级达到%s级，才有资格进入秘境。", EventManager.IVER_nFourfoldMapLevel))
    return 0
  end
  local nRemainTime = me.GetTask(2040, 16)
  if nRemainTime <= 0 then
    Dialog:MsgBox(string.format("你今天的修行已经达到顶峰了，还是明天再继续吧。"))
    return 0
  end
  if me.nTeamId <= 0 then
    Dialog:MsgBox(string.format("你<color=yellow>必须组队<color>并且是<color=yellow>队长<color>，才能带领你的朋友共同修行。"))
    return 0
  end
  me.CallServerScript({ "PlayerCmd", "SignFourfold" })
end

function uiTreasuremap:OnListOver(szWnd, nItemIndex) end
function uiTreasuremap:OnMouseEnter(szWnd, nItemIndex) end

function uiTreasuremap:SyncInfo(tbData)
  if self.bOpened ~= 1 then
    return
  end
  self.nTreasureId = tbData[1]
  self.nOpenStar = tbData[2]
  self.nMapId = tbData[3]
  self.nDeyuefang = tbData[4]
  self.bRandom = tbData[5]
  self.nMiJingMap = tbData[6]
  self:Update()
end

function uiTreasuremap:TeamInfoChanged()
  if self.bOpened ~= 1 then
    return
  end
  me.CallServerScript({ "PlayerCmd", "ApplyTreasuremapInfo" })
end
--设置星星上的tips
function uiTreasuremap:SetStarTips()
  local nStar, bTeam, nLevel = TreasureMapEx:GetTeamStar_C()
  if nStar == -1 then
    return
  end
  local szMsg = string.format("您的队伍队员最低等级为<color=yellow>%d级<color>，可挑战的副本最高星级为<color=blue>%d星<color>。<enter><enter>随机挑战将会随机进入以下副本：<enter><enter>", nLevel, nStar)
  local tbMaps = TreasureMapEx:Star2Maps(nStar)
  if not tbMaps or not tbMaps[nStar] then
    return
  end
  for _, tbMapInfo in pairs(tbMaps[nStar]) do
    szMsg = szMsg .. "       <color=gold>" .. Lib:StrFillL(tbMapInfo.Name, 10) .. "(" .. nStar .. "星)<color><enter>"
  end
  if bTeam == 0 then
    szMsg = szMsg .. "<enter><color=red>你还没有组队<color>"
  else
    szMsg = szMsg .. "<enter><enter>"
  end
  Wnd_SetTip(self.UIGROUP, self.PIC_STARPIC, szMsg)
  Wnd_SetTip(self.UIGROUP, self.BTN_SUIJI, szMsg)
end
--更新数据
function uiTreasuremap:Update()
  local nStar, bTeam = TreasureMapEx:GetTeamStar_C()
  self.nStar = nStar
  if self.nStar ~= -1 then
    if bTeam == 1 then
      Txt_SetTxt(self.UIGROUP, self.TXT_PUTONGTISHI, "您的队伍可挑战的最高星级为：")
    else
      Txt_SetTxt(self.UIGROUP, self.TXT_PUTONGTISHI, "您必须<color=red>组队<color>才可以挑战副本：")
    end
    Wnd_Show(self.UIGROUP, self.PIC_STARPIC)
    Img_SetImage(self.UIGROUP, self.PIC_STARPIC, 1, "image\\ui\\002a\\yijun\\" .. self.nStar .. ".spr")
    self:SetStarTips()
  else
    Wnd_Hide(self.UIGROUP, self.PIC_STARPIC)
    Txt_SetTxt(self.UIGROUP, self.TXT_PUTONGTISHI, "没有适合您的队伍挑战的副本。")
  end
  local _, tbItem = TreasureMapEx:Star2AwrrowCount(self.nStar, 1)
  if tbItem then
    TxtEx_SetText(self.UIGROUP, self.TXT_SUIJINEIRONG, string.format("挑战随机副本可额外获得：\n\n       <item=%d,%d,%d,%d> <color=yellow>X 3<color>", unpack(tbItem)))
  else
    TxtEx_SetText(self.UIGROUP, self.TXT_SUIJINEIRONG, "您没有队伍或者您的队伍不能挑战随机副本。")
  end
  local nCount = me.GetTask(TreasureMapEx.TASK_GROUP, TreasureMapEx.TASK_COUNT)
  Txt_SetTxt(self.UIGROUP, self.TXT_MYCOUNT, string.format("(%d/100)", nCount))
  local nTime = me.GetTask(2040, 16) --秘境剩余时间
  local szTime = Lib:TimeFullDesc(nTime)
  local _, nEnd = string.find(szTime, "分钟")
  if nEnd then
    szTime = string.sub(szTime, 0, nEnd)
  end
  Wnd_SetTip(self.UIGROUP, self.BTN_DEYUEFANG1, "您有<color=yellow>" .. self.nDeyuefang .. "条<color>奖励记录")
  Wnd_SetTip(self.UIGROUP, self.BTN_DEYUEFANG2, "您有<color=yellow>" .. self.nDeyuefang .. "条<color>奖励记录")
  Txt_SetTxt(self.UIGROUP, self.TXT_MYMIJING, string.format("您目前剩余秘境修炼时间为：<color=green>%s<color>", szTime))
  self:UpdateEnter()
  self:UpdateList(0)
  self:UpdateTeamMap()
end

function uiTreasuremap:UpdateEnter()
  if self:IsCaptain() == 0 or self.nTreasureId ~= -1 or self.nStar == -1 then
    Wnd_SetEnable(self.UIGROUP, self.BTN_ZHIDING, 0)
    Wnd_SetEnable(self.UIGROUP, self.BTN_SUIJI, 0)
  else
    Wnd_SetEnable(self.UIGROUP, self.BTN_ZHIDING, 1)
    Wnd_SetEnable(self.UIGROUP, self.BTN_SUIJI, 1)
  end
  if self:IsCaptain() == 0 or self.nMiJingMap ~= -1 or self.nStar == -1 then
    Wnd_SetEnable(self.UIGROUP, self.BTN_OPENMJ, 0)
  else
    Wnd_SetEnable(self.UIGROUP, self.BTN_OPENMJ, 1)
  end
end
function uiTreasuremap:UpdateList(nType)
  if nType == 0 then
    Lst_Clear(self.UIGROUP, self.LIS_MAPSLIST)
    ClearComboBoxItem(self.UIGROUP, self.COMB_STARSELECT)
    local nNum = 0
    for n, tbData in ipairs(TreasureMapEx.tbRankTable) do
      if n - 1 <= self.nStar then
        local tbColor = { "", "" }
        if n - 1 < self.nStar then
          tbColor = { "<color=green>", "<color>" }
        end
        ComboBoxAddItem(self.UIGROUP, self.COMB_STARSELECT, nNum, string.format("    %s %s星【%s-%s】%s", tbColor[1], tbData.Star, tbData.LevelLower, tbData.LevelUpper, tbColor[2]))
        nNum = nNum + 1
      end
    end
    if nNum == 0 then
      ComboBoxAddItem(self.UIGROUP, self.COMB_STARSELECT, 0, "<color=yellow>没有适合的副本<color>")
    end
    ComboBoxSelectItem(self.UIGROUP, self.COMB_STARSELECT, self.nStar)
    return
  end
  if nType == 1 then
    if not self.nSelectStar then
      return
    end
    local tbMaps = TreasureMapEx:Star2Maps(self.nStar)
    if not tbMaps then
      return
    end
    Lst_Clear(self.UIGROUP, self.LIS_MAPSLIST)
    self.tbMapsInfo = {}
    for n, tbMapinfo in pairs(tbMaps[self.nSelectStar]) do
      Lst_SetCell(self.UIGROUP, self.LIS_MAPSLIST, n, 0, "○   " .. Lib:StrFillL(tbMapinfo.Name, 10) .. "（" .. self.nSelectStar .. "星）")
      self.tbMapsInfo[n] = tbMapinfo
    end
    Lst_SetCurKey(self.UIGROUP, self.LIS_MAPSLIST, 1)
  end
end
--更新队伍副本信息
function uiTreasuremap:UpdateTeamMap()
  if self.nTreasureId ~= -1 then
    local tbMapInfo = TreasureMapEx:Id2MapInfo(self.nTreasureId)
    if not tbMapInfo then
      return
    end
    local szRandom = ""
    if self.bRandom == 1 then
      szRandom = "(随机)"
    end
    Txt_SetTxt(self.UIGROUP, self.TXT_SELECTCBTNAME, szRandom .. tbMapInfo.szName .. "（" .. self.nOpenStar .. "星）")
    TxtEx_SetText(self.UIGROUP, self.TXT_SELECTCBTLINK, string.format("<link=npcpos:%s,%d,2711>", GetMapNameFormId(self.nMapId), self.nMapId))
    Wnd_SetEnable(self.UIGROUP, self.BTN_SELECTCBT, 1)
    if Btn_GetCheck(self.UIGROUP, self.BTN_SELECTMJ) ~= 1 then
      Btn_Check(self.UIGROUP, self.BTN_SELECTCBT, 1)
      Wnd_SetTip(self.UIGROUP, self.BTN_ENTER, "进入藏宝图副本")
    end
  else
    Txt_SetTxt(self.UIGROUP, self.TXT_SELECTCBTNAME, "未开启藏宝图")
    TxtEx_SetText(self.UIGROUP, self.TXT_SELECTCBTLINK, "")
    Wnd_SetEnable(self.UIGROUP, self.BTN_SELECTCBT, 0)
    Btn_Check(self.UIGROUP, self.BTN_SELECTCBT, 0)
  end
  if self.nMiJingMap ~= -1 then
    Txt_SetTxt(self.UIGROUP, self.TXT_SELECTMJNAME, "秘境地图")
    TxtEx_SetText(self.UIGROUP, self.TXT_SELECTMJLINK, string.format("<link=npcpos:%s,%d,2711>", GetMapNameFormId(self.nMiJingMap), self.nMiJingMap))
    Wnd_SetEnable(self.UIGROUP, self.BTN_SELECTMJ, 1)
    if Btn_GetCheck(self.UIGROUP, self.BTN_SELECTCBT) ~= 1 then
      Btn_Check(self.UIGROUP, self.BTN_SELECTMJ, 1)
      Wnd_SetTip(self.UIGROUP, self.BTN_ENTER, "进入秘境副本")
    end
  else
    Txt_SetTxt(self.UIGROUP, self.TXT_SELECTMJNAME, "未开启秘境")
    TxtEx_SetText(self.UIGROUP, self.TXT_SELECTMJLINK, "")
    Wnd_SetEnable(self.UIGROUP, self.BTN_SELECTMJ, 0)
    Btn_Check(self.UIGROUP, self.BTN_SELECTMJ, 0)
  end
  self:UpdateSelect()
end

function uiTreasuremap:EnterDeyuefang(nType)
  if not nType then
    local szMsg = "你没有奖励记录，是否确定要进入得悦舫参观？"
    if self.nDeyuefang > 0 then
      szMsg = string.format("你有<color=yellow>%s条<color>评价奖励记录，是否确定要进入得悦舫领取奖励？", self.nDeyuefang)
    end
    Dialog:MsgBox(szMsg, "得月舫", 2, self.EnterDeyuefang)
  end
  if nType == 2 then
    me.CallServerScript({ "PlayerCmd", "EnterDeYuefang" })
    UiManager:CloseWindow(Ui.UI_TREASUREMAP)
  end
end

function uiTreasuremap:IsCaptain()
  local nAllotModel, tbTeamList = me.GetTeamInfo()
  if me.nTeamId <= 0 then
    return 0
  end
  if tbTeamList[1].nPlayerID == me.nId then
    return 1
  end
  return 0
end
