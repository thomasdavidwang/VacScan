/**
 * @type {import('@types/aws-lambda').DefineAuthChallengeTriggerHandler}
 */
exports.handler = async (event) => {
  if (event.request.session.length == 0) {
    event.response.issueTokens = false;
    event.response.failAuthentication = false;
    event.response.challengeName = 'CUSTOM_CHALLENGE';
  } else if (s
    event.request.session.length == 1 &&
    event.request.session[0].challengeName == 'CUSTOM_CHALLENGE' &&
    event.request.session[0].challengeResult == true
  ) {
    event.response.issueTokens = true;
    event.response.failAuthentication = false;
    event.response.challengeName = 'CUSTOM_CHALLENGE';
  } else {
    event.response.issueTokens = false;
    event.response.failAuthentication = true;
  }
};
