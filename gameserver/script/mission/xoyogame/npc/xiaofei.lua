-- 晓菲
local tbXiaoFei = Npc:GetClass("xoyonpc_xiaofei") -- id:3319
function tbXiaoFei:OnDialog()
  if TimeFrame:GetState("OpenXoyoGameTask") ~= 1 then
    Dialog:Say("我这有个好东西，不过还没到给你的时候。")
    return
  end

  local szMsg = "听说逍遥谷有很多神奇的卡片，我这有本收集录给你，你只要把收集到的卡片放入其中，我会根据你收集的卡片数量及排名给你奖赏。"
  szMsg = szMsg .. "<enter><color=red>对了，我这还有很多宝物卡，不过你得给我弄到这些宝物我才能给你。<color>"

  local tbOpt = {
    { "领取逍遥录", self.GetXoyolu, self },
    { "宝物换卡片", self.HandUpItem, self },
    { "我要换特殊卡", self.GetSpecialCard, self },
    { "我是来领奖的", self.GetAward, self },
    { "结束对话" },
  }

  --if tonumber(GetLocalDate("%Y%m%d")) < 20090501 then
  --	table.insert(tbOpt, 2, {"交还逍遥录", self.HandUpXoyolu, self});
  --end

  Dialog:Say(szMsg, tbOpt)
end

function tbXiaoFei:GetXoyolu()
  local nRes, szMsg = XoyoGame.XoyoChallenge:CanGetXoyolu(me)
  if nRes == 0 and szMsg then
    Dialog:Say(szMsg)
    return
  end

  XoyoGame.XoyoChallenge:GetXoyolu(me)
end

function tbXiaoFei:HandUpXoyolu()
  local nRes, szMsg = XoyoGame.XoyoChallenge:CanHandUpXoyolu(me)

  if nRes == 0 and szMsg then
    Dialog:Say(szMsg)
    return
  end

  local szMsg = string.format("你这个月共完成了<color=green>%d/%d<color>个挑战，确认现在就要把<color=green>逍遥录<color>交还给我吗？", XoyoGame.XoyoChallenge:GetGatheredCardNum(me), XoyoGame.XoyoChallenge:GetTotalCardNum())

  Dialog:OpenGift(szMsg, nil, { self.CallbackHandUpXoyolu, self })
end

function tbXiaoFei:CallbackHandUpXoyolu(tbItems)
  local nRes, szMsg = XoyoGame.XoyoChallenge:HandUpXoyolu(me, tbItems)
  if szMsg then
    Dialog:Say(szMsg)
  end
end

function tbXiaoFei:HandUpItem()
  local nRes, szMsg = XoyoGame.XoyoChallenge:CanHandUpItemForCard(me)
  if nRes == 0 and szMsg then
    Dialog:Say(szMsg)
    return
  end

  Dialog:OpenGift(XoyoGame.XoyoChallenge:ItemForCardDesc(), nil, { self.CallbackHandUpItem, self })
end

function tbXiaoFei:CallbackHandUpItem(tbItems)
  local nRes, szMsg = XoyoGame.XoyoChallenge:HandUpItemForCard(me, tbItems)
  if szMsg then
    Dialog:Say(szMsg)
  end
end

function tbXiaoFei:GetSpecialCard()
  local nRes, szMsg = XoyoGame.XoyoChallenge:CanGetSpecialCard(me)
  if nRes == 0 and szMsg then
    Dialog:Say(szMsg)
    return
  end

  Dialog:OpenGift("可以用血影枪、灵兽战靴、遁甲灵符、紫晶幻佩、七彩仙丹中的任意一种换取特殊卡，一个换一张，每天最多换两张。", nil, { self.CallbackGetSpecialCard, self })
end

function tbXiaoFei:CallbackGetSpecialCard(tbItems)
  local nRes, szMsg = XoyoGame.XoyoChallenge:GetSpecialCard(me, tbItems)
  if szMsg then
    Dialog:Say(szMsg)
  end
end

function tbXiaoFei:GetAward()
  local nRes, szMsg = XoyoGame.XoyoChallenge:GetAward(me)
  if szMsg then
    Dialog:Say(szMsg)
  end
end

--?pl DoScript("\\script\\mission\\xoyogame\\npc\\xiaofei.lua")
