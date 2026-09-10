// npm install google-auth-library axios
const path = require('path');
const { GoogleAuth } = require('google-auth-library');
const axios = require('axios');

const auth = new GoogleAuth({
    keyFile: path.join(__dirname, 'service-account.json'),
    scopes: 'https://www.googleapis.com/auth/firebase.messaging'
});

async function getAccessToken() {
    const client = await auth.getClient();
    const accessToken = await client.getAccessToken();
    return accessToken.token;
}

const scoreMap = {
    0: "0️⃣",
    1: "1️⃣",
    2: "2️⃣",
    3: "3️⃣",
    4: "4️⃣",
    5: "5️⃣",
    6: "6️⃣",
    7: "7️⃣",
    8: "8️⃣",
};

async function sendNotification() {
    try {
        const token = await getAccessToken();
        const url = 'https://fcm.googleapis.com/v1/projects/tiki-taka-scoreboard/messages:send';

        const matchId = 498957;
        const homeTeam = { id: 81, shortName: "Barça" };
        const awayTeam = { id: 86, shortName: "Real Madrid" };
        const homeScore = 6;
        const awayScore = 2;

        const isHomeGoal = true;
        const scoringTeam = isHomeGoal ? homeTeam : awayTeam;
        const suffix = isHomeGoal ? "⚽ 🏠" : "⚽ ✈️";

        const messagePayload = {
            message: {
                // 1. Envío por condición de tópicos como en TikiTaka_Backend/main.py:
                condition: `'team_${homeTeam.id}' in topics || 'team_${awayTeam.id}' in topics`,

                // Alternativa directa al tópico del Barça:
                // topic: `team_${homeTeam.id}`,

                // Alternativa por token de dispositivo individual para pruebas:
                // token: "faUsjPtwT-qWKXWZUkdvJW:APA91bEby5Tie_Nuc8L07MQ3H0aUF4rtEOjiWNoNBqJQ5LP-a5-2L8ltI59KZr1PPYXfvy36Lp83cxw54pargKAR8x0XvN2QA2grR8c_uM5Nk3vwfcflz0o",

                // Configuración Android con localización nativa pura (res/values/strings.xml del proyecto)
                android: {
                    priority: "high",
                    collapse_key: `match_${matchId}`,
                    notification: {
                        title_loc_key: "notification_goal_title",
                        title_loc_args: [
                            scoringTeam.shortName,
                            suffix
                        ],
                        body_loc_key: "notification_match_body",
                        body_loc_args: [
                            homeTeam.shortName,
                            scoreMap[homeScore] || `${homeScore}`,
                            scoreMap[awayScore] || `${awayScore}`,
                            awayTeam.shortName
                        ],
                        channel_id: "high_importance_channel",
                        notification_priority: "PRIORITY_MAX",
                        tag: `match_${matchId}`
                    }
                },
                data: {
                    match: `matchId:${matchId}`,
                    matchId: `${matchId}`
                }
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