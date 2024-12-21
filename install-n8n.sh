#!/bin/bash

set -e  # Exit on errors

# Error handling
handle_error() {
    echo "An error occurred. Exiting."
    exit 1
}
trap 'handle_error' ERR

echo "Starting n8n installation script..."

# Step 1: Check if Git is installed
if ! command -v git &>/dev/null; then
    echo "Git is not installed. Installing Git and dependencies..."
    if [ -f /etc/debian_version ]; then
        sudo apt update
        sudo apt install -y git
    elif [ -f /etc/redhat-release ]; then
        sudo yum install -y git
    else
        echo "Unsupported OS. Please install Git manually."
        exit 1
    fi
else
    echo "Git is already installed."
fi

# Step 2: Clone the repository
REPO_URL="https://github.com/butdiditwork/n8n-docker"
INSTALL_DIR="n8n-docker"

if [ -d "$INSTALL_DIR" ]; then
    echo "Directory '$INSTALL_DIR' already exists. Pulling latest changes..."
    cd "$INSTALL_DIR" && git pull && cd ..
else
    echo "Cloning repository..."
    git clone "$REPO_URL" "$INSTALL_DIR"
fi

# Always ensure we are in the working directory
cd "$INSTALL_DIR"

# Step 3: Create necessary directories and set permissions
echo "Creating necessary directories..."
mkdir -p n8n_data pgdata

echo "Current UID: $(id -u)"
echo "Current GID: $(id -g)"

echo "Setting directory ownership for persistent storage..."
# Alternative: Static UID/GID for n8n container
sudo chown -R 1000:1000 ./n8n_data ./pgdata

# Step 4: Copy and configure .env file
if [ ! -f .env ]; then
    echo "Setting up .env configuration..."
    if [ -f .env.example ]; then
        cp .env.example .env
    else
        echo "No .env.example file found. Please ensure it exists in the repository."
        exit 1
    fi
fi

echo "Opening .env for editing. Please follow the instructions below to configure your environment."

echo ""
echo "Instructions:"
echo ""
echo "1. Set your desired Basic Authentication credentials:"
echo "   - N8N_BASIC_AUTH_USER: Set the username for accessing n8n."
echo "   - N8N_BASIC_AUTH_PASSWORD: Set the password for accessing n8n."
echo ""
echo "2. Configure your host and webhook settings:"
echo "   - N8N_HOST: Specify the hostname (e.g., localhost or a domain)."
echo "   - WEBHOOK_URL: Provide the full URL for webhook endpoints (e.g., http://localhost:5678)."
echo ""
echo "3. Set PostgreSQL database credentials:"
echo "   - POSTGRES_USER: Define the username for PostgreSQL."
echo "   - POSTGRES_PASSWORD: Define the password for PostgreSQL."
echo "   - POSTGRES_DB: Define the database name for n8n."
echo ""
echo "4. Save and exit the editor when you are done editing."
echo ""

read -p "Press Enter to open the .env file in nano..."
nano .env

# Step 5: Final instructions for starting n8n
echo ""
echo "Configuration complete!"
echo ""
echo "You are now in the project directory: $(pwd)"
echo "You can now start n8n with the following command:"
echo "    docker compose up -d"
echo ""
echo "To stop n8n, run:"
echo "    docker compose down"
echo ""
echo "To view logs, run:"
echo "    docker compose logs -f"
echo ""
