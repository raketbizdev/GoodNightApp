# README

## Table of Contents

- [Original Instructions](#original-instructions)
- [Business Requirements](#busines-requirements-based-on-the-current-instruction)
  - [Project Description](#project-description)
  - [Technical Requirements](#technical-requirements)
- [Software Design Document (SDD)](#software-design-document)
  - [Introduction](#introduction)
  - [Application Logic](#application-logic)
    - [User Stories](#user-stories)
  - [API](#api)
    - [API Endpoints](#api-endpoints)
    - [Sample API endpoints](#sample-api-endpoints)
  - [Database Design](#database-design)
    - [Database Tables](#database-tables)
    - [Database Diagram](#database-diagram)
  - [Testing](#testing)
  - [Deployments](#deployments)
    - [Prerequisite requirements](#prerequisite-requirements)
    - [Local](#local)

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

## Software Design Document

### Introduction

The "Good Night App" is an application designed to help users track their sleep patterns. It is built using the Ruby on Rails framework and utilizes RESTful APIs for various operations. The main focus of the app is to provide users with a tool that allows them to clock in and out of their sleep cycles, follow and unfollow other users, and view the sleep records of their friends over the past week.

The application has two primary models, User and SleepRecord, and uses database migrations to create the required tables in the database. It offers a secure and user-friendly interface so that users can easily navigate its features and functionalities.

One of the main features of the app is the clock-in operation, which enables users to start and end their sleep cycles. Once a user clocks out, the app calculates the length of the sleep cycle and stores it in the database. It then displays all clocked-in times, ordered by created time, for users to observe their sleep patterns over time.

Another feature of the app is the follow and unfollow function. This allows users to connect with others and view their sleep records, by storing the relationship between the two users.

The sleep records feature lets users view their friends' sleep records from the past week. The app returns a list of sleep records containing the start time, end time, and length of sleep, as well as the name of the user who slept during that period. It ensures the privacy and security of users' data by only displaying sleep records for users who the requester is following.

### Application Logic

In this Section, we provide an overview of the core functionality and flow of the application, detailing how the system should behave from a user's perspective. This section helps developers, testers, and stakeholders understand the purpose and functionality of the application, ensuring alignment with project goals and requirements.

#### User Stories

| Path                                | As a... | I want to...                  | So that I can...               | Acceptance Criteria                                                      |
| ----------------------------------- | ------- | ----------------------------- | ------------------------------ | ------------------------------------------------------------------------ |
| Visitor                             | Visitor | Access the home page          | Explore the app                | - Home index is displayed (not part of API)                              |
| `POST /api/v1/users/signup`         | User    | Sign up (register)            | Create a new account           | - Email, password, and password confirmation are provided                |
|                                     |         |                               |                                | - Successful registration with a unique email                            |
| `POST /api/v1/users/sign_in`        | User    | Sign in (login)               | Access my account              | - Correct email and password are provided                                |
|                                     |         |                               |                                | - Successful authentication with a valid token                           |
| `DELELTE /api/v1/users/sign_out`    | User    | Sign out (logout)             | Log out of my account          | - Current user's token is revoked                                        |
|                                     |         |                               |                                | - Successful logout and user is redirected                               |
| `GET /api/v1/users/:id`             | User    | Retrieve a user's information | View a specific user's profile | - Valid user ID is provided                                              |
|                                     |         |                               |                                | - Valid user ID of the user being followed                               |
|                                     |         |                               |                                | - Successful retrieval of user information including profile details     |
|                                     |         |                               |                                | - User is currently login                                                |
|                                     |         |                               |                                | - User being folowed, also followed back user                            |
|                                     |         |                               |                                | - Successful seeing records of sleeps of the user being followed         |
| `PUT /api/v1/users/:id`             | User    | Update my information         | Keep my profile up to date     | - Valid user ID and updated information are provided                     |
|                                     |         |                               |                                | - Successful update of user information with changes reflected           |
| `POST /api/v1/users/:id/follow `    | User    | Follow another user           | Connect with other users       | - Valid user ID of the user to be followed is provided                   |
|                                     |         |                               |                                | - Successful following of another user without duplicates                |
| `DELETE /api/v1/users/:id/unfollow` | User    | Unfollow another user         | Disconnect from other users    | - Valid user ID of the user to be unfollowed is provided                 |
|                                     |         |                               |                                | - Successful unfollowing of another user and removal from following list |
| `POST /api/v1/users/:id/clock_in`   | User    | Clock-in sleep                | Record my sleep start time     | - Valid user ID is provided                                              |
|                                     |         |                               |                                | - Clock-in only allowed if the user has no ongoing sleep record          |
|                                     |         |                               |                                | - Successful clock-in with sleep record created                          |
| `POST /api/v1/users/:id/clock_out`  | User    | Clock-out sleep               | Record my sleep end time       | - Valid user ID is provided                                              |
|                                     |         |                               |                                | - Clock-out only allowed if the user has an ongoing sleep record         |
|                                     |         |                               |                                | - Successful clock-out with sleep record updated                         |

Based on the database schema, the application consists of five main tables: connections, jwt_denylist, profiles, sleeps, and users. The user stories are designed around these tables and their relationships:

1. **User Authentication:** Users can register, log in, and authenticate themselves to access the app's features. The users table stores user credentials, while the jwt_denylist table is used for managing JSON Web Tokens (JWT) for secure authentication.

2. **User Profiles:** Registered users can create and update their profiles, which are stored in the profiles table. Profiles are linked to users through a foreign key relationship.

3. **Sleep Records: Users** can clock-in and clock-out to record their sleep cycles. The sleeps table stores these records, which include start time, end time, and duration, and are linked to users through a foreign key relationship.

4. **Follow and Unfollow:** Users can follow and unfollow friends, enabling them to view their friends' sleep records. The connections table stores the relationship between follower and following users, with unique index constraints to prevent duplicate connections.

5. **View Sleep Records:** Users can view their sleep records and the sleep records of their followed friends. The application retrieves sleep records from the sleeps table and filters them based on the connections table.

#### API:

In this Section, we provide an overview of the RESTful API endpoints that correspond to the functionality outlined in the User Stories. These endpoints are based on the given routes defined in the Ruby on Rails application.

##### API Endpoints

| HTTP Method | Endpoint                    | Anchor Tag                      | Description                            |
| ----------- | --------------------------- | ------------------------------- | -------------------------------------- |
| GET         | /                           |                                 | Home index (not part of API)           |
| POST        | /api/v1/users/signup        | [signup](#signup)               | Sign up (register) a new user          |
| POST        | /api/v1/users/sign_in       | [sign-in](#sign-in)             | Sign in (login) an existing user       |
| DELETE      | /api/v1/users/sign_out      | [sign-out](#sign-out)           | Sign out (logout) the current user     |
| GET         | /api/v1/users/:id           | [get-user](#get-user)           | Retrieve a specific user's information |
| PUT         | /api/v1/users/:id           | [update-user](#update-user)     | Update a specific user's information   |
| POST        | /api/v1/users/:id/follow    | [follow-user](#follow-user)     | Follow another user                    |
| DELETE      | /api/v1/users/:id/unfollow  | [unfollow-user](#unfollow-user) | Unfollow another user                  |
| POST        | /api/v1/users/:id/clock_in  | [clock-in](#clock-in)           | Clock-in sleep for the user            |
| POST        | /api/v1/users/:id/clock_out | [clock-out](#clock-out)         | Clock-out sleep for the user           |

These API endpoints allow the GoodNight App to interact with the server and perform the required operations. The anchor tags provide a convenient way to navigate the documentation and quickly access specific sections related to each endpoint. The endpoint paths are still displayed to ensure clarity. The endpoints are designed to provide a consistent and user-friendly interface to access and manage the data stored in the database. The HTTP methods follow the RESTful convention, ensuring a clear separation of responsibilities for each action.

##### Sample API endpoints

Here are the sample code snippets for each endpoint using cards instead of a table format. Please note that you need to replace the placeholders with your actual values, such as `<API_URL>`, `<AUTH_TOKEN>`, `<USER_ID>`, `<FOLLOW_USER_ID>`.

###### Postman API endpoints

[![Run in Postman](https://run.pstmn.io/button.svg)](https://app.getpostman.com/run-collection/23592113-29316bb0-524f-4a34-89e4-a192bb86c7a4?action=collection%2Ffork&collection-url=entityId%3D23592113-29316bb0-524f-4a34-89e4-a192bb86c7a4%26entityType%3Dcollection%26workspaceId%3D68366fbd-068a-4d58-bda2-aa1377bb68a7)

###### Signup

```bash
# POST /api/v1/users/signup
curl -X POST "<API_URL>/api/v1/users/signup" \
  -H "Content-Type: application/json" \
  -d '{
    "user": {
      "email": "<EMAIL>",
      "password": "<PASSWORD>",
      "password_confirmation": "<PASSWORD_CONFIRMATION>"
    }
  }'

# Success Response:
# HTTP Status: 201 Created
{
  "success": true,
  "message": "User with email 'test@example.com' successfully registered"
}

# Error Response:
# HTTP Status: 422 Unprocessable Entity
{
  "success": false,
  "errors": [...]
}
```

###### Sign in

```bash
# POST /api/v1/users/sign_in
curl -X POST "<API_URL>/api/v1/users/sign_in" \
  -H "Content-Type: application/json" \
  -d '{
    "user": {
      "email": "<EMAIL>",
      "password": "<PASSWORD>"
    }
  }'

# Success Response:
# HTTP Status: 200 OK
{
  "message": "Logged in successfully.",
  "user": {...},
  "token": "<JWT_TOKEN>"
}

# Error Response:
# HTTP Status: 401 Unauthorized
{
  "error": "Invalid email or password."
}
```

###### Sign out

```bash
# DELETE /api/v1/users/sign_out
curl -X DELETE "<API_URL>/api/v1/users/sign_out" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <AUTH_TOKEN>"

# Success Response:
# HTTP Status: 200 OK
{
  "message": "Logged out successfully."
}

# Error Response:
# HTTP Status: 401 Unauthorized
{
  "error": "Unauthorized."
}
```

###### GET User

```bash
# GET /api/v1/users/:id
curl -X GET "<API_URL>/api/v1/users/<USER_ID>" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <AUTH_TOKEN>"

# Success Response:
# HTTP Status: 200 OK
{
  "email": "user@example.com",
  "full_name": "John Doe",
  "followers_count": 10,
  "following_count": 5,
  "followers": [...],
  "followings": [...]
}

# Error Response:
# HTTP Status: 404 Not Found
{
  "success": false,
  "error": "User not found."
}

```

###### Update User

```bash
# PUT /api/v1/users/:id
curl -X PUT "<API_URL>/api/v1/users/<USER_ID>" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <AUTH_TOKEN>" \
  -d '{"profile": {"first_name": "John", "last_name": "Doe"}}'

# Success Response:
# HTTP Status: 200 OK
{
  "profile": {...},
  "success": true,
  "message": "Profile updated successfully",
  "followers_count": 10,
  "following_count": 5
}

# Error Response:
# HTTP Status: 401 Unauthorized
{
  "success": false,
  "error": "You are not authorized to update this profile."
}

```

###### Follow User

```bash
# POST /api/v1/users/:id/follow
curl -X POST "<API_URL>/api/v1/users/<FOLLOW_USER_ID>/follow" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <AUTH_TOKEN>"

# Success Response:
# HTTP Status: 200 OK
{
  "success": true,
  "message": "You are now following user@example.com."
}

# Error Response:
# HTTP Status: 404 Not Found
{
  "success": false,
  "error": "User not found."
}

```

###### Unfollow User

```bash
# DELETE /api/v1/users/:id/unfollow
curl -X DELETE "<API_URL>/api/v1/users/<FOLLOW_USER_ID>/unfollow" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <AUTH_TOKEN>"

# Success Response:
# HTTP Status: 200 OK
{
  "success": true,
  "message": "You have unfollowed user@example.com."
}

# Error Response:
# HTTP Status: 404 Not Found
{
  "success": false,
  "error": "User not found."
}
```

###### Clock in

```bash
# POST /api/v1/users/:id/clock_in
curl -X POST "<API_URL>/api/v1/users/<USER_ID>/clock_in" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <AUTH_TOKEN>"
# Success Response:
# HTTP Status: 201 Created
{
  "success": true,
  "message": "Clock in successful.",
  "sleep": {...}
}

# Error Response:
# HTTP Status: 401 Unauthorized
{
  "success": false,
  "message": "You are not authorized to perform this action."
}
```

###### Clock out

```bash
# POST /api/v1/users/:id/clock_out
curl -X POST "<API_URL>/api/v1/users/<USER_ID>/clock_out" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <AUTH_TOKEN>"

# Success Response:
# HTTP Status: 200 OK
{
  "success": true,
  "message": "Clock out successful.",
  "sleep": {...}
}

# Error Response:
# HTTP Status: 401 Unauthorized
{
  "success": false,
  "message": "You are not authorized to perform this action."
}
```

Please note that you need to replace the placeholders with your actual values, such as `<API_URL>`, `<AUTH_TOKEN>`, `<USER_ID>`.

### Database Design

In this Section, we provide an overview of the database tables, their attributes, and relationships based on the given schema. The schema is designed to support the features and functionalities outlined in the User Stories and API Sections.

#### Database Tables

| Table Name | Attribute              | Type     | Constraints      | Relationships |
| ---------- | ---------------------- | -------- | ---------------- | ------------- |
| users      | id                     | bigint   |                  |               |
|            | email                  | string   | unique, not null |               |
|            | encrypted_password     | string   | not null         |               |
|            | reset_password_token   | string   | unique           |               |
|            | reset_password_sent_at | datetime |                  |               |
|            | remember_created_at    | datetime |                  |               |
|            | created_at             | datetime | not null         |               |
|            | updated_at             | datetime | not null         |               |
|            | jti                    | string   |                  |               |
|            | token                  | string   |                  |               |

| Table Name | Attribute  | Type     | Constraints | Relationships                 |
| ---------- | ---------- | -------- | ----------- | ----------------------------- |
| profiles   | id         | bigint   |             |                               |
|            | first_name | string   |             |                               |
|            | last_name  | string   |             |                               |
|            | user_id    | bigint   | not null    | Foreign key: user_id -> users |
|            | created_at | datetime | not null    |                               |
|            | updated_at | datetime | not null    |                               |

| Table Name | Attribute  | Type     | Constraints | Relationships                 |
| ---------- | ---------- | -------- | ----------- | ----------------------------- |
| sleeps     | id         | bigint   |             |                               |
|            | user_id    | bigint   | not null    | Foreign key: user_id -> users |
|            | start_time | datetime |             |                               |
|            | end_time   | datetime |             |                               |
|            | duration   | float    |             |                               |
|            | created_at | datetime | not null    |                               |
|            | updated_at | datetime | not null    |                               |

| Table Name  | Attribute    | Type     | Constraints | Relationships |
| ----------- | ------------ | -------- | ----------- | ------------- |
| connections | id           | bigint   |             |               |
|             | follower_id  | integer  |             |               |
|             | following_id | integer  |             |               |
|             | created_at   | datetime | not null    |               |
|             | updated_at   | datetime | not null    |               |

| Table Name   | Attribute | Type     | Constraints | Relationships |
| ------------ | --------- | -------- | ----------- | ------------- |
| jwt_denylist | id        | bigint   |             |               |
|              | jti       | string   | not null    |               |
|              | exp       | datetime | not null    |               |

#### Database Diagram

![Good Night App Database Schema](goodnight_db.png "Good Night App Database Schema")

These database tables store the necessary data to support the features and functionalities of the GoodNight App. The relationships between the tables ensure data integrity and consistency, while the unique constraints and foreign key relationships promote a well-structured and efficient database design.

### Testing

In this section, I outline User and Unit testing scenarios using RSpec, a popular testing framework for Ruby applications. RSpec helps ensure that the application's features and functionalities operate as intended.

#### GET /api/v1/users

```bash
- Test Scenario: Verify that the `/api/v1/users` endpoint returns a list of all users and their associated statistics.
  - Context: When the user is signed in
  - Check that the response has a 200 (OK) status code.
  - Check that the response body contains the correct keys and values.
  - Check that the user statistics are present and correctly formatted.
```

#### GET /api/v1/users/:id

```bash
- Test Scenario: Verify the functionality of the `/api/v1/users/:id` endpoint, which retrieves information for a specific user.
  - Context: When the user is authenticated
  - Check that the response has a 200 (OK) status code.
  - Check that the user's email is present and correct.
  - Check that the user's full name is present and correct.
  - Check that the number of followers for the user is correct.
  - Check that the number of followings for the user is correct.
  - Check that the list of followers for the user is present and correctly formatted.
  - Check that the list of followings for the user is present and correctly formatted.
  - Check that the list of sleep records for the user is present and correctly formatted.
  - Check that the total sleep duration for the user is correct.
- Check that the sleep count for the user is correct.
- Context: When the user is not authenticated
  - Check that the response has a 401 (Unauthorized) status code.
```

#### PUT /api/v1/users/:id

```bash
- Test Scenario: Verify the functionality of the `/api/v1/users/:id` endpoint, which updates a user's profile.
  - Context: When the user is authenticated
    - Context: When updating their own profile
      - Check that the response has a 200 (OK) status code.
      - Check that the response body contains the correct keys and values.
      - Check that the profile is updated and the updated profile is returned.
      - Check that an error is returned when the update fails.
    - Context: When updating another user's profile
      - Check that the response has a 401 (Unauthorized) status code.
      - Check that an error message is returned indicating that the user is not authorized to update the profile.
  - Context: When the user is not authenticated
    - Check that the response has a 401 (Unauthorized) status code.
```

#### POST /api/v1/users/:id/follow

```bash
- Test Scenario: Verify the functionality of the `/api/v1/users/:id/follow` endpoint, which allows a user to follow another user.
  - Context: When the user is signed in and authenticated
    - Check that the response has a 200 (OK) status code.
    - Check that the response body contains the correct keys and values.
    - Check that the user is successfully followed.
    - Check that an error message is returned when trying to follow a non-existent user.
    - Check that an error message is returned when trying to follow oneself.
    - Check that an error message is returned when trying to follow a user that is already being followed.
  - Context: When the user is not signed in or authenticated
    - Check that the response has a 401 (Unauthorized) status code.
```

#### DELETE /api/v1/users/:id/unfollow

```bash
- Test Scenario: Verify the functionality of the `/api/v1/users/:id/unfollow` endpoint, which allows a user to unfollow another user.
  - Context: When the user is signed in and authenticated
    - Unfollows the user successfully.
      - Check that the response has a 200 (OK) status code.
      - Check that the response body contains the correct keys and values.
      - Check that the message indicates that the user has been unfollowed.
      - Check that the user is no longer following the unfollowed user.
    - Returns an error when trying to unfollow a non-existent user.
      - Check that the response has a 404 (Not Found) status code.
      - Check that the response body contains the correct keys and values.
      - Check that the error message indicates that the user was not found.
    - Returns an error when trying to unfollow oneself.
      - Check that the response has a 422 (Unprocessable Entity) status code.
      - Check that the response body contains the correct keys and values.
      - Check that the error message indicates that the user cannot unfollow themselves.
    - Returns an error when trying to unfollow a user that is not being followed.
      - Check that the response has a 422 (Unprocessable Entity) status code.
      - Check that the response body contains the correct keys and values.
      - Check that the error message indicates that the user is not following the unfollowed user.
  - Context: When the user is not signed in or authenticated
    - Check that the response has a 401 (Unauthorized) status code.
```

#### POST /api/v1/users/:id/clock_in

```bash
- Test Scenario: Verify the functionality of the `/api/v1/users/:id/clock_in` endpoint, which allows a user to clock in.
  - Context: When the user is signed in and authenticated
    - Clocks the user in successfully.
      - Check that the response has a 201 (Created) status code.
      - Check that the response body contains the correct keys and values.
      - Check that the message indicates that the clock in was successful.
      - Check that the start time of the sleep record is not null.
      - Check that the number of sleep records for the user is 1.
    - Returns an error when the user is not authorized to clock in.
      - Check that the response has a 401 (Unauthorized) status code.
      - Check that the response body contains the correct keys and values.
      - Check that the error message indicates that the user is not authorized to perform this action.
      - Check that the number of sleep records for the user is 0.
    - Returns an error when the user is already clocked in.
      - Check that the response has a 422 (Unprocessable Entity) status code.
      - Check that the response body contains the correct keys and values.
      - Check that the error message indicates that the user must clock out before clocking in again.
      - Check that the number of sleep records for the user is 1.
  - Context: When the user is not signed in or authenticated
    - Check that the response has a 401 (Unauthorized) status code.
```

#### POST /api/v1/users/:id/clock_out

```bash
- Test Scenario: Verify the functionality of the `/api/v1/users/:id/clock_out` endpoint, which allows a user to clock out their sleep.
  - Context: When the user is signed in and authenticated
  - When the user has a sleep record that is not already clocked out.
    - Check that the response has a 200 (OK) status code.
    - Check that the response body contains the correct keys and values.
    - Check that the message indicates that the clock out was successful.
    - Check that the sleep record has an end time and is associated with the user.
  - When the user has no sleep records or all sleep records are already clocked out.
    - Check that the response has a 422 (Unprocessable Entity) status code.
    - Check that the response body contains the correct keys and values.
    - Check that the error message indicates that the user must clock in before clocking out.
  - Context: When the user is not signed in
    - Check that the response has a 401 (Unauthorized) status code.
  - Context: When the user is signed in but calling a non-existent user
    - Check that the response has a 404 (Not Found) status code.
    - Check that the response body contains the correct keys and values.
    - Check that the error message indicates that the user was not found.
  - Context: When the user is signed in but not authorized
    - Check that the response has a 401 (Unauthorized) status code.
    - Check that the response body contains the correct keys and values.
    - Check that the error message indicates that the user is not authorized to perform the action.
```

### Deployments

This section provides a brief overview of deploying the application to a local environment.

#### Prerequisite requirements

- Ruby version 3.1.2
- Rails version 7.0.4 or higher
- PostgreSQL as the database for Active Record
- Puma web server version 5.0 or higher
- Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
- Devise gem version 4.9 or higher for user authentication
- Devise-JWT gem version 0.10.0 or higher for JWT token authentication
- JSON API for building APIs in Rails
- Rack-Attack for rate limiting and throttling
- Faker for generating fake data for testing
- RSpec gem version 6.0.1 or higher for testing
- JSONAPI-RSpec for testing JSON API responses
- Factory Bot gem for generating test data

Additionally, the debug gem is included for development and testing, as well as the bootsnap gem to reduce boot times through caching. The tzinfo-data gem is also required for Windows machines to include timezone information.

#### Local

To run the Ruby on Rails app from the GitHub repository `git@github.com:raketbizdev/GoodNightApp.git`, follow these steps:

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
