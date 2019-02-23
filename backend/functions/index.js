const functions = require('firebase-functions');
const firebase = require("firebase");
const md5 = require('md5');

firebase.initializeApp({
    apiKey: 'AIzaSyBeScpUiFwTzjy5v-O1CiFOVcrNi5ygFo8',
    projectId: 'whix-com'
});
let db = firebase.firestore();


// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//  response.send("Hello from Firebase!");
// });

exports.login = functions.https.onCall(async (data, context) => {
    const email = data.email.trim();
    const username = data.username.trim();
    let users = db.collection("users");
    try {
        const querySnapshot = await users.where("email", "==", email)
            .where("username", "==", username)
            .get();
        let userId = null;
        if(querySnapshot.size > 0) {
            querySnapshot.forEach(function(doc){
                userId = doc.id;
            });
        } else {
            const emailQuerySnapshot = await users.where("email", "==", email).get();
            const usernameQuerySnapshot = await users.where("username", "==", username).get();
            if(emailQuerySnapshot.size === 0 && usernameQuerySnapshot.size === 0) {
                const doc = await users.add({
                    email: email,
                    gravatar: "https://www.gravatar.com/avatar/" + md5(email),
                    username: username
                });

                userId = doc.id;
            } else {
                console.warn("email or username already exist");
            }
        }
        return userId;
    } catch (er) {
        console.error(er);
        return null;
    }
});

exports.post = functions.https.onCall(async (data, context) => {
    const { contenturl, username, lat, lon } = data;
    let post = db.collection("post");
    let users = db.collection("users");

    try {
        const querySnapshot = await users.where("username", "==", username)
            .get();
        let userId = null;
        querySnapshot.forEach(function(doc){
            userId = doc.id;
        });

        const doc = await post.add({
            content: contenturl,
            date: new Date(),
            likes: [],
            likesCount: 0,
            locationid: new firebase.firestore.GeoPoint(lat, lon),
            userid: userId
        });

        return doc.id;
    } catch(er) {
        console.error(er);
        return null;
    }
});

function like(usernameLiker, postId) {
    //return newCount;
}

function unlike(usernameLiker, postId) {
    //return newCount;
}
