------------------------------------------------------
-- 文件名　：alternpc.lua
-- 创建者　：dengyong
-- 创建时间：2012-11-21 10:17:24
-- 描  述  ：重生NPC脚本
------------------------------------------------------
local tbNpc = Npc:GetClass("alternpc")
function tbNpc:OnDialog()
  if Player:IsAlterOpen() == 0 then
    Dialog:Say("该功能即将开放，敬请期待。")
    return
  end

  local szMsg = [[<color=green>我佛慈悲，凡大彻大悟者，

皆可重排轮回，入于涅槃。

然入轮回之道，

需一世间珍奇得以保全今日种种，

此物位于忘川河畔，菩提树下，

名曰“三生石”。<color>]]

  local tbOpt = {
    { "<color=yellow>角色重生<color>", self.ApplyOpenWindow, self },
  }

  Dialog:Say(szMsg, tbOpt)
end

function tbNpc:ApplyOpenWindow()
  me.CallClientScript({ "UiManager:OpenWindow", "UI_REINCARNATE" })
end
