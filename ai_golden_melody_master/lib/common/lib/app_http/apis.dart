class APIs {
  static const String apiPrefix = "https://inchat.beiyinapp.com/"; // 线上环境
  static const String channel = "2ce49c9cee03d75a";

  // static const String apiPrefix = "https://chatest.beiyinapp.com/"; // 测试环境

  /// 启动接口（游客登陆）- 获取 token
  static const String launch = 'api/login/tourist';

  /// 注销账户
  static const String accountCancellations = 'api/user/accountCancellations';

  /// 启动接口（游客登陆）- 获取 token
  static const String deviceInfo = 'api/user/device';

  /// 微信登陆
  static const String loginByWX = 'api/login/wx';

  /// 一键登录
  static const String oneclickv2 = 'api/login/oneclickv2';

  /// 获取登陆验证码
  static const String sendVCode = "api/login/sendCode";

  /// 手机号登陆
  static const String loginByPhone = "api/login/phone";

  /// 退出登陆
  static const String logout = "api/user/logout";

  /// 自功能列表
  static const String showcaseList = "api/HomeConfig/showcaseList";

  /// 推小果列表
  static const String homeHotlist = "api/tuixiaoguo/hotlist";

  /// 推小果URL
  static const String tuixiaoguoUrl = "api/Navigation/getTuixiaoguoUrl";

  /// 检查DNS
  static const String dnsCheck = "api/dns/check";

  /// 首页广播
  static const String homeBroadcast = "api/tuixiaoguo/broadcast";

  /// 首页banner
  static const String homeBanner = "api/HomeConfig/bannerList";

  /// 个人信息
  static const String loadUserInfo = "api/user/info";

  /// 个人作品
  static const String getWorkList = "api/UserWorkLog/getWorkList";

  /// 删除个人作品
  static const String deleteWork = "api/UserWorkLog/deleteWorkLog";

  /// 个人作品详情
  static const String getWorkDetail = "api/UserWorkLog/getWorkDetail";

  /// 设置项目
  static const String loadSettingIems = "api/user/menus";

  ///
  static const String legalright = "api/user/legalright";

  /// 首页顶部的滚动列表配置
  static const String getHomeScrollListConfig =
      "HomeConfig/getHomeBannerConfig";

  ///====================== VIP ======================

  /// 获取VIP套餐列表
  static const String vipHappys = "api/vip/happys";

  /// 获取VIP权益列表
  static const String vipRights = "api/vip/rights";

  /// 获取文案提取列表
  static const String getExtractTextList = "api/ExtractText/getExtractTextList";

  /// 判断支付后是否展示客服引导弹窗
  static const checkVipGuidStaus = "api/vip/page";

  ///====================== 智能混剪 ======================
  static const String createUserWork = "api/UserWorkLog/addLog";
  static const String updateWorkLog = "api/UserWorkLog/updateWorkLog";
  static const String textRisk = "api/risk/textRisk";
  static const String getCommentarySimpleText =
      "Commentary/getCommentarySimpleText";

  ///====================== 文字提取 ======================
  static const String textExtract = "api/ExtractText/ocr";
  static const String imageUpladInfo = "api/image/imageUpladInfo";
  static const String extractTextBatchDelete = "api/ExtractText/batchDelete";
  static const String createAudioRecognitionTask =
      "ExtractText/createAudioRecognitionTask";
  static const String queryAudioRecognitionTask =
      "ExtractText/queryAudioRecognitionTask";

  ///====================== 故事创作 ======================
  static const String generalPresets = "api/general/presets";
  static const String generalRichmessage = "api/general/richmessage";
  static const String generalMessage = "api/general/message";
  static const String richmessageconfig = "api/general/richmessageconfig";
  static const String parseDelete = "api/video/batchDeleteParseLog";

  /// AI 创作纪录
  static const String generalChats = "api/general/chatlist";
  static const String generalDelMsg = "api/general/delMsg";
  static const String generaIlnfo = "api/general/info";
  static const String batchDeleteMsg = "api/creator/batchDeleteMsg";
  static const String chatList = "api/general/chats";
  static const String cleanUpChat = "api/user/cleanupchat";

  /// AI 助手
  static const String creators = "api/creator/creators";
  static const String creatorPageInfo = "api/creator/info";
  static const String creatorMessage = "api/creator/message";
  static const String assistantRecord = "api/creator/chatlist";
  static const String assistantDelMsg = "api/creator/delMsg";
  static const String export = "api/creator/export";

  ///AIchat
  static const String getModelList = "api/role/getModelList";
  static const String getDefaultPrompt = "api/role/getDefaultPrompt";

  ///AI 音乐
  static const String musicAiGetConfig = "api/MusicAi/getConfig";
  // 根据music的id查询music详情
  static const String queryAiMusicTask = "api/MusicAi/queryAiMusicTask";

  ///AI 音乐创建任务
  static const String musicAiCreateTask = "api/MusicAi/createTask";
  static const String aiLyrics = "api/MusicAi/aiLyrics";
  static const String getTaskList = "api/MusicAi/getTaskList";
  static const String getDetailList = "api/MusicAi/getDetailList";
  static const String batchDeleteDetails = "api/MusicAi/batchDeleteDetails";
  static const String getRightsByType = "api/vip/getRightsByType";

  /// 获取云端素材库列表
  static const String cloudVideosList =
      "api/MultiMedia/getMaterialListWithDetail";

  /// 获取素材详情(分集)
  static const String getMaterialDetail = "api/MultiMedia/getMaterialDetail";

  /// 创建VIP支付订单
  static const String createVipOrder = "api/vip/orderv2";
  static const String getConfig = "api/SuperConfigs/listByGroup";
  static const String queryOrderStatus = "api/vip/query";
  static const String imageErase = "api/FileErase/imageErase";
  static const String getEraseRecords = "api/FileErase/getEraseList";

  /// 视频提取
  static const String parseShareUrl = "api/video/parseShareUrl";
  static const String getParseList = "api/video/getParseList";

  // 更新视频提取的任务状态
  // static const String updateParseVideoAddress = "api/video/updateParseVideoAddress";

  static const String videoIntroList = "api/video/videoIntroList";
  // static const String dubbingList = "api/dubbing/initDubbing";
  static const String speakerList = "api/dubbing/speakerList";
  static const String vipPage = "api/vip/page";
  static const String voiceStyle = "api/Commentary/getOptimizeStyles";
  static const String optimizeText = "api/Commentary/optimizeText";

  /// 配乐分类列表
  static const String bgmCategoryList = "api/VideoMix/getBgmCateList";

  /// 配乐列表
  static const String bgmList = "api/VideoMix/bgmList";
  static const String getParseShareUrlConfig =
      "api/video/getParseShareUrlConfig";

  /// 生成解说文案
  static const String getCommentaryList = "api/Commentary/getCommentaryText";

  /// 查看解说文案生成进度
  static const String queryOptimizeTextState = "api/Commentary/queryState";

  /// 文字转语音
  static const String createDubbingTask = "api/dubbing/ttsV1";

  /// 批量创建任务
  static const String ttsV1Batch = "api/dubbing/ttsV1Batch";

  /// 转语音详情
  static const String getDubbingTaskDetails = "api/dubbing/getTtsByPid";

  /// 批量获取作品详情
  static const String getTtsByPids = "api/dubbing/getTtsByPids";

  /// 绑定手机号
  static const String bindPhone = "api/user/bindphonev2";

  /// ********************************** v2 **********************************
  /// AI绘图页面配置信息
  static const String drawConfig = "api/QiumiImage/config";

  /// 变现教学
  static const String aiCashTutor = "api/SuperConfigs/allV2";

  /// AI绘图同款案例信息 / ai广场
  static const String aiSquare = "api/QiumiImage/square";
  // AI音乐
  static const String getSquareList = "api/MusicAi/getSquareList";
  //AIbanner
  static const String getBannerList = "api/MusicAi/getBannerList";
  // AI绘图

  /// AI绘图
  static const String aiImageCreate = "api/QiumiImage/create";

  /// AI绘图进度查询
  static const String aiImageCreateProgress = "api/QiumiImage/query";

  /// AI绘图详情
  static const String aiImageDetails = "api/QiumiImage/picinfo";

  /// 我的所有图片
  static const String allAiPictures = "api/QiumiImage/allpictures";

  /// 图片详情
  static const String picInfo = "api/QiumiImage/picinfo";

  /// 我的图片带状态参数
  static const String aiPictures = "api/QiumiImage/pictures";

  /// ai广场
  // static const String aiSquare = "api/QiumiImage/square";

  /// 推文画面风格
  static const String screenStyleList = "api/VideoV2/screenStyleList";

  /// 视频比例列表
  static const String videoRatioList = "api/VideoBy/videoScaleList";

  /// 视频字体列表
  static const String videoFontList = "api/VideoBy/typeFaceListV2";

  /// ai配音列表
  static const String viVoiceList = "api/VideoV2/ttsList";

  /// ai本地bgm列表
  static const String customBgmList = "api/Material/getSelfMaterial";

  /// ai本地bgm上传
  /// 类型:文本 text 图片img 背景音乐bgm 视频video
  static const String uploadBgm = "api/Material/saveSelfMaterial";

  /// ai本地bgm上传
  /// 类型:文本 text 图片img 背景音乐bgm 视频video
  static const String aiSpeakerList = "api/DubbingLow/speakerList";

  /// 图文生视频第一步(保存基本参数)
  static const String saveVideoStep1 = "api/videoBy/videoStep1";

  /// 获取推文随机
  static const String getRandText = "api/video/getRandText";

  /// 获取文本分段
  static const String articleSplit = "api/videoV2/articleSplit";

  /// 获取文本分段
  static const String videoStep2 = "api/videoBy/videoStep2";

  /// 获取文本分段
  static const String imgsList = "api/videoV2/getById";

  /// 删除分段图片
  static const String cleanItemImg = "api/videoV2/cleanItemImg";

  /// 生成(或上传或者重绘)单张图片
  static const String regenerateImg = "api/videoBy/submitItemImg";

  /// 换一张图库
  static const String searchSplitImg = "api/videoBy/searchSplitImg";

  /// 视频管理列表
  static const String videoList = "api/video/getMyVideoParamsV2";

  /// 视频生成
  static const String videoSubmit = "api/videoBy/submitTaskById";

  /// 删除视频
  static const String batchDeleteMyWork = "api/video/batchDeleteMyWork";

  /// 获取首页变现案例tab配置
  static const String getTabsConfig = "api/HomeConfig/getExampleTabsConfig";

  /// 鉴黄
  static const String contentsRisk = "api/risk/risk";

  /// 删除图片
  static const String batchDeletePictures = "api/QiumiImage/deleteOrders";

  /// 获取作品数量
  static const String getWorksCount = "api/user/getWorksCount";

  /// 获取用户作品
  static const String getUserWorks = 'api/user/getWorksCountArr';

  /// 推文广场
  static const String videoSquareList = "api/HomeConfig/videoSquareList";

  /// ***************************************** 智能混剪 *****************************************
  /// 获取云端素材库列表
  static const aiCloudMaterialList =
      "api/MultiMedia/getMaterialCateWithPackList";

  /// 按分类获取明细列表
  static const aiGetDetailList = "api/MultiMedia/getDetailList";

  /// 云端素材库样片列表
  static const aiMaterialDemoList = "api/MultiMedia/getMaterialDemoList";

  /// 图文生视频第一步(保存基本参数)
  static const aiClipSave = "api/videoMix/videoStep1";

  /// 视频比例列表
  static const aiVideoScaleList = "api/VideoMix/videoScaleList";

  /// 字体列表
  static const aiTypeFaceList = "api/VideoMix/typeFaceList";

  /// 获取云端素材库列表
  static const aiBgmCateList = "api/VideoMix/getBgmCateList";

  /// 获取云端素材库列表
  static const aiBgmList = "api/VideoMix/bgmList";

  /// 获取云端素材库列表
  static const aiMaterialsList = "api/MultiMedia/getMaterialCateWithPackList";

  /// 获取片头
  static const aiMaterialsOpeningList = "api/MultiMedia/getMaterialTitlesList";

  /// 创建配音
  static const aiTtsVideo = "api/DubbingLow/ttsVideo";

  /// ***************************************** AI 视频 *****************************************

  /// 广场视频列表
  static const aiVideoCategoryDetail = "api/VideoAi/getAiVideoCategoryDetail";

  /// 视屏详情
  static const queryAiVideoTask = "api/VideoAi/queryAiVideoTask";

  /// ***************************************** 智能混剪 *****************************************
  /// ***************************************** 积分权益 *****************************************

  /// 积分套餐列表
  static const scoreHappys = "api/IntegralVip/happys";

  /// 积分页面数据
  static const scoresInfo = "api/IntegralVip/page";

  /// 积分日志
  static const scoreRecords = "api/IntegralVip/logs";

  /// 创建订单
  static const createOrder = "api/IntegralVip/order";

  /// 积分创建订单
  static const createOrderv2 = "api/IntegralVip/orderv2";

  /// 查询订单状态
  static const queryOrder = "api/IntegralVip/query";

  /// ***************************************** 积分权益 *****************************************

  /// ***************************************** 数字人 *****************************************
  /// 声音克隆 --------
  /// 获取克隆列表
  static const getUserAudioCloneList =
      "api/UserAudioClone/getUserAudioCloneList";

  /// 删除声音克隆
  static const deleteUserAudioClone = "api/UserAudioClone/deleteUserAudioClone";

  /// 修改声音克隆标题
  static const renameUserAudioClone = "api/UserAudioClone/renameUserAudioClone";

  /// 创建声音克隆
  static const createUserAudioClone = "api/UserAudioClone/createUserAudioClone";

  /// 获取默认的朗读文本
  static const getDefaultTxt = "api/UserAudioClone/getDefaultTxt";

  /// 删除上传的视频
  static const deleteUserVideo = "api/Material/deleteSelfMatrial";

  /// 上传视频
  static const uploadUserVideo = "api/Material/saveSelfMaterial";

  /// 获取配音详情
  static const queryUserAudioClone = "api/UserAudioClone/queryUserAudioClone";

  /// 保存音色
  static const saveUserAudioClone = "api/UserAudioClone/saveUserAudioClone";

  /// 创建配音任务
  static const createUserAudioTTS = "api/UserAudioTTS/createUserAudioTTS";

  /// 获取配音详情
  static const getUserAudioTTS = "api/UserAudioTTS/getUserAudioTTS";

  /// 删除任务
  static const deleteUserAudioTTS = "api/UserAudioTTS/deleteUserAudioTTS";

  /// 获取任务列表
  static const getUserAudioTTSList = "api/UserAudioTTS/getUserAudioTTSList";

  /// 重命名配音
  static const renameUserAudioTTS = "api/UserAudioTTS/renameUserAudioTTS";

  /// 口播 --------
  /// 创建口播(数字人)任务
  static const createDigitalHuman = "api/DigitalHuman/createDigitalHuman";

  /// 获取口播任务详情
  static const getDigitalHuman = "api/DigitalHuman/getDigitalHuman";

  /// 口播任务列表
  static const getDigitalHumanList = "api/DigitalHuman/getDigitalHumanList";

  /// 删除任务
  static const deleteDigitalHuman = "api/DigitalHuman/deleteDigitalHuman";

  /// 转换视频比特率
  static const convertVideoRatio = "api/video/changeScale";

  /// ***************************************** 数字人 *****************************************

  /// ***************************************** 新工具箱 *****************************************

  /// 工具箱列表类别
  static const crumbsCategoryList = "api//HomeConfig/crumbsCategoryList";

  /// 工具箱列表数据
  static const crumbsList = "api//HomeConfig/crumbsList";

  /// 获取推文视频详情
  static const videoSquareInfo = "api/HomeConfig/videoSquareInfo";

  /// ***************************************** 新工具箱 *****************************************
  /// ***************************************** 爆款复刻 *****************************************
  /// 创建爆款复刻任务
  static const createHotCopy = "api/videoMix/createHotCopy";

  /// ***************************************** 爆款复刻 *****************************************

  /// ***************************************** 爆文创作 *****************************************
  /// 获取分类配置
  static const categoryConfig = "api/Tuixiaobei/getConfig";

  /// 获取小说列表
  static const getNovelList = "api/Tuixiaobei/getNovelList";

  /// 获取小说章节列表
  static const getNovelDetailList = "api/Tuixiaobei/getNovelDetailList";

  /// 推广页菜单配置
  static const getPromotionMenu = "api/Navigation/getPromotionMenu";

  /// 混剪啊文案 - AI改写
  static const explanationDramaText = "api/VideoMix/explanationDramaText";

  /// ***************************************** 爆文创作 *****************************************

  ///首页智能绘图
  static const aiTips = "api/ImageChats/tips";

  ///首页智能回答
  static const aiPresets = "api/general/presets";

  ///首页ai动态视频
  static const aiVideoBanner = "api/VideoAi/getBannerList";

  ///首页ai写歌
  static const aiMusic = "api//MusicAi/getBannerList";

  ///批量导出ai创作
  static const exportAiNovelBatch = "api/AiNovel/exportAiNovelBatch";

  ///根据id 获取短剧详情
  static const getMaterialInfo = "api/MultiMedia/getMaterilInfo";

  ///头条回传
  static const oceanengineSuccess = "api/Oceanengine/success";
  static const oceanengineFail = "api/Oceanengine/fail";

  /// 新民间故事
  /// 获取民间故事详情
  static const storyInfo = "api/folkStory/getFolkStoryInfo";

  /// 获取民间故事列表
  static const folkStoryList = "api/folkStory/getFolkStoryList";

  /// 获取民间故事列表
  static const storyList = "api/folkStory/getFolkStoryList";

  /// 获取民间故事角色列表
  static const roleList = "api/folkStory/getRoleList";

  /// 获取角色详情
  static const roleInfo = "api/folkStory/getRoleInfo";

  /// 修改角色信息
  static const updateRoleInfo = "api/folkStory/updateRoleInfo";

  /// 角色重绘
  static const roleRepaint = "api/folkStory/roleRepaint";

  /// 手动开始分镜
  static const manualDrawScene = "api/folkStory/manualDrawScene";

  /// 获取分镜列表
  static const sceneList = "api/folkStory/getSceneList";

  /// 获取分镜信息
  static const sceneInfo = "api/folkStory/getSceneInfo";

  /// 修改分镜信息
  static const updateSceneInfo = "api/folkStory/updateSceneInfo";

  /// 分镜重绘
  static const sceneRepaint = "api/folkStory/sceneRepaint";

  /// 开始生成视频
  static const createVideoTask = "api/folkStory/createVideoTask";

  ///新的配乐列表
  static const String bgmListNew = "api/VideoMix/bgmListNew";

  ///公告
  static const String noticeData = "api/common/notice";

  /// 删除民间故事
  static const deleteFolkStory = "api/folkStory/delFolkStory";

  /// 一键成片
  /// 获取一键成片的分类
  static const String filmCategory = "api/common/OneClickFilmCategory";

  /// 根据分类id获取一键成片提示词列表
  static const String filmPrompt = "api/common/getOneClickFilmPrompt";

  /// 获取随机的故事灵感
  static const String randomPrompt = "api/common/getRandomPrompt";

  ///ios-支付相关
  static const iosOrder = "api/vip/orderv2";
  static const iosRepair = "api/vip/iosRepair";

  ///攻略列表
  static const String strategyGuideList = "api/ComConfig/strategyGuideList";

  ///图生视频（仅用于首尾帧与多图参考两种模式）
  static const String createFunnyVideoTask = "api/videoAi/createFunnyVideoTask";

  ///解锁会员页面配置数据
  static const String unlockMember = "music/config/unlockMember";

  /*
    **********************************
    ai金曲大师-首页
    **********************************
  */

  /// 获取首页数据
  static const String aiMusicHome = "music/home/index";

  ///获取精选作品
  static const String getSelectedWorks = "music/home/getSelectedWorks";

  ///歌曲榜单分类列表
  static const String getCategoryList = "music/home/getCategoryList";

  ///获取歌曲榜单作品
  static const String getRankWorks = "music/home/getRankWorks";

  /*
    **********************************
    ai金曲大师-攻略
    **********************************
  */

  ///获取分类列表
  static const String strategygetCategoryList = 'api/comConfig/getCategoryList';

  ///获取攻略列表
  static const String getStrategyGuideList =
      'api/comConfig/getStrategyGuideList';

  ///获取攻略详情
  static const String getStrategyGuideDetail =
      'api/comConfig/getStrategyGuideDetail';

  ///获取攻略配置
  static const String getStrategyGuideConfig =
      'api/comConfig/getStrategyGuideConfig';

  ///member
  static const String member = "music/member/index";

  ///基础配置
  static const String config = "music/config/getConfig";

  ///ai music
  static const String aiMusicHintText = "music/creation/creative";

  ///获取热门话题
  static const String hotTopic = "music/creation/hotTopic";

  ///一键写歌-灵感模式
  static const String aiCreateMusic = "music/creation/createMusicBase";

  ///获取我的作品数量
  static const String myWorkNumber = "music/music/getMyWorkNumber";

  ///
  static const String getMyWorkList = "music/music/getMyWorkList";

  static const String getMusicDetail = "music/music/getMusicDetail";

  static const String musicScore = "music/member/integralLogs";

  ///得到音乐Ai配置
  static const String getAiMusicConfig = "music/creation/getConfig";

  ///生成歌词
  static const String createLyric = "music/creation/createLyric";

  ///查询任务
  static const String taskQuery = "music/creation/taskQuery";

  ///生成歌曲
  static const String createMusic = "music/creation/createMusicAdva";

  ///获取清唱音频数据接口
  static const String getMusicStrategyGuideList =
      "music/creation/getTrainLyric";

  ///训练音色
  static const String trainTimbre = "music/creation/trainTimbre";

  static const String getTrainTimbreList = "music/music/getTimbreList";

  ///一键同款
  static const String createSame = "music/creation/creative";

  ///修改音乐名称
  static const String reMusicName = "music/music/updateMusicName";

  ///修改作者名称
  static const String reNameAuthor = "music/music/updateMusicAuthor";

  ///删除歌曲
  static const String deleteMusic = "music/music/deleteMusic";

  ///获取VIP升级套餐列表
  static const String vipRiseHappys = "api/vip/risehappys";

  ///创建VIP升级订单
  static const String createRiseOrderV2 = "api/vip/riseorderv2";
  static const String aiCreateCover = "music/music/createAiCover";

  static const String getCoverList = "/music/music/getCoverList";

  ///生成封面提示文本
  static const String getAiHintText = "/music/music/createAiPrompt";

  static const String aiTaskQuery = "/music/music/getAiCover";

  ///修改封面
  static const String updateMusicCover = "/music/music/updateMusicCover";

  ///删除封面
  static const String deleteMusicCover = "/music/music/deleteCover";

  ///重新生成封面
  static const String restartAiCover = "music/music/restartAiCover";

  ///查询是否可以升级套餐
  static const String canRisehappys = "api/vip/canRisehappys";

  ///删除音频
  static const String deleteTimbre = "music/music/deleteTimbre";

  static const String updateTimbreName = "music/music/updateTimbreName";

  ///获取最近的训练一个任务
  static const String getLastTimbre = "music/music/getLastTimbre";

  ///获取第一个套餐
  static const String getFirstHappy = "api/vip/firstHappy";

  ///下载mp3
  static const String downloadMp3 = "music/creation/getDownload";

  ///获取引导页配置数据
  static const String getPresetMusic = "/music/config/getPresetMusic";


  ///邀请信息
  static const String invitePeople = "api/invite/getInviteIndex";

  ///确认邀请码
  static const String confirmInviteCode = "api/invite/bindInviterCode";

  ///绑定支付方式
  static const String bindPay = "api/invite/switchBindPay";

  ///提现账号信息
  static const String withdrawAccount = "api/invite/withdrawAccount";

  ///实名认证
  static const String authentication = "api/invite/authentication";

  ///微信 支付宝认证回调
  static const String authCallback = "api/invite/authCallback";

  ///提现
  static const String withdraw = "api/invite/withdraw";

  ///提现列表
  static const String getWithdrawList = "api/invite/getWithdrawList";

  ///提现信息
  static const String getInviteMoney = "api/invite/getInviteMoney";

  ///收益明细
  static const String getIncomeList = "api/invite/getIncomeList";

  ///邀请明细
  static const String getInviteList = "api/invite/getInviteList";
}
