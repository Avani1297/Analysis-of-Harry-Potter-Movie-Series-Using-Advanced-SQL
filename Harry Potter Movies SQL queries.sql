
-- Creating the new table MovieDialogues
DROP TABLE IF EXISTS MovieDialogues;
CREATE TABLE MovieDialogues (
    Characters VARCHAR(255),  -- Adjust the size as needed
    Sentence TEXT,
    MovieNumber VARCHAR(255)  -- Include MovieNumber in the creation script
);

-- Inserting data into the new table from existing tables
INSERT INTO MovieDialogues (Characters, Sentence, MovieNumber)
SELECT ï»¿Character, Sentence, CONCAT("Harry Potter - ", 1) AS MovieNumber FROM `harry potter 1`
UNION
SELECT ï»¿Character, Sentence, CONCAT("Harry Potter - ", 3) AS MovieNumber FROM `harry potter 3` ;

SELECT * FROM MOVIEDIALOGUES;

-- Business Queastion 1
-- a.i.	Family Lineage and House Sorting:
-- Do members of wizarding families sharing the same surname tend to be sorted into the same Hogwarts house and share loyalty alignments, 
-- suggesting a lineage-based influence on house sorting and affiliations?

SELECT 
    sub.FamilyName,
    hn.House,
    COALESCE(hs.Loyalty, st.Loyalty) AS Loyalty,
    COUNT(*) AS NumberOfFamilyMembers
FROM 
    (SELECT 
         Id, 
         Lname AS FamilyName
     FROM 
         Wizard 
     WHERE 
         Lname IS NOT NULL AND TRIM(Lname) <> '') AS sub
LEFT JOIN `house name` hn ON sub.Id = hn.Id
LEFT JOIN `hogwarts student` hs ON sub.Id = hs.Id
LEFT JOIN `hogwarts staff` st ON sub.Id = st.Id
GROUP BY 
    sub.FamilyName, hn.House, Loyalty
HAVING 
    COUNT(*) > 1
ORDER BY 
    sub.FamilyName, COUNT(*) DESC;


-- Business question 2
-- b.Character and House Alignment:
-- Determine the distribution of characters, including staff and students, 
-- among the four Hogwarts houses and identify any significant attributes (like Loyalty or Blood Type) 
-- that may influence house assignment?

WITH HouseCounts AS (
    SELECT 
        H.House AS HouseName,
        COUNT(DISTINCT HStaff.Id) AS NumberOfStaff,
        COUNT(DISTINCT HStudent.Id) AS NumberOfStudents
    FROM 
        `house name` AS H
    LEFT JOIN 
        `hogwarts staff` AS HStaff ON H.ID = HStaff.ID
    LEFT JOIN 
        `hogwarts student` AS HStudent ON H.ID = HStudent.ID
    WHERE 
        H.House IS NOT NULL AND H.House != ''
    GROUP BY 
        H.House
),
StaffStudentData AS (
    SELECT 
        H.House AS HouseName,
        HStaff.`Blood status` AS StaffBloodStatus,
        HStudent.`Blood status` AS StudentBloodStatus,
        HStaff.Loyalty AS StaffLoyalty,
        HStudent.Loyalty AS StudentLoyalty
    FROM 
        `house name` AS H
    LEFT JOIN 
        `hogwarts staff` AS HStaff ON H.ID = HStaff.ID
    LEFT JOIN 
        `hogwarts student` AS HStudent ON H.ID = HStudent.ID
    WHERE 
        H.House IS NOT NULL AND H.House != ''
)
SELECT DISTINCT
    HC.HouseName,
    HC.NumberOfStaff,
    HC.NumberOfStudents,
    SSD.StaffBloodStatus,
    SSD.StudentBloodStatus,
    SSD.StaffLoyalty,
    SSD.StudentLoyalty
FROM 
    HouseCounts AS HC
LEFT JOIN 
    StaffStudentData AS SSD ON HC.HouseName = SSD.HouseName
ORDER BY 
    HC.NumberOfStaff DESC, HC.NumberOfStudents DESC;

-- BUSINESS QUESTION 3
-- c.Potion Complexity Analysis and Usage:
-- How does the number of known ingredients in a potion relate to its described effect and characteristics? 
-- Can we identify a complexity rating for each potion? Then, determine if more complex potions are mentioned more or less frequently across the Harry Potter series files.
-- Complexity Rating
SELECT 
    ï»¿Name,
    (LENGTH(`Known ingredients`) - LENGTH(REPLACE(`Known ingredients`, ',', '')) + 1) AS NumberOfIngredients,
    `Difficulty level`,
    Effect,
    Characteristics,
    CASE 
        WHEN (LENGTH(`Known ingredients`) - LENGTH(REPLACE(`Known ingredients`, ',', '')) + 1) BETWEEN 1 AND 3 THEN 'Low'
        WHEN (LENGTH(`Known ingredients`) - LENGTH(REPLACE(`Known ingredients`, ',', '')) + 1) BETWEEN 4 AND 6 THEN 'Moderate'
        WHEN (LENGTH(`Known ingredients`) - LENGTH(REPLACE(`Known ingredients`, ',', '')) + 1) BETWEEN 7 AND 10 THEN 'High'
        ELSE 'Undefined'
    END AS ComplexityRating
FROM 
    Potions
ORDER BY 
    (LENGTH(`Known ingredients`) - LENGTH(REPLACE(`Known ingredients`, ',', '')) + 1) DESC;

-- Potions mentioned in movies
SELECT 
    p.ï»¿Name,
    p.Complexity,
    md.Sentence
FROM 
    (SELECT 
         ï»¿Name, 
         'Low to Moderate' AS Complexity,
         (LENGTH(`Known ingredients`) - LENGTH(REPLACE(`Known ingredients`, ',', '')) + 1) AS IngredientCount
     FROM 
         potions
     WHERE 
         (LENGTH(`Known ingredients`) - LENGTH(REPLACE(`Known ingredients`, ',', '')) + 1) BETWEEN 1 AND 4
     UNION ALL
     SELECT 
         ï»¿Name, 
         'High' AS Complexity,
         (LENGTH(`Known ingredients`) - LENGTH(REPLACE(`Known ingredients`, ',', '')) + 1) AS IngredientCount
     FROM 
         potions
     WHERE 
         (LENGTH(`Known ingredients`) - LENGTH(REPLACE(`Known ingredients`, ',', '')) + 1) BETWEEN 7 AND 10) AS p
JOIN 
    MovieDialogues AS md 
ON 
    md.Sentence LIKE CONCAT('%', p.ï»¿Name, '%')
ORDER BY 
    p.Complexity, p.ï»¿Name;

-- Business Question 4
-- d.	House Diversity Analysis:
-- What is the distribution of blood status (pureblood, half-blood, muggle-born) among students in each Hogwarts house, 
-- based on data from Hogwarts Student.csv and House Name.csv?

SELECT 
    h.House,
    s.`Blood status`,
    COUNT(*) AS NumberOfStudents
FROM 
    `hogwarts student` AS s
JOIN 
    `house name` AS h ON s.ID = h.Id
GROUP BY 
    h.House, s.`Blood status`
ORDER BY 
    NumberOfStudents DESC;
    
-- Business Question 5
-- e.	Movie Dialogues and Character Representation:
-- How many unique dialogues are delivered by characters in the movies? 
-- Can we analyze the representation of blood status and loyalty in the dialogues spoken by characters?

WITH WizardSubquery AS (
    SELECT ID, Fname, Lname
    FROM Wizard
),
DialoguesWithWizardInfo AS (
    SELECT 
		w.ID,
        md.Characters,
        w.Fname,
        w.Lname,
        md.Sentence
    FROM 
        MovieDialogues AS md
    JOIN WizardSubquery AS w 
    ON md.Characters = w.Fname OR md.Characters = w.Lname
) 
SELECT 
    dw.Fname,
    dw.Lname,
    hs.`Blood Status`,
    hs.Loyalty,
    COUNT(DISTINCT dw.Sentence) AS NumberOfDialogues
FROM 
    DialoguesWithWizardInfo AS dw
JOIN 
    `Hogwarts Student` AS hs 
ON 
    dw.ID = hs.ID
GROUP BY 
    dw.Fname, dw.Lname, hs.`Blood Status`, hs.Loyalty;

-- Business Question 6
-- 
-- f.	Staff Loyalty and Characteristics:
-- How does the blood status of Hogwarts staff members correlate with their job titles, and what are the distinct characteristics of their wands?
--
SELECT 
    hs.`Blood status`,
    hs.Job,
    COUNT(*) AS NumberOfStaff,
    GROUP_CONCAT(DISTINCT hs.Wand SEPARATOR ', ') AS WandCharacteristics
FROM 
    (SELECT 
         Job, 
         `Blood status`, 
         Loyalty,
         Wand
     FROM 
         `hogwarts staff`
     WHERE 
         `Blood status` != '') AS hs
GROUP BY 
    hs.Job, hs.`Blood status`, hs.Loyalty
ORDER BY 
    hs.Job, hs.`Blood status`;

-- Business QUestion 7
-- g.	Life Events and Blood Status:
-- How do birth and death rates vary among wizards based on their blood status, and are there any notable patterns or trends?

SELECT 
    COALESCE(hs.`Blood Status`, 'Unknown') AS BloodStatus,
    SUM(CASE WHEN wz.Birth != '' THEN 1 ELSE 0 END) AS BirthCount,
    SUM(CASE WHEN wz.Death != '' THEN 1 ELSE 0 END) AS DeathCount
FROM 
    `Wizard` AS wz
LEFT JOIN 
    (SELECT Id, `Blood Status` FROM `Hogwarts Staff`
     UNION ALL
     SELECT Id, `Blood Status` FROM `Hogwarts Student`) AS hs 
    ON wz.Id = hs.Id
GROUP BY 
    BloodStatus
ORDER BY 
    BirthCount DESC, DeathCount DESC;


-- Business Question 8
-- h.	Popular Characters:
-- Among the characters featured in all three movies, which are the top 3 that have garnered the highest level of popularity and major screen time, 
-- as measured by their frequency of dialogue throughout the 3 movies?

WITH DialogueCounts AS (
    SELECT 
        UPPER(Characters) AS Characters,
        COUNT(Sentence) AS DialogueCount
    FROM 
        MovieDialogues
    GROUP BY 
        Characters
)

SELECT 
    w.`Full Name`,
    w.Job,
    dc.DialogueCount,
    RANK() OVER (ORDER BY dc.DialogueCount DESC) AS PopularityRank
FROM 
    Wizard w
JOIN 
    DialogueCounts dc ON UPPER(dc.Characters) = UPPER(w.Fname) OR UPPER(dc.Characters) = UPPER(w.Lname)
ORDER BY 
    dc.DialogueCount DESC
LIMIT 4;
--
WITH DialogueCounts AS (
    SELECT 
        UPPER(Characters) AS UppercaseCharacter,
        COUNT(Sentence) AS DialogueCount
    FROM 
        MovieDialogues
    GROUP BY 
        UppercaseCharacter
)

SELECT 
    w.`Full Name`,
    w.Job,
    dc.DialogueCount,
    RANK() OVER (ORDER BY dc.DialogueCount DESC) AS PopularityRank
FROM 
    Wizard w
JOIN 
    DialogueCounts dc ON dc.UppercaseCharacter = UPPER(w.Fname) OR dc.UppercaseCharacter = UPPER(w.Lname)
ORDER BY 
    dc.DialogueCount DESC
LIMIT 4;
