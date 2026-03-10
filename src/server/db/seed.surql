-- We will use the namespace 'app' and database 'main'
USE NS app DB main;

-- 1. Create some initial users
-- You can specify the ID (e.g. user:yrrrrrf) or let SurrealDB generate it (e.g. CREATE user SET ...)
CREATE user:yrrrrrf SET 
    name = 'Yrrrrrf', 
    role = 'admin',
    created_at = time::now();

CREATE user:john_doe SET 
    name = 'John Doe', 
    role = 'user',
    created_at = time::now();

-- 2. Create some posts
CREATE post:first_post SET 
    title = 'Welcome to v3!', 
    content = 'SurrealDB v3 has successfully been deployed.',
    published = true;

CREATE post:second_post SET 
    title = 'How to query SurrealDB', 
    content = 'You can use SurrealQL to query graph relations easily.',
    published = true;

-- 3. Create Graph Relations
-- Relate users to the posts they authored
RELATE user:yrrrrrf->wrote->post:first_post;
RELATE user:john_doe->wrote->post:second_post;

-- 4. Sample Queries
-- Select all users
SELECT * FROM user;

-- Select all posts
SELECT * FROM post;

-- Graph query: Get all posts written by yrrrrrf
SELECT ->wrote->post.* AS posts FROM user:yrrrrrf;

-- Filter query
SELECT * FROM post WHERE published = true;
