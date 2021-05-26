package com.example.afribiopos01;
import android.text.Layout;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugins.GeneratedPluginRegistrant;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodCall;


import androidx.annotation.NonNull;
import com.zcs.sdk.Beeper;
import com.zcs.sdk.DriverManager;
import com.zcs.sdk.Led;
import com.zcs.sdk.LedLightModeEnum;
import com.zcs.sdk.Printer;
import com.zcs.sdk.SdkResult;
import com.zcs.sdk.print.PrnStrFormat;
import com.zcs.sdk.print.PrnTextFont;
import com.zcs.sdk.print.PrnTextStyle;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.text.SimpleDateFormat;
import java.util.Date;


public class MainActivity extends FlutterActivity {
    private static final String CHANNEL= "com.flutter.pos";
    DriverManager mDriverManager = DriverManager.getInstance();
    Printer mPrinter = mDriverManager.getPrinter();
    Beeper mBeeper = mDriverManager.getBeeper();
    Led mLed = mDriverManager.getLedDriver();

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);
        new MethodChannel(flutterEngine.getDartExecutor(), CHANNEL).setMethodCallHandler(
                (methodCall, result) -> {
                    String args = methodCall.arguments();
                    if (methodCall.method.equals("printing")) {
                        getPrint(methodCall, result);
                    }
                }
        );
    }

    void getPrint(MethodCall methodCall, MethodChannel.Result result){
        try{
            String args = methodCall.arguments();
            int printStatus = mPrinter.getPrinterStatus();
            if (printStatus == SdkResult.SDK_PRN_STATUS_PAPEROUT) {

            } else {
                PrnStrFormat format = new PrnStrFormat();
                format.setAli(Layout.Alignment.ALIGN_OPPOSITE);
                format.setStyle(PrnTextStyle.NORMAL);
                format.setTextSize(20);
                format.setUnderline(true);
                mPrinter.setPrintAppendString("Date : "+getCurrentTimeStamp(), format);

                format.setTextSize(30);
                format.setUnderline(false);
                format.setAli(Layout.Alignment.ALIGN_NORMAL);
                format.setStyle(PrnTextStyle.BOLD);
                format.setFont(PrnTextFont.DEFAULT);
                mPrinter.setPrintAppendString("AFRIBIO MARCHANT ", format);

                format.setTextSize(25);
                format.setStyle(PrnTextStyle.NORMAL);
                format.setAli(Layout.Alignment.ALIGN_NORMAL);
                mPrinter.setPrintAppendString("Rapidos Technology rdc", format);
                mPrinter.setPrintAppendString("Téléphone :" + " +(243) 999 749 599 ", format);
                mPrinter.setPrintAppendString("Adresse : " + "03. Bismarck Gombe Kin. Ref. terrain Maman yemo ", format);
                mPrinter.setPrintAppendString(" ", format);


                format.setAli(Layout.Alignment.ALIGN_NORMAL);
                format.setStyle(PrnTextStyle.BOLD);
                format.setTextSize(25);
                format.setLetterSpacing(0);
                mPrinter.setPrintAppendString("Désignation " + "    Qté "+ "       P.U ", format);
                mPrinter.setPrintAppendString("----------------------------------------", format);
                format.setAli(Layout.Alignment.ALIGN_NORMAL);
                format.setStyle(PrnTextStyle.NORMAL);
                format.setTextSize(22);
                int payAmount = 0;

                try {
                    JSONObject jsonObject = new JSONObject(args);
                    JSONArray jsonArray = jsonObject.getJSONArray("cart");

                    for(int i= 0; i<jsonArray.length(); i++){
                        JSONObject object = jsonArray.getJSONObject(i);
                        String titre = object.getString("titre");
                        String qte = object.getString("quantite");
                        String pu = object.getString("prix_unitaire");

                        int pt = Integer.parseInt(qte) * Integer.parseInt(pu);

                        mPrinter.setPrintAppendString(titre + "     " +qte+" kg     " + pu +" Fc", format);
                        mPrinter.setPrintAppendString("----------------------------------------------------", format);
                        payAmount += pt;
                    }
                } catch (JSONException e) {
                    e.printStackTrace();
                }
                format.setAli(Layout.Alignment.ALIGN_OPPOSITE);
                format.setStyle(PrnTextStyle.BOLD);
                format.setLetterSpacing(0);
                format.setTextSize(25);
                mPrinter.setPrintAppendString(" ", format);
                mPrinter.setPrintAppendString(" Net à payer : " +payAmount +" Fc", format);
                mPrinter.setPrintAppendString(" ", format);
                mPrinter.setPrintAppendString(" ", format);
                mPrinter.setPrintAppendString(" ", format);
                mPrinter.setPrintStart();
                result.success("Printing is done !");
                mBeeper.beep(4000, 400);
            }
        }
        catch (Exception ex){
            result.success(ex.getMessage());
        }
    }

    public static String getCurrentTimeStamp() {
        SimpleDateFormat sdfDate = new SimpleDateFormat("dd-MM-yyyy");
        Date now = new Date();
        String strDate = sdfDate.format(now);
        return strDate;
    }
}