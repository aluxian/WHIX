package com.example.jacob.campushack19;

import android.graphics.drawable.TransitionDrawable;
import android.os.Bundle;
import android.support.v4.view.ViewPager;
import android.support.v7.app.AppCompatActivity;
import android.view.View;
import android.widget.ImageButton;
import com.example.jacob.campushack19.helpers.CollectionPagerAdapter;

public class Feeder extends AppCompatActivity {

    private ImageButton imgB;
    private boolean isPlus = true;

    private ImageButton likeButton;
    private boolean isClicked = false;

    private ImageButton profileHead;

    private CollectionPagerAdapter cpa;
    private ViewPager viewPager;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_feeder);

        imgB = findViewById(R.id.createPostButton);
        likeButton = findViewById(R.id.likeButton);

        cpa = new CollectionPagerAdapter(getSupportFragmentManager());
        viewPager = findViewById(R.id.viewPagerFeed);
        viewPager.setAdapter(cpa);
    }

    public void createNewPost(View view){
//        Animation rotator = AnimationUtils.loadAnimation(getApplicationContext(), R.anim.rotate);
//        imgB.startAnimation(rotator);

        if (isPlus){
            imgB.setRotation(0);
        } else {
            imgB.setRotation(45);
        }

        isPlus = !isPlus;
    }

    public void likePost(View view){
        TransitionDrawable starImg = (TransitionDrawable) likeButton.getDrawable();

        if (isClicked) {
            starImg.startTransition(0);
        } else {
            starImg.resetTransition();
        }

        isClicked = !isClicked;


    }

}
