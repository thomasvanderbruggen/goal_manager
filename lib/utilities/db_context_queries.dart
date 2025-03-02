// Versions of these formatted properly can be found in a.sqlite

String createGoal = 'CREATE TABLE Goal (id INTEGER PRIMARY KEY, title TEXT, description TEXT, goalDate TEXT, stretchDate TEXT, completeDate TEXT, goalType TEXT);'; 

String insertTestGoal = "INSERT INTO Goal (title, description, goalDate, stretchDate, completeDate, goalType) VALUES ('Lose Weight', 'Lose 10 pounds in 3 months', '2025-05-01', '2025-06-01', NULL, 'Health')";

String insertTestGoalMetric = "INSERT INTO GoalMetrics (goalId, title, description, percentCompleted) VALUES (1, 'Lose First 5 Pounds', 'Reach the halfway point', 50)"; 
