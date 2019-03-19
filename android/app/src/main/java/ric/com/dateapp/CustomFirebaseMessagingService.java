// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

package ric.com.dateapp;

import android.content.Context;
import android.content.Intent;
import android.os.PowerManager;
import androidx.localbroadcastmanager.content.LocalBroadcastManager;

import com.dexterous.flutterlocalnotifications.FlutterLocalNotificationsPlugin;
import com.dexterous.flutterlocalnotifications.models.NotificationDetails;
import com.google.firebase.messaging.FirebaseMessagingService;
import com.google.firebase.messaging.RemoteMessage;

import java.util.HashMap;
import java.util.Map;

public class CustomFirebaseMessagingService extends FirebaseMessagingService {

    public static final String ACTION_REMOTE_MESSAGE =
            "io.flutter.plugins.firebasemessaging.NOTIFICATION";
    public static final String EXTRA_REMOTE_MESSAGE = "notification";

    /**
     * Called when message is received.
     *
     * @param remoteMessage Object representing the message received from Firebase Cloud Messaging.
     */
    @Override
    public void onMessageReceived(RemoteMessage remoteMessage) {
        Intent intent = new Intent(ACTION_REMOTE_MESSAGE);
        intent.putExtra(EXTRA_REMOTE_MESSAGE, remoteMessage);

//        AlertDialog.Builder builder = new AlertDialog.Builder(context.getApplicationContext());
//        LayoutInflater inflater = LayoutInflater.from(context);
//        View dialogView = inflater.inflate(R.layout.caller_dialog, null);
//        ImageView button = dialogView.findViewById(R.id.close_btn);
//        builder.setView(dialogView);
//        final AlertDialog alert = builder.create();
//        alert.getWindow().requestFeature(Window.FEATURE_NO_TITLE);
//        alert.getWindow().setType(WindowManager.LayoutParams.TYPE_PHONE);
//        alert.setCanceledOnTouchOutside(true);
//        alert.show();
//        WindowManager.LayoutParams lp = new WindowManager.LayoutParams();
//        Window window = alert.getWindow();
//        window.addFlags(WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE);
//        window.clearFlags(WindowManager.LayoutParams.FLAG_DIM_BEHIND);
//        window.setGravity(Gravity.TOP);
//        lp.copyFrom(window.getAttributes());
//        //This makes the dialog take up the full width
//        lp.width = WindowManager.LayoutParams.MATCH_PARENT;
//        lp.height = WindowManager.LayoutParams.WRAP_CONTENT;
//        window.setAttributes(lp);
//        button.setOnClickListener(new View.OnClickListener() {
//            @Override
//            public void onClick(View view) {
//                //close the service and remove the from from the window
//                alert.dismiss();
//            }
//        });

        PowerManager pm = (PowerManager) this.getSystemService(Context.POWER_SERVICE);

        if (pm != null) {
            boolean isScreenOn = pm.isScreenOn();
            if (!isScreenOn) {
                PowerManager.WakeLock wakeLock = pm.newWakeLock(PowerManager.FULL_WAKE_LOCK | PowerManager.ACQUIRE_CAUSES_WAKEUP | PowerManager.ON_AFTER_RELEASE, "DateApp:MyLock");
                wakeLock.acquire(5000);
                PowerManager.WakeLock wakeLockCpu = pm.newWakeLock(PowerManager.PARTIAL_WAKE_LOCK, "DateApp:MyCpuLock");

                wakeLockCpu.acquire(5000);
            }
        }

        if (MyLifecycleHandler.isApplicationInForeground()) {
            LocalBroadcastManager.getInstance(this).sendBroadcast(intent);
        } else {
            HashMap<String, Object> notification = new HashMap<>();
            HashMap<String, Object> notificationStyle = new HashMap<>();
            HashMap<String, Object> styleInformation = new HashMap<>();
            Map<String, String> message = remoteMessage.getData();

            notification.put("body", message.get("body") == null ? "Body" : message.get("body"));
            notification.put("payload", message.toString());
            notification.put("title", message.get("title") == null ? "Title" : message.get("title"));
            notification.put("id", 0);
            notification.put("platformSpecifics", notificationStyle);

            styleInformation.put("htmlFormatTitle", false);
            styleInformation.put("htmlFormatContent", false);

            notificationStyle.put("enableVibration", true);
            notificationStyle.put("showProgress", false);
            notificationStyle.put("progress", 0);
            notificationStyle.put("style", 0);
            notificationStyle.put("sound", null);
            notificationStyle.put("colorBlue", null);
            notificationStyle.put("largeIconBitmapSource", null);
            notificationStyle.put("autoCancel", true);
            notificationStyle.put("channelId", "your channel id");
            notificationStyle.put("ongoing", null);
            notificationStyle.put("groupKey", null);
            notificationStyle.put("colorRed", null);
            notificationStyle.put("colorGreen", null);
            notificationStyle.put("vibrationPattern", null);
            notificationStyle.put("icon", null);
            notificationStyle.put("playSound", true);
            notificationStyle.put("setAsGroupSummary", null);
            notificationStyle.put("importance", 5);
            notificationStyle.put("largeIcon", null);
            notificationStyle.put("channelName", "your channel name");
            notificationStyle.put("onlyAlertOnce", null);
            notificationStyle.put("colorAlpha", null);
            notificationStyle.put("channelDescription", "your channel description");
            notificationStyle.put("styleInformation", styleInformation);
            notificationStyle.put("channelShowBadge", true);
            notificationStyle.put("indeterminate", false);
            notificationStyle.put("groupAlertBehavior", 0);
            notificationStyle.put("priority", 1);
            notificationStyle.put("maxProgress", 0);

            NotificationDetails details = NotificationDetails.from(notification);
            this.setIconResourceId(this, details);

            FlutterLocalNotificationsPlugin.showNotification(this, details);
        }
    }

    private static final String DRAWABLE = "drawable";

    private void setIconResourceId(Context context, NotificationDetails notificationDetails) {
        int defaultIconResourceId = context.getResources().getIdentifier("app_icon", "drawable", context.getPackageName());
        if (notificationDetails.iconResourceId == null) {
            int resourceId;
            if (notificationDetails.icon != null) {
                resourceId = context.getResources().getIdentifier(notificationDetails.icon, DRAWABLE, context.getPackageName());
                if (resourceId == 0) {
                    return;
                }
            } else {
                resourceId = defaultIconResourceId;
            }
            notificationDetails.iconResourceId = resourceId;
        }
    }
}
