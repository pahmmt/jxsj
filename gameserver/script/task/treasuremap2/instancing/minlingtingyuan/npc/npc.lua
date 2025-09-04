-- 文件名　：npc.lua
-- 创建者　：LQY
-- 创建时间：2012-11-13 10:04:34
-- 说　　明：NPC处理
--
--第四关宝箱
local tbRound4Box = Npc:GetClass("minling4_box")
function tbRound4Box:OnDialog()
  local nMapId = him.GetWorldPos()
  local tbInstancing = TreasureMap2:GetInstancing(nMapId)
  if not tbInstancing or tbInstancing:IsOpen() ~= 1 then
    return
  end
  local Round4 = tbInstancing:GetRound(4)
  if Round4.bCantOpen == 1 then
    Dialog:Say("钥匙已经找到，赶快离开这个地方！")
    return
  end
  local tbEvent = {
    Player.ProcessBreakEvent.emEVENT_MOVE,
    Player.ProcessBreakEvent.emEVENT_ATTACK,
    Player.ProcessBreakEvent.emEVENT_SITE,
    Player.ProcessBreakEvent.emEVENT_USEITEM,
    Player.ProcessBreakEvent.emEVENT_ARRANGEITEM,
    Player.ProcessBreakEvent.emEVENT_DROPITEM,
    Player.ProcessBreakEvent.emEVENT_SENDMAIL,
    Player.ProcessBreakEvent.emEVENT_TRADE,
    Player.ProcessBreakEvent.emEVENT_CHANGEFIGHTSTATE,
    Player.ProcessBreakEvent.emEVENT_CLIENTCOMMAND,
    Player.ProcessBreakEvent.emEVENT_ATTACKED,
    Player.ProcessBreakEvent.emEVENT_DEATH,
    Player.ProcessBreakEvent.emEVENT_LOGOUT,
  }
  -- 读条开宝箱
  GeneralProcess:StartProcess("开启宝箱", tbInstancing.tbRound4.nBoxReadTime, { Round4.OpenBox, Round4, him.dwId }, { me.Msg, "开启被打断" }, tbEvent)
end

--第四关灯
local tbRound4Light = Npc:GetClass("minling4_light")
function tbRound4Light:OnDialog()
  local nMapId = him.GetWorldPos()
  local tbInstancing = TreasureMap2:GetInstancing(nMapId)
  if not tbInstancing or tbInstancing:IsOpen() ~= 1 then
    return
  end
  local Round4 = tbInstancing:GetRound(4)
  if Round4.bCantOpen == 1 then
    Dialog:Say("钥匙已经找到，赶快离开这个地方！")
    return
  end
  local tbEvent = {
    Player.ProcessBreakEvent.emEVENT_MOVE,
    Player.ProcessBreakEvent.emEVENT_ATTACK,
    Player.ProcessBreakEvent.emEVENT_SITE,
    Player.ProcessBreakEvent.emEVENT_USEITEM,
    Player.ProcessBreakEvent.emEVENT_ARRANGEITEM,
    Player.ProcessBreakEvent.emEVENT_DROPITEM,
    Player.ProcessBreakEvent.emEVENT_SENDMAIL,
    Player.ProcessBreakEvent.emEVENT_TRADE,
    Player.ProcessBreakEvent.emEVENT_CHANGEFIGHTSTATE,
    Player.ProcessBreakEvent.emEVENT_CLIENTCOMMAND,
    --Player.ProcessBreakEvent.emEVENT_ATTACKED,
    Player.ProcessBreakEvent.emEVENT_DEATH,
    Player.ProcessBreakEvent.emEVENT_LOGOUT,
  }
  -- 读条开宝箱
  GeneralProcess:StartProcess("点灯", tbInstancing.tbRound4.nLightOnTime, { Round4.OnLight, Round4, him.dwId }, { me.Msg, "开启被打断" }, tbEvent)
end

--第五关剧情BOSS
local tbRound5Boss = Npc:GetClass("minling5_boss_chat")
function tbRound5Boss:OnDialog() end

--第六关妹子
local tbRound6Girl = Npc:GetClass("minling6_girl")
function tbRound6Girl:OnDialog()
  local nMapId = him.GetWorldPos()
  local tbInstancing = TreasureMap2:GetInstancing(nMapId)
  if not tbInstancing or tbInstancing:IsOpen() ~= 1 then
    return
  end
  local Round6 = tbInstancing:GetRound(6)
  if Round6.bSaveGirl ~= 1 then
    Dialog:Say("好像被施了什么法术，绳子纹丝不动。")
    return
  end
  if me.GetSkillState(tbInstancing.tbRound6.nSavebuff) ~= -1 then
    Dialog:Say("你身上的剧毒还没消除，不能再次救人！")
    return
  end
  if Round6.Finished == 1 then
    Dialog:Say("已经来不及了。。")
    return
  end
  local tbEvent = {
    Player.ProcessBreakEvent.emEVENT_MOVE,
    Player.ProcessBreakEvent.emEVENT_ATTACK,
    Player.ProcessBreakEvent.emEVENT_SITE,
    Player.ProcessBreakEvent.emEVENT_USEITEM,
    Player.ProcessBreakEvent.emEVENT_ARRANGEITEM,
    Player.ProcessBreakEvent.emEVENT_DROPITEM,
    Player.ProcessBreakEvent.emEVENT_SENDMAIL,
    Player.ProcessBreakEvent.emEVENT_TRADE,
    Player.ProcessBreakEvent.emEVENT_CHANGEFIGHTSTATE,
    Player.ProcessBreakEvent.emEVENT_CLIENTCOMMAND,
    --Player.ProcessBreakEvent.emEVENT_ATTACKED,
    Player.ProcessBreakEvent.emEVENT_DEATH,
    Player.ProcessBreakEvent.emEVENT_LOGOUT,
  }
  -- 读条开宝箱
  GeneralProcess:StartProcess("解开少女的束缚", tbInstancing.tbRound6.nSaveGirlTime, { Round6.SaveGirl, Round6, him.dwId }, { me.Msg, "被打断了" }, tbEvent)
end

--路路通
local tbLulutong = Npc:GetClass("mlty_llt")
function tbLulutong:OnDialog()
  local tbPos = {
    [2] = { { 1675, 3239 }, "通往北煌沼" },
    [3] = { { 1737, 3157 }, "通往火狼王囚室" },
    [4] = { { 1805, 3176 }, "通往藏宝室" },
    [5] = { { 1787, 3228 }, "通往嗜月沼" },
    [6] = { { 1714, 3361 }, "通往祭祀大殿" },
    [7] = { { 1834, 3370 }, "通往冥灵心殿" },
  }
  local szMsg = "想去哪，就去哪。"
  local tbOpt = {}
  local nMapId = him.GetWorldPos()
  local tbInstancing = TreasureMap2:GetInstancing(nMapId)
  if not tbInstancing or tbInstancing:IsOpen() ~= 1 then
    return
  end
  for i = 2, tbInstancing.nStep do
    if tbPos[i] then
      table.insert(tbOpt, { tbPos[i][2], self.NewWorld, self, nMapId, tbPos[i][1] })
    end
  end
  tbOpt[#tbOpt + 1] = { "我再想想" }
  Dialog:Say(szMsg, tbOpt)
end
function tbLulutong:NewWorld(nMapId, tbPos)
  me.NewWorld(nMapId, unpack(tbPos))
end
