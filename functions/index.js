const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

exports.checkPremiumEndDate = functions.database.ref('/chat_rooms/{roomId}').onUpdate(async (change, context) => {
    const roomId = context.params.roomId;
    const roomData = change.after.val();
    if (!roomId || !roomData) {
        console.error('Invalid data:', roomId, roomData);
        return null;
    }

    const [senderUid, receiverUid] = roomId.split('-'); // roomId'ü '-' karakterine göre ayırarak senderUid ve receiverUid elde ediyoruz.

    const usersRef = admin.database().ref('/users');
    const [senderSnapshot, receiverSnapshot] = await Promise.all([
        usersRef.child(senderUid).once('value'),
        usersRef.child(receiverUid).once('value'),
    ]);

    const senderPremiumEndDate = senderSnapshot.child('premiumEndDate').val();
    const receiverPremiumEndDate = receiverSnapshot.child('premiumEndDate').val();

    const now = Date.now();

    if (
        ((senderPremiumEndDate && senderPremiumEndDate >= now) || !senderPremiumEndDate) &&
        ((receiverPremiumEndDate && receiverPremiumEndDate >= now) || !receiverPremiumEndDate)
    ) {
        const lastMessageRef = admin.database().ref(`/chat_rooms/${roomId}`).orderByChild('timestamp').limitToLast(1);
        const lastMessageSnapshot = await lastMessageRef.once('value');
        const lastMessage = lastMessageSnapshot.val();

        if (lastMessage) {
            const messageTimestamp = lastMessage.timestamp;
            const messageAge = now - messageTimestamp;

            if (messageAge >= 10 * 24 * 60 * 60 * 1000) {
                // Son mesaj 10 günden daha eski, mesajları sil
                return admin.database().ref(`/chat_rooms/${roomId}`).remove();
            }
        } else {
            // Mesaj yok, mesajları sil
            return admin.database().ref(`/chat_rooms/${roomId}`).remove();
        }
    }

    return null;
});

exports.scheduleCheckPremiumEndDate = functions.pubsub.schedule('every 60 minutes').timeZone('Europe/Istanbul').onRun(async (context) => {
    const chatRoomsRef = admin.database().ref('/chat_rooms');

    const snapshot = await chatRoomsRef.once('value');
    snapshot.forEach(async (childSnapshot) => {
        const roomId = childSnapshot.key;
        const roomData = childSnapshot.val();

        if (!roomId || !roomData) {
            console.error('Invalid data:', roomId, roomData);
            return null;
        }

        const [senderUid, receiverUid] = roomId.split('-');

        const usersRef = admin.database().ref('/users');
        const [senderSnapshot, receiverSnapshot] = await Promise.all([
            usersRef.child(senderUid).once('value'),
            usersRef.child(receiverUid).once('value'),
        ]);

        const senderPremiumEndDate = senderSnapshot.child('premiumEndDate').val();
        const receiverPremiumEndDate = receiverSnapshot.child('premiumEndDate').val();

        const now = Date.now();

        if (
            ((senderPremiumEndDate && senderPremiumEndDate >= now) || !senderPremiumEndDate) &&
            ((receiverPremiumEndDate && receiverPremiumEndDate >= now) || !receiverPremiumEndDate)
        ) {
            const lastMessageRef = admin.database().ref(`/chat_rooms/${roomId}`).orderByChild('timestamp').limitToLast(1);
            const lastMessageSnapshot = await lastMessageRef.once('value');
            const lastMessage = lastMessageSnapshot.val();

            if (lastMessage) {
                const messageTimestamp = lastMessage.timestamp;
                const messageAge = now - messageTimestamp;

                if (messageAge >= 10 * 24 * 60 * 60 * 1000) {
                    // Son mesaj 10 günden daha eski, mesajları sil
                    return admin.database().ref(`/chat_rooms/${roomId}`).remove();
                }
            } else {
                // Mesaj yok, mesajları sil
                return admin.database().ref(`/chat_rooms/${roomId}`).remove();
            }
        }

        return null;
    });

    const chatRoomsSnapshot = await chatRoomsRef.once('value');
    const chatRoomIds = Object.keys(chatRoomsSnapshot.val());

    senderSnapshot.child('chatrooms').forEach(async (childSnapshot) => {
        const chatRoomId = childSnapshot.key;
        if (!chatRoomIds.includes(chatRoomId)) {
            await usersRef.child(`${senderUid}/chatrooms/${chatRoomId}`).remove();
        }
    });

    receiverSnapshot.child('chatrooms').forEach(async (childSnapshot) => {
        const chatRoomId = childSnapshot.key;
        if (!chatRoomIds.includes(chatRoomId)) {
            await usersRef.child(`${receiverUid}/chatrooms/${chatRoomId}`).remove();
        }
    });

    return null;
});
