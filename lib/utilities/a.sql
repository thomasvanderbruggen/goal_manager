
-- createGoal
CREATE TABLE Goal (
    id INTEGER PRIMARY KEY,
    title TEXT,
    description TEXT,
    goalDate TEXT,
    stretchDate TEXT,
    completeDate TEXT,
    goalType TEXT
);

-- createGoalMetrics
CREATE TABLE GoalMetrics (
    goalmetricid INTEGER PRIMARY KEY,
    goalId INTEGER,
    title TEXT,
    description TEXT,
    percentCompleted INTEGER,
    FOREIGN KEY (goalid) REFERENCES Goal(id) ON DELETE CASCADE
);



INSERT INTO Goal (id, title, description, goalDate, stretchDate, completeDate, goalType) 
VALUES 
(1, 'Lose Weight', 'Lose 10 pounds in 3 months', '2025-05-01', '2025-06-01', NULL, 'Health'),
(2, 'Read More Books', 'Read 12 books this year', '2025-12-31', '2026-01-31', NULL, 'Personal Development');

INSERT INTO GoalMetrics (goalmetricid, goalid, title, description, percentCompleted) 
VALUES 
(1, 1, 'Lose First 5 Pounds', 'Reach the halfway point', 50),
(2, 1, 'Lose All 10 Pounds', 'Complete the full goal', 100),
(3, 2, 'Read 6 Books', 'Halfway through the goal', 50),
(4, 2, 'Read 12 Books', 'Complete the goal', 100);