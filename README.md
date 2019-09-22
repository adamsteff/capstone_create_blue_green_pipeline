# Udacity Capstone - Cloud DevOps

## Project Overview
In this project we had to build a CI/CD pipeline for a microservices application. I've designed this CI/CD pipeline to work wth Jenkins and it follows this blue/green deployment methodology. This project has **three** braches **master**, **blue** & **green**.

## Installation
In order to run this CI/CD pipeline you will first need access to **Jenkins**, and have an **AWS** account. You will also need to install the **Blue Ocean** and **AWS pipline** plugins.

Once you have your Jenkins and AWS enviroments setup you will need to first run my #Create cluster pipeline# which can be found [Here].(https://github.com/adamsteff/capstone_create_cluster_pipeline) 

## Usage
The pipeline has been designed so when code changes are made to the different branches the step run will are conditional.
The steps in the pipeline are as follows.

### Lint HTML
This step is used to make sure thier is no syntax error in the code

### Build Docker Image
This step builds a new docker image of the website

### Push Docker Image
This step builds a uploads the new docker image to [DockerHub](https://cloud.docker.com) 

### Set Kubectl Context to Cluster
This step switches to the correct cluster using the following command `kubectl config use-context arn:aws:eks:ap-southeast-2:048353547478:cluster/capstonecluster` 

### Master Branch
When you code change are commited and push in the master branch the follow steps will occur.
Lint HTML
Build Docker Image
Push Docker Image
Set Kubectl Context to Cluster

All the other steps in the pipeline are skipped and no upates to the website will be made.


### Blue Branch
 
