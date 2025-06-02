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
                topic: "all-devices",
                android: {
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
                    priority: "HIGH",
                    notification: {
                        title: "¡Gol de FC Barcelona! ⚽",
                        body: "🔴🔵 Barça 4️⃣ - 3️⃣ Real Madrid ⚪⚪",
                        color: "#A50044",
                        title_loc_key: "goal_home_title",
                        title_loc_args: JSON.stringify(["FC Barcelona"]),
                        body_loc_key: "goal_home_body",
                        body_loc_args: JSON.stringify(["FC Barcelona", "4", "Real Madrid", "3"]),
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