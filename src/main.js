window.onload = function () {
  // API endpoint URL
  const apiGatewayURL =
    'https://hc7krzi1z5.execute-api.us-west-1.amazonaws.com/default/visitorcount';

  // Fetch visitor count from Lambda function via API Gateway
  fetch(apiGatewayURL, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
    },
  })
    .then((response) => response.json())
    .then((data) => {
      // Update the visitor count on the webpage with the updated value
      document.getElementById('visitor-count').textContent = data.visitor_count;
    })
    .catch((error) => {
      console.log('Error', error);
      document.getElementById('visitor-count').textContent =
        'Error loading visitor count.';
    });
};
