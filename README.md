# E-Commerce Backend Setup Guide

### Overview
This is a Ruby on Rails 7 API-only application E-Commerce Backend Setup Guide.

### System Requirements
- Linux/macOS
- Git
- Postgresql
- Node.js & Yarn (for ActiveAdmin assets)

### Installing RVM (Ruby Version Manager)

First, install GPG keys:
```
gpg --keyserver keyserver.ubuntu.com --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
```

Install RVM:
```
\curl -sSL https://get.rvm.io | bash -s stable
```

Load RVM:
```
source ~/.rvm/scripts/rvm
```

### Installing Ruby

Install and use Ruby 3.2.2:
```
rvm install 3.2.2
rvm use 3.2.2 --default
```

Verify installation:
```
ruby -v
```

### Installing Rails

Install Rails 7:
```
gem install rails -v 7.0.8
```

Verify installation:
```
rails -v
```

### Project Setup

Clone the repository:
```
git clone <your-repository-url>
cd <your-project-name>
```

Install dependencies:
```
bundle install
```

### Database Setup

Create and setup the database:
```
rails db:create
rails db:migrate
rails db:seed
```

### ActiveAdmin Setup

ActiveAdmin is already integrated into this API-only application. The setup includes:

- Custom middleware to handle ActiveAdmin's browser sessions
- Asset pipeline configuration for ActiveAdmin styles and JavaScript
- Custom CORS configuration to allow ActiveAdmin access

Access ActiveAdmin at:
```
http://localhost:3000/admin
```

Default admin credentials:
```
Email: admin@example.com
Password: password
```

### Running the Application

Start the Rails server:
```
rails s
```

The API will be available at `http://localhost:3000`

### API Documentation

API endpoints are available at:
```
http://localhost:3000/api/v1/
```

### Testing

Run the test suite:
```
bundle exec rspec
```

### Environment Variables

Create a `.env` file in the root directory and add the following variables:

```
DATABASE_USERNAME=your_username
DATABASE_PASSWORD=your_password
RAILS_MAX_THREADS=5
RAILS_MIN_THREADS=5
```

### CORS Configuration

CORS configuration can be found in `config/initializers/cors.rb`

### Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details

### Acknowledgments

- Rails API Documentation
- ActiveAdmin Documentation
- Other resources used in the project
