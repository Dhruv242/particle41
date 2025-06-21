# SimpleTimeService

A minimalist microservice that returns the current timestamp and the IP address of the requester.

##  Features

- Returns current UTC time in ISO format
- Returns visitor's IP address
- Dockerized with non-root user
- Lightweight image using Python slim

## 🐳 Docker Instructions

### Build the image

```bash
docker build -t yourdockerhubusername/simpletimeservice .

## YOU CAN PULL IMAGE FROM "public.ecr.aws/p1o6l2q2/dk_particle:latest" public ECR
# docker pull public.ecr.aws/p1o6l2q2/dk_particle:latest