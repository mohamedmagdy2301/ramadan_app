package com.mohamedmagdy.azkar

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetProvider

class TimePrayer : HomeWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences
    ) {
        appWidgetIds.forEach { widgetId ->
            val views = RemoteViews(context.packageName, R.layout.time_prayer_widget)

            val nextPrayer = widgetData.getString("nextPrayer", "الصلاة القادمة")
            val remainingTime = widgetData.getString("remainingTime", "--:--")

            views.setTextViewText(R.id.tv_next_prayer, nextPrayer)
            views.setTextViewText(R.id.tv_remaining_time, remainingTime)

            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }
}
