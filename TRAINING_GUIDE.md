# Training Sequence

1. Pre-Requisites
    - Create a GitHub account
    - Create a DockerHub account
    - Create an AWS account
    - Create a New Relic account
    - Install Visual Studio Code
    - Install Git (windows)

2. Docker (TRAINING_GUIDE.sh, part 1)
    - Clone the application (locally)
    - Create the EC2 instance
        - Amazon Linux
        - t2.large
        - 24Gb Storage
    - Configure the EC2 instance
    - Clone and build the application
    - Explain the application structure
    - Run the application

3. Instrumentation (services)
    - Node.JS
        - cart
        - catalogue
        - user
    - Python
        - payment
    - Java
        - shipping
    - GoLang
        - dispatch
    - PHP
        - ratings
    - Angular.JS
        - web

4. Observability in New Relic, part 1
    - Check data on APM
    - Check data on BROWSER
    - Check data on INSIGHTS
    - Check data on INFRASTRUCTURE

5. Kubernetes Setup (TRAINING_GUIDE.sh, part 2)
    - Push the images
    - Create the EKS cluster

6. Instrumentation (Infrastructure)
    - Services
        - Kubernetes
        - MongoDB
        - MySQL
        - RabbitMQ
        - Redis
    - Deploy manifests

7. Observability in New Relic, part 2
    - Check data on INFRASTRUCTURE
    - Navigate the Kubernetes Cluster
    - Navigate the 4 on-host integrations (MySQL, MongoDB, Redis, RabbitMQ)
    - Setup Alerts
    - Create Dashboards