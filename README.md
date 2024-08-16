# Instagram Clone

This project is an Instagram clone developed using Flutter, Firebase, and BLoC for state management. It includes functionalities for user authentication, including sign-up and login using either email or username.

## Features

- **User Signup**
  - Users can sign up using their email, username, and password.
  - Username availability is checked during sign-up to avoid duplication.
  
- **User Login**
  - Users can log in using either their email or username along with their password.
  
- **UI Components**
  - `SignupPage`: A page for user registration with form validation and error handling.
  - `LoginPage`: A login page with support for email and username login, and dynamic form validation.

## Technologies Used

- **Flutter**: Framework for building the cross-platform mobile application.
- **Firebase Authentication**: Handles user authentication and account management.
- **Firebase Firestore**: Stores user data such as usernames, email addresses, and profile information.
- **BLoC**: Manages state and business logic.

## Installation

1. **Clone the Repository**

   ```sh
   git clone https://github.com/your-repository/instagram-clone.git
   cd instagram-clone
