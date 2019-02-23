package com.example.jacob.campushack19.helpers;

import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentStatePagerAdapter;
import android.util.Log;
import com.example.jacob.campushack19.WhixPost;
import com.google.android.gms.tasks.OnCompleteListener;
import com.google.android.gms.tasks.Task;
import com.google.firebase.firestore.CollectionReference;
import com.google.firebase.firestore.FirebaseFirestore;
import com.google.firebase.firestore.QueryDocumentSnapshot;
import com.google.firebase.firestore.QuerySnapshot;

import java.util.ArrayList;

public class CollectionPagerAdapter extends FragmentStatePagerAdapter {

    private FirebaseFirestore database;
    private ArrayList<WhixPost> WhixPosts;

    public CollectionPagerAdapter(FragmentManager fm) {
        super(fm);
        database = FirebaseFirestore.getInstance();
        WhixPosts = new ArrayList<>();

        CollectionReference cr = database.collection("post");

        cr.get().addOnCompleteListener(new OnCompleteListener<QuerySnapshot>() {
            @Override
            public void onComplete(@NonNull Task<QuerySnapshot> task) {
                if (task.isSuccessful()) {
                    for (QueryDocumentSnapshot document : task.getResult()) {
                        Log.i("TAG", document.getId() + " => " + document.getData());
                        WhixPosts.add(new WhixPost(document));
                    }
                } else {
                    Log.i("TAG", "Error getting documents: ", task.getException());
                }
                notifyDataSetChanged();
            }
        });

    }

    private void updatePost() {

    }

    @Override
    public Fragment getItem(int i) {
        Fragment fragment = new FeedFragments();
        Bundle args = new Bundle();

        args.putInt(FeedFragments.ARG_FILETYPE, FeedFragments.IMAGE);
        args.putString(FeedFragments.ARG_FILEURI, WhixPosts.get(i).content);
        fragment.setArguments(args);
        return fragment;
    }

    @Override
    public int getCount() {
        return WhixPosts.size();
    }

}
