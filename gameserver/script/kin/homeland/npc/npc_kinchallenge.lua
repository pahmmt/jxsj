------------------------------------------------------
-- 文件名　：npc_kinchallenge.lua
-- 创建者　：dengyong
-- 创建时间：2012-10-09 20:02:04
-- 描  述  ：家族挑战令相关NPC脚本
------------------------------------------------------

-- 挑战BOSS
local tbNpc = Npc:GetClass("homeland_boss")
function tbNpc:OnDeath(pKiller)
  HomeLand:OnChallengeBossDeath(pKiller)
end

-- 奖励箱子
local tbBox = Npc:GetClass("homeland_box")
function tbBox:OnDialog()
  local szMsg = "领取奖励？"
  local tbOpt = {
    { "领取奖励", HomeLand.OpenAwardBox, HomeLand },
    { "我再想想 " },
  }
  Dialog:Say(szMsg, tbOpt)
end

-- 对话Npc
local tbDialoger = Npc:GetClass("homeland_dialog")
function tbDialoger:OnDialog()
  local szMsg = [[    如果你对你身处的家族实力有足够的信心，就可以在这里接受意识英魂对家族的考验。若成功，不但可以得到丰厚的经验，玄晶等奖励，还可以使<color=yellow>参加挑战的家族玩家间的亲密度大幅提升！<color> 
    <color=yellow>另外，还有一定几率遇到知名英雄的考验，若挑战成功的话奖励会更加丰厚！<color>
    然欲速则不达，<color=yellow>每日家族能挑战的次数有限<color>，务必厉兵秣马，准备妥善后再行挑战。切记！]]
  local tbOpt = {
    { "开启家族挑战", HomeLand.ApplyChallenge, HomeLand },
    { "我知道了" },
  }
  Dialog:Say(szMsg, tbOpt)
end
