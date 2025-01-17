FROM ruby:3.3.4

# Set working directory
WORKDIR /app

# Install Node.js 23.1.0 and Yarn
RUN curl -fsSL https://deb.nodesource.com/setup_23.x | bash - && \
    apt-get update -qq && \
    apt-get install -y build-essential libpq-dev libvips-dev nodejs && \
    npm install -g yarn

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
COPY --chown=appuser:appuser ../ ./

# **Corrected COPY path for entrypoint.sh**
COPY --chown=appuser:appuser .devcontainer/entrypoint.sh /usr/bin/entrypoint.sh

# Ensure the entrypoint script is executable
RUN chmod +x /usr/bin/entrypoint.sh

# Expose Rails server port
EXPOSE 5000

# Set entrypoint
ENTRYPOINT ["entrypoint.sh"]