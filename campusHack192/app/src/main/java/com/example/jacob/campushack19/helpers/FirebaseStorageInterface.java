package com.example.jacob.campushack19.helpers;

import android.content.Context;
import com.google.firebase.storage.FileDownloadTask;
import com.google.firebase.storage.FirebaseStorage;

import java.io.File;
import java.util.UUID;

public class FirebaseStorageInterface {

    private static Context context;

    public enum fileType {
        IMAGE, VIDEO
    }

    private FirebaseStorage storage;

    public FirebaseStorageInterface(Context context){
        storage = FirebaseStorage.getInstance();
        this.context = context;
    }

    public boolean uploadFile(File file){

        return false;
    }

    public File getFile(String param, fileType type) throws Exception {
        File file;
        String[] filenames = param.split("/");
        String filename = filenames[filenames.length - 1];

        if (type == fileType.IMAGE){
            file = new File(context.getFilesDir(), filename);
        } else {
            file = File.createTempFile("video", "mp4");
        }

        FileDownloadTask fdt = storage.getReferenceFromUrl(param).getFile(file);
        while (fdt.isInProgress()) {}
        if (fdt.isSuccessful()){
            return file;
        } else {
            throw fdt.getException();
        }
    }
}
