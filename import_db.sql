DROP TABLE IF EXISTS users;


CREATE TABLE users (

    id INTEGER PRIMARY KEY,
    fname TEXT,
    lname TEXT,
);

DROP TABLE IF EXISTS questions;

 CREATE TABLE questions (

    id INTEGER PRIMARY KEY,
    title TEXT,
    body TEXT,

    FOREIGN KEY (user_id) REFERENCES users(id)
 );

 DROP TABLE IF EXISTS question_follows 

 CREATE TABLE question_follows (
    
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (question_id) REFERENCES questions(id),
 )

 DROP TABLE IF EXISTS replies

 CREATE TABLE replies (

    
 )
 