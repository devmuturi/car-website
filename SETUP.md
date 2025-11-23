# Lazcar Setup Guide

## Installation

1. Install dependencies:
```bash
bundle install
yarn install
```

2. Set up the database:
```bash
rails db:create
rails db:migrate
```

3. Create an admin user:
```bash
rails console
```

Then in the console:
```ruby
user = User.create!(
  email: "admin@example.com",
  password: "password123",
  password_confirmation: "password123"
)
user.add_role(:admin)
```

4. Set WhatsApp phone number (optional):
Add to your `.env` file or environment:
```
WHATSAPP_PHONE=1234567890
```

## Usage

### Admin Panel

1. Log in at `/admin` (or navigate to `/admin` after logging in)
2. Create Makes and Models first
3. Then create Cars with images
4. Set `published_at` to publish cars to the public site

### Public Site

- Browse cars at `/cars`
- Filter by make, model, year, condition, price range
- View car details
- Compare cars
- Enquire via WhatsApp

## Features

- ✅ Admin-only car management
- ✅ Car images (multiple per car)
- ✅ Status management (In Stock/Sold)
- ✅ Condition (New/Used)
- ✅ Advanced filtering
- ✅ Car comparison
- ✅ WhatsApp integration
- ✅ Responsive design with animations

