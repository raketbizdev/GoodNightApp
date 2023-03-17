# README

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
 https://example.com/api/v1/users/2/follow
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

#### Data Storage Layer:

This layer will store the data required by the application, including user profiles, sleep records, and following relationships. The data storage layer will be implemented using a relational database, such as PostgreSQL, and will use Ruby on Rails' built-in ActiveRecord library for database interactions.
