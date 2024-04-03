DROP DATABASE IF EXISTS imbd_HLAVACH;
CREATE DATABASE imdb_HLAVACH;

USE imdb_HLAVACH;

CREATE TABLE film (
    film_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255),
    description TEXT,
    release_year INT
);

CREATE TABLE actor (
    actor_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50)
);

CREATE TABLE film_actor (
    actor_id INT,
    film_id INT,
    PRIMARY KEY (actor_id, film_id),
    FOREIGN KEY (actor_id) REFERENCES actor(actor_id),
    FOREIGN KEY (film_id) REFERENCES film(film_id)
);

ALTER TABLE film
ADD COLUMN last_update TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

ALTER TABLE actor
ADD COLUMN last_update TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

ALTER TABLE film_actor
ADD CONSTRAINT fk_actor_id FOREIGN KEY (actor_id) REFERENCES actor(actor_id),
ADD CONSTRAINT fk_film_id FOREIGN KEY (film_id) REFERENCES film(film_id);

INSERT INTO actor (first_name, last_name) VALUES
('Tom', 'Hanks'),
('Leonardo', 'DiCaprio'),
('Scarlett', 'Johansson');

INSERT INTO film (title, description, release_year) VALUES
('Forrest Gump', 'Un hombre con discapacidad', 1994),
('Titanic', 'Un romance', 1997),
('Lost in Translation', 'Un actor y una joven', 2003);

INSERT INTO film_actor (actor_id, film_id) VALUES
(1, 1), -- Tom Hanks en Forrest Gump
(2, 2), -- Leonardo DiCaprio en Titanic
(3, 3); -- Scarlett Johansson en Lost in Translation