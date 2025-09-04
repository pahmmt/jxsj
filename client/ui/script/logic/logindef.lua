local tbLogin = Ui.tbLogic.tbLogin or {}
Ui.tbLogic.tbLogin = tbLogin

tbLogin.emLOGINSTATUS_NULL = 0 -- 无状态
tbLogin.emLOGINSTATUS_IDLE = 1 -- 空闲
tbLogin.emLOGINSTATUS_LOGGING = 2 -- 登录中
tbLogin.emLOGINSTATUS_SELROLE = 3 -- 选择角色
tbLogin.emLOGINSTATUS_ENTERING_GAME = 4 -- 进入游戏中
tbLogin.emLOGINSTATUS_ENTERED_GAME = 5 -- 已进入游戏
tbLogin.emLOGINSTATUS_OPT_CREATEROLE = 6 -- 创建角色选项
tbLogin.emLOGINSTATUS_WAIT_CREATEROLE = 7 -- 创建角色中
tbLogin.emLOGINSTATUS_LIMIT = 8 -- 防沉迷补填信息
tbLogin.emLOGINSTATUS_AGREE = 9 -- 阅读协议中
tbLogin.emLOGINSTATUS_DEAD = 10 -- 整个进程准备退出，其实不太想把这个状态放这里，但剑世的逻辑都这么写了
tbLogin.emLOGINSTATUS_ACTIVECODE = 11 -- 需要激活码，激活码验证中

-- 事件
tbLogin.emKOBJEVENTTYPE_NONE = 0x00000000
tbLogin.emKOBJEVENTTYPE_LOGIN_BEGIN = 0x00001000
tbLogin.emKOBJEVENTTYPE_LOGIN_CONNECT = 0x00001001 -- 连接到网关结果
tbLogin.emKOBJEVENTTYPE_LOGIN_DISCONNECT = 0x00001002 -- 与网关断开连接
tbLogin.emKOBJEVENTTYPE_STATUS_CHANGE = 0x00001003 -- 状态切换
tbLogin.emKOBJEVENTTYPE_LOGIN_RESULT = 0x00001004 -- 帐号验证结果
tbLogin.emKOBJEVENTTYPE_ENTER_GAME_RESULT = 0x00001005 -- 进入游戏结果
tbLogin.emKOBJEVENTTYPE_PRE_CREATE_ROLE = 0x00001006 -- 准备创建角色
tbLogin.emKOBJEVENTTYPE_CREATE_ROLE_RESULT = 0x00001007 -- 创建角色结果
tbLogin.emKOBJEVENTTYPE_YY_LOGIN = 0x00001008 -- YY方式登录
tbLogin.emKOBJEVENTTYPE_YY_BIND = 0x00001009 -- YY绑定金山帐号

tbLogin.tbLoginErrorMsg = {
  [1] = "登录成功",
  [2] = "服务器忙",
  [3] = "帐号或密码错误,如果您的账号存在风险，建议您进行自助冻结。",
  [4] = "帐号正在登录中，建议您进行自助踢号。",
  [5] = "帐号点数不足",
  [9] = "因为使用了非官方客户端，账号被暂时冻结，请稍后再登录",
  [10] = "协议版本不兼容",
  [11] = "账号被冻结，请确认是否本人操作，建议您进行账号自助解冻或咨询客服028-85437733",
  [12] = "账号被短信冻结",
  [13] = "账号未激活",
  [14] = "账号踢出中",
  [15] = "此帐号已在其他区服登录，请稍候再试！",
  [16] = "因为使用了非官方客户端，账号被暂时冻结，请稍后再登录",
  [17] = "输入的激活码错误",
  [18] = "账号未被激活,需要激活码",
  [20] = "系统维护中",
  [24] = "激活码不存在",
  [25] = "激活码已经被使用过了",
  [26] = "该帐号为防沉迷对象，限制登录，离线5小时后恢复",
  [27] = "动态密码系统出现异常，请稍后再试用！",
  [28] = "令牌正在被使用",
  [29] = "动态密码验证失败",
  [30] = "动态密码已经超过使用期限",
  [31] = "动态密码绑定异常",
  [32] = "动态密码已经挂失",
  [33] = "防沉迷账号信息不完整",
  [34] = "帐号需要激活才能登录",
  -- 客户端自己返回
  [8086] = "获取帐号密码失败，请重新登录",
  [8087] = "连接服务器失败，请重新选择服务器",
}

tbLogin.tbCreateRoleErrorMsg = {
  [4] = "角色的名字不合法，请另起名字！",
  [5] = "角色名已存在，请另起名字！",
  [6] = "已达到了最大角色数，无法再创建角色！",
  [7] = "已达到了最大角色数，无法再创建角色！",
}

tbLogin.LOGINWAY_KS = 1
tbLogin.LOGINWAY_YY = 2

--自助冻结解冻URL
tbLogin.szLockUrl = "http://safe.xoyo.com/zizhu/"
tbLogin.szUnLockUrl = "http://safe.xoyo.com/zizhu/"
tbLogin.szKickUrl = "http://safe.xoyo.com/zizhu/"
