# Use a lightweight base image
FROM python:3.11-slim

# Create a non-root user
RUN useradd -m simpleuser

# Set working directory
WORKDIR /app

# Copy code
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY app.py .

# Change ownership and permissions
RUN chown -R simpleuser:simpleuser /app

# Switch to non-root user
USER simpleuser

# Expose port
EXPOSE 5000

# Run the application
CMD ["python", "app.py"]
