exports.handler = async (event) => {
    // Extract the request from the CloudFront event that is sent to Lambda@Edge
    var request = event.Records[0].cf.request;
    // Re-route '/' access to '/index.html'
    request.uri = request.uri.replace(/\/$/, '\/index.html');

    return request;
};
