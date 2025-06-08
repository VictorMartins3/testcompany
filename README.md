# Events Manager

Events Manager is a Ruby on Rails API for managing events, talks, participants, and attendances. This system allows:

- Managing events with start and end dates
- Creating talks within events with specific schedules
- Registering participants for events
- Recording attendances of participants at talks

## Code Challenge

As a candidate, you are required to implement a new feedback functionality for the Events Manager system. The challenge consists of enhancing the current application with a feature that allows participants to provide feedback on talks they attended.

The feedback functionality should capture a comment and a rating (from 1 to 5) from participants. It's important to note that feedback can only be registered for participants who actually attended the talk, and each participant should be limited to providing only one feedback per talk.

Additionally, you need to implement a reporting endpoint that will provide comprehensive feedback information for events. This report should include the average rating for each talk within the event, the total count of feedbacks received per talk, and a complete list of comments for each talk.

For simplicity, you do not need to implement any user registration or login features for this challenge.

Fell free to update this README file with any additional information you think is necessary.

## Technologies

- Ruby 3.4.2
- Rails 8.0.2
- PostgreSQL
- RSpec for testing
- Docker and Docker Compose

## Requirements

To run this project you will need:

- Ruby 3.4.2
- PostgreSQL
- Docker (optional, but recommended)
- Git

## Environment Setup

### Using DevContainer (Recommended)

The easiest way to set up the development environment is by using DevContainer, which comes with all the necessary dependencies pre-configured.

1. Install [Docker](https://www.docker.com/get-started)
2. Install [Visual Studio Code](https://code.visualstudio.com/)
3. Install the [Dev Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) extension in VS Code
4. Clone the repository:
   ```bash
   git clone https://github.com/your-username/events_manager.git
   cd events_manager
   ```
5. Open VS Code in this folder:
   ```bash
   code .
   ```
6. When prompted to "Reopen in Container", click on "Reopen in Container", or use the `Remote-Containers: Reopen in Container` command in VS Code's command palette (F1)
7. VS Code will build and start the Docker container with all necessary dependencies
8. The DevContainer includes Docker CLI and GitHub CLI pre-installed and available on the PATH
9. Once inside the container, run:
   ```bash
   bin/setup
   ```

### Manual Installation

If you prefer to set up manually:

1. Install Ruby 3.4.2 (recommended to use [rbenv](https://github.com/rbenv/rbenv) or [rvm](https://rvm.io/))
2. Install PostgreSQL
3. Clone the repository:
   ```bash
   git clone https://github.com/your-username/events_manager.git
   cd events_manager
   ```
4. Install dependencies:
   ```bash
   bundle install
   ```
5. Set up the database:
   ```bash
   bin/rails db:create db:migrate db:seed
   ```
6. Run the tests to verify everything is working:
   ```bash
   bundle exec rspec
   ```
7. Start the development server:
   ```bash
   bin/rails s
   ```

## Running Tests

```bash
bundle exec rspec
```
