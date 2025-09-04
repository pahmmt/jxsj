Require("\\script\\fightskill\\enchant\\enchant.lua")

local tb = {
  --中级秘籍：碧月飞星
  biyuefeixingadd = {
    {
      RelatedSkillId = 787, --幻影追魂枪&子
      magic = {
        missile_range = {
          value1 = { SkillEnchant.OP_ADD, { { 1, 1 }, { 10, 1 } } },
          value3 = { SkillEnchant.OP_ADD, { { 1, 1 }, { 10, 1 } } },
        },
      },
    },

    {
      RelatedSkillId = 492, --幻影追魂枪
      magic = {
        skill_mintimepercast_v = {
          value1 = { SkillEnchant.OP_ADD, { { 1, -18 }, { 10, -18 * 10 }, { 11, -18 * 10 } } },
        },
        skill_mintimepercastonhorse_v = {
          value1 = { SkillEnchant.OP_ADD, { { 1, -18 }, { 10, -18 * 10 }, { 11, -18 * 10 } } },
        },
      },
    },

    {
      RelatedSkillId = 148, --魔音噬魄子弹
      magic = {
        missile_range = {
          value1 = { SkillEnchant.OP_ADD, { { 1, 2 }, { 10, 4 }, { 11, 4 } } },
          value3 = { SkillEnchant.OP_ADD, { { 1, 2 }, { 10, 4 }, { 11, 4 } } },
        },
      },
    },
  },
  --高级秘籍：
  zhanrenadvancedbookadd = {
    {
      RelatedSkillId = 492, --幻影追魂枪
      magic = {
        skill_mintimepercast_v = {
          value1 = { SkillEnchant.OP_ADD, { { 1, -18 * 0.5 }, { 10, -18 * 2.5 }, { 11, -18 * 2.5 } } },
        },
        skill_mintimepercastonhorse_v = {
          value1 = { SkillEnchant.OP_ADD, { { 1, -18 * 0.5 }, { 10, -18 * 2.5 }, { 11, -18 * 2.5 } } },
        },
      },
    },
    {
      RelatedSkillId = 787, --幻影追魂枪
      magic = {
        state_zhican_attack = {
          value1 = { SkillEnchant.OP_ADD, { { 1, 40 }, { 10, 100 }, { 11, 105 } } },
          value2 = { SkillEnchant.OP_ADD, { { 1, 2.5 * 18 }, { 10, 2.5 * 18 } } },
        },
      },
    },
    {
      RelatedSkillId = 148, --魔音噬魄
      magic = {
        skill_mintimepercast_v = {
          value1 = { SkillEnchant.OP_ADD, { { 1, -18 }, { 10, -18 * 10 }, { 11, -18 * 10 } } },
        },
        skill_mintimepercastonhorse_v = {
          value1 = { SkillEnchant.OP_ADD, { { 1, -18 }, { 10, -18 * 10 }, { 11, -18 * 10 } } },
        },
      },
    },

    {
      RelatedSkillId = 847, --飞鸿无迹
      magic = {
        skill_mintimepercast_v = {
          value1 = { SkillEnchant.OP_ADD, { { 1, -18 }, { 10, -18 * 15 }, { 11, -18 * 15 } } },
        },
        skill_mintimepercastonhorse_v = {
          value1 = { SkillEnchant.OP_ADD, { { 1, -18 }, { 10, -18 * 15 }, { 11, -18 * 15 } } },
        },
      },
    },
  },
  --中级秘籍：玄冥吸星
  xuanmingxixingadd = {
    {
      RelatedSkillId = 494, --玄冥吸星
      magic = {
        skill_mintimepercast_v = {
          value1 = { SkillEnchant.OP_ADD, { { 1, -18 }, { 10, -18 * 10 }, { 11, -18 * 10 } } },
        },
        skill_mintimepercastonhorse_v = {
          value1 = { SkillEnchant.OP_ADD, { { 1, -18 }, { 10, -18 * 10 }, { 11, -18 * 10 } } },
        },
        missile_range = {
          value1 = { SkillEnchant.OP_ADD, { { 1, 2 }, { 10, 6 }, { 11, 6 } } },
          value3 = { SkillEnchant.OP_ADD, { { 1, 2 }, { 10, 6 }, { 11, 6 } } },
        },
        missile_lifetime_v = {
          value1 = { SkillEnchant.OP_ADD, { { 1, 18 }, { 10, 18 * 5 }, { 11, 18 * 5 } } },
        },
      },
    },

    {
      RelatedSkillId = 151, --弹指烈焰
      magic = {
        skill_mintimepercast_v = {
          value1 = { SkillEnchant.OP_ADD, { { 1, -18 * 0.5 }, { 5, -18 * 1 }, { 10, -18 * 1.5 }, { 11, -18 * 1.5 } } },
        },
        skill_mintimepercastonhorse_v = {
          value1 = { SkillEnchant.OP_ADD, { { 1, -18 * 0.5 }, { 5, -18 * 1 }, { 10, -18 * 1.5 }, { 11, -18 * 1.5 } } },
        },
      },
    },

    {
      RelatedSkillId = 153, --推山填海
      magic = {
        skill_mintimepercast_v = {
          value1 = { SkillEnchant.OP_ADD, { { 1, -18 * 0.5 }, { 5, -18 * 1 }, { 10, -18 * 1.5 }, { 11, -18 * 1.5 } } },
        },
        skill_mintimepercastonhorse_v = {
          value1 = { SkillEnchant.OP_ADD, { { 1, -18 * 0.5 }, { 5, -18 * 1 }, { 10, -18 * 1.5 }, { 11, -18 * 1.5 } } },
        },
      },
    },
  },
  --高级秘籍:九曲一合枪
  jiuquadd = {
    {
      RelatedSkillId = 847, --飞鸿无迹
      magic = {
        floatdamage_p = {
          value1 = { SkillEnchant.OP_MUL, { { 1, -30 }, { 10, -30 }, { 12, -25 } } },
          value2 = { SkillEnchant.OP_MUL, { { 1, -30 }, { 10, -30 }, { 12, -25 } } },
        },
      },
    },
    {
      RelatedSkillId = 1178, --飞鸿无迹_对玩家伤害
      magic = {
        floatdamage_p = {
          value1 = { SkillEnchant.OP_MUL, { { 1, -30 }, { 10, -30 }, { 12, -25 } } },
          value2 = { SkillEnchant.OP_MUL, { { 1, -30 }, { 10, -30 }, { 12, -25 } } },
        },
      },
    },
  },
}

SkillEnchant:AddBooksInfo(tb)
