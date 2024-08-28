
-- Select every excersise that mostly targets some specific muscle (`mp_level` for that muscle is more or equal to 3)
SELECT "excersises"."name" AS "excersise_name", "equipment"."name" AS "equipment_used", "machines"."name" AS "machine_used", "mp_level" AS "muscle_participation_level", ROUND(AVG("score"), 2) AS "average_score", ROUND(AVG("difficulty_level"), 2) AS "average_difficulty_level", ROUND(AVG("weight_level"), 2) AS "average_weight_level"  from "excersises"
JOIN "muscle_connections" ON "muscle_connections"."excersise_id" = "excersises"."id"
LEFT JOIN "excersises_reviews" ON "excersises_reviews"."excersise_id" = "excersises"."id"
JOIN "equipment" ON "excersises"."equipment_id" = "equipment"."id"
JOIN "machines" ON "excersises"."machine_id" = "machines"."id"
WHERE "muscle_id" = (
	SELECT "id" FROM "muscles"
	WHERE "name" = 'Quadriceps'
)
AND "mp_level" >= 3
GROUP BY "excersises"."id"
ORDER BY "muscle_participation_level" DESC, "average_score" DESC, "average_difficulty_level" DESC, "average_weight_level" DESC;



-- Select every excersise that priamry targets some specific muscle area
SELECT "excersises"."name" AS "excersise_name", "equipment"."name" AS "equipment_used", "machines"."name" AS "machine_used", ROUND(AVG("score"), 2) AS "average_score", ROUND(AVG("difficulty_level"), 2) AS "average_difficulty_level", ROUND(AVG("weight_level"), 2) AS "average_weight_level"  from "excersises"
LEFT JOIN "excersises_reviews" ON "excersises_reviews"."excersise_id" = "excersises"."id"
JOIN "equipment" ON "excersises"."equipment_id" = "equipment"."id"
JOIN "machines" ON "excersises"."machine_id" = "machines"."id"
WHERE "primary_muscle_area_id" = (
	SELECT "id" FROM "muscle_areas"
	WHERE "name" = 'Chest'
)
GROUP BY "excersises"."id"
ORDER BY "average_score" DESC, "average_difficulty_level" DESC, "average_weight_level" DESC;


-- Select every excersise that uses barbell or dumbbells
SELECT "excersises"."name" AS "excersise_name", "equipment"."name" AS "equipment_used", "machines"."name" AS "machine_used", ROUND(AVG("score"), 2) AS "average_score", ROUND(AVG("difficulty_level"), 2) AS "average_difficulty_level", ROUND(AVG("weight_level"), 2) AS "average_weight_level"  from "excersises"
LEFT JOIN "excersises_reviews" ON "excersises_reviews"."excersise_id" = "excersises"."id"
JOIN "equipment" ON "excersises"."equipment_id" = "equipment"."id"
JOIN "machines" ON "excersises"."machine_id" = "machines"."id"
WHERE "equipment_id" IN (
	SELECT "id" FROM "equipment"
	WHERE "name" = 'Barbell' OR "name" = 'Dumbbells'
)
GROUP BY "excersises"."id"
ORDER BY "average_score" DESC, "equipment_used" ASC, "average_difficulty_level" DESC, "average_weight_level" DESC;



-- Select every public schedule that has difficulty_level less or equal to 2
SELECT "schedules"."name" AS "name", ROUND(AVG("like"), 2) AS "rating", "schedules"."difficulty_level", "schedules"."time_consume_level", "schedules"."intensity_level" FROM "schedules"
LEFT JOIN "schedules_reviews" ON "schedules_reviews"."schedule_id" = "schedules"."id"
GROUP BY "schedules"."id"
HAVING "difficulty_level" <= 3
AND "private" = FALSE
ORDER BY "rating" DESC, "difficulty_level" ASC, "time_consume_level" ASC, "intensity_level" ASC, "name" DESC;



-- Select every schedule that user have created
SELECT "schedules"."name" AS "name", ROUND(AVG("like"), 2) AS "rating", "schedules"."difficulty_level", "schedules"."time_consume_level", "schedules"."intensity_level" FROM "schedules"
LEFT JOIN "schedules_reviews" ON "schedules_reviews"."schedule_id" = "schedules"."id"
GROUP BY "schedules"."id"
HAVING "schedules"."user_id" = 1
ORDER BY "rating" DESC, "name" DESC, "difficulty_level" ASC, "time_consume_level" ASC, "intensity_level" ASC;



-- Select every schedule that have been added to favorites by the user
SELECT "schedules"."name" AS "name", ROUND(AVG("like"), 2) AS "rating", "schedules"."difficulty_level", "schedules"."time_consume_level", "schedules"."intensity_level" FROM "schedules"
LEFT JOIN "schedules_reviews" ON "schedules_reviews"."schedule_id" = "schedules"."id"
JOIN "favorites" ON "favorites"."schedule_id" = "schedules"."id"
GROUP BY "schedules"."id"
HAVING "favorites"."user_id" = 2
ORDER BY "rating" DESC, "name" DESC, "difficulty_level" ASC, "time_consume_level" ASC, "intensity_level" ASC;


-- Select excersises that are included in the schedule
SELECT "excersises"."name" AS "excersise_name", "days"."name" AS "day", "weight_level", "min_reps", "max_reps", "rest_time", "comment" FROM "schedules_excersises"
JOIN "excersises" ON "schedules_excersises"."excersise_id" = "excersises"."id"
JOIN "days" ON "schedules_excersises"."day_id" = "days"."id"
WHERE "schedule_id" = 3
ORDER BY "day_id" DESC, "schedules_excersises"."id" DESC;


-- Select every review of specific excersise
SELECT "users"."username",  "score", "review", "advices", "difficulty_level", "weight_level" FROM "excersises_reviews"
JOIN "users" ON "excersises_reviews"."user_id" = "users"."id"
WHERE "excersise_id" = 1
ORDER BY "score" DESC, "username" ASC;


-- Select every review of specific schedule
SELECT "users"."username",  "like", "review" FROM "schedules_reviews"
JOIN "users" ON "schedules_reviews"."user_id" = "users"."id"
WHERE "schedule_id" = 1
ORDER BY "like" DESC, "username" ASC;


-- Select every response to a specific review
SELECT "timestamp", "username", "comment" FROM "schedules_responses"
JOIN "users" ON "schedules_responses"."user_id" = "users"."id"
WHERE "schedule_review_id" = 2
ORDER BY "schedules_responses"."id" DESC;


-- Select every entry in the `wall` table of specific user
SELECT "timestamp","name", "weight", "reps", "next_time_weight", "comment" FROM "wall"
JOIN "excersises" ON "wall"."excersise_id" = "excersises"."id"
WHERE "user_id" = 1
ORDER BY "wall"."id" ASC;


-- Adding new user
INSERT INTO "users"("username")
VALUES
('johnny_2');


-- Adding new muscle area
INSERT INTO "muscle_areas"("name")
VALUES
('Legs');


-- Adding new muscle
INSERT INTO "muscles"("muscle_area_id", "name")
VALUES
(1, 'Quadriceps');

-- Adding new piece of equipment
INSERT INTO "equipment"("name")
VALUES
('Barbell');

-- Adding new machine
INSERT INTO "machines"("name")
VALUES
('Incline Bench');

-- Adding new excersise
INSERT INTO "excersises"("name", "primary_muscle_area_id", "equipment_id", "machine_id")
VALUES
('Squat', 1, 2, 1);

-- Adding connection between excersise and muscle participating
INSERT INTO "muscle_connections"("excersise_id", "muscle_id", "mp_level")
VALUES
(1, 1, 3);

-- Adding excersise review
INSERT INTO "excersises_reviews"("user_id", "excersise_id", "score", "difficulty_level", "weight_level", "review", "advices")
VALUES
(1, 1, 10, 2, 3, 'Really good excersise, probably the best to hit your quadriceps and improve overall strength', 'If you are a beginner, do not go with big weight');

-- Adding new schedule
INSERT INTO "schedules" ("name", "user_id", "private", "goal", "difficulty_level", "intensity_level", "time_consume_level")
VALUES
('Push Pull Legs', 1, 0, 'H', 3, 2, 3);

-- Adding new day
INSERT INTO "days" ("name")
VALUES
('Monday');

-- Adding new connection between schedule and excersise included in that schedule
INSERT INTO "schedules_excersises" ("schedule_id", "day_id", "excersise_id", "weight_level", "min_reps", "max_reps", "rest_time")
VALUES
(1, 1, 10, 3, 5, 8, 180);

-- Adding new schedule review
INSERT INTO "schedules_reviews" ("user_id", "schedule_id", "like", "review")
VALUES
(1, 2, 1, 'Great schedule!');

-- Adding new response to the schedule review
INSERT INTO "schedules_responses" ("schedule_review_id", "user_id", "comment")
VALUES
(1, 2, 'Thanks!');

-- Adding schedule to favorites
INSERT INTO "favorites" ("user_id", "schedule_id")
VALUES
(1, 2);

-- Adding new entry in the history of excersises performed
INSERT INTO "wall" ("user_id", "excersise_id", "weight", "reps", "next_time_weight", "comment")
VALUES
(1, 10, 75, 10, 'u', 'It was ok');


-- Note that in some cases, especially when searching through excersises and schedules, there has been only one filter applied (e.g. that difficulty_level is less or equal to 2), but there are dozens of similar queries where other or couple filters could have been applied.
