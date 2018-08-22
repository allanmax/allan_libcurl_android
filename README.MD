拷贝：https://github.com/byhook/libcurl-android
在centos环境下编译，ndk使用r10e 版本，其他版本编译没有通过

注意：

```
脚本中的
export ANDROID_NDK_ROOT=
需要改成你本机的环境
```

目录结构

```
|—curl源码目录
  |—build_curl.sh
  |—build_all.sh
  |—...
```

执行脚本

```
sh build_all.sh
```

编译成功之后
在/usr/local/curl目录里

###测试一下
新建JNI目录，将刚才生成的armeabi目录里的include文件夹和lib文件夹复制进去
新建Android.mk文件

```
LOCAL_PATH := $(call my-dir)

#libcurl库
include $(CLEAR_VARS)
LOCAL_MODULE := libcurl
LOCAL_SRC_FILES := lib/libcurl.a 
include $(PREBUILT_STATIC_LIBRARY) 


#测试程序
include $(CLEAR_VARS)
LOCAL_MODULE := main
LOCAL_SRC_FILES := main.cpp
LOCAL_C_INCLUDES += $(LOCAL_PATH)/include
LOCAL_LDLIBS := -llog -lz
LOCAL_STATIC_LIBRARIES := libcurl

LOCAL_CFLAGS += -pie -fPIE
LOCAL_LDFLAGS += -pie -fPIE

include $(BUILD_EXECUTABLE)
```

新建Application.mk添加对C++的支持

```
APP_ABI := armeabi
APP_PLATFORM := 12
APP_CPPFLAGS += -fexceptions -frtti
APP_STL := stlport_static
```

新建源文件main.cpp

```
#include <curl/curl.h>
#include <iostream>

using namespace std;

int main(int argc,char * argv[])
{
    //定义CURL类型的指针
    CURL * curl;
    //定义CURLcode类型的变量，保存返回状态码
    CURLcode res;

    //初始化一个CURL类型的指针
    curl = curl_easy_init();
    if(curl!=NULL)
    {

        curl_easy_setopt(curl, CURLOPT_URL, argv[1]);        
        //curl_easy_setopt(curl, CURLOPT_WRITEDATA, recv);

        res = curl_easy_perform(curl);
        if(res != CURLE_OK){
             cout << curl_easy_strerror(res) << endl;
    }

        //清除curl操作.
        curl_easy_cleanup(curl);
    }

    return 0;
}
```


注意:
如果需要生成Linux下的静态库，最好把不必要的选项禁用掉，不然链接可能会出错。

```
./configure --prefix=/usr/local/curl --disable-shared --enable-static --without-libidn --without-ssl --without-librtmp --without-gnutls --without-nss --without-libssh2 --without-zlib --without-winidn --disable-rtsp --disable-ldap --disable-ldaps --disable-ipv6
```

资源下载：
https://curl.haxx.se/download/curl-7.54.1.tar.gz
https://dl.google.com/android/repository/android-ndk-r10e-linux-x86_64.zip


