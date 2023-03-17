# README

### Table of Contents

- [Original Instructions](#original-instructions)
- [Business Requirements for the Good Night App](#business-requirements-for-the-good-night-app)
- [Technical Requirements for the Good Night App](#technical-requirements-for-the-good-night-app)
- [Software Design Document (SDD)](#software-design-document-sdd)
  - [Introduction](#introduction)
  - [Getting Started](#getting-started)
  - [System Architecture](#system-architecture)
- [API Layer](#api-layer)
  - [Application Logic Layer](#application-logic-layer)
  - [RSPEC Testing Methods](#rspec-testing-methods)
- [Data Storage Layer](#data-storage-layer)
- [Database Diagram](#database-diagram)

## Original Instructions

We would like you to implement a “good night” application to let users track when they go to bed and when they wake up. Please use "Ruby on Rails" for this project:

We require some restful APIS to achieve the following:

1. Clock In operation, and return all clocked-in times, ordered by created time.
2. Users can follow and unfollow other users.
3. See the sleep records over the past week for their friends, ordered by the length of their sleep.

Please implement the model, db migrations, and JSON API.
You can assume that there are only two fields on the users “id” and “name”.

You do not need to implement any user registration API.

You can use any gems you like.

## Busines Requirements based on the current instruction.

### title: **Good Aight App**

### Project Description:

We want to build a "good night" application that allows users to track their sleep patterns. The application will be built using the Ruby on Rails framework. We require RESTful APIs that can perform the following operations:

1. **Clock In operation:** Users should be able to clock in and out of their sleep cycles. When they clock out, the application should calculate the length of the sleep cycle and store it in the database. The application should also return all clocked-in times, ordered by created time.
2. **Follow and unfollow other users:** Users should be able to follow and unfollow other users. The application should store the following relationship between the two users.
3. **Sleep records over the past week:** Users should be able to view the sleep records of their friends over the past week, ordered by the length of their sleep. The application should return a list of sleep records that contain the start time, end time, and length of sleep, as well as the name of the user who slept during that period. The application should only return sleep records for users who the requester is following.

### Technical Requirements:

The following are the technical requirements for the application:

1. **Model:** The application should have two models: User and SleepRecord. The user should have two fields: id and name. SleepRecord should have five fields: id, user_id, start_time, end_time, and length_of_sleep.
2. **Database Migrations:** The application should use database migrations to create the User and SleepRecord tables in the database.
3. **JSON API:** The application should provide a RESTful JSON API that allows users to perform the required operations.
4. **Security:** The application should be secure and only allow authenticated users to access the API. Users should only be able to access their own data or the data of users they are following.

### Conclusion:

In summary, we want to build a "good night" application that allows users to track their sleep patterns. The application will use the Ruby on Rails framework and provide RESTful APIs for the required operations. The application will have two models, User and SleepRecord, and use database migrations to create the required tables in the database. The application will also provide a JSON API and be secure, allowing only authenticated users to access the API and restricting access to data based on the following relationships.

## Software Design Document

### Introduction

This Software Design Document (SDD) provides a comprehensive overview of the design of the "Good Night App" application, which aims to help users track their sleep patterns. The application will be built using the Ruby on Rails framework and will provide RESTful APIs for the required operations. The application will have two main models, User and SleepRecord, and will use database migrations to create the required tables in the database.

The "Good Night App" application will allow users to track their sleep patterns and perform various operations. Users will be able to clock in and out of their sleep cycles, follow and unfollow other users, and view the sleep records of their friends over the past week. The application will provide a secure and user-friendly interface, allowing users to easily navigate the features and functionalities.

The clock in operation will allow users to start and end their sleep cycles. When users clock out, the application will calculate the length of the sleep cycle and store it in the database. The application will also return all clocked-in times, ordered by created time, allowing users to view their sleep patterns over time.

The follow and unfollow feature will allow users to connect with other users and view their sleep records. The application will store the following relationship between the two users, allowing users to follow and unfollow other users as desired.

The sleep records feature will allow users to view the sleep records of their friends over the past week. The application will return a list of sleep records that contain the start time, end time, and length of sleep, as well as the name of the user who slept during that period. The application will only return sleep records for users who the requester is following, ensuring the privacy and security of the users' data.

This SDD will describe the architecture, design, and implementation of the "Good Night App" application in detail, providing a comprehensive guide for developers, testers, and other stakeholders. By following the design outlined in this document, we aim to create a high-quality, robust, and reliable application that meets the needs of our users.

### Getting Started

To run the Ruby on Rails app from the GitHub repository git@github.com:raketbizdev/GoodNightApp.git, follow these steps:

**Note:** These instructions assume you have Git, Ruby, Rails, and a PostgreSQL database installed on your local machine.

1. Clone the repository:
   Open a terminal/command prompt and run the following command:

   ```bash
    git clone git@github.com:raketbizdev/GoodNightApp.git
   ```

   This command will create a new directory named GoodNightApp containing the repository files.

2. Change to the project directory:

   ```bash
    cd GoodNightApp
   ```

3. Install dependencies:
   Install the required gems using Bundler:

   ```bash
    bundle install
   ```

4. Configure the database:
   Open the `config/database.yml` file and modify the `username`, `password`, and other `database settings` to match your local PostgreSQL configuration.

5. Create and setup the database:
   Run the following command to create the database, load the schema, and seed the data:

   ```bash
    rails db:create db:migrate db:seed
   ```

6. Start the Rails server:
   Start the Rails server by running:

   ```bash
    rails server
   ```

7. Access the application:
   Open your web browser and navigate to `http://
   you should see something below.

   ```json
   {
     "status": "ok",
     "message": "Welcome to Good Night API!"
   }
   ```

8. Visit Postmant:
   To start playing with the endpoints

   [![Run in Postman](https://run.pstmn.io/button.svg)](https://app.getpostman.com/run-collection/23592113-29316bb0-524f-4a34-89e4-a192bb86c7a4?action=collection%2Ffork&collection-url=entityId%3D23592113-29316bb0-524f-4a34-89e4-a192bb86c7a4%26entityType%3Dcollection%26workspaceId%3D68366fbd-068a-4d58-bda2-aa1377bb68a7)

### System architecture

#### API Layer:

This layer will provide RESTful APIs for the clock in operation, follow and unfollow other users, and sleep records over the past week. The API layer will be implemented using the Ruby on Rails framework and will communicate with the database layer to fetch and store data.

| HTTP Method | Endpoint                             | Description                                 |
| ----------- | ------------------------------------ | ------------------------------------------- |
| GET         | `/api/v1/users`                      | Retrieve a list of all users                |
| GET         | `/api/v1/users/:id`                  | Retrieve a specific user by ID              |
| PATCH       | `/api/v1/users/:id`                  | Update a specific user by ID                |
| PUT         | `/api/v1/users/:id`                  | Update a specific user by ID                |
| POST        | `/api/v1/users/:user_id/connections` | Create a new connection for a specific user |
| POST        | `/api/v1/users/:id/follow`           | Follow a specific user by ID                |
| DELETE      | `/api/v1/users/:id/unfollow`         | Unfollow a specific user by ID              |
| POST        | `/api/v1/users/:id/clock_in`         | Clock in a specific user by ID              |
| POST        | `/api/v1/users/:id/clock_out`        | Clock out a specific user by ID             |
| POST        | `/api/v1/users/signup`               | Register a new user                         |
| POST        | `/api/v1/users/sign_in`              | Sign in a user                              |
| DELETE      | `/api/v1/users/sign_out`             | Sign out a user                             |

##### User List

| Endpoint        | HTTP Method | Request Body | Success Response              | Error Response            |
| --------------- | ----------- | ------------ | ----------------------------- | ------------------------- |
| `/api/v1/users` | `GET`       | None         | [Success JSON](#success-json) | [Error JSON](#error-json) |

##### Success JSON

```json
{
  "users": [
    {
      "id": 1,
      "name": "John Doe",
      "email": "john.doe@example.com",
      "created_at": "2023-01-01T00:00:00.000Z",
      "updated_at": "2023-01-01T00:00:00.000Z"
    },
    {
      "id": 2,
      "name": "Jane Doe",
      "email": "jane.doe@example.com",
      "created_at": "2023-01-02T00:00:00.000Z",
      "updated_at": "2023-01-02T00:00:00.000Z"
    }
  ],
  "user_count": 2,
  "followers_count": 1,
  "followings_count": 1
}
```

##### Error JSON

```json
{
  "error": "You need to sign in or sign up before continuing."
}
```

##### User Follow

| Endpoint                   | HTTP Method | Request Body | Success Response                     | Error Response                   |
| -------------------------- | ----------- | ------------ | ------------------------------------ | -------------------------------- |
| `/api/v1/users/:id/follow` | `POST`      | None         | [Success JSON](#success-json-follow) | [Error JSON](#error-json-follow) |

##### User Follow Request

```json
/api/v1/users/2/follow
```

##### Success JSON (follow)

```json
{
  "success": true,
  "message": "You are now following user@example.com."
}
```

##### Error JSON (follow)

```json
[
  {
    "success": false,
    "error": "User not found.",
    "status": "not_found"
  },
  {
    "success": false,
    "error": "You cannot follow yourself.",
    "status": "unprocessable_entity"
  },
  {
    "success": false,
    "error": "You are already following this user.",
    "status": "unprocessable_entity"
  }
]
```

#### Application Logic Layer:

This layer will contain the business logic of the application, including the calculation of sleep cycle length, sorting of sleep records, and determining which sleep records to return based on the following relationship between users. The application logic layer will be implemented using the Ruby on Rails framework.

| User Story                   | Scenario                                               | Given                                                          | When                                                | Then                                                                       |
| ---------------------------- | ------------------------------------------------------ | -------------------------------------------------------------- | --------------------------------------------------- | -------------------------------------------------------------------------- |
| Clock In for Sleep Tracking  | User clocks in for the first time                      | I am a registered user and not clocked in yet                  | I send a request to clock in                        | I start a new sleep session with the current time as the start time        |
| Clock In for Sleep Tracking  | User tries to clock in without clocking out            | I am a registered user and have an ongoing sleep session       | I send a request to clock in                        | I receive an error message that I must clock out before clocking in again  |
| Clock In for Sleep Tracking  | User tries to clock in for another user                | I am a registered user trying to clock in for a different user | I send a request to clock in with another user's ID | I receive an error message that I am not authorized to perform this action |
| Clock Out for Sleep Tracking | User clocks out after a sleep session                  | I am a registered user and have an ongoing sleep session       | I send a request to clock out                       | My ongoing sleep session is updated with the current time as the end time  |
| Clock Out for Sleep Tracking | User tries to clock out without clocking in            | I am a registered user and not clocked in yet                  | I send a request to clock out                       | I receive an error message that I must clock in before clocking out        |
| Follow a User                | User follows another user                              | I am a registered user and not following the target user       | I send a request to follow the target user          | I start following the target user and receive a success message            |
| Follow a User                | User tries to follow themselves                        | I am a registered user                                         | I send a request to follow myself                   | I receive an error message that I cannot follow myself                     |
| Follow a User                | User tries to follow a user they are already following | I am a registered user and already following the target user   | I send a request to follow the target user          | I receive an error message that I am already following this user           |
| Follow a User                | User tries to follow a non-existent user               | I am a registered user                                         | I send a request to follow a non-existent user      | I receive an error message that the user is not found                      |
| Unfollow a User              | User unfollows another user                            | I am a registered user and following the target user           | I send a request to unfollow the target user        | I stop following the target user and receive a success message             |
| Unfollow a User              | User tries to unfollow themselves                      | I am a registered user                                         | I send a request to unfollow myself                 | I receive an error message that I cannot unfollow myself                   |

#### RSPEC Testing Methods:

This layer contains the tescase list using the Rspec

| Context                   | Expectation                           | Response              | Result                                                    |
| ------------------------- | ------------------------------------- | --------------------- | --------------------------------------------------------- |
| User is authenticated     | List of all users and user statistics | GET /api/v1/users     | HTTP 200 OK, correct keys, structure, and content         |
| User is authenticated     | User's email                          | GET /api/v1/users/:id | HTTP 200 OK, user's email in JSON response                |
| User is authenticated     | User's full name                      | GET /api/v1/users/:id | HTTP 200 OK, user's full name in JSON response            |
| User is authenticated     | Number of followers for the user      | GET /api/v1/users/:id | HTTP 200 OK, user's followers count in JSON response      |
| User is authenticated     | Number of followings for the user     | GET /api/v1/users/:id | HTTP 200 OK, user's following count in JSON response      |
| User is authenticated     | List of followers for the user        | GET /api/v1/users/:id | HTTP 200 OK, user's followers list in JSON response       |
| User is authenticated     | List of followings for the user       | GET /api/v1/users/:id | HTTP 200 OK, user's followings list in JSON response      |
| User is authenticated     | List of sleep records for the user    | GET /api/v1/users/:id | HTTP 200 OK, user's sleep records list in JSON response   |
| User is authenticated     | Total sleep duration for the user     | GET /api/v1/users/:id | HTTP 200 OK, user's total sleep duration in JSON response |
| User is authenticated     | Sleep count for the user              | GET /api/v1/users/:id | HTTP 200 OK, user's sleep count in JSON response          |
| User is not authenticated | Access to user's details              | GET /api/v1/users/:id | HTTP 401 Unauthorized                                     |

**Note:** Not every actions in the controller have been tested

List of controllers that has been tested

- rspec ./spec/requests/home_spec.rb
- rspec ./spec/requests/api/v1/users/users_controller_spec.rb
- rspec ./spec/requests/api/v1/users/sessions_spec.rb

Lis of controllers that has not been tested

| HTTP Method | Endpoint                             | Description                                 |
| ----------- | ------------------------------------ | ------------------------------------------- |
| PATCH       | `/api/v1/users/:id`                  | Update a specific user by ID                |
| PUT         | `/api/v1/users/:id`                  | Update a specific user by ID                |
| POST        | `/api/v1/users/:user_id/connections` | Create a new connection for a specific user |
| POST        | `/api/v1/users/:id/follow`           | Follow a specific user by ID                |
| DELETE      | `/api/v1/users/:id/unfollow`         | Unfollow a specific user by ID              |
| POST        | `/api/v1/users/:id/clock_in`         | Clock in a specific user by ID              |
| POST        | `/api/v1/users/:id/clock_out`        | Clock out a specific user by ID             |
| POST        | `/api/v1/users/signup`               | Register a new user                         |
| DELETE      | `/api/v1/users/sign_out`             | Sign out a user                             |

#### Data Storage Layer:

This layer will store the data required by the application, including user profiles, sleep records, and following relationships. The data storage layer will be implemented using a relational database, such as PostgreSQL, and will use Ruby on Rails' built-in ActiveRecord library for database interactions.

**users** table: This table stores user-related information such as email, encrypted password, and reset password tokens. There are unique indexes on the email and reset_password_token columns.

**profiles** table: This table stores profile-related information such as first_name and last_name. There is a foreign key relationship between the profiles table and the users table through the user_id column, meaning each profile is associated with a user.

**sleeps** table: This table stores sleep-related information such as start_time, end_time, and duration. There is a foreign key relationship between the sleeps table and the users table through the user_id column, meaning each sleep record is associated with a user.

**connections** table: This table represents the relationship between users in a "follower-following" model. The table has two columns, follower_id and following_id, that are used to represent a directed relationship between two users. There are indexes on follower_id, following_id, and a composite index on (follower_id, following_id) to ensure uniqueness in the relationships.

**jwt_denylist** table: This table stores JSON Web Token (JWT) denylist entries, which are used to track and deny access to invalidated JWTs. The table contains a jti (JWT ID) column and an exp (expiration time) column. There is an index on the jti column.

##### Database Diagram

![Good Night App Database Schema](goodnight_db.png "Good Night App Database Schema")

To whoever reviews my code, I would like to express my appreciation for your time and effort in examining the "Good Night" application. Your feedback and suggestions are valuable to me, and I am committed to using them to improve the application and provide a better experience for our users. Thank you for your attention and support.
