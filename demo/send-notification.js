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
        
        const messagePayload = {
            message: {
                topic: "all-devices",
                notification: {
                    title: "¡Gol de FC Barcelona! ⚽",
                    body: "🔴🔵 Barça 4️⃣ - 3️⃣ Real Madrid ⚪⚪",
                },
                data: {
                    match: "matchId:498957"
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