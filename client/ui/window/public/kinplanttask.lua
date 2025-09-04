-- 文件名　：kinplanttask.lua
-- 创建者　：jiazhenwei
-- 创建时间：2011-12-14 11:27:49
-- 功能    ：

local uiKinPlantTask = Ui:GetClass("kinplanttask")

uiKinPlantTask.BtnClose = "BtnClose"
uiKinPlantTask.Txt_weather = "Txt_weather"
uiKinPlantTask.Txt_TaskInfo = "Txt_TaskInfo"
uiKinPlantTask.Page_Task = "Page_Task"
uiKinPlantTask.Obj_TaskItem = "Obj_TaskItem"
uiKinPlantTask.Txt_ItemNum = "Txt_ItemNum"
uiKinPlantTask.Txt_NpcName = "Txt_NpcName"
uiKinPlantTask.Txt_WeekTask = "Txt_WeekTask"
uiKinPlantTask.Txt_TaskInfo = "Txt_TaskInfo"
uiKinPlantTask.nUpWeatherTime = 10

uiKinPlantTask.tbWeatherName = { [0] = "多云（温度适中）", [1] = "雨天", [2] = "烈日", [3] = "大雪" }

function uiKinPlantTask:OnOpen()
  self.nWeatherId = Weather.nWeatherId
  self.nTaskInfo = KGblTask.SCGetDbTaskInt(DBTASK_KINPLANT_TASK)
  self:Update()
  Timer:Register(self.nUpWeatherTime * Env.GAME_FPS, self.Timer, self)
  me.CallServerScript({ "KinCmd", "RefreshKinPlant_HandIn", me.dwKinId })
end

function uiKinPlantTask:OnButtonClick(szWnd, nParam)
  if szWnd == self.BtnClose then
    UiManager:CloseWindow(self.UIGROUP)
  end
end

function uiKinPlantTask:Update()
  local nTask1 = math.fmod(self.nTaskInfo, 100)
  local nTask2 = math.fmod((self.nTaskInfo - nTask1) / 100, 100)
  local nTask3 = math.fmod((self.nTaskInfo - nTask2 * 100 - nTask1) / 10000, 100)
  local tbTask = { nTask1, nTask2, nTask3 }
  local nWeakly = math.floor(self.nTaskInfo / 1000000)
  local nTaskWeakly = me.GetTask(KinPlant.TASKGID, KinPlant.TASK_FINISHTASK)
  --天气
  Txt_SetTxt(self.UIGROUP, self.Txt_weather, "当前天气状况：" .. self.tbWeatherName[self.nWeatherId] or self.tbWeatherName[1])
  --周末进度
  local cKin = KKin.GetSelfKin()
  local nCountTree = 0
  if cKin then
    local nNowWeekly = tonumber(GetLocalDate("%W"))
    local nWeekly = math.floor(math.fmod(cKin.GetHandInCount(), 1000) / 10)
    if nNowWeekly == nWeekly then
      nCountTree = math.min(math.floor(cKin.GetHandInCount() / 1000), KinPlant.nKinMaxTreeWeekly)
    end
  end
  Txt_SetTxt(self.UIGROUP, self.Txt_WeekTask, "本周家族总收获植物数目：" .. nCountTree .. " / " .. KinPlant.nKinMaxTreeWeekly)
  if nWeakly == 0 or (nWeakly > 0 and nWeakly == nTaskWeakly) then
    if nWeakly == 0 then
      Txt_SetTxt(self.UIGROUP, self.Txt_TaskInfo, "本周订单：无")
    elseif nWeakly > 0 and nWeakly == nTaskWeakly then
      Txt_SetTxt(self.UIGROUP, self.Txt_TaskInfo, "本周订单：已经完成")
    end
  else
    Txt_SetTxt(self.UIGROUP, self.Txt_TaskInfo, "本周订单：<color=yellow>吕丰年<color>（订单人） ")
  end
  local tbName = { "<color=green>【粮食订单】<color>", "<color=green>【水果订单】<color>", "<color=green>【鲜花订单】<color>" }
  --任务
  for i = 1, 3 do
    local Page_Task = self.Page_Task .. i
    if nWeakly == 0 or (nWeakly > 0 and nWeakly == nTaskWeakly) then
      Wnd_Hide(self.UIGROUP, Page_Task)
    elseif tbTask[i] > 0 and KinPlant.tbPlantWeekTask[i][tbTask[i]] then
      Wnd_Show(self.UIGROUP, Page_Task)
      local szNpc = KinPlant.tbPlantWeekTask[i][tbTask[i]][2]
      for j = 1, 5 do
        local Obj_Item = string.format("%s%s_%s", self.Obj_TaskItem, j, i)
        local Txt_ItemNum = string.format("%s%s_%s", self.Txt_ItemNum, j, i)
        local Txt_NpcName = string.format("%s%s", self.Txt_NpcName, i)
        if KinPlant.tbPlantWeekTask[i][tbTask[i]][1][j] then
          local tbFruit = Lib:SplitStr(KinPlant.tbPlantWeekTask[i][tbTask[i]][1][j][1])
          local nCount = KinPlant.tbPlantWeekTask[i][tbTask[i]][1][j][2]
          TxtEx_SetText(self.UIGROUP, Txt_NpcName, tbName[i])
          if #tbFruit == 4 then
            local pItem = KItem.CreateTempItem(tonumber(tbFruit[1]), tonumber(tbFruit[2]), tonumber(tbFruit[3]), tonumber(tbFruit[4]), 0)
            if pItem then
              ObjMx_AddObject(self.UIGROUP, Obj_Item, Ui.CGOG_ITEM, pItem.nIndex, 0, 0)
              Txt_SetTxt(self.UIGROUP, Txt_ItemNum, "×" .. nCount)
              Wnd_Show(self.UIGROUP, Obj_Item)
            else
              Wnd_Hide(self.UIGROUP, Obj_Item)
            end
          else
            Wnd_Hide(self.UIGROUP, Obj_Item)
          end
        else
          Wnd_Hide(self.UIGROUP, Obj_Item)
        end
      end
    end
  end
end

--刷新天气状况
function uiKinPlantTask:Timer()
  if self.nWeatherId ~= Weather.nWeatherId then
    if UiManager:WindowVisible(self.UIGROUP) == 1 then
      self.nWeatherId = Weather.nWeatherId
      self:Update()
    else
      return 0
    end
  end
  return
end

function uiKinPlantTask:OnObjHover(szWnd, uGenre, uId, nX, nY)
  local pItem = KItem.GetItemObj(uId)
  if pItem then
    Wnd_ShowMouseHoverInfo(self.UIGROUP, szWnd, pItem.GetCompareTip(Item.TIPS_BINDGOLD_SECTION))
  end
end
