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
