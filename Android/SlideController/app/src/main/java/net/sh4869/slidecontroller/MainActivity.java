package net.sh4869.slidecontroller;

import android.content.Context;
import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;
import android.hardware.SensorManager;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.util.Log;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.EditText;

import java.io.IOException;

import okhttp3.Call;
import okhttp3.Callback;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.Response;

public class MainActivity extends AppCompatActivity implements SensorEventListener {

    SensorManager manager;
    protected final static double RAD2DEG = 180/Math.PI;
    int rate = SensorManager.SENSOR_DELAY_GAME;
    float[] rotationMatrix = new float[9];
    float[] gravity = new float[3];
    float[] geomagnetic = new float[3];
    float[] attitude = new float[3];
    boolean normal = true;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        Log.d("TEST", "first");
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        manager = (SensorManager) getSystemService(Context.SENSOR_SERVICE);
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the act ion bar if it is present.
        getMenuInflater().inflate(R.menu.menu_main, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        // Handle action bar item clicks here. The action bar will
        // automatically handle clicks on the Home/Up button, so long
        // as you specify a parent activity in AndroidManifest.xml.
        int id = item.getItemId();

        //noinspection SimplifiableIfStatement
        if (id == R.id.action_settings) {
            return true;
        }

        return super.onOptionsItemSelected(item);
    }

    public void sendRightRequest(View v) {
        String ipUrl = ((EditText) findViewById(R.id.editText)).getText().toString();
        final OkHttpClient client = new OkHttpClient();
        Request request = new Request.Builder()
                .url("http://" + ipUrl + "/right")
                .build();
        try {
            client.newCall(request).enqueue(new Callback() {
                @Override
                public void onFailure(Call call, IOException e) {

                }

                @Override
                public void onResponse(Call call, Response response) throws IOException {
                    Log.d("HTTP", response.body().string());
                }
            });
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void sendLeftRequest(View v) {
        String ipUrl = ((EditText) findViewById(R.id.editText)).getText().toString();
        final OkHttpClient client = new OkHttpClient();
        Request request = new Request.Builder()
                .url("http://" + ipUrl + "/left")
                .build();
        try {
            client.newCall(request).enqueue(new Callback() {
                @Override
                public void onFailure(Call call, IOException e) {

                }

                @Override
                public void onResponse(Call call, Response response) throws IOException {
                    Log.d("HTTP", response.body().string());
                }
            });
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    protected void onResume() {
        super.onResume();
        manager.registerListener(this, manager.getDefaultSensor(Sensor.TYPE_ACCELEROMETER), rate);
        manager.registerListener(this, manager.getDefaultSensor(Sensor.TYPE_MAGNETIC_FIELD), rate);
    }

    // アクティビティがアクティブでなくなったら測定をいったん取り止める
    // そうしないとバッテリーを消費してしまうんだそうで
    @Override
    protected void onPause() {
        super.onPause();
        manager.unregisterListener(this);
    }

    @Override
    public void onAccuracyChanged(Sensor arg0, int arg1) {
    }

    @Override
    public void onSensorChanged(SensorEvent event) {
        switch (event.sensor.getType()) {
            case Sensor.TYPE_MAGNETIC_FIELD:
                geomagnetic = event.values.clone();
                break;
            case Sensor.TYPE_ACCELEROMETER:
                gravity = event.values.clone();
                break;
        }
        if(geomagnetic != null && gravity != null){
            SensorManager.getRotationMatrix(rotationMatrix,null,gravity,geomagnetic);
            SensorManager.getOrientation(rotationMatrix, attitude);
        }
        if(normal) {
            if (attitude[2] * RAD2DEG > 50) {
                sendRightRequest(null);
                normal = false;
            } else if (attitude[2] * RAD2DEG < -50) {
                sendLeftRequest(null);
                normal = false;
            }
        } else {
            if(attitude[2]* RAD2DEG > -10 && attitude[2] *RAD2DEG < 10){
                normal = true;
            }
        }
    }
}
