--Representing useres

CREATE TABLE "users" (
	"id" INTEGER,
	"username" TEXT NOT NULL UNIQUE CHECK(LENGTH("username") <= 20),
	PRIMARY KEY("id")
);


--Representing muscle areas

CREATE TABLE "muscle_areas" (
	"id" INTEGER,
	"name" TEXT NOT NULL UNIQUE,
	PRIMARY KEY("id")
);

--Representing muscles

CREATE TABLE "muscles" (
	"id" INTEGER,
	"name" TEXT NOT NULL,
	"muscle_area_id" INTEGER,
	PRIMARY KEY("id"),
	FOREIGN KEY("muscle_area_id") REFERENCES "muscle_areas"("id")
);


--Representing equipment

CREATE TABLE "equipment" (
	"id" INTEGER,
	"name" TEXT UNIQUE,
	PRIMARY KEY("id")
);

--Representing machines (bigger equipment)

CREATE TABLE "machines" (
	"id" INTEGER,
	"name" TEXT UNIQUE,
	PRIMARY KEY("id")
);

--Representing excersises

CREATE TABLE "excersises" (
	"id" INTEGER,
	"name" TEXT NOT NULL,
	"primary_muscle_area_id" INTEGER,
	"equipment_id" INTEGER,
	"machine_id" INTEGER,
	PRIMARY KEY("id"),
	FOREIGN KEY("primary_muscle_area_id") REFERENCES "muscle_areas"("id"),
	FOREIGN KEY("equipment_id") REFERENCES "equipment"("id"),
	FOREIGN KEY("machine_id") REFERENCES "machines"("id")
);

--Representing connections between excersises and muscles participating

CREATE TABLE "muscle_connections" (
	"id" INTEGER,
	"excersise_id" INTEGER,
	"muscle_id" INTEGER,
	"mp_level" INTEGER NOT NULL CHECK("mp_level" BETWEEN 1 AND 4),
	PRIMARY KEY("id"),
	FOREIGN KEY("excersise_id") REFERENCES "excersises"("id"),
	FOREIGN KEY("muscle_id") REFERENCES "muscles"("id")
);

--Representing excersises reviews

CREATE TABLE "excersises_reviews" (
	"id" INTEGER,
	"user_id" INTEGER,
	"excersise_id" INTEGER,
	"score" INTEGER NOT NULL CHECK("score" BETWEEN 1 AND 10),
	"difficulty_level" INTEGER NOT NULL CHECK("difficulty_level" BETWEEN 1 AND 3),
	"weight_level" INTEGER NOT NULL CHECK("weight_level" BETWEEN 0 AND 3),
	"review" TEXT NOT NULL CHECK(LENGTH("review") BETWEEN 5 AND 1000),
	"advices" TEXT CHECK(LENGTH("advices") BETWEEN 5 AND 500),
	PRIMARY KEY("id"),
	FOREIGN KEY("user_id") REFERENCES "users"("id") ON DELETE CASCADE
);


--Representing users schedules

CREATE TABLE "schedules" (
	"id" INTEGER,
	"name" TEXT NOT NULL UNIQUE CHECK(LENGTH("name") BETWEEN 1 AND 30),
	"user_id" INTEGER,
	"private" BOOLEAN NOT NULL DEFAULT TRUE,
	"goal" TEXT NOT NULL CHECK("goal" IN ('FB', 'S', 'H')),
	"difficulty_level" INTEGER NOT NULL CHECK("difficulty_level" BETWEEN 1 AND 3),
	"intensity_level" INTEGER NOT NULL CHECK("intensity_level" BETWEEN 1 AND 3),
	"time_consume_level" INTEGER NOT NULL CHECK("time_consume_level" BETWEEN 1 AND 3),
	PRIMARY KEY("id"),
	FOREIGN KEY("user_id") REFERENCES "users"("id") ON DELETE CASCADE
);


--Representing schedules excersises

CREATE TABLE "schedules_excersises" (
	"id" INTEGER,
	"schedule_id" INTEGER,
	"day_id" INTEGER,
	"excersise_id" INTEGER,
	"weight_level" INTEGER NOT NULL CHECK("weight_level" BETWEEN 0 AND 3),
	"min_reps" INTEGER NOT NULL CHECK("min_reps" BETWEEN 1 AND 99),
	"max_reps" INTEGER NOT NULL CHECK("max_reps" > "min_reps" AND "max_reps" <100),
	"rest_time" INTEGER NOT NULL CHECK("rest_time" >= 0),
	"comment" TEXT CHECK(LENGTH("comment") < 200),
	PRIMARY KEY("id"),
	FOREIGN KEY("schedule_id") REFERENCES "schedules"("id") ON DELETE CASCADE,
	FOREIGN KEY("excersise_id") REFERENCES "excersises"("id") ON DELETE SET NULL
	FOREIGN KEY("day_id") REFERENCES "days"("id")
);


-- Representing days

CREATE TABLE "days" (
	"id" INTEGER,
	"name" TEXT NOT NULL UNIQUE,
	PRIMARY KEY("id")
);

--Representing schedules reviews

CREATE TABLE "schedules_reviews" (
	"id" INTEGER,
	"timestamp" NUMERIC NOT NULL DEFAULT CURRENT_TIMESTAMP,
	"user_id" INTEGER,
	"schedule_id" INTEGER,
	"like" INTEGER NOT NULL CHECK("like" IN (0, 1)),
	"review" TEXT NOT NULL CHECK(LENGTH("review") BETWEEN 5 AND 2000),
	PRIMARY KEY("id"),
	FOREIGN KEY("user_id") REFERENCES "users"("id") ON DELETE CASCADE,
	FOREIGN KEY("schedule_id") REFERENCES "schedules"("id") ON DELETE CASCADE
);


--Representing users respondes to schedules reviews

CREATE TABLE "schedules_responses" (
	"id" INTEGER,
	"timestamp" NUMERIC NOT NULL DEFAULT CURRENT_TIMESTAMP,
	"schedule_review_id" INTEGER,
	"user_id" INTEGER,
	"comment" TEXT NOT NULL CHECK(LENGTH("comment") BETWEEN 5 AND 2000),
	PRIMARY KEY("id"),
	FOREIGN KEY("schedule_review_id") REFERENCES "schedules_reviews"("id") ON DELETE CASCADE,
	FOREIGN KEY("user_id") REFERENCES "users"("id") ON DELETE CASCADE
);


--Representing users favorites

CREATE TABLE "favorites" (
	"id" INTEGER,
	"user_id" INTEGER,
	"schedule_id" INTEGER,
	PRIMARY KEY("id"),
	FOREIGN KEY("user_id") REFERENCES "users"("id") ON DELETE CASCADE,
	FOREIGN KEY("schedule_id") REFERENCES "schedules"("id") ON DELETE CASCADE
);

--Representing users walls (history of excersises performed)

CREATE TABLE "wall" (
	"id" INTEGER,
	"timestamp" NUMERIC NOT NULL DEFAULT CURRENT_TIMESTAMP,
	"user_id" INTEGER,
	"excersise_id" INTEGER,
	"weight" INTEGER NOT NULL CHECK("weight" BETWEEN 0 AND 999),
	"reps" INTEGER NOT NULL CHECK("reps" BETWEEN 1 AND 99),
	"next_time_weight" TEXT CHECK("next_time_weight" IN ('u', 'd', 's')),
	"comment" TEXT CHECK(LENGTH("comment") < 350),
	PRIMARY KEY("id"),
	FOREIGN KEY("user_id") REFERENCES "users"("id") ON DELETE CASCADE,
	FOREIGN KEY("excersise_id") REFERENCES "excersises"("id") ON DELETE SET NULL
);



-- Views

CREATE VIEW "top_excersises"
AS
SELECT "excersises"."name" AS "name", ROUND(AVG("excersises_reviews"."score"), 2) AS "avg_rating", COUNT("excersises_reviews"."user_id") AS "numb_of_votes",
"muscle_areas"."name" AS "primary_muscle_area_worked", "equipment"."name" AS "equipment_used", "machines"."name" AS "machine_used"
FROM "excersises"
JOIN "excersises_reviews" ON "excersises_reviews"."excersise_id" = "excersises"."id"
JOIN "muscle_areas" ON "muscle_areas"."id" = "excersises"."primary_muscle_area_id"
JOIN "equipment" ON "equipment"."id" = "excersises"."equipment_id"
JOIN "machines" ON "machines"."id" = "excersises"."machine_id"
GROUP BY "excersises_reviews"."excersise_id"
ORDER BY "avg_rating" DESC, "numb_of_votes" DESC, "primary_muscle_area_worked" DESC, "equipment_used" DESC, "machine_used" DESC, "name" DESC
LIMIT 20;



CREATE VIEW "top_schedules"
AS
SELECT "name", ROUND(AVG("like"), 2) AS "rating", COUNT("schedules_reviews"."user_id") AS "numb_of_votes",  "goal", "difficulty_level", "intensity_level", "time_consume_level"
FROM "schedules"
JOIN "schedules_reviews" ON "schedules"."id" = "schedules_reviews"."schedule_id"
GROUP BY "schedules"."id"
HAVING "private" = FALSE
ORDER BY "rating" DESC, "numb_of_votes" DESC, "difficulty_level" ASC, "time_consume_level" ASC, "intensity_level" ASC
LIMIT 20;


--Indexes

CREATE INDEX "index_muscle_areas" ON "muscle_areas"("name");
CREATE INDEX "index_muscles" ON "muscles"("name");
CREATE INDEX "index_excersises" ON "excersises"("name");
CREATE INDEX "index_equipment" ON "equipment"("name");
CREATE INDEX "index_machines" ON "machines"("name");
CREATE INDEX "excersises_difficulty" ON "excersises_reviews"("difficulty");
CREATE INDEX "score" ON "excersises_reviews"("score");
CREATE INDEX "mp_level" ON "muscle_connections"("mp_level");
CREATE INDEX "schedules_difficulty" ON "schedules"("difficulty_level");
CREATE INDEX "schedules_time_consume" ON "schedules"("time_consume_level");

--Triggers

CREATE TRIGGER "excersise_review_duplicate"
BEFORE INSERT ON "excersises_reviews"
WHEN NEW."excersise_id" IN (
	SELECT "excersise_id" FROM "excersises_reviews"
	WHERE "user_id" = NEW."user_id"
)
BEGIN
	DELETE FROM "excersises_reviews" WHERE "excersise_id" = NEW."excersise_id" AND "user_id" = NEW."user_id";
END;


CREATE TRIGGER "schedule_reviews_duplicate"
BEFORE INSERT ON "schedules_reviews"
WHEN NEW."schedule_id" IN (
	SELECT "schedule_id" FROM "schedules_reviews"
	WHERE "user_id" = NEW."user_id"
)
BEGIN
	DELETE FROM "schedules_reviews" WHERE "schedule_id" = NEW."schedule_id" AND "user_id" = NEW."user_id";
END;


CREATE TRIGGER "schedule_creator_review"
AFTER INSERT ON "schedules_reviews"
WHEN NEW."user_id" IN (
	SELECT "user_id" FROM "schedules"
	WHERE "id" = NEW."schedule_id"
)
BEGIN
	DELETE FROM "schedules_reviews" WHERE "user_id" = NEW."user_id" AND "schedule_id" = NEW."schedule_id";
END;
