-- 文件名  : xidianquan.lua
-- 创建者  : jiazhenwei
-- 创建时间: 2010-12-12 13:44:28
-- 描述    : 大逃杀 洗点券

local tbItem = Item:GetClass("xidianquan")

function tbItem:OnUse()
  local tbOpt = {
    { "使用", self.OnUseEx, self, it },
    { "我再想想" },
  }

  Dialog:Say("洗点券会将你的潜能点和技能点都洗去，你是否要使用呢？", tbOpt)
end

function tbItem:OnUseEx(pItem)
  me.ResetFightSkillPoint()
  me.UnAssignPotential()
  pItem.Delete(me)
  return 1
end
