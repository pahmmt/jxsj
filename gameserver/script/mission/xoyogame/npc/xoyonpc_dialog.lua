---

local tbNpc = Npc:GetClass("xoyonpc_dialog")

local tbDialogMsg = {
  --	NPC ID   进度条字样		横幅字样
  [3251] = { "调查中……", "石像轰然倒塌之时，一股暴虐之气直冲我们来时的山坡方向而去。" },
  [3252] = { "机关开启中……", "该机关已成功开启。" },
  [3253] = { "机关开启中……", "该机关已成功开启。" },
  [3254] = { "机关开启中……", "石像轰然倒塌之时，前方的铁栅栏也随之打开。" },
  [3255] = { "机关开启中……", "石像轰然倒塌的之时，密道的出口也随之打开。" },
  [3289] = { "调查中……", "石碑轰然碎裂，周围突然冒出一堆凶猛的机关兽……" },
  [3257] = { "开启袋子中……", "哇！好多水果……不，好多果农！" },
  [3258] = { "开启宝箱中……", "哇！好多宝贝……不好！这是陷阱……" },
  [3259] = { "采集中……", "果子没采着，到是惹来一群野猴……" },
  [3260] = { "开启宝箱中……", "陷阱！……" },
  [3293] = { "开启宝箱中……", "宝箱里空空如也……" },
  [3298] = { "调查中……", "早知道没好东西出现……" },
  [3299] = { "调查中……", "果然又是陷阱……" },
  [3300] = { "调查中……", "还是陷阱……" },
  [3304] = { "开启袋子中……", "把这些西瓜送回去，顺便看看还有什么可以帮助他的吧。" },
  [4656] = { "机关开启中……", "另一侧的城门已经打开！" },
  [4657] = { "机关开启中……", "另一侧的城门已经打开！" },
  [4658] = { "机关开启中……", "另一侧的城门已经打开！" },
  [4659] = { "机关开启中……", "另一侧的城门已经打开！" },
  [7344] = { "机关开启中……", "障碍已经消失，冲过去吧！" },
  [10192] = { "采摘中……", "嘿，好大个的西瓜！" },
  [10196] = { "开启宝箱中……", "宝箱已成功打开" },
  [10203] = { "解读中……", "剑碑上记载着一些模糊的文字……" },
}

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
  Player.ProcessBreakEvent.emEVENT_LOGOUT,
  Player.ProcessBreakEvent.emEVENT_DEATH,
  Player.ProcessBreakEvent.emEVENT_ATTACKED,
}

function tbNpc:OnDialog()
  local nTime = tonumber(him.GetSctiptParam())
  if not nTime then
    self:EndProcess(him.dwId)
  else
    if him.GetTempTable("XoyoGame").nDontTalk then
      return
    else
      if XoyoGame:IsInLock(him) == 1 then
        local szMsg = "开启中..."
        if tbDialogMsg[him.nTemplateId] then
          szMsg = tbDialogMsg[him.nTemplateId][1]
        end
        GeneralProcess:StartProcess(szMsg, nTime * Env.GAME_FPS, { self.EndProcess, self, him.dwId }, nil, tbEvent)
      end
    end
  end
end

function tbNpc:EndProcess(nNpcId)
  local pNpc = KNpc.GetById(nNpcId)
  if not pNpc then
    return 0
  end
  XoyoGame:NpcUnLock(pNpc)
  XoyoGame:NpcClearLock(pNpc)
  local szMsg = "该机关已经开启了"
  if tbDialogMsg[pNpc.nTemplateId] then
    szMsg = tbDialogMsg[pNpc.nTemplateId][2]
  end
  pNpc.Delete()
  Dialog:SendBlackBoardMsg(me, szMsg)
end
