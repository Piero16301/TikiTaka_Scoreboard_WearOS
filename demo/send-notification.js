const axios = require('axios');

const token = 'ya29.c.c0ASRK0GbEYkQZDM3Ol2SI6s3qHach5RT2c3o9NIflU1VGCpJNEEUn_8UoevDV7KGE1z1A1RZBDf5Tq72IaYfhQWNovp5Gj_6ZU7jGbDFdhWfeLT7PWzz4BKlijW58Ew8dyiWsvJIg_Tqfd8F1D06IZBPNXJtmVILiv1dIhXFioagn0mUV9OUKC0Qq-1PAVw0zR914lAMFnyEk4_vFvMXzKLeUkacxYLhm1g9ZDmGSP5ooBDbHvgL9lXuMYQMf4SF02LLzTl2YHGEFpCeMWzAC81YvKAJr462PPc3ygz18UhchY52J1saBB3eQ0vlnu0MkFXTQyvFg1uE2w3FrG7O0b_-HGA2rezGcxJx593e-lBIqPLTUgg-bQ0y2G385AMo7iWRjx4X333X6lM5nwqg3WOn4MJjQFJyexsvaBs3cY_-73r50Yayl_5BM-qyQxRnQ7oMtQ5jwwUWwZIi83BiUr-mZ8q6Offhli0ot_xbXlYdvVfg73y4lXdcx-V7i16ren2yz0S9qQRYzJozX39eUhq6Wo6q4bs1gszBzOjxIXuuB48_cOkW4zIhng6it7U_0koez43w4eUll8uJ7e3qckrjVb64QRxe_Jw5UMzjI9-j3OYZIi1dUj-n1qaB1vB3WloBbcFj8qU47-Fz4az1YtS5a93Ub06gu94nj91pgSj3eg-bBbluo2QVjfi5gJoSm0t-pnqezo_fW5sZOyl6VS16wbebUOqQhrS9_jJXbhiM8mYk2Ymct14gV413MMzVO65mzIvR5fBMrqBYxaos4cV8MdcSlhfuc3r_cqfuyfoSy5aeibI4SZUvwenYJqc6VVFeesu_v1fIw2UX87ezzpFxn3dgq3XVcn1Q3q_k7uXBm6kvQWYbQuifZwswmVcrZjg_szzyr9omeV1Fxz9sO9hc69aYqnS9x_1mS4lzc4Y05VgRtk5cO9IZrwps4Q0uwRvSc0ybmyZhxUacmFIhqIc2Yy7xup3q_OVBI-lphjrJg9FgiwO1Uq_h';
const url = 'https://fcm.googleapis.com/v1/projects/tiki-taka-scoreboard/messages:send';

const messagePayload = {
    message: {
        topic: "all-devices",
        notification: {
            title: "Broadcast Notification",
            body: "This message is sent to all devices subscribed to the topic."
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

axios.post(url, messagePayload, { headers })
    .then(response => {
        console.log('Notification sent successfully:', response.data);
    })
    .catch(error => {
        console.error('Error sending notification:', error.response ? error.response.data : error.message);
    });
