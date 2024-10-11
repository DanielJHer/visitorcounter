describe('Visitor Count API', () => {
  const apiUrl =
    'https://iehktaw4th.execute-api.us-east-1.amazonaws.com/default/visitorcount'; // Your API endpoint

  it('should increment visitor count with POST request', () => {

    // Getting the intial visitor count
    cy.request('GET', apiUrl).then((getResponse) => {
      const initialCount = getResponse.body.visitor_count;

    // Test the POST request
    cy.request({
      method: 'POST',
      url: apiUrl,
      headers: {
        'Content-Type': 'application/json',
      },
    }).then((response) => {
      // Assertions for POST request
      expect(response.status).to.eq(200);

      // Check that the visitor count has incremented
      const newCount = postResponse.body.visitor_count;
      expect(newCount).to.be.greaterThan(initialCount);
    });
  });
});
