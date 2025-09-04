-- UI窗口临时数据管理，该类数据生命周期不受窗口影响，上下线自动复位清除

Ui.tbLogic.tbTempData = {}
local tbTempData = Ui.tbLogic.tbTempData

function tbTempData:Init()
  self.nSelectTaskId = 0 -- 当前选择任务的ID

  self.bInBattle = 0 --	1、战场中，用于显示即时战斗信息；0、正常的任务追踪
  self.szBattleMsg = "[战场即时消息]" -- 战场即时消息
  self.nBattleTempTimer = nil -- 临时切换到另一个模式的恢复状态Timer
  self.nBattleTimerFrame = nil -- 战场倒计时计数器
  self.nBattleRefreshTimer = nil -- 注册新的刷新Timer
  self.szBattleTimeMsg = "" -- 时间信息
  self.nMiniMapState = 0 -- 小地图状态数据
  self.nMiniMapFlagPosX = 0 -- 小地图的X坐标
  self.nMiniMapFlagPosY = 0 -- 小地图的Y坐标
  self.nMailNewFlag = 0 -- 新信件闪烁标致

  self.nCurChannel = 0 -- 当前的频道栏
  self.tbRecentPlay = {} -- 最近联系的玩家
  self.tbRecentMsg = {} -- 最近发送的消息
  self.szCurTab = ""

  self.tbInfoboardText = nil -- 中间提示的文字信息
  self.nMaxInfoboardText = 0 -- 中间提示的文字信息数量
  self.nDisableStall = 0
  self.nDisableFriend = 0
  self.nDisableTeam = 0
  self.nForbidSpeRepair = 0 -- 是否禁止特修
end
