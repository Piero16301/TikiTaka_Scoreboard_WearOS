// npm install google-auth-library axios
const { GoogleAuth } = require('google-auth-library');
const axios = require('axios');

const auth = new GoogleAuth({
    keyFile: 'service-account.json',
    scopes: 'https://www.googleapis.com/auth/firebase.messaging'
});

async function getAccessToken() {
    const client = await auth.getClient();
    const accessToken = await client.getAccessToken();
    return accessToken.token;
}

async function sendNotification() {
    try {
        const token = await getAccessToken();
        const url = 'https://fcm.googleapis.com/v1/projects/tiki-taka-scoreboard/messages:send';

        const matchId = 498957;

        const messagePayload = {
            message: {
                // topic: "all-devices",
                token: "dGixPljGTha8RWrlyqA2tN:APA91bGGPj14JslOJCnLiNHgdNT-XbDZaXwiGA-Skexjuu6RJsVUnLwZbra0BV4jrqC55UBrTSAQAb4yMvgivh0YVKzM_bcSN7u0QqqywsK2NvIJ0ChS2-g",
                notification: {
                    title: "¡Gol de Barça! ⚽ 🏠",
                    body: "Barça 6️⃣ - 2️⃣ Real Madrid",
                },
                android: {
                    priority: "high",
                    collapse_key: `match_${matchId}`,
                    notification: {
                        notification_priority: "PRIORITY_MAX",
                        tag: `match_${matchId}`,
                    },
                },
                data: {
                    match: `matchId:${matchId}`,
                },
            }
        };

        const headers = {
            'Authorization': `Bearer ${token}`,
            'Content-Type': 'application/json'
        };

        const response = await axios.post(url, messagePayload, { headers });
        console.log('Notification sent successfully:', response.data);
    } catch (error) {
        console.error('Error:', error.response ? error.response.data : error.message);
    }
}

sendNotification();