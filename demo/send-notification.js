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
    9: "9️⃣",
    10: "🔟",
};

const SUPPORTED_LANGUAGES = ["en", "es", "de", "fr", "it", "pt"];

const TRANSLATIONS = {
    en: {
        goal_title: (team, suffix) => `Goal by ${team}! ${suffix}`,
        body: (home, homeScore, awayScore, away) => `${home} ${homeScore} - ${awayScore} ${away}`,
    },
    es: {
        goal_title: (team, suffix) => `¡Gol de ${team}! ${suffix}`,
        body: (home, homeScore, awayScore, away) => `${home} ${homeScore} - ${awayScore} ${away}`,
    },
    de: {
        goal_title: (team, suffix) => `Tor von ${team}! ${suffix}`,
        body: (home, homeScore, awayScore, away) => `${home} ${homeScore} - ${awayScore} ${away}`,
    },
    fr: {
        goal_title: (team, suffix) => `But de ${team} ! ${suffix}`,
        body: (home, homeScore, awayScore, away) => `${home} ${homeScore} - ${awayScore} ${away}`,
    },
    it: {
        goal_title: (team, suffix) => `Gol di ${team}! ${suffix}`,
        body: (home, homeScore, awayScore, away) => `${home} ${homeScore} - ${awayScore} ${away}`,
    },
    pt: {
        goal_title: (team, suffix) => `Golo de ${team}! ${suffix}`,
        body: (home, homeScore, awayScore, away) => `${home} ${homeScore} - ${awayScore} ${away}`,
    },
};

function buildMessage(lang, matchId, homeTeam, awayTeam, homeScore, awayScore, isHomeGoal) {
    const trans = TRANSLATIONS[lang] || TRANSLATIONS.en;
    const scoringTeam = isHomeGoal ? homeTeam : awayTeam;
    const suffix = isHomeGoal ? "⚽ 🏠" : "⚽ ✈️";
    const homeScoreStr = scoreMap[homeScore] || `${homeScore}`;
    const awayScoreStr = scoreMap[awayScore] || `${awayScore}`;
    const title = trans.goal_title(scoringTeam.shortName, suffix);
    const body = trans.body(homeTeam.shortName, homeScoreStr, awayScoreStr, awayTeam.shortName);

    const condition = `'team_${homeTeam.id}_${lang}' in topics || 'team_${awayTeam.id}_${lang}' in topics`;

    return {
        condition: condition,
        notification: {
            title: title,
            body: body,
        },
        android: {
            priority: "high",
            collapse_key: `match_${matchId}`,
            notification: {
                title: title,
                body: body,
                channel_id: "high_importance_channel",
                notification_priority: "PRIORITY_MAX",
                tag: `match_${matchId}`,
                default_sound: true,
                default_vibrate_timings: true,
            },
        },
        data: {
            match: `matchId:${matchId}`,
            matchId: `${matchId}`,
        },
    };
}

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

        const headers = {
            'Authorization': `Bearer ${token}`,
            'Content-Type': 'application/json'
        };

        // Enviar notificación simulando main.py para cada idioma (o para español como prueba directa)
        for (const lang of ["es"]) {
            const message = buildMessage(lang, matchId, homeTeam, awayTeam, homeScore, awayScore, isHomeGoal);
            console.log(`Sending topic notification for language '${lang}' with condition: ${message.condition}`);
            console.log(`Title: ${message.notification.title}`);
            console.log(`Body: ${message.notification.body}`);

            const response = await axios.post(url, { message }, { headers });
            console.log(`Notification for '${lang}' sent successfully:`, response.data);
        }
    } catch (error) {
        console.error('Error:', error.response ? error.response.data : error.message);
    }
}

sendNotification();