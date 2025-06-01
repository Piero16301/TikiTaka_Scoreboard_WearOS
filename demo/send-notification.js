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
        
        const goalHomePayload = {
            message: {
                token: "cU5OvektRC-TiECBt4dot5:APA91bFOsT2FopnpsHOBiLWD1EmA8AQ51zvwuHkN5YnyrvumXgqO5_y6pCkelok1G1wTr_RegH1K7Tnm_12j5XnLqPh8YA-NN_p4yJUOyujVeO9xBGjEu4I",
                data: {
                    type: "GOAL_HOME",
                    deepLink: "matchId:498957",
                    homeTeam: JSON.stringify({
                        colors: "Red / Navy Blue / Orange",
                        name: "FC Barcelona",
                        shortName: "Barça",
                        score: "4",
                    }),
                    awayTeam: JSON.stringify({
                        colors: "White / Purple",
                        name: "Real Madrid CF",
                        shortName: "Real Madrid",
                        score: "2",
                    }),
                    status: "IN_PLAY",
                },
                android: {
                    priority: "high",
                    notification: {
                        channel_id: "high_importance_channel"
                    }
                },
            }
        };
        
        const messagePayload = {
            message: {
                topic: "all-devices",
                notification: {
                    title: "¡Gol de FC Barcelona! ⚽",
                    body: "🔴🔵 Barça 4️⃣ - 3️⃣ Real Madrid ⚪⚪",
                },
                data: {
                    type: "matchId:498957"
                },
                android: {
                    priority: "high",
                    notification: {
                        channel_id: "high_importance_channel"
                    }
                },
            }
        };
        
        const headers = {
            'Authorization': `Bearer ${token}`,
            'Content-Type': 'application/json'
        };
        
        const response = await axios.post(url, goalHomePayload, { headers });
        console.log('Notification sent successfully:', response.data);
    } catch (error) {
        console.error('Error:', error.response ? error.response.data : error.message);
    }
}

sendNotification();