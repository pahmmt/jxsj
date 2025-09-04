-- 文件名　：newfubenview.lua
-- 创建者　：LQY
-- 创建时间：2012-11-20 15:27:51
-- 说　　明：藏宝图UI
local uiNewFubenView = Ui:GetClass("newfubenview")
local TreasureMapEx = TreasureMap.TreasureMapEx
--常量
uiNewFubenView.tbInfo = {
  taozhugongyizhong = {
    "taozhugong.spr",
    "战国的英魂，儒雅的谋士。他的墓冢深处，是他的财富、计谋？还是记忆中，那倾国倾城的佳人？",
  },
  damogucheng = { "damo.spr", "大漠中荒芜已久的古城，掩埋了无数执念的过往。机关重重，如何取得先机、逃出生天？" },
  wanhuagu = {
    "wanhua.spr",
    "万花谷，花之谷，遍地繁花，暖阳鸟鸣，却暗藏杀机。石冢之坚，竟欲吞山河社稷图，家国危矣！",
  },
  qianqionggongfuben = {
    "qianqiong.spr",
    "谁明美人心，谁解千琼迷？此华丽宫殿，反反复复，不过一地冷清。到头来，奈何佳人求不得。",
  },
  longmenfeijian = {
    "longmen.spr",
    "以先皇私印拟的割地盟约，藏于浩浩黄沙下的迷阵，镖局龙门，白衣公子。家国天下，究竟荣辱予谁？！",
  },
  biluogu = {
    "biluo.spr",
    "义军秘密营地被破，是试探还是绝杀？桃溪镇一别，下落不明的子书青，为何会出现在此地？上穷碧落下黄泉，可否再寻你一次。",
  },
  minlingtingyuan = {
    "tingyuan.spr",
    "桃溪镇大火之后，当年线索俱失。暗藏五毒教，竟得知当年下毒一事，与五毒暗旗冥灵旗有关。背后之手究竟是谁？",
  },
  fuxianshanzhuang = {
    "shanzhuang.spr",
    "江南突现一山庄，庄主素喜盛唐胡风，庄内遍布泉池，胡姬美人环侍……却暗地收集着武林的无数消息。",
  },
  chenchongzhen = {
    "chenchong.spr",
    "出现在蒙夏战场中的边塞小镇，不知名的慈祥老妪。层叠的过往，牵扯出一段海市蜃楼中的往事，悲兮叹兮。",
  },
  yinyangshiguangdian = {
    "shiguang.spr",
    "秦陵雾散地宫现，谁家司命夺光阴。暗藏玄机的地下宫殿，阴阳家的最后司命，是陷阱？还是宿命？",
  },
}
uiNewFubenView.tbSeniorMaps = {
  { "辰虫镇", "chenchongzhen" },
  { "阴阳时光殿", "yinyangshiguangdian" },
}
uiNewFubenView.nFontSize = 12
uiNewFubenView.nRowSpacing = 8
uiNewFubenView.Move_Hight = uiNewFubenView.nFontSize + uiNewFubenView.nRowSpacing
-- 窗口标识
uiNewFubenView.TXT_DANGQIAN = "Txt_DangQian"
uiNewFubenView.TXT_MYDATA = "Txt_MyData"
uiNewFubenView.TXT_BENZHOU = "Txt_BenZhou"
uiNewFubenView.TXT_SHUOMING = "txt_shuoming"
uiNewFubenView.TXT_SHUOMING2 = "txt_shuoming2"

uiNewFubenView.COM_LIST = "com_List"
uiNewFubenView.LIS_COMLIST = "list_CommonList"
uiNewFubenView.LIS_SENLIST = "list_SeniorList"

uiNewFubenView.IMG_SHOW1 = "Img_Show"
uiNewFubenView.IMG_SHOW2 = "Img_Show2"
uiNewFubenView.IMG_SELECT = "img_chose"
uiNewFubenView.IMG_ON = "img_on"

uiNewFubenView.BTN_CLOSE = "BtnExit"
uiNewFubenView.BTN_JOIN1 = "btn_join"
uiNewFubenView.BTN_JOIN2 = "btn_join2"
uiNewFubenView.BTN_JOIN3 = "btn_join3"

uiNewFubenView.PAGE_SET = "MainPageSet"
uiNewFubenView.PAGE_COMMON = "CommonPage"

uiNewFubenView.BTN_SENIOR = "SeniorButton"
uiNewFubenView.BTN_COMMON = "CommonButton"
-- end

------ 功能定义 ------
function uiNewFubenView:Init()
  self.nMATCHTIMES = {}
end

-- 基本功能
function uiNewFubenView:Initialization() end
function uiNewFubenView:OnClose()
  --胎死的滑动特效
  --Timer:Close(self.nTimer);
end

function uiNewFubenView:OnOpen()
  local nStar = TreasureMapEx:Level2Star(me.nLevel)
  local nCount = me.GetTask(TreasureMapEx.TASK_GROUP, TreasureMapEx.TASK_COUNT)
  Txt_SetTxt(self.UIGROUP, self.TXT_DANGQIAN, string.format("当前挑战次数为： <color=green>%d/100<color>", nCount))
  Txt_SetTxt(self.UIGROUP, self.TXT_MYDATA, string.format("你当前等级为 <color=239,180,52>%d <color>，最高可挑战难度为 <color=239,180,52>%d星<color> 的藏宝图", me.nLevel, nStar))
  Txt_SetTxt(self.UIGROUP, self.TXT_BENZHOU, "每周挑战上限： <color=green>2次<color>")
  PgSet_ActivePage(self.UIGROUP, self.PAGE_SET, self.PAGE_COMMON) -- 设置首页
  ClearComboBoxItem(self.UIGROUP, self.COM_LIST)

  for n, tbData in ipairs(TreasureMapEx.tbRankTable) do
    local tbColor = { "", "" }
    if n - 1 < nStar then
      tbColor = { "<color=green>", "<color>" }
    end
    if n - 1 > nStar then
      tbColor = { "<color=red>", "<color>" }
    end
    ComboBoxAddItem(self.UIGROUP, self.COM_LIST, n, string.format("%s %s星【%s-%s】%s", tbColor[1], tbData.Star, tbData.LevelLower, tbData.LevelUpper, tbColor[2]))
  end
  ComboBoxSelectItem(self.UIGROUP, self.COM_LIST, nStar)
  self:ShowSeniorMaps()
  --胎死的滑动特效
  --self.nTimer = Timer:Register(1, self.MoveTimer, self);
  self.szNowList = self.LIS_COMLIST
end
--高级副本
function uiNewFubenView:ShowSeniorMaps()
  self.tbPicSeniorId = {}
  Lst_Clear(self.UIGROUP, self.LIS_SENLIST)
  for n, tbMapInfo in pairs(self.tbSeniorMaps) do
    Lst_SetCell(self.UIGROUP, self.LIS_SENLIST, n, 0, tbMapInfo[1])
    self.tbPicSeniorId[n] = tbMapInfo[2]
  end
  Lst_SetCurKey(self.UIGROUP, self.LIS_SENLIST, 1)
end

function uiNewFubenView:OnComboBoxIndexChange(szWnd, nIndex)
  if szWnd == self.COM_LIST then
    local tbMaps = TreasureMapEx:Star2Maps(nIndex)
    Lst_Clear(self.UIGROUP, self.LIS_COMLIST)
    self.tbPicCommonId = {}
    for n, tbMapInfo in pairs(tbMaps[nIndex]) do
      Lst_SetCell(self.UIGROUP, self.LIS_COMLIST, n, 0, tbMapInfo.Name)
      self.tbPicCommonId[n] = tbMapInfo.TypeName
    end
    Lst_SetCurKey(self.UIGROUP, self.LIS_COMLIST, 1)
  end
end
-- 单击列表
function uiNewFubenView:OnListSel(szWnd, nParam)
  if szWnd == self.LIS_COMLIST and nParam then
    local szTypeName = self.tbPicCommonId[nParam]
    local tbInfo = self.tbInfo[szTypeName]
    if not tbInfo then
      return
    end
    Img_SetImage(self.UIGROUP, self.IMG_SHOW1, 1, "image\\ui\\002a\\newfubenview\\" .. tbInfo[1])
    Txt_SetTxt(self.UIGROUP, self.TXT_SHUOMING, tbInfo[2])
    self:Move2Select(self.LIS_COMLIST, nParam)
  end
  if szWnd == self.LIS_SENLIST and nParam then
    local szTypeName = self.tbPicSeniorId[nParam]
    local tbInfo = self.tbInfo[szTypeName]
    if not tbInfo then
      return
    end
    Img_SetImage(self.UIGROUP, self.IMG_SHOW2, 1, "image\\ui\\002a\\newfubenview\\" .. tbInfo[1])
    Txt_SetTxt(self.UIGROUP, self.TXT_SHUOMING2, tbInfo[2])
    self.nSeniorSelect = nParam
    self:Move2Select(self.LIS_SENLIST, nParam)
  end
end

function uiNewFubenView:OnButtonClick(szWnd, nParam)
  if szWnd == self.BTN_CLOSE then
    UiManager:CloseWindow(self.UIGROUP)
  elseif szWnd == self.BTN_JOIN1 then
    me.CallServerScript({ "PlayerCmd", "GoFubenEnter", 0, 1 })
  elseif szWnd == self.BTN_JOIN2 then
    local tbMsg = {}
    tbMsg.szMsg = string.format("确定要移动到高级藏宝图<color=yellow>%s<color>报名点？", self.tbSeniorMaps[self.nSeniorSelect][1])
    tbMsg.szTitle = "提示"
    tbMsg.nOptCount = 2
    tbMsg.Callback = self.Move2Senior
    UiManager:OpenWindow(Ui.UI_MSGBOX, tbMsg, self.nSeniorSelect)
    --me.CallServerScript({"PlayerCmd", "GoFubenEnter", 0, 2, self.nSeniorSelect});
  elseif szWnd == self.BTN_JOIN3 then
    me.CallServerScript({ "PlayerCmd", "GetTreasureTimes", 3, self.nSeniorSelect })
  elseif szWnd == self.BTN_SENIOR then
    Lst_SetCurKey(self.UIGROUP, self.LIS_SENLIST, 1)
    self.szNowList = self.LIS_SENLIST
  elseif szWnd == self.BTN_COMMON then
    Lst_SetCurKey(self.UIGROUP, self.LIS_COMLIST, 1)
    self.szNowList = self.LIS_COMLIST
  elseif szWnd == self.IMG_ON then
    self:Button2List()
  end
end
--移动到高级报名点
function uiNewFubenView:Move2Senior(nType, nSeniorSelect)
  if nType == 2 then
    me.CallServerScript({ "PlayerCmd", "GoFubenEnter", 0, 2, nSeniorSelect })
  end
end

--移动遮罩到
function uiNewFubenView:Move2Select(szItem, nRow)
  local nLeft, nTop = Wnd_GetPos(self.UIGROUP, szItem)
  nTop = nTop + nRow * self.Move_Hight + self.Move_Hight / 2 - 35
  self.Move_TarX = nLeft
  self.Move_TarY = nTop
  self.Move_Item = szItem
  self.Move_Row = nRow
  Wnd_SetPos(self.UIGROUP, self.IMG_SELECT, nLeft, nTop)
end

function uiNewFubenView:Button2List()
  local nLeft, nTop = Wnd_GetPos(self.UIGROUP, self.IMG_ON)
  local nLeft2, nTop2 = Wnd_GetPos(self.UIGROUP, self.szNowList)
  local nNum = math.floor((nTop - nTop2 + 36 - self.Move_Hight / 2) / self.Move_Hight)
  Lst_SetCurKey(self.UIGROUP, self.szNowList, nNum)
end

function uiNewFubenView:MoveTimer()
  local nSpeed = 4
  local nLeft, nTop = Wnd_GetPos(self.UIGROUP, self.IMG_SELECT)
  local nSpeedEx = math.floor(math.abs(nTop - self.Move_TarY) / 20) + 4
  nSpeed = nSpeed + nSpeedEx
  if nTop - self.Move_TarY < -2 then
    nTop = nTop + nSpeed
  end
  if nTop - self.Move_TarY > 2 then
    nTop = nTop - nSpeed
  end
  if math.abs(nTop - self.Move_TarY) < 4 then
    nTop = self.Move_TarY
  end
  Wnd_SetPos(self.UIGROUP, self.IMG_SELECT, nLeft, nTop)
end
function uiNewFubenView:OnListOver(szWnd, nItemIndex)
  if szWnd == self.LIS_COMLIST and nItemIndex then
    local nLeft, nTop = Wnd_GetPos(self.UIGROUP, self.LIS_COMLIST)
    nTop = nTop + nItemIndex * self.Move_Hight + self.Move_Hight / 2 - 35
    Wnd_SetPos(self.UIGROUP, self.IMG_ON, nLeft, nTop)
  end
  if szWnd == self.LIS_SENLIST and nItemIndex then
    local nLeft, nTop = Wnd_GetPos(self.UIGROUP, self.LIS_SENLIST)
    nTop = nTop + nItemIndex * self.Move_Hight + self.Move_Hight / 2 - 35
    Wnd_SetPos(self.UIGROUP, self.IMG_ON, nLeft, nTop)
  end
end
function uiNewFubenView:OnMouseEnter(szWnd, nItemIndex)
  if szWnd ~= self.LIS_COMLIST and szWnd ~= self.IMG_ON and szWnd ~= self.LIS_SENLIST then
    Wnd_Hide(self.UIGROUP, self.IMG_ON)
  else
    Wnd_Show(self.UIGROUP, self.IMG_ON)
  end
end
