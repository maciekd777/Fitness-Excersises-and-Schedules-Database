# Fitness Excersises Database

A simple database for storing data about fitness excersises, schedules, and users reviews. Schema of this database is written in `schema.sql` file, and `queries.sql` contains queries that would probably be the most frequently used on this database.

## Scope

This database includes entities that enable easy searching through list of excersises, creating your own workout schedules, following others schedules and saving your results. Included in this database's scope is:

* Users, including their names
* Muscle areas, including names of general muscles you can target with excersises (e.g. "legs", "chest")
* Muscles, that is more detailed list of muscles included in muscle areas (e.g. "calfs", "middle chest")
* Equipment, including names of rather small piece of equipment you can use in excersises, such as barbell or dumbbells
* Machines, including names of more advanced, bigger and more expensive piece of equipment using in excersises
* Excersises, including names and connections with machine and equipment that is used to perform the excersise, as well as primary muscle area that is targetted by the excersise
* Muscle connections, including detailed connections between excersises and muscle group participating
* Excersises reviews, including users detailed opinions about excersises, such as difficulty (did they have problems with performing the excersise properly), weight (did they use light or heavy weight), review and advices
* Schedules, including users schedules and basic informations about them, such as name, difficulty, intensity, time consume, is it private or not and what is goal of the schedule (e.g. to gain strength or hyperthrophy of the muscles)
* Schedules excersises, which represent connections between schedules and excersises included, as well as basic informations about performing the excersise: weight (wether you should use light or heavy weight), minimum and maximum amount of repitisions in one series, rest time before series and comment, if the creator of the schedule wants to inform about something
* Days, including names of the days in a week
* Schedules reviews, including comments of other users about schedules, including schedule review, timestamp and wether the user liked the schedule or not
* Schdeules responses, including responses to schedule reviews, including timestamp and the comment itself
* Favorites, representing connection between users and schedules that they liked and to wchich they wanted quicker acces
* Wall, including basic informations about history of excersises performed by users, such as which excersise was performed, at what time, what was the weight, number of reps done, user opinion about wether the weight was too high, too low or good enough and optional comment

Out of this scope are descriptions about the excersises and personal data about users (age, weight, etc.)

## Functional Requirements

This database will support:
* CRUD operations for users
* Adding reviews to excersises (at max one review for one excersise for each user)
* Creating schedules from available excersises
* Adding reviews to schedules (at max one review for one schedule for each user, except the user that created the schedule)
* Adding multiple comments to schedule reviews
* Adding schedules to favorites
* Tracking users history of performed excersises

## Representation

Entities are captured in SQLite tables with the following schema.

### Entities

The database includes the following entities:

#### Users

The `users` table includes:

* `id`, which specifies the unique ID of the user as an `INTEGER`. This column thus has the `PRIMARY KEY` constraint applied.
* `name`, which specifies the name of the user as an `TEXT`. This column has the following constraints:
    - `UNIQUE` to make sure every user has different name
    - `NOT NULL` to avoid `NULL` value being assigned
    - `CHECK` with `LENGTH("username") <= 20` option to make sure username won't be longer than 20 characters. There is no need to create longer username and thanks to this limit some space could be saved. Also, it makes sure that no one will take this database to its limit and, for example, have whole "Lorem ipsum..." as an username. If this database would be used to create some app or website, very long username could completely destroy displaying it on the screen, so applying limit of characters to it, as well as to other texts or values that would be inserting to database, is needed.

#### Muscle areas

The `muscle_areas` table includes:

* `id`, which specifies the unique ID for each muscle area as an `INTEGER`. This column thus has the `PRIMARY KEY` constraint applied.
* `name`, which specifies the name of the muscle area as an `TEXT`. To avoid `NULL` value being assigned and many elements sharing the same name, `NOT NULL` and `UNIQUE` constraints have been applied.

#### Muscles

The `muscles` table includes:

* `id`, which specifies the unique ID for each muscle as an `INTEGER`. This column thus has the `PRIMARY KEY` constraint applied.
* `name`, which specifies the name of the muscle as an `TEXT`. To avoid `NULL` value being assigned `NOT NULL` constraint has been applied (`UNIQUE` constraint wasn't applied, because some muscle areas share the same name for muscles, e.g. "long head" is both in biceps and tricpes)
* `muscle_area_id`, which connects muscle to muscle area from the `muscle_area` table. This column thus has the `FOREIGN KEY` constraint applied, referencing the `id` column in the `muscle_area` table

#### Equipment

The `equipment` table includes:

* `id`, which specifies the unique ID for each piece of equipment as an `INTEGER`. This column thus has the `PRIMARY KEY` constraint applied.
* `name`, which specifies the name of piece of equipment as an `TEXT`. To avoid `NULL` value being assigned and many pieces of equipment sharing the same name, `NOT NULL` and `UNIQUE` constraints have been applied.


#### Machines

The `machines` table includes:

* `id`, which specifies the unique ID for each machine as an `INTEGER`. This column thus has the `PRIMARY KEY` constraint applied.
* `name`, which specifies the name of a machine as an `TEXT`. To avoid NULL value being assigned `NOT NULL` constraint has been applied and to avoid many machines having the same name, `UNIQUE` constraint has been applied.

#### Excersises

The `excersises` table includes:

* `id`, which specifies the unique ID for each excersise as an `INTEGER`. This column thus has the `PRIMARY KEY` constraint applied.
* `name`, which specifies the name of the excersise as an `TEXT`. To avoid `NULL` value being assigned, `NOT NULL` constraint has been applied (`UNIQUE` constraint hasn't been applied, because some excersises could be done with different equipment and machines. Those excersises could be inserted repeatedly to the table with the same name, but with different equipment and/or machine connected to them)
* `primary_muscle_area_id`, which connects the excersise to the `muscle_area` that is participating the most in this excersise. This column thus has the `FOREIGN KEY` constraint applied, referencing the `id` column in the `muscle_area` table
* `equipment_id`, which connects the excersise to the equipment used in this excersise. This column thus has the `FOREIGN KEY` constraint applied, referencing the `id` column in the `equipment` table
* `machine_id`, which connects the excersise to the machine used in this excersise. This column thus has the `FOREIGN KEY` constraint applied, referencing the `id` column in the `machines` table

#### Muscle connections

The `muscle_connections` table includes:

* `id`, which specifies the unique ID for each connection as an `INTEGER`. This column thus has the `PRIMARY KEY` constraint applied.
* `excersise_id`, which refers to the excersise that we want to include in the connection. This column thus has the `FOREIGN KEY` constraint applied, referencing the `id` column in the `excersises` table
* `muscle_id`, which refers to the muscle that we want to connect with previously chosen excersise. This column thus has the `FOREIGN KEY` constraint applied, referencing the `id` column in the `muscles` table
* `mp_level`, wchich specify "muscle participation level" (how much the muscle is involved in the excersise), by giving it a number between 1 and 4:
    - 1: a muscle is barely involved in the excersise, acting more like a stabilizer, e.g. calfs when performing a squat
    - 2: a muscle plays a secondary role in the excersise, but the person can definitely "feel" it while performing. While it is not the primary target, if this muscle is not recovered, the person could have problems with performing the excersise properly, e.g. triceps when performing a bench press
    - 3: a muscle plays primary role in the excersise, however there are also muscles that helps performing it, e.g. chest when performing a bench press
    - 4: a muscle plays the only role in the excersise, making it so called "isolation excersise". For this type of excersises it is recommended being careful with using heavy weights (e.g. biceps when performing concentration curls)

#### Excersises reviews

The `excersises_reviews` table includes:

* `id`, which specifies the unique ID for each review as an `INTEGER`. This column thus has the `PRIMARY KEY` constraint applied.
* `user_id`, which specifies the user that has written the review by refering to its `id` column in the `users` table. This column thus has the `FOREIGN KEY` constraint applied, refering the `id` column in the `users` table. If any user would be deleted from `users` table, reviews written by this user should also be deleted, thus `ON DELETE CASCADE` has been applied to this column
* `excersise_id`, which specifies the excersise that previously chosen user has reviewed by refering to its `id` column in the `excersises` table. This column thus has the `FOREIGN KEY` constraint applied, refering the `id` column in the `excersises` table
* `score`, which specifies the score that the user has given to the excersise. The score needs to be an integer from 1 to 10 (the higher the number, the better the excersise), thus `INTEGER` and `CHECK("score" BETWEEN 1 AND 10)` constraints has been applied. Every review needs to have a score, thus also `NOT NULL` constraint has been used.
* `difficulty_level`, which represents the difficulty the user had with performing the excersise by giving a number from 1 to 3 (the higher the number, the more difficult was the excersise). Thus, constraint applied to this column are `INTEGER`, `NOT NULL` and `CHECK("difficulty_level" BETWEEN 1 AND 3)`
* `weight_level`, which represents weight the user performed the excersise with by giving a number from 0 to 3 (the higher the number, the heavier was the weight and 0 means that the excersise was performed with bodyweight. Let's note that the weight level was chosen instead of exact weight in kilograms, because the weight in kilograms doesn't say much about wether it was heavy or light weight. For some 40 kilograms in a chest press is not that much and some would be really struggling with it. However, 3 points in a weight level means that it was really hard to do even couple of repititions regardless of the weight used.). Thus, constraint applied to this column are `INTEGER`, `NOT NULL` and `CHECK("weight_level" BETWEEN 0 AND 3)`
* `review`, which contains reviews written by users as a `TEXT`. A review should have some text opinion and consist of 5-1000 characters, thus the constraints `NOT NULL` and `CHECK(LENGTH("review") BETWEEN 5 AND 1000)` has been applied.
* `advices`, which contains advices and tips about excersises that users can share with others. It is not necessery to include any advice in the review, thus `NOT NULL` constraint has not been applied. However, if user wants to include advice, it needs to be `TEXT` and consist of 5-500 characters, thus `CHECK(LENGTH("review") BETWEEN 5 AND 1000)` constrain has been applied.

#### Schedules

The `excersises_reviews` table includes:

* `id`, which specifies the unique ID for each schedule as an `INTEGER`. This column thus has the `PRIMARY KEY` constraint applied.
* `user_id`, which specifies the user that created the schedule by refering to its `id` column in the `users` table. This column thus has the `FOREIGN KEY` constraint applied, refering the `id` column in the `users` table. If any user would be deleted from `users` table, schedules created by this user should also be deleted, thus `ON DELETE CASCADE` has been applied
* `private`, which specifies wether the schedule is private or not, and because it can only have two values, it is stored as a `BOOLEAN` with `DEFAULT` value `TRUE`. It is necessary to specify a value in this column, thus `NOT NULL` constraint has been applied
* `goal`, which specifies the goal the schedule helps to achieve (wether it helps with fat burn `FB`, strength `S` or hyperthrophy `H`). Because the only values are `FB`, `S` and `H`, constraint `TEXT` and `CHECK("goal" IN ('FB', 'S', 'H'))` has been applied. It is necessary to specify a value in this column, thus `NOT NULL` constraint has also been applied
* `difficulty_level`, which represents the difficulty the creator of the schedule thinks it has by giving it a number from 1 to 3 (the higher the number, the more difficult overall the schedule). Thus, constraint applied to this column are `INTEGER`, `NOT NULL` and `CHECK("difficulty_level" BETWEEN 1 AND 3)`
* `instensity_level`, which represents the intensity the creator of the schedule thinks it has by giving it a number from 1 to 3 (the higher the number, the more intense overall the schedule, e.g. more dynamic excersises and less rest time between the series raise overall intensity of the schedule). Thus, constraint applied to this column are `INTEGER`, `NOT NULL` and `CHECK("intensity_level" BETWEEN 1 AND 3)`
* `time_consume_level`, which represents the time the creator of the schedule thinks it will consume by giving it a number from 1 to 3 (the higher the number, the more time consume overall the schedule, e.g. more excersises and more rest time between the series raise overall time consume of the schedule). Thus, constraint applied to this column are `INTEGER`, `NOT NULL` and `CHECK("time_consume_level" BETWEEN 1 AND 3)`

#### Schedules excersises

The `schedules_excersises` table includes:

* `id`, which specifies the unique ID for each schedule excersise as an `INTEGER`. This column thus has the `PRIMARY KEY` constraint applied.
* `schedule_id`, which specifies the schedule we want to include in the connection by refering to its `id` in the `schedules` column. This column thus has the `FOREIGN KEY` constraint applied, refering the `id` column in the `schedules` table. If any schedule would be deleted from `users` table, any connections between that schedule and excersises should also be deleted, thus `ON DELETE CASCADE` has been applied
* `day`, which specifies the day in which excersise should be performed. Because this column will be used to sort, it can accept only `INTEGER` values between 1 and 7, thus constraint `CHECK("day" BETWEEN 1 AND 7)` has been applied
* `excersise_id`, which specifies the excersise we want to include in the connection by refering to its `id` in the `excersises` column. This column thus has the `FOREIGN KEY` constraint applied, refering the `id` column in the `excersise` table. However, if any excersise would be deleted, the connections between it and schedules should not be deleted. User should know that something changed in his schedule, thus `ON DELETE SET NULL` has been applied.
* `weight_level`, which specifies the suggest weight level which should be used for performing the excersise. Constraint applied to this column are `INTEGER`, `NOT NULL` and `CHECK("weight_level" BETWEEN 0 AND 3)`, as in the `excersises_reviews` table
* `min_reps`, which specifies the minimum number of repititions in a single series while performing the excersise, as an `INTEGER`. Minimum number of repititions is a necessary information for every excersise in the schedule and should be greater than 0, but definitely should not be 3 digits long, thus `NOT NULL` and `CHECK("min_reps" BETWEEN 1 AND 99)` constraints has been applied.
* `max_reps`, the maximum number of repititions in a single series as an `INTEGER` while performing the excersise. Maximum number of repititions is a necessary information for every excersise in the schedule and should be greater than minimum number of repititions `min_reps`, but definitely should not be 3 digits long, thus `NOT NULL` and `CHECK("max_reps" > "min_reps" AND "max_reps" <100)` constraints have been applied.
* `rest_time`, which specifies the time (in seconds) as an `INTEGER` that the one following the schedule should rest between the excersises. It is necessary to specify this value and it should be greater or equal to zero, thus `NOT NULL` and `CHECK("rest_time" >= 0)` constraints have been applied.
* `comment`, which contains `TEXT` comments that the creator of the schedule can add to the excersises. It is not necessary to add the comment, but it should not be long, thus `CHECK(LENGTH("comment") < 200)` constraint has been applied.

#### Days

The `days` table includes:

* `id`, which specifies the unique ID for each day as an `INTEGER`. This column thus has the `PRIMARY KEY` constraint applied.
* `name`, which specifies the name of the day as `TEXT`. Each day should have different name, thus `NOT NULL` and `UNIQUE` constraints has been applied.

#### Schedule reviews

The `schedule_reviews` table includes:

* `id`, which specifies the unique ID for each schedule review as an `INTEGER`. This column thus has the `PRIMARY KEY` constraint applied.
* `timestamp`, which specifies the timestamp at which schedule review has been added with `DEFAULT` value of `CURRENT_TIMESTAMP`.
* `schedule_id`, which connects the review to the reviewed schedule. This column thus has the `FOREIGN KEY` constraint applied, refering the `id` column in the `schedules` table. If the schedule is deleted, reviews of that schedule should also be deleted, thus `ON DELETE CASCADE` has been applied.
* `like`, wchich specifies wether the reviewer liked the schedule or not. This table can store `INTEGER` values, more specifically it can store either 1 or 0, cause of `CHECK("like" IN (0, 1))` constraint. This option was chosen instead of `BOOLEAN` type of value, because it enables to aggregate the avarage value for the column (although it would probably work also on boolean type, as every `TRUE` value would be counted as 1 and `FALSE` value as 0)
* `review`, which contains reviews written by users as `TEXT`. A review should have some text opinion and consist of 5-2000 characters, thus the constraints `NOT NULL` and `CHECK(LENGTH("review") BETWEEN 5 AND 2000)` has been applied.

#### Schedules responses

The `schedules_responses` table includes:

* `id`, which specifies the unique ID for each schedule response as an `INTEGER`. This column thus has the `PRIMARY KEY` constraint applied.
* `timestamp`, which specifies the timestamp at which schedule response has been added with `DEFAULT` value of `CURRENT_TIMESTAMP`.
* `schedule_review_id`, which connects the response to the schedule review. This column thus has the `FOREIGN KEY` constraint applied, refering the `id` column in the `schedule_reviews` table. If the review is deleted, responses to that review should also be deleted, thus `ON DELETE CASCADE` has been applied.
* `user_id`, which connects the response to the user that wrote it. If a user would be deleted, responses wrote by that user should be deleted as well, thus `ON DELETE CASCADE` has been applied.
* `comment`, which contains responses as `TEXT` consisting of 5-2000 characters, thus constraint `CHECK(LENGTH("comment") BETWEEN 5 AND 2000)` has been applied. In this table comment is a necessary thing making it a column with `NOT NULL` constraint applied to it.

#### Favorites

The `favorites` table includes:

* `id`, which specifies the unique ID for each connection as an `INTEGER`. This column thus has the `PRIMARY KEY` constraint applied.
* `user_id`, which refers to the user that we want to include in the connection. This column thus has the `FOREIGN KEY` constraint applied, referencing the `id` column in the `users` table
* `schedule_id`, which refers to the schedule that we want to connect with previously chosen user. This column thus has the `FOREIGN KEY` constraint applied, referencing the `id` column in the `schedules` table.

Every connection between `users` and `schedules` occuring in this table is respresenting a user liking a schedule. If either user or schedule occuring in the connection would be deleted, the connection should also be deleted, thus both `user_id` and `schedule_id` columns have `ON DELETE CASCADE` applied.

#### Wall

The `wall` table includes:

* `id`, which specifies the unique ID for each entry as an `INTEGER`. This column thus has the `PRIMARY KEY` constraint applied.
* `user_id`, which refers to the user that did the excersise. This column thus has the `FOREIGN KEY` constraint applied, referencing the `id` column in the `users` table. If a user would be deleted, entries in the `wall` table connected to that user should be deleted as well, thus `ON DELETE CASCADE` has been applied
* `excersise_id`, which refers to the excersise that user did. This column thus has the `FOREIGN KEY` constraint applied, referencing the `id` column in the `excersises` table. If any excersise would be deleted, the connections between it and entries in the `wall` table should not be deleted. User should know that something changed in his history of the excersises performed, thus `ON DELETE SET NULL` has been applied.
* `timestamp`, which specifies the timestamp at which the entry has been added, with `DEFAULT` value of `CURRENT_TIMESTAMP`.
* `weight`, which specifies the weight (in kilograms) as an `INTEGER` that has been used to perform th excersise with the limit of 999 kilograms, thus `CHECK("weight" BETWEEN 0 AND 999)` constraint has been applied.
* `reps`, which specifies the number of repititions as an `INTEGER` the user did while performing the excersise in a single series, with the limit of 99 repititions, thus `CHECK("reps" BETWEEN 1 AND 99)` constraint has been applied.
* `next_time_weight`, which specifies wether the user wants to use more, less, or the same weight in the next attemption to the excersise as `TEXT`. The only accepted values in this table are: `u` (up - more weight in the next attempt), `d` (down - less weight in the next attempt), `s` (same - no change in weight in the next attempt), thus `CHECK("next_time_weight" IN ('u', 'd', 's'))` constraint has been applied. It is not necessary to specify this value, thus `NOT NULL` constraint was not applied.
* `comment`, which allows the user to add `TEXT` comments about the attempts. It is not necessary to add a comment, thus `NOT NULL` constraint was not applied.

In this table necessary values to specifie are `user_id`, `excersise_id`, `timestamp`, `weight`, `reps`. To these collumns `NOT NULL` constraint has been applied with exception of `user_id` and `excersise_id`, cause `FOREIGN_KEY` constraint already has `NOT NULL` constraint in it.


### Relationships

<div align="center">
<img src="https://github.com/user-attachments/assets/4b9124a3-89ce-434e-98a0-fe05d140a625">
<p>ER Diagram of this database</p>
</div>


As detailed by the diagram:

* A muscle area can include many muscles, but every single muscle can be included by one and only one muscle area (there is no possibility that muscle belongs to many muscle areas or desn't belong to any)
* A muscle area can be associated with one or many different excersises (if there would be a muscle area with zero excersises associated with it, there would be no sense to include that area at all in the table), but every single excersise can be associated with one and only one muscle area (despite that some excersises hit many different muscle areas, it has been decided that one excersise can be associated with only one muscle area that is targeted the most, so called "primary muscle area" of the excersise)
* To perform an excersise involves one and only one piece of equipment (even if excersise doesn't involve any equipment at all, in the `equipment` table there is a NULL value that can be associated with that excersise. There can be excersises that involve more than one piece of equipment, but they are a rarity. The most common situation is a combination of small equipment or machine and a bench, that's why bench could be included to both `equipment` and `machines` table), but every single piece of equipment is involved in one, or many different excerises (it makes no sense to store a piece of equipment that have no excersises associated with it).
* To perform an excersise involves one and only one machine (even if excersise doesn't involve any machine at all, in the `machines` table there is a NULL value that can be associated with that excersise), but a machine can be associated with one or many different excerises (it makes no sense to store a machine that have no excersises associated with it).
* An excersise can target one or many different muscles and one muscle can be targetted by one or many different excersises as well.
* An excersise can be associated with zero, one or many excersises reviews, but every review needs to be associated with one and only one excersise
* An excersise can be included in zero, one or many schedules and a schedule can include zero, one or many excersises
* An excersise can be included in zero, one or many entries in the `wall` table (users history of excersises performed), but every entry can be associated with one and only one excersise
* An excersise can be scheduled on zero or many different days (because they can be on different schedules) and on every day there can be scheduled zero or many different excersises
* A user can write zero, one or many excersises reviews, but every excersise review can be written by one and only one user.
* A user can create zero, one or many schedules, but every schedule can be created by one and only one user
* A user can write zero, one or many schedules reviews, but every schedule review can be written by one and only one user
* A user can write zero, one or many responses to schedules reviews and every schedule review can also have zero, one or many different responses to it
* A user can have zero, one or many different entries in the `wall` table (users history of excersises performed), but every entry can be associated with one and only one user.

## Optimizations

In a database with reviews and scores a common thing to do is to search for top entities based on avarage score. A view `top_excersises` has been created for that purpose, thus it is sorting top 20 excersises based on:

1. Avarage user score in reviews (descending)
2. Number of votes (descending)
3. Primary muscle area participating in the excersise (alphabetically)
4. Equipment used (alphabetically)
5. Machine used (alphabetically)
6. Name of the excersise (alphabetically)


The same goes with schedule reviews, but in this column we won't be talking about avarage score, because a user can't give a score to the schedule - he can only give a like or dislike. Thus for the schedule table, we will be talking about a ratio between like and dislikes, despite still using an `AVG` method. For example, if a result of `AVG` method on the `like` column in the `schedule_reviews` would be 0.79, it would means that 79% of users liked the schedule. When searching for the top schedules we also need into account that not every schedule is public, thus `private = FALSE` line has been applied to the query. A `top_schedules` view sorts the schedules based on:

1. Ratio of likes and dislikes (0 or 1) (descending)
2. Number of votes (descending)
3. Difficulty level (value specified by creator of the schedule, ascending)
4. Time consume level (value specified by creator of the schedule, ascending)
5. Intensity level (value specified by creator of the schedule, ascending)

Mostly, users would include name of some entity while searching through the database, thus indexes has been created on the following columns:

* `"muscle_areas"("name")`
* `"muscles"("name")`
* `"excersises"("name")`
* `"equipment"("name")`
* `"machines"("name")`

Other reasonable filters are 'levels' values, thus indexes has been created on the following columns:

* `"excersises_reviews"("score")`
* `"muscle_connections"("mp_level")`
* `"schedules"("difficulty_level")`
* `"schedules"("time_consume_level")`

To ensure that all excersises and schedules scores will be fair, the following triggers hava been created:

* `"excersise_review_duplicate"`, which ensures that every user can review every excersise only once (if inserted `user_id` and `excersise_id` are already connected via `excersises_reviews`, old row connecting these two ID's will be deleted)
* `schedule_reviews_duplicate`, which ensures that every user can review every schedule only once (if inserted `user_id` and `schedule_id` are already connected via `schedules_reviews`, old row connecting these two ID's will be deleted)
* `schedule_creator_review`, which ensures that any user can't review schedule that he created (if the `user_id` inserted to the `schedules_reviews` table matches the creator of the schedule corresponding to the inserted `schedule_id`, the newly inserted row will be deleted)


## Limitations

Every excersise can involve one and only one piece of equipment and machine. If an excersise would involve, for example, dumbbells and a resistance band, it could be associated with only one of these. There is also no possible way for a user to save a schedule
that he liked from beying deleted. If a user that created the schedule would be deleted, schedules that he created would also be deleted, despite other users that added it to favorites and posiibly are following it.
