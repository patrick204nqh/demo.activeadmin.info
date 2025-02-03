FROM ruby:3.3.4

# Set working directory
WORKDIR /app

# Install dependencies
RUN apt-get update -qq && \
    apt-get install -y \
    curl \
    build-essential \
    libpq-dev \
    libvips-dev \
    postgresql-client \
    ffmpeg

# Install Node.js 23.1.0
RUN curl -fsSL https://deb.nodesource.com/setup_23.x | bash - && \
    apt-get install -y nodejs

# Install Yarn
RUN npm install -g yarn

# Set environment variables
ENV LANG=C.UTF-8
ENV BUNDLE_PATH=/usr/local/bundle
ENV RAILS_ENV=development

# Install Yarn
RUN npm install -g yarn

# Copy package.json and install Node.js dependencies
COPY package.json yarn.lock ./
RUN yarn install

# Copy and install gems
COPY Gemfile Gemfile.lock ./
RUN bundle install

# Copy the rest of the application code
COPY ../ ./

# Copy the entrypoint script and ensure it's executable
COPY .devcontainer/entrypoint.sh /usr/bin/entrypoint.sh
RUN chmod +x /usr/bin/entrypoint.sh

# Expose Rails server port
EXPOSE 3000

# Set entrypoint
ENTRYPOINT ["entrypoint.sh"]