-- 文件名　：duanxiaomodaoshi.lua
-- 创建者　：jiazhenwei
-- 创建时间：2009-10-28 11:04:30
-- 描  述  ：
local tbItem = Item:GetClass("duanxiaomodaoshi")
tbItem.nDuration = Env.GAME_FPS * 10
tbItem.nSkillId = 387

function tbItem:OnUse()
  me.AddSkillState(self.nSkillId, 8, 1, self.nDuration)
  me.AddSkillState(697, 8, 0, 10 * 18, 0, 1, 0, 0, 1)
  return 1
end

function tbItem:GetTip()
  local szTip = FightSkill:GetSkillItemTip(self.nSkillId, 8)

  szTip = szTip .. "\n能发现隐身对手"

  -- 自己处理状态持续时间
  szTip = szTip .. string.format("\n<color=white>持续时间：<color><color=gold>%s<color>\n", Lib:FrameTimeDesc(self.nDuration))
  return szTip
end
