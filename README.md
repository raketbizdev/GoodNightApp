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

1. Clock In operation: Users should be able to clock in and out of their sleep cycles. When they clock out, the application should calculate the length of the sleep cycle and store it in the database. The application should also return all clocked-in times, ordered by created time.
2. Follow and unfollow other users: Users should be able to follow and unfollow other users. The application should store the following relationship between the two users.
3. Sleep records over the past week: Users should be able to view the sleep records of their friends over the past week, ordered by the length of their sleep. The application should return a list of sleep records that contain the start time, end time, and length of sleep, as well as the name of the user who slept during that period. The application should only return sleep records for users who the requester is following.

### Technical Requirements:

The following are the technical requirements for the application:

1. Model: The application should have two models: User and SleepRecord. The user should have two fields: id and name. SleepRecord should have five fields: id, user_id, start_time, end_time, and length_of_sleep.
2. Database Migrations: The application should use database migrations to create the User and SleepRecord tables in the database.
3. JSON API: The application should provide a RESTful JSON API that allows users to perform the required operations.
4. Security: The application should be secure and only allow authenticated users to access the API. Users should only be able to access their own data or the data of users they are following.

### Conclusion:

In summary, we want to build a "good night" application that allows users to track their sleep patterns. The application will use the Ruby on Rails framework and provide RESTful APIs for the required operations. The application will have two models, User and SleepRecord, and use database migrations to create the required tables in the database. The application will also provide a JSON API and be secure, allowing only authenticated users to access the API and restricting access to data based on the following relationships.
