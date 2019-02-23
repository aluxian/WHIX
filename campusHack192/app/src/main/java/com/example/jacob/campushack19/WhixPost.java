package com.example.jacob.campushack19;

import android.support.annotation.NonNull;
import com.google.firebase.Timestamp;
import com.google.firebase.firestore.DocumentReference;
import com.google.firebase.firestore.GeoPoint;
import com.google.firebase.firestore.QueryDocumentSnapshot;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;

public class WhixPost implements Comparable<WhixPost>{

    public String key;
    public String content;
    public Timestamp date;
    public ArrayList<DocumentReference> likes;
    public GeoPoint location;
    public String author;

    public WhixPost(QueryDocumentSnapshot doc){
        this.key = doc.getId();
        this.content = (String) doc.get("content");
        this.date = (Timestamp) doc.get("date");
        this.likes = (ArrayList<DocumentReference>) doc.get("likes");
        this.location = (GeoPoint) doc.get("locationid");
        this.author = (String) doc.get("userid");
    }


    public void updatePost(){

    }


    @Override
    public int compareTo(@NonNull WhixPost o) {
        return date.compareTo(o.date);
    }
}
