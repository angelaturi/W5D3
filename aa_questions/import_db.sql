DROP TABLE IF EXISTS question_follows;
DROP TABLE IF EXISTS question_likes;
DROP TABLE IF EXISTS replies;
DROP TABLE IF EXISTS questions;
DROP TABLE IF EXISTS users;

PRAGMA foreign_keys = ON;

CREATE TABLE users (
    id INTEGER PRIMARY KEY,
    fname TEXT NOT NULL,
    lname TEXT NOT NULL
);

CREATE TABLE questions (
    id INTEGER PRIMARY KEY,
    title TEXT NOT NULL,
    body TEXT NOT NULL,
    user_id INTEGER NOT NULL,

    FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE question_follows (
    id INTEGER PRIMARY KEY,
    user_id INTEGER NOT NULL,
    question_id INTEGER NOT NULL,

    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (question_id) REFERENCES questions(id)
);


CREATE TABLE replies (
    id INTEGER PRIMARY KEY,
    question_id INTEGER NOT NULL,
    parent_reply_id INTEGER ,
    user_id INTEGER NOT NULL,
    body TEXT NOT NULL,

    FOREIGN KEY (question_id) REFERENCES questions(id),
    FOREIGN KEY (parent_reply_id) REFERENCES replies(id),
    FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE question_likes (
    id INTEGER PRIMARY KEY,
    user_id INTEGER NOT NULL,
    question_id INTEGER NOT NULL,

    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (question_id) REFERENCES questions(id)
);

INSERT INTO 
    users (fname, lname)
VALUES 
    ('Angela', 'Turi'), ('Daniel', 'Wu');

INSERT INTO
    questions (title, body, user_id)
VALUES
    ('Angela''s Question', 'How do you query in an RDBMS?', (SELECT id FROM users WHERE fname = 'Angela' AND lname = 'Turi')),
    ('Daniel''s Question', 'What is a heredoc?', (SELECT id FROM users WHERE fname = 'Daniel' AND lname = 'Wu'));

INSERT INTO 
    question_follows (user_id, question_id)
VALUES
    ((SELECT id FROM users WHERE fname = 'Angela' AND lname = 'Turi'), (SELECT id FROM questions WHERE title = 'Angela''s Question')),
    ((SELECT id FROM users WHERE fname = 'Daniel' AND lname = 'Wu'), (SELECT id FROM questions WHERE title = 'Daniel''s Question'));

INSERT INTO 
    replies (question_id, parent_reply_id, user_id, body)
VALUES 
    ((SELECT id FROM questions WHERE title = 'Angela''s Question'), NULL, (SELECT id FROM users WHERE fname = 'Angela' AND lname = 'Turi'), 'Ask the TAs for help'),
    ((SELECT id FROM questions WHERE title = 'Daniel''s Question'), (SELECT id FROM replies WHERE body = 'Ask the TAs for help'), (SELECT id FROM users WHERE fname = 'Daniel' AND lname = 'Wu'), 'Ask the circle leader for help');

INSERT INTO 
    question_likes (user_id, question_id)
VALUES
    ((SELECT id FROM users WHERE fname = 'Angela' AND lname = 'Turi'), (SELECT id FROM questions WHERE title = 'Angela''s Question')),
    ((SELECT id FROM users WHERE fname = 'Daniel' AND lname = 'Wu'), (SELECT id FROM questions WHERE title = 'Daniel''s Question'));