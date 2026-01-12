# Use Ruby slim image for smaller footprint
FROM ruby:3.2-slim

# Set working directory
WORKDIR /app

# Install dependencies
RUN apt-get update -qq && \
    apt-get install -y \
        curl \
        build-essential \
        libsqlite3-dev \
        sqlite3 \
        nodejs \
        libyaml-dev \
        && rm -rf /var/lib/apt/lists/*

# Enable yarn via corepack (Node 20+ comes with corepack)
RUN corepack enable && corepack prepare yarn@stable --activate

# Copy Gemfile and Gemfile.lock first to leverage Docker cache
COPY Gemfile Gemfile.lock ./

# Install gems
RUN gem install bundler -v 2.6.9 && bundle install

# Copy the rest of the app
COPY . .

# Expose default Rails port
EXPOSE 3000

# Default command
CMD ["rails", "server", "-b", "0.0.0.0"]
