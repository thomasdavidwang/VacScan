/**
 * @type {import('@types/aws-lambda').CreateAuthChallengeTriggerHandler}
 */

const AWS = require('aws-sdk');
const crypto = require('node:crypto');

// Use SES or custom logic to send the secret code to the user.
async function sendChallengeCode(phoneNumber, secretCode) {
  const message = "Your verification code is: " + secretCode
  var sns = new AWS.SNS();
  await sns.publish({
     PhoneNumber: phoneNumber,
     Message: message
  }).promise();
}

async function createAuthChallenge(event) {
  if (event.request.challengeName === 'CUSTOM_CHALLENGE') {
     // Generate a random code for the custom challenge
     let challengeCode = '';
     for (let i = 0; i < 6; i++) {
       challengeCode += crypto.randomInt(10);
     }

     // Send the custom challenge to the user
     await sendChallengeCode(event.request.userAttributes.phone_number, challengeCode)

     event.response.privateChallengeParameters = {};
     event.response.privateChallengeParameters.answer = challengeCode;
   }
}
 
exports.handler = async (event) => {
  return createAuthChallenge(event);
};