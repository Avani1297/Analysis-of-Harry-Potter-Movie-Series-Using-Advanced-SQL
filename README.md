# Analysis-of-Harry-Potter-Movie-Series-Using-Advanced-SQL
Leveraged advanced SQL, including CTEs and window functions, to analyze and interpret data from the first three Harry Potter movies revealing insights into character dynamics and plot developments that correlated with viewer engagement and ratings.

## Introduction
The primary goal of this project is to analyze and interpret data from the first three Harry Potter movies to reveal insights into character dynamics, plot developments, and their correlations with viewer engagement and ratings. By leveraging advanced SQL techniques, including CTEs and window functions, we aim to answer various business questions and provide a comprehensive understanding of the dataset.

## Dataset Overview
  The dataset was sourced from Kaggle and contains detailed information from the first three Harry Potter movies. It includes:

  ###### Potions: 
  Names, ingredients, effects, characteristics, and difficulty levels.
  ###### Hogwarts Staff: 
  Job titles, loyalty, wands, blood status, and house affiliations.
  ###### Patronus: 
  Types and details of Patronus charms.
  ###### Wizards: 
  Names, jobs, physical attributes, and life spans.
  ###### Spells: 
  Names, incantations, types, effects, and associated light.
  ###### Movie Dialogues: 
  Character names and their lines.
  ###### Hogwarts Students: 
  Blood status, loyalty, and wands.
  
## Implementation
### Data Conversion and Importation
  1. Initial Data Source:
  The dataset was sourced from Kaggle, containing information from the first three Harry Potter movies.
  
  2. Creation of Tables as per ERD:
  Organized raw data into distinct tables for Potions, Hogwarts Staff, Patronus, Wizard, Spells, Movie Dialogues, and Hogwarts Students.
  
  3. Conversion to CSV Format:
  Converted each table into CSV format for ease of import into MySQL.
  
  4. Importing into SQL:
  Imported CSV files into MySQL, structuring the data according to the database schema.
  
  5. Data Inspection and Key Assignments:
  Checked tables for accuracy and consistency, assigned primary keys for unique identification, and used foreign keys to link related tables.

## Findings
  1. Spell Effectiveness and Usage:
  Identified the distribution of spells by type and the most frequently mentioned spells across the three movies.
  
  2. Character and House Alignment:
  Analyzed the distribution of characters among the four Hogwarts houses and identified attributes influencing house assignments.
  3. Potion Complexity Analysis:
  Determined the relationship between the number of ingredients in a potion and its effect, and identified complexity ratings for potions.
  
  4. House Diversity Analysis:
  Examined the distribution of blood status among students in each Hogwarts house.
  
  5. Movie Dialogues and Character Representation:
  Analyzed the number of unique dialogues delivered by characters and their representation based on blood status and loyalty.
  
  6. Staff Loyalty and Characteristics:
  Correlated the blood status of Hogwarts staff with their job titles and examined the characteristics of their wands.
  
  7. Life Events and Blood Status:
  Investigated birth and death rates among wizards based on their blood status and identified notable patterns.
  
  8. Popular Characters:
  Determined the characters with the highest popularity and screen time based on their frequency of dialogue.
  
  9. Family Lineage and House Sorting:
  Assessed whether members of wizarding families sharing the same surname tend to be sorted into the same house and share loyalty alignments.

By utilizing advanced SQL techniques and detailed data analysis, this project provides comprehensive insights into the Harry Potter movies, aiding in understanding character dynamics, plot developments, and their impact on viewer engagement.







