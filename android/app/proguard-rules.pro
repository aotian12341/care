 ## Flutter wrapper
 -keep class io.flutter.app.** { *; }
 -keep class io.flutter.plugin.** { *; }
 -keep class io.flutter.util.** { *; }
 -keep class io.flutter.view.** { *; }
 -keep class io.flutter.** { *; }
 -keep class io.flutter.plugins.** { *; }
 -keep class com.hyphenate.** {*;}
 -dontwarn  com.hyphenate.**
 -keep class internal.org.apache.http.entity.** {*;}
 -keep class com.superrtc.** {*;}
 -dontwarn  com.superrtc.**
# -keep class com.google.firebase.** { *; } // uncomment this if you are using firebase in the project
 -dontwarn io.flutter.embedding.**
 -ignorewarnings

 #导航 V7.3.0及以后：
 -keep class com.amap.api.navi.**{*;}
 -keep class com.alibaba.mit.alitts.*{*;}
 -keep class com.google.**{*;}

 #定位：
 -keep class com.amap.api.location.**{*;}
 -keep class com.amap.api.fence.**{*;}
 -keep class com.autonavi.aps.amapapi.model.**{*;}

 #搜索：
 -keep class com.amap.api.services.**{*;}

 #3D地图 V5.0.0之后：
 -keep class com.amap.api.maps.**{*;}
 -keep class com.autonavi.**{*;}
 -keep class com.amap.api.trace.**{*;}

 #阿里云实人认证
 -verbose

 -keep class com.aliyun.aliyunface.network.model.** {*;}
 -keep class com.aliyun.aliyunface.api.ZIMCallback {*;}
 -keep class com.aliyun.aliyunface.api.ZIMFacade {*;}
 -keep class com.aliyun.aliyunface.api.ZIMFacadeBuilder {*;}
 -keep class com.aliyun.aliyunface.api.ZIMMetaInfo {*;}
 -keep class com.aliyun.aliyunface.api.ZIMResponse {*;}
 -keep class com.aliyun.aliyunface.api.ZIMSession {*;}
 -keep class com.aliyun.aliyunface.config.**{*;}
 -keep class com.aliyun.aliyunface.log.RecordBase {*;}
 -keep class com.aliyun.aliyunface.ui.ToygerWebView {*;}

 -keep class com.alipay.zoloz.toyger.**{*;}
 -keep class com.alipay.zoloz.image.** {*;}
 -keep class com.alipay.android.** {*;}

 -keep class net.security.device.api.** {*;}
 -keep class com.alipay.deviceid.** { *; }
 -keep class com.alibaba.fastjson.** {*;}
 -keep class com.alibaba.sdk.android.oss.** { *; }
 -dontwarn okio.**
 -dontwarn org.apache.commons.codec.binary.**

 -keepclassmembers,allowobfuscation class * {
      @com.alibaba.fastjson.annotation.JSONField <fields>;
 }



