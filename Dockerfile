# Use a Ruby base image
FROM ruby:3.0.6

# Set the working directory inside the container
WORKDIR /app

# Copy Gemfile and Gemfile.lock
COPY Gemfile Gemfile.lock ./

# Install dependencies
RUN bundle install

# Copy the rest of the application code
COPY . .

# Expose port 3000 to the outside world
EXPOSE 3000

# Command to run the application
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]