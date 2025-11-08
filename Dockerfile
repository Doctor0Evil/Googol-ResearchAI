# Base image for running SuperLegal.AI core environment
FROM ubuntu:22.04

LABEL maintainer="SuperLegal.AI Collective <support@superlegal.ai>"

# Install dependencies for ALN runtime and particles execution environment
RUN apt-get update && apt-get install -y \
    python3 python3-pip git curl \
    && rm -rf /var/lib/apt/lists/*

# Copy project files into container
COPY . /app

WORKDIR /app

# Install runtime dependencies (placeholder for actual runtime requirements)
RUN pip3 install -r requirements.txt

# Define default command to run compliance CI check (example)
CMD ["./scripts/compliance_check.sh"]
