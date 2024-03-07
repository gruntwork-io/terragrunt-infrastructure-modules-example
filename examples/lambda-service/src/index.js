/**
 * The entrypoint for this Lambda function. This will be called by API Gateway. Returns a simple "Hello, World"
 * response.
 *
 * @param event
 * @param context
 * @param callback
 * @returns {Promise<void>}
 */
exports.handler = (event, context, callback) => {
    console.log('Received an event:', JSON.stringify(event, null, 2));
    callback(null, {statusCode: 200, body: "Hello, World!"});
};