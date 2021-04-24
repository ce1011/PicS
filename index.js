const functions = require('firebase-functions');
const admin = require("firebase-admin");
const client = require('firebase-tools');
const { Storage } = require("@google-cloud/storage");
const path = require("path");
const os = require("os");
const fs = require("fs");
const ffmpeg = require("fluent-ffmpeg");
const ffmpegPath = require('@ffmpeg-installer/ffmpeg').path;

admin.initializeApp();

async function removePosts(uid){
  // remove all posts created by user
  await admin.firestore().collection('post').where('UID', '=', uid).get().then((snapshot) => {
    snapshot.forEach(doc => {
      deletePost({postid: doc.id});
    })
  })

  // remove comment made
  await admin.firestore().collection('post').orderBy('postTime', 'desc').get().then((snapshot) => {
    console.log('1.2');
    snapshot.forEach(doc => {
      admin.firestore().collection('post').doc(doc.id).collection('comment')
      .where('UID', '=', uid).get().then((snapshot) => {
        snapshot.docs.forEach(doc => {
          doc.delete();
        })
      })
    })
  })
}

// good
async function removeGroupDB(uid){
  console.log('2');
  // delete usergroup database
  var path = '/groupDB/' + uid;
  await client.firestore
      .delete(path, {
        project: process.env.GCLOUD_PROJECT,
        recursive: true,
        yes: true
  });
}

async function removeChatroom(uid){
  const bucket = admin.storage().bucket();

  // delete chatroom content
  await admin.firestore().collection('chatroom').orderBy('UID').get().then((roomSnapshot) => {
    roomSnapshot.docs.forEach(doc => {
      // user found in chatroom
      if (Object.keys(doc.data().UID).includes(uid)){
        // delete content sent by user
        admin.firestore().collection('chatroom/'+doc.id+'/chatContent')
        .where('sendBy', '==', uid).get().then((chatSnapshot) => {
          console.log(JSON.stringify(chatSnapshot.docs));
          chatSnapshot.docs.forEach(chat => {
              // delete attachment
              var path = '';
              switch(chat.contentType){
                case 1:
                  // image
                  path += '.jpg';
                  break;
                case 2:
                  // video
                  path += '.mp4';
                  break;
                case 3:
                  // audio
                  path += '.aac';
                  break;
              }
              // delete file (wip)
              console.log('del: '+path);
              // delete chat record
              chat.ref.delete();
          })
        })

        // create new member list
        const updatedMember = {};
        Object.keys(doc.data().UID).forEach(id => {
          if (id != uid){
            updatedMember[id] = true;
          }
        })
        // update the member list
        console.log(updatedMember);
        console.log(doc.data().UID);
        doc.ref.set( {UID: updatedMember} );
      }
    })
  });
}

async function removeProfile(uid){
  console.log('4');
  // delete profile
  await admin.firestore().collection('user').where('UID', '==', uid).get().then((snapshot) => {
    snapshot.docs.forEach(doc =>{
      doc.ref.delete();
    });
  });
}

async function removeIcon(uid){
  const bucket = admin.storage().bucket();

  console.log('5');
  // delete icon if exist
  path = 'usericon/' + uid + '.jpg';
}

exports.deleteAccount = functions.https.onCall( async(data, context) => {
  const uid = context.auth.uid;
  
  await Promise.all([
    removePosts(uid),
    removeGroupDB(uid),
    removeChatroom(uid),
    removeProfile(uid),
    removeIcon(uid)
  ]);
  
  return {"status": "success"};
})

function deletePost(data) {
  const postid = data.postid;
  const path = 'post/' + postid + '/comment';
  const bucket = admin.storage().bucket();

  // delete comment sub-collection
  client.firestore
      .delete(path, {
        project: process.env.GCLOUD_PROJECT,
        recursive: true,
        yes: true
  });
  console.log('delpost: '+postid);
  // delete multimedia (wip)
  if (admin.firestore().collection('post').doc(postid).video){
    console.log('del: '+'/post/'+postid+'.mp4');
  }
  else {
    console.log('del: '+'/post/'+postid+'.jpg');
  }
  console.log('delf: '+'/post/'+postid+'/')
  // try delete comment folder (wip)
  try {
    console.log('delfolder: '+'post/'+postid+'/');
  }
  catch (error) {
    console.error(error);
  }

  // delete post
  admin.firestore().collection('post').doc(postid).delete();
}

const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

exports.viewPostAvalibility = functions.https.onCall(async (data, context) => {
  const uid = context.auth.uid;
  const postID = data.postID;
  //const uid = req.query.uid;
  //const postID = req.query.postID;


  var json = {};

  functions.logger.log(uid + " is accessing postID " + postID);

  await admin
    .firestore()
    .collection("post")
    .doc(postID)
    .get()
    .then(async (data) => {
      if (data.data()["permission"]["visibleForPublic"] == true) {
        functions.logger.log(uid + "can visible to post " + postID);
        json.view = true;
        if (data.data()["permission"]["ableToCommentForPublic"] == true) {
          functions.logger.log(uid + "can comment to post " + postID);
          json.comment = true;

          //res.send(JSON.stringify(json))
        } else {
          console.log(data
            .data()
            ["permission"]["ableToCommentFor"]);
          if(data
            .data()
            ["permission"]["ableToCommentFor"] == null){
              json.comment = false;
            }else{
              data
              .data()
              ["permission"]["ableToCommentFor"].get()
              .then(async (data) => {
                if (data.data()["UID"][uid] == true) {
                  functions.logger.log(uid + "can comment to post " + postID);
                  json.comment = true;
                } else {
                  functions.logger.log(uid + "cannot comment to post " + postID);
                  json.comment = false;
                }
                //res.send(JSON.stringify(json))
              });
            }

        }
      } else {
        if(        data
          .data()
          ["permission"]["visibleFor"]== null){
            json.view = false;
            json.comment = false;
            functions.logger.log(
              uid + "can comment and visible to post " + postID
            );
          }else{
            data
            .data()
            ["permission"]["visibleFor"].get()
            .then(async (data1) => {
              if (data1.data()["UID"][uid] == true) {
                functions.logger.log(uid + "can visible to post " + postID);
                json.view = true;
                if (data.data()["permission"]["ableToCommentForPublic"] == true) {
                  functions.logger.log(uid + "can comment to post " + postID);
                  json.comment = true;
                  //res.send(JSON.stringify(json))
                } else {
                  if(                data
                    .data()
                    ["permission"]["ableToCommentFor"] == null){
                      json.comment = false;
                    }else{
                      data
                      .data()
                      ["permission"]["ableToCommentFor"].get()
                      .then(async (data) => {
                        if (data.data()["UID"][uid] == true) {
                          functions.logger.log(
                            uid + "can comment to post " + postID
                          );
                          json.comment = true;
                        } else {
                          functions.logger.log(
                            uid + "cannot comment to post " + postID
                          );
                          json.comment = false;
                        }
                        //res.send(JSON.stringify(json))
                      });
                    }
  
                }
              } else {
                json.view = false;
                json.comment = false;
                functions.logger.log(
                  uid + "can comment and visible to post " + postID
                );
                //res.send(JSON.stringify(json));
              }
            });
          }

      }
    });

  functions.logger.log("Sending can data. The data is " + JSON.stringify(json));
  //res.send(JSON.stringify(json))
  return json;
});

// function to see if a user can comment on the post and push the post data to the list
function pushPost(post, uid) {
  console.log('pushPost called');
  var canComment = post.data().permission.ableToCommentForPublic + (post.data().UID == uid);
  if (post.data().permission.ableToCommentFor != null) {
    canComment = canComment + checkPermission(uid, post.data().permission.ableToCommentFor);
  }
  console.log('can '+canComment)
  if (canComment) {
    canComment = true;
  }
  else {
    canComment = false;
  }
  return {
    postID: post.id,
    UID: post.data().UID,
    description: post.data().description,
    postTimeSeconds: post.data().postTime._seconds,
    postTimeNanoseconds: post.data().postTime._nanoseconds,
    video: post.data().video,
    canComment: canComment,
  };
}

// function to check permission
function checkPermission(uid, ref) {
  var path = '';
  ref._path.segments.forEach((str) => {
    path += '/';
    path += str;
  })
  admin.firestore().doc(path).get()
  .then((data) => {
    return Object.keys(data.get('UID')).includes(uid);
  })
}

// function to get the post list as a object array
exports.getPostList = functions.https.onCall( async (data, context) => {
  const uid = context.auth.UID;
  var postList = new Array();
  console.log(uid);
  // get the post list in descending order
  await admin.firestore().collection('post').orderBy('postTime', 'desc').get()
  .then((data)=>{data.docs.forEach( (post) => {
      // public post
      if (post.data().permission.visibleForPublic||(post.data().UID == uid)) {
        postList.push(pushPost(post, uid));
      }
      else {
        if (post.data().permission.visibleFor != null) {
          if (checkPermission(uid, post.data().permission.visibleFor))
          {
            const obj = pushPost(post, uid);
            postList.push(pushPost(post, uid));
          }
        }
      }
  })
  console.log(JSON.stringify(postList));
  
  });
  return postList;
})

const gcs = new Storage();

// Makes an ffmpeg command return a promise.
function promisifyCommand(command) {
  return new Promise((resolve, reject) => {
    command.on('end', resolve).on('error', reject).run();
  });
}

exports.postVideoClipComment = functions.https.onCall(async (data, context) => {
  const uid = context.auth.uid;
  const startTime = data.startTime;
  const endTime = data.endTime;
  const postID = data.postID;
  const comment = data.comment;

  await admin
    .firestore()
    .collection("post/" + postID + "/comment")
    .add({
      UID: uid,
      startTime: startTime,
      endTime: endTime,
      content: comment,
      commentTime: admin.firestore.Timestamp.fromDate(new Date()),
    })
    .then(async (value) => {
      const fileBucket = "pics-a3fa1.appspot.com";
      const filePath = "post/" + postID + ".mp4";
      const fileName = postID + ".mp4";

      const bucket = gcs.bucket(fileBucket);
      const tempFilePath = path.join(os.tmpdir(), fileName);
      const targetTempFileName = value.id + ".mp4";
      const targetTempFilePath = path.join(os.tmpdir(), targetTempFileName);
      const targetStorageFilePath = path.join("post/" + postID +"/", targetTempFileName);

      await bucket.file(filePath).download({destination: tempFilePath});

      
      let command = ffmpeg(tempFilePath).setFfmpegPath(ffmpegPath).setStartTime(startTime).setDuration(endTime - startTime).output(targetTempFilePath);

      await promisifyCommand(command);
      functions.logger.log('Output video created at', targetTempFilePath);

      await bucket.upload(targetTempFilePath, {destination: targetStorageFilePath});
      functions.logger.log('Output audio uploaded to', targetStorageFilePath);

      fs.unlinkSync(tempFilePath);
      fs.unlinkSync(targetTempFilePath);
    });

  return { "status": "success" };
});

exports.viewPost = functions.https.onCall(async (context, data) => {
  const uid = context.auth.uid;
  const postID = data.postID;
  //const uid = "QOXIKNDPz9fitaLajFe4CLHaKWm1";

  var json = {};

  admin
    .firestore()
    .collection("post")
    .doc(postID)
    .get()
    .then(async (data) => {
      if (data.data()["permission"]["visibleForPublic"] == true) {
        json.view = true;
        if (data.data()["permission"]["ableToCommentForPublic"] == true) {
          json.comment = true;
          return json
        } else {
          data
            .data()
            ["permission"]["ableToCommentFor"].get()
            .then(async (data) => {
              if (data.data()["UID"][uid] == true) {
                json.comment = true;
              } else {
                json.comment = false;
              }
              return json
            });
        }
      } else {
        data
          .data()
          ["permission"]["visibleFor"].get()
          .then(async (data1) => {
            if (data1.data()["UID"][uid] == true) {
              json.view = true;
              if (data.data()["permission"]["ableToCommentForPublic"] == true) {
                json.comment = true;
                return json
              } else {
                data
                  .data()
                  ["permission"]["ableToCommentFor"].get()
                  .then(async (data) => {
                    if (data.data()["UID"][uid] == true) {
                      json.comment = true;
                    } else {
                      json.comment = false;
                    }
                    return json
                  });
              }
            } else {
              json.view = false;
              json.comment = false;
              res.send(JSON.stringify(json));
            }
          });
      }
    });
});