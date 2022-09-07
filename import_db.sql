PRAGMA foreign_keys = ON;

DROP TABLE IF EXISTS users;
CREATE TABLE users (

    id INTEGER PRIMARY KEY,
    fname TEXT,
    lname TEXT
);

DROP TABLE IF EXISTS questions;
 CREATE TABLE questions (

    id INTEGER PRIMARY KEY,
    title TEXT,
    body TEXT,
    user_id INTEGER NOT NULL,

    FOREIGN KEY (user_id) REFERENCES users(id)
 );

 DROP TABLE IF EXISTS question_follows;

 CREATE TABLE question_follows (
    
    user_id INTEGER NOT NULL,
    question_id INTEGER NOT NULL,

    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (question_id) REFERENCES questions(id)
 );

 DROP TABLE IF EXISTS replies;
 CREATE TABLE replies (

   id INTEGER PRIMARY KEY,
   question_id INTEGER NOT NULL,
   parent_reply INTEGER,
   author INTEGER NOT NULL,
   body TEXT,

   FOREIGN KEY (question_id) REFERENCES questions(id),
   FOREIGN KEY (parent_reply) REFERENCES replies(id),
   FOREIGN KEY (author) REFERENCES users(id)
   
 );
 
 DROP TABLE IF EXISTS question_likes;
 CREATE TABLE question_likes (

   question INTEGER NOT NULL,
   user INTEGER NOT NULL,

   FOREIGN KEY (question) REFERENCES questions(id),
   FOREIGN KEY (user) REFERENCES users(id)

 );

INSERT INTO 
    users (fname,lname)
VALUES
    ('Shu', 'Shibahara'),
    ('Mike', 'Moses');

INSERT INTO
    questions (title, body, user_id)
VALUES
    ('Where''s my hat?', 'Yesterday I was drunk and I lost my hat', 1),
    ('Who''s the best teacher?', 'Trying to find a tutor for coding.', 1);

INSERT INTO    
    question_follows (user_id, question_id)
VALUES
    (1,2),
    (1,1);

INSERT INTO 
    replies (question_id, parent_reply, author, body)
VALUES
    (1, NULL, 1, 'I should learn to drink less.'),
    (1, 1, 2, 'You learned your lesson punk!');

INSERT INTO
    question_likes (question,user)
VALUES
    (2,2),
    (1,2);



