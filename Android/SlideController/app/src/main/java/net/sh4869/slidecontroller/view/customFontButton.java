package net.sh4869.slidecontroller.view;

import android.content.Context;
import android.content.res.TypedArray;
import android.graphics.Typeface;
import android.util.AttributeSet;
import android.util.Log;
import android.widget.Button;

import net.sh4869.slidecontroller.R;
import net.sh4869.slidecontroller.utility.CachedTypefaces;

/**
 * Created by Nobuhiro on 2016/05/06.
 */
public class customFontButton extends Button {
    private static final String TAG = "CustomFontButton";

    public customFontButton(Context context) {
        super(context);
    }

    public customFontButton(Context context, AttributeSet attrs) {
        super(context, attrs);
        setCustomFont(context, attrs);
    }

    public customFontButton(Context context, AttributeSet attrs, int defStyle) {
        super(context, attrs, defStyle);
        setCustomFont(context, attrs);
    }

    private void setCustomFont(Context ctx, AttributeSet attrs) {
        TypedArray a = ctx.obtainStyledAttributes(attrs, R.styleable.CustomFontButton);
        String customFont = a.getString(R.styleable.CustomFontButton_customFont);
        setCustomFont(ctx, customFont);
        a.recycle();
    }

    public boolean setCustomFont(Context context, String asset) {
        Typeface tf = null;
        try {
            // ここでフォントファイル読み込み。
            // 読み込み済みならキャッシュから。
            tf = CachedTypefaces.get(context, asset);
        } catch (Exception e) {
            Log.e(TAG, "Could not get typeface: " + e.getMessage());
            return false;
        }

        setTypeface(tf);
        return true;
    }
}