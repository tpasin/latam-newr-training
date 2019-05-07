# Training Sequence

1. Pre-Requisites
    - Create a GitHub account
    - Create a DockerHub account
    - Create an AWS account
    - Create a New Relic account
    - Install Visual Studio Code
    - Install Git (windows)
    - Clone the repository on your local computer
    - Open the repository in Visual Studio Code

2. EC2 instance setup (TRAINING_GUIDE.sh, part 1)
    - Create the EC2 instance
        - Amazon Linux
        - t2.medium
        - 24Gb Storage
    - Configure the EC2 instance
    
3. Observability in New Relic, part 1
    - Check data on INFRASTRUCTURE
        - Hosts
        - Events
        - Inventory
    
4. Docker setup (TRAINING_GUIDE.sh, part 2)
    - Explain the repository structure
    - Explain the application structure (PPT slide and docker-compose.yaml)
    - Clone the repository
    - Branch back in time
    - Build / Run the application

5. Instrumentation (services)
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

4. Observability in New Relic, part 2
    - Check data on INSIGHTS
        - custom attributes
        - custom events
    - Check data on APM
        - distributed tracing
        - error analytics
    - Check data on BROWSER
        - traces
        - js errors
    - Check data on INFRASTRUCTURE
        - processes
        - container attributes

5. Kubernetes Setup (TRAINING_GUIDE.sh, part 3)
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

7. Observability in New Relic, part 3
    - Check data on INFRASTRUCTURE
        - Kubernetes Cluster Explorer
        - On Host Integrations Dashboards
    - Setup Alerts
    - Create Insights Dashboards
