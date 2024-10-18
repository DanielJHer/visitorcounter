# Cloud Resume Challenge

This project is a part of the Cloud Resume Challenge, which aims to demonstrate practical experience in cloud technologies like AWS, Terraform, and GitHub Actions. The project consists of a static website hosted on AWS S3, integrated with a visitor counter using AWS Lambda, API Gateway, DynamoDB, and a CI/CD pipeline built using GitHub Actions and Terraform.

[Check it out!](https://danielher.com)

## Features

1. Static Resume Website:

   - Deployed to an AWS S3 bucket.
   - Accessed via a custom domain using Route 53 and secured with SSL (AWS Certificate Manager).
   - Served through AWS CloudFront for content delivery.

2. Visitor Counter:

   - A Lambda function (written in Python) that increments and retrieves the visitor count from DynamoDB.
   - API Gateway is used to invoke the Lambda function from the frontend.
   - CORS enabled to allow communication between the S3-hosted frontend and the API Gateway.

3. CI/CD Pipline:
   - Built using GitHub Actions.
   - Automated workflow triggers on push to GitHub repository, running Terraform to manage and deploy AWS resources.
   - The pipeline runs the following steps:
     1. Checkout code from the repository.
     2. Install and initialize Terraform.
     3. Deploy infrastructure changes using terraform apply.
     4. Configure AWS credentials securely through GitHub Secrets.

## Infrastructure

- S3: Hosts the static HTML, CSS, and JavaScript files for the resume website.
- CloudFront: Distributes the website via a global CDN, ensuring fast content delivery.
- Route 53: Manages the DNS for the custom domain.
- ACM: Provides an SSL certificate to secure the website with HTTPS.
- Lambda: Handles the logic for counting website visitors.
- DynamoDB: Stores the visitor count.
- API Gateway: Provides a RESTful endpoint to interact with the Lambda function.
- GitHub Actions: Automates the CI/CD pipeline for deploying Terraform configurations.

## Technologies Used

- Frontend: HTML, CSS, JavaScript
- Backend: Python (Lambda function)
- Infrastructure as Code: Terraform
- CI/CD: GitHub Actions
- AWS Services: S3, CloudFront, Lambda, DynamoDB, API Gateway, Route 53, ACM
- Version Control: Git, GitHub
