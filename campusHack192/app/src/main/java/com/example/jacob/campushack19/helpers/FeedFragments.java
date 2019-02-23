package com.example.jacob.campushack19.helpers;

import android.graphics.BitmapFactory;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.VideoView;
import com.example.jacob.campushack19.R;

import java.io.File;

public class FeedFragments extends Fragment {

    public static final String ARG_FILETYPE = "filetype";
    public static final String ARG_FILEURI= "fileuri";
    public static final int IMAGE = 2;
    public static final int VIDEO = 3;


    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        ViewGroup rootView = (ViewGroup) inflater.inflate(
                R.layout.feed_fragment, container, false);

        ImageView imgV = rootView.findViewById(R.id.imageView);
        VideoView vV = rootView.findViewById(R.id.videoView);

        Bundle args = getArguments();
        String uri = args.getString(ARG_FILEURI);

        FirebaseStorageInterface fbsi = new FirebaseStorageInterface(getContext());
        try {
            File file = fbsi.getFile(uri, FirebaseStorageInterface.fileType.IMAGE);

            if (args.getInt(ARG_FILETYPE) == IMAGE) {
                vV.setEnabled(false);

                imgV.setImageBitmap(BitmapFactory.decodeFile(file.getAbsolutePath()));

            } else {
                imgV.setEnabled(false);

            }
        } catch (Exception e) {
            e.printStackTrace();
        }



        return rootView;
    }


}
