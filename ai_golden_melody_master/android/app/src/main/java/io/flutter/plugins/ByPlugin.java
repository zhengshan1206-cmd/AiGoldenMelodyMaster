package io.flutter.plugins;

import android.app.Activity;
import android.content.ContentResolver;
import android.content.Context;
import android.database.Cursor;
import android.net.Uri;
import android.os.Build;
import android.provider.MediaStore;
import android.provider.Settings;
import android.util.Log;

import com.bytedance.ads.convert.BDConvert;
import com.bytedance.applog.AppLog;
import com.bytedance.applog.InitConfig;
import com.bytedance.applog.util.UriConstants;
import com.github.gzuliyujiang.oaid.DeviceID;
import com.github.gzuliyujiang.oaid.IGetter;
import java.util.HashMap;
import java.util.Map;
import com.bytedance.applog.game.GameReportHelper;

import org.json.JSONObject;


public  class ByPlugin {

    public  interface ByPluginCallbackListener {
        void onFinish(String oId, String androidId);
    }
    protected static Boolean isIniBDConvert = false;
    /**
     * 初始化头条SDK上报
     */
    public static void iniBDConvert(Context context,Activity activity, String appId,String channel) {
        try {
            if(!isIniBDConvert) {
                isIniBDConvert = true;
                if (null == channel || "".equals(channel)) {
                    channel = "channel";
                }
                // 对线程不敏感，可放入子线程执行初始化
                /* 初始化SDK开始 */
                // 第一个参数APPID: 参考2.1节获取
                // 第二个参数CHANNEL: 填写渠道信息，请注意不能为空
                Log.d("iniBDConvert", "InitConfig");
                Log.d("iniBDConvert", "AppId" + appId);
                Log.d("iniBDConvert", "Channel" + channel);
                final InitConfig config = new InitConfig(appId, channel);
                // 设置数据上送地址
                config.setUriConfig(UriConstants.DEFAULT);
                config.setImeiEnable(false);//建议关停获取IMEI（出于合规考虑）
                config.setAutoTrackEnabled(false); // 全埋点开关，true开启，false关闭
                config.setLogEnable(true); // true:开启日志，参考4.3节设置logger，false:关闭日志
                AppLog.setEncryptAndCompress(false); // 加密开关，true开启，false关闭
                config.setEnablePlay(true); // 配置心跳事件（时长统计）
                Log.d("iniBDConvert", "BDConvert");
                //SDK会采集OAID、ANDROID_ID和其他的设备特征字段，请遵循相关合规要求在隐私弹窗后采集
                BDConvert.getInstance().init(context, AppLog.getInstance());
                // 如果在 onCreate 阶段初始化拿不到 XXXActivity 则不需要传递第三个参数
                AppLog.init(context, config, activity);
                Log.d("iniBDConvert", "OK");
            }else{
                Log.d("iniBDConvert", "repeat");
            }
        } catch (Exception e) {
            Log.d("iniBDConvert", "ERROR" + e.getMessage());
        }
    }

    /**
     * SDK回传
     * @param eventString
     */
    public static void oceanengineEvent(String eventString){
        Log.d("iniBDConvert Event",eventString);
        try{
            JSONObject event = new JSONObject(eventString);
            String e = event.getString("event");
            String _auto_id_ = "";
            if(event.has("_auto_id_")){
                _auto_id_ = event.getString("_auto_id_");
                event.remove("_auto_id_");
            }
            if(e.equals("register")){
                //注册
                //内置事件: “注册” ，属性：注册方式，是否成功，属性值为：wechat ，true
                String way = event.getString("way");//登陆方式(wechat 微信,phone 手机)
                GameReportHelper.onEventRegister(way,true);
            }else if(e.equals("purchase")){
                //付费
                //内置事件 “支付”，属性：商品类型，商品名称，商品ID，商品数量，支付渠道，币种，是否成功（必传），金额（必传）
                // 付费金额单位为元
                String goodType = event.getString("good_type");
                String goodName = event.getString("good_name");
                String goodId = event.getString("good_id");
                int goodNum = event.getInt("good_num");
                String payType = event.getString("pay_type");
                String currency = event.getString("currency");
                double money = event.getDouble("money");
                int intMoney = (int)money;
                GameReportHelper.onEventPurchase(goodType,goodName, goodId,goodNum, payType,currency, true, intMoney);
            }else if(e.equals("game_addiction")){
                //关键行为
                org.json.JSONObject paramsObj = new org.json.JSONObject();
                try {
                    String originEvent =  event.getString("origin_event");
                    paramsObj.put("origin_event", originEvent); // 添加原始事件名称参数
                } catch (Exception ex) {
                }
                AppLog.onEventV3("game_addiction", paramsObj);
            }else{
                try {
                    event.remove("event");
                    String eventStr = event.toString();
                    org.json.JSONObject paramsObj = new org.json.JSONObject(eventStr);
                    AppLog.onEventV3(e, paramsObj);
                    Log.d("iniBDConvert onEventV3",e + ":" + eventStr);
                }catch (Exception ex){}
            }
        }catch (Exception e){
            Log.d("iniBDConvert onEventV3",e.getMessage());
        }
    }

    public static void getAndroidDeviceInfo(Activity context, ByPluginCallbackListener byPluginCallbackListener) {
        String andoridId="";

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.CUPCAKE) {
            try {
                andoridId = Settings.Secure.getString(context.getContentResolver(), Settings.Secure.ANDROID_ID);
            }catch (Exception e) {
                andoridId = "";
            }
        }

        String finalAndoridId = andoridId;
        DeviceID.getOAID(context, new IGetter() {
            @Override
            public void onOAIDGetComplete(String result) {
                if (byPluginCallbackListener != null) {
                    byPluginCallbackListener.onFinish(result, finalAndoridId);
                }
            }

            @Override
            public void onOAIDGetError(Exception error) {
                // 获取OAID/AAID失败

                if (byPluginCallbackListener != null) {
                    byPluginCallbackListener.onFinish("", finalAndoridId);
                }

//                if (null != callback) {
//                    JSONObject res = new JSONObject();
//                    JSONObject data = new JSONObject();
//                    data.put("OAID", "");
//                    data.put("error", error.getMessage());
//                    data.put("androidid", andoridId);
//                    res.put("data", data);
//                    callback.invoke(res);
//                }
            }
        });
    }

 //统一返回格式
public static Map  baserResult(int code, String msg){
    HashMap hashMap=new HashMap();
    hashMap.put("code", code);
    hashMap.put("msg",msg);
    return hashMap;
 }
    public static Map  baserResult(int code,Map data){
        HashMap hashMap=new HashMap();
        hashMap.put("code", code);
        hashMap.put("data",data);
        return hashMap;
    }
    public static Map  baserResult(int code){
        HashMap hashMap=new HashMap();
        hashMap.put("code", code);
        return hashMap;
    }
//    fun  baserResult(code:Int,){
//        Map
//        mapOf("code" to 200,
//                "data" to mapOf(GlobalConstant.AUDIO_LOCAL_FILE_PATH_RESULT to data.getStringExtra(SdkEntry.ALBUM_RESULT),
//                        GlobalConstant.VIDEO_TEXT_RESULT to data.getStringExtra(SdkEntry.ALBUM_RESULT_TXT)))
//
//    }

}
