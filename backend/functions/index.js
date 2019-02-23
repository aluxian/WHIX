const functions = require('firebase-functions');
const md5 = require('md5');

let db = functions.firestore;


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
            locationid: new db.GeoPoint(lat, lon),
            userid: db.doc("/users/" + userId)
        });

        return doc.id;
    } catch(er) {
        console.error(er);
        return null;
    }
});

async function toggleLike(data, like) {
    const { username, postId } = data;
    let post = db.collection("post");
    let users = db.collection("users");

    try {
        const querySnapshot = await users.where("username", "==", username)
            .get();
        let userId = null;
        querySnapshot.forEach(function(doc){
            userId = doc.id;
        });

        const postDoc = await post.doc(postId).get();
        let likesCount = postDoc.data().likesCount;
        let likes = postDoc.data().likes;

        if(like) {
            likes.push(db.doc("/users/" + userId));
            likesCount += 1;
        } else {
            likes.splice(likes.indexOf(db.doc("/users/" + userId)), 1);
            likesCount -= 1;
        }

        await post.doc(postId).update({
            likes: likes,
            likesCount: likesCount,
        });

        return likesCount;
    } catch(er) {
        console.error(er);
        return null;
    }
}

exports.like = functions.https.onCall(async (data, context) => {
   return await toggleLike(data, true);
});

exports.unlike = functions.https.onCall(async (data, context) => {
    return await toggleLike(data, false);
});
