# Udacity Cloud DevOps Capstone - blue/green CI/CD pipeline

## Project Overview
In this project, we had to build a CI/CD pipeline for a microservices application. I've designed this CI/CD pipeline to work with Jenkins, and it follows this blue/green deployment methodology. This project has **three** braches **master**, **blue** & **green**.

In terms of the type of application this pipeline is deploying, I decided to create a simple **PHP** application which is built into a docker image. My reasons for this is I'm application development by trade, and we build our API in **PHP**.

## Installation
In order to run this CI/CD pipeline, you will first need access to **Jenkins**, and have an **AWS** account. You will also need to install the **Blue Ocean** and **AWS pipeline** plugins.

Once you have your Jenkins and AWS environments setup you will need to first run my #Create cluster pipeline# which can be found [here](https://github.com/adamsteff/capstone_create_cluster_pipeline) 
- https://github.com/adamsteff/capstone_create_cluster_pipeline

The #Create cluster pipeline# uses eksctl to create an AWS EKS cluster through CloudFormation. This CloudFormation Scripts can be found in that repository.

## Overview
The pipeline has been designed so when code changes are made to the different branches, the steps will run in a conditional format. The steps in the pipeline are as follows:

### Lint HTML
This step is used to makes sure there is no syntax error in the .php files

### Build Docker Image
This step builds a new docker image of the website

### Push Docker Image
This step uploads the new docker image to [DockerHub](https://cloud.docker.com) 

### Set Kubectl Context to Cluster
This step switches to the correct cluster using the following command `kubectl config use-context arn:aws:eks:ap-southeast-2:048353547478:cluster/capstonecluster` 

### Create Blue Controller
This step creates the blue controller using the following command `kubectl apply -f ./blue-controller.json`

### Create Green Controller
This step creates the green controller using the following command `kubectl apply -f ./green-controller.json`

### Deploy to Production
This is an interactive step where the user decides if the changes are to be released to production or not.

### Rollout Blue Changes
This step rolls out the latest Docker image from DockerHub to the blue pods using the command `kubectl rolling-update blueversion --image=adamsteff/capstonerepository:latest`

### Rollout Green Changes
This step rolls out the latest Docker image from DockerHub to the green pods using the command `kubectl rolling-update greenversion --image=adamsteff/capstonerepository:latest`

### Create Blue-Green service
This steps applies the change to load balancer by running `kubectl apply -f ./blue-green-service.json`

## Usage

### Master Branch
When your code changes are committed and pushed in the master branch, the following steps will occur:
- Lint HTML
- Build Docker Image
- Push Docker Image
- Set Kubectl Context to Cluster

All the other steps in the pipeline are skipped, and no updates to the website will be made.

### Blue Branch
When your code changes are committed and pushed in the blue branch, the following steps will occur:
- Lint HTML
- Build Docker Image
- Push Docker Image
- Set Kubectl Context to Cluster
- Create Blue Controller
- Deploy to Production
- Rollout Blue Changes
- Create Blue-Green service - the load balancer will point to the blue pods

### Green Branch
When your code changes are committed and pushed in the green branch, the following steps will occur.
- Lint HTML
- Build Docker Image
- Push Docker Image
- Set Kubectl Context to Cluster
- Create Green Controller
- Deploy to Production
- Rollout Green Changes
- Create Blue-Green service - the load balancer will point to the green pods
