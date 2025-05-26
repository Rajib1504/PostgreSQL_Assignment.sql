-- Active: 1747667091457@@127.0.0.1@5432@conservation_db
CREATE DATABASE "conservation_db";

CREATE TABLE rangers (
    ranger_id SERIAL UNIQUE,
    name VARCHAR(200) NOT NULL,
    region VARCHAR(250) NOT NULL
);

INSERT INTO
    rangers (name, region)
VALUES (
        'Alice Green',
        'Northern Hills'
    ),
    ('Bob White', 'River Delta'),
    (
        'Carol King',
        'Mountain Range'
    ),
    ('David Smith', 'Forest Edge'),
    ('Eva Brown', 'Coastal Plains'),
    (
        'Frank Miller',
        'Savanna Fields'
    ),
    ('Grace Lee', 'Desert Canyon'),
    ('Henry Moore', 'River Delta'),
    ('Ivy Clark', 'Mountain Range'),
    (
        'Jack Taylor',
        'Northern Hills'
    );

CREATE TABLE species (
    species_id SERIAL UNIQUE,
    common_name VARCHAR(100),
    scientific_name VARCHAR(200),
    discovery_date DATE,
    conservation_status VARCHAR(100)
);

INSERT INTO
    species (
        common_name,
        scientific_name,
        discovery_date,
        conservation_status
    )
VALUES (
        'Snow Leopard',
        'Panthera uncia',
        '1775-01-01',
        'Endangered'
    ),
    (
        'Bengal Tiger',
        'Panthera tigris tigris',
        '1758-01-01',
        'Endangered'
    ),
    (
        'Red Panda',
        'Ailurus fulgens',
        '1825-01-01',
        'Vulnerable'
    ),
    (
        'Asiatic Elephant',
        'Elephas maximus indicus',
        '1758-01-01',
        'Endangered'
    ),
    (
        'Giant Panda',
        'Ailuropoda melanoleuca',
        '1869-03-11',
        'Vulnerable'
    ),
    (
        'African Elephant',
        'Loxodonta africana',
        '1797-01-01',
        'Vulnerable'
    ),
    (
        'Indian Rhinoceros',
        'Rhinoceros unicornis',
        '1814-01-01',
        'Vulnerable'
    ),
    (
        'Koala',
        'Phascolarctos cinereus',
        '1816-01-01',
        'Vulnerable'
    ),
    (
        'Polar Bear',
        'Ursus maritimus',
        '1774-01-01',
        'Vulnerable'
    ),
    (
        'Orangutan',
        'Pongo pygmaeus',
        '1760-01-01',
        'Endangered'
    );

CREATE TABLE sightings (
    sighting_id SERIAL PRIMARY KEY,
    ranger_id INTEGER REFERENCES rangers (ranger_id),
    species_id INTEGER REFERENCES species (species_id),
    sighting_time TIMESTAMP,
    location VARCHAR(150),
    notes TEXT
);

INSERT INTO
    sightings (
        species_id,
        ranger_id,
        location,
        sighting_time,
        notes
    )
VALUES (
        1,
        1,
        'Peak Ridge',
        '2024-05-10 07:45:00',
        'Camera trap image captured'
    ),
    (
        2,
        2,
        'Bankwood Area',
        '2024-05-12 16:20:00',
        'Juvenile seen'
    ),
    (
        3,
        3,
        'Bamboo Grove East',
        '2024-05-15 09:10:00',
        'Feeding observed'
    ),
    (
        1,
        2,
        'Snowfall Pass',
        '2024-05-18 18:30:00',
        NULL
    ),
    (
        4,
        4,
        'Riverbank West',
        '2024-05-20 12:45:00',
        'Group of elephants seen'
    ),
    (
        5,
        1,
        'Forest Edge',
        '2024-05-22 06:30:00',
        'Single panda resting'
    ),
    (
        6,
        2,
        'Savanna Plains',
        '2024-05-23 14:15:00',
        'Family herd observed'
    ),
    (
        7,
        3,
        'Wetlands South',
        '2024-05-24 10:40:00',
        'One-horned rhino crossing'
    ),
    (
        8,
        1,
        'Eucalyptus Woods',
        '2024-05-25 15:55:00',
        'Koala spotted on tree'
    ),
    (
        9,
        2,
        'Glacier Bay',
        '2024-05-26 11:20:00',
        'Polar bear seen far off'
    );

select * FROM rangers;

SELECT * FROM species;

SELECT * FROM sightings;

-- DROP TABLE species;
-- DROP TABLE rangers;

-- 1️⃣ Register a new ranger with provided data with name = 'Derek Fox' and region = 'Coastal Plains'

INSERT INTO
    rangers (name, region)
VALUES ('Derek Fox', 'Coastal Plains');

-- 2️⃣ Count unique species ever sighted.
SELECT COUNT(DISTINCT species_id) FROM sightings;

-- 3️⃣ Find all sightings where the location includes "Pass".
SELECT * FROM sightings WHERE location ILIKE '%Pass';

-- 4️⃣ List each ranger's name and their total number of sightings.

-- SELECT * FROM rangers as r
-- JOIN sightings s on r.ranger_id = s.ranger_id ;
SELECT
    name,
    COUNT(*) as total_number_of_sightings
FROM rangers as r
    JOIN sightings s on r.ranger_id = s.ranger_id
GROUP BY
    name;

-- 5️⃣ List species that have never been sighted.
SELECT *
FROM species as s
    JOIN sightings as sl on s.species_id = sl.species_id;

SELECT common_name
FROM species as s
    LEFT JOIN sightings as sl on s.species_id = sl.species_id
WHERE
    sl IS NULL;

-- 6️⃣ Show the most recent 2 sightings.
SELECT * FROM sightings;

SELECT * FROM sightings ORDER BY sighting_time DESC LIMIT 2;

-- 7️⃣ Update all species discovered before year 1800 to have status 'Historic'.
UPDATE species
set
    conservation_status = 'Historic'
WHERE (
        extract(
            YEAR
            FROM discovery_date
        ) < 1800
    );

SELECT * FROM species;

-- 8️⃣ Label each sighting's time of day as 'Morning', 'Afternoon', or 'Evening'.
SELECT * FROM sightings;

SELECT sighting_time,sighting_id, case  WHEN EXTRACT (HOUR  FROM sighting_time) BETWEEN 5 AND 11 THEN 'Morning'
  WHEN EXTRACT (HOUR  FROM sighting_time) BETWEEN 12 AND 17 THEN 'Afternoon'
  WHEN EXTRACT (HOUR  FROM sighting_time) BETWEEN 18 AND 21 THEN 'Evening'
  else 'night'
  END AS time_of_day
 FROM sightings;

--  9️⃣ Delete rangers who have never sighted any species
DELETE FROM rangers
WHERE ranger_id NOT IN(SELECT DISTINCT ranger_id FROM sightings );

