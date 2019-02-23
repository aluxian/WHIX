package com.example.jacob.campushack19;

import android.content.Intent;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.View;
import com.google.firebase.functions.FirebaseFunctions;

public class MainActivity extends AppCompatActivity {

    private FirebaseFunctions mFunctions;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        mFunctions = FirebaseFunctions.getInstance();
    }

    public void login(View view){



        Intent intent = new Intent(this, Feeder.class);
        startActivity(intent);
    }
}
