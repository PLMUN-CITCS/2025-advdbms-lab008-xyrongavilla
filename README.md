# **2025-ADVDBMS-LAB008**
Week 04 - Entity–Relationship Modeling

Laboratory # 08 - Combined Week 04 Database Activity

## **Instructions**

### **Step 1.1: Accept the Assignment**

   1. Click on the assignment link provided by your instructor.
   2. GitHub Classroom will create a **private repository** under your GitHub account.
   3. After the repository is created, click **"Go to Repository"** to view your assignment.

---

### **Step 1.2: Setup your Git Environment**
Only perform this if this is the first time you will setup your Git Environment

   1. Create a GitHub Account:
   ```bash
   https://github.com/signup?source=login
   ```
      
   2. Download and Install Git on your Laptop/Desktop:
   ```bash
   https://git-scm.com/downloads
   ```
   
   3. Create a Folder in your Laptop/Desktop
   4. Right-click anywhere in the created folder and select "Open Git Bash Here".
   5. In the Git Bash Terminal, set your git name, perform command:
   ```bash
   git config --global user.name "Your Name"
   ```
   
   6. In the Git Bash Terminal, set your git email, perform command:
   ```bash
   git config --global user.email "your.email@example.com"
   ```
   
   7. Create your SSH Key, just follow the instructions, no need to provide filename and passphrase. In the Git Bash Terminal, perform command:
   ```bash
   ssh-keygen -t rsa -b 4096 -C "your_email@example.com"
   ```
   
   8. Copy your SSH Keys into clipboard. In the Git Bash Terminal, perform command:
   ```bash
   clip < ~/.ssh/id_rsa.pub
   ```
   
   9. Log in to your GitHub account.
   10. In the upper-right corner of GitHub, click your profile picture and select Settings.
   11. In the left sidebar, click on SSH and GPG keys.
   12. Click the New SSH key button.
   13. In the Title field, give the key a recognizable name (e.g., "My Windows Laptop").
   14. In the Key field, CTRL + V or paste the keys copied into your clipboard. Save the key.
   15. Go Back to terminal, use command:
   ```bash
   ssh -T git@github.com
   ```

### **Step 2: Clone the Repository to Your Local Machine**

   1. On your repository page, click the green **"Code"** button.
   2. Copy the repository URL (choose HTTPS for simplicity).
   3. Open your terminal (or Git Bash, Command Prompt, or PowerShell) and run:
   
   ```bash
   git clone <git_repo_url>
   ```
   
   4. Navigate into the cloned folder:
   
   ```bash
   cd <git_cloned_folder>
   ```

### **Step 3: Complete the Assignment**

**Laboratory # 08 - Combined Week 04 Database Activity**

   **Objective:**
   Design, implement, populate, and query a bookstore database, demonstrating the relationship between ERD design and SQL operations.

   **Folder Structure:**
   ```
  bookstore_database/
   ├── create_bookstore_schema.sql
   ├── insert_bookstore_data.sql
   └── query_bookstore_data.sql
   ```

   **File Naming Convention:**
   - `create_bookstore_schema.sql`: SQL script to create the database schema.
   - `insert_bookstore_data.sql`: SQL script to insert sample data.
   - `query_bookstore_data.sql`: SQL script with queries to explore and manipulate data.

   **Entities to be Created:**
   - Books
   - Authors
   - BookAuthors (linking table)
   - Customers
   - Orders
   - OrderDetails
   
   **Data to be Inserted:**
   Insert at least 3 records for each table, ensuring foreign key relationships are correctly established. For example, when inserting into OrderDetails, make sure the OrderID and ISBN exist in the Orders and Books tables, respectively.

   **Fields to be Joined:**
   - Customers and Orders (on CustomerID)
   - Orders and OrderDetails (on OrderID)
   - OrderDetails and Books (on ISBN)
   - Books and BookAuthors (on ISBN)
   - Authors and BookAuthors (on AuthorID)

   **Notable Observations (to be discussed after completing the exercise):**
   - Auto-increment is used for primary keys where appropriate (Authors, Customers, Orders).
   - Foreign keys are crucial for maintaining referential integrity.
   - The BookAuthors table resolves the many-to-many relationship between Books and Authors.
   - Queries demonstrate how joins retrieve related data from multiple tables.

   **SQL Script Best Practices**
   - Use comments to explain each section.
   - Follow consistent naming conventions.
   - Use proper indentation for readability.
   - Test each script individually.
   - Use transactions for complex operations (optional, but good practice).

   **Step-by-Step Instructions:**

   1. Create the Database and Tables (`create_bookstore_schema.sql`):
   - Open `create_bookstore_schema.sql` in a text editor.
   - Create Database: Write the SQL command to create a database named BookstoreDB.
   ```SQL
   CREATE DATABASE `BookstoreDB`;
   
   ```
   - Use Database: Write the SQL command to select the BookstoreDB database for use.
   ```SQL
   USE `BookstoreDB`;
   
   ```
   - Create Tables: For each entity (Books, Authors, BookAuthors, Customers, Orders, OrderDetails), write a CREATE TABLE statement. 
      - Define appropriate data types for each attribute.
      - Declare primary keys for each table. Use AUTO_INCREMENT for IDs where appropriate (Authors, Customers, Orders).
      - For the BookAuthors table, create a composite primary key using both ISBN and AuthorID.
      - Define foreign key constraints to enforce referential integrity. For example, in the Orders table, the CustomerID should be a foreign key referencing the Customers table's CustomerID. Do this for all appropriate relationships. The BookAuthors table will have two foreign keys.
   ```SQL
   -- Books Table [cite: 11]
   CREATE TABLE `Books` (
      `ISBN` VARCHAR(20) PRIMARY KEY,
      `Title` VARCHAR(255) NOT NULL,
      `Price` DECIMAL(10,2) NOT NULL
   );

   -- Authors Table [cite: 11]
   CREATE TABLE `Authors` (
      `AuthorID` INT PRIMARY KEY,
      `Name` VARCHAR(255) NOT NULL
   );

   -- BookAuthors Table (Associative Entity) [cite: 11]
   CREATE TABLE `BookAuthors` (
      `ISBN` VARCHAR(20),
      `AuthorID` INT,
      PRIMARY KEY (`ISBN`, `AuthorID`),
      FOREIGN KEY (`ISBN`) REFERENCES `Books`(`ISBN`),
      FOREIGN KEY (`AuthorID`) REFERENCES `Authors`(`AuthorID`)
   );

   -- Customers Table [cite: 11]
   CREATE TABLE `Customers` (
      `CustomerID` INT PRIMARY KEY,
      `Name` VARCHAR(255) NOT NULL,
      `Email` VARCHAR(255) NOT NULL
   );

   -- Orders Table [cite: 11]
   CREATE TABLE `Orders` (
      `OrderID` INT PRIMARY KEY,
      `CustomerID` INT,
      `OrderDate` DATE NOT NULL,
      FOREIGN KEY (`CustomerID`) REFERENCES `Customers`(`CustomerID`)
   );

   -- OrderDetails Table [cite: 11]
   CREATE TABLE `OrderDetails` (
      `OrderID` INT,
      `ISBN` VARCHAR(20),
      `Quantity` INT NOT NULL,
      PRIMARY KEY (`OrderID`, `ISBN`),
      FOREIGN KEY (`OrderID`) REFERENCES `Orders`(`OrderID`),
      FOREIGN KEY (`ISBN`) REFERENCES `Books`(`ISBN`)
   );

   ```    
   - Save the create_bookstore_schema.sql file.

   2. Insert Sample Data (`insert_bookstore_data.sql`):
   - Open `insert_bookstore_data.sql` in a text editor.
   - Use Database: Write the SQL command to select the `BookstoreDB` database.
   ```SQL
   USE `BookstoreDB`;
   
   ```
   - Insert Data: For each table, write `INSERT INTO` statements to populate the table with sample data. 
      - Insert at least three records for each table.
      - Crucially: Ensure that foreign key relationships are satisfied. For example, when inserting into Orders, the CustomerID you use must exist in the Customers table. Similarly, when inserting into OrderDetails, the OrderID and ISBN must exist in the Orders and Books tables, respectively. The BookAuthors entries must reference valid ISBNs and AuthorIDs.
   ```SQL
   -- Insert into Books
   INSERT INTO `Books` (`ISBN`, `Title`, `Price`) VALUES
   ('9781234567890', 'The Hitchhiker''s Guide to the Galaxy', 7.99),
   ('9780321765723', 'The Lord of the Rings', 12.99),
   ('9780743273565', 'Pride and Prejudice', 9.99);

   -- Insert into Authors
   INSERT INTO `Authors` (`AuthorID`, `Name`) VALUES
   (1, 'Douglas Adams'),
   (2, 'J.R.R. Tolkien'),
   (3, 'Jane Austen');

   -- Insert into BookAuthors
   INSERT INTO `BookAuthors` (`ISBN`, `AuthorID`) VALUES
   ('9781234567890', 1),
   ('9780321765723', 2),
   ('9780743273565', 3);

   -- Insert into Customers
   INSERT INTO `Customers` (`CustomerID`, `Name`, `Email`) VALUES
   (1, 'John Doe', 'john.doe@example.com'),
   (2, 'Jane Smith', 'jane.smith@example.com'),
   (3, 'David Lee', 'david.lee@example.com');

   -- Insert into Orders
   INSERT INTO `Orders` (`OrderID`, `CustomerID`, `OrderDate`) VALUES
   (1, 1, '2024-07-26'),
   (2, 2, '2024-07-27'),
   (3, 3, '2024-07-28');

   -- Insert into OrderDetails
   INSERT INTO `OrderDetails` (`OrderID`, `ISBN`, `Quantity`) VALUES
   (1, '9781234567890', 1),
   (1, '9780321765723', 2),
   (2, '9780743273565', 1);

   ```
   - Save the `insert_bookstore_data.sql` file.

   3. Query and Manipulate Data (`query_bookstore_data.sql`)
   - Open `query_bookstore_data.sql` in a text editor.
   - Use Database: Write the SQL command to select the `BookstoreDB` database.
   ```SQL
   USE `BookstoreDB`;
   
   ```
   - Data Retrieval: Write a SELECT statement that joins the Customers, Orders, OrderDetails, and Books tables to retrieve information about customer orders, including customer names, order dates, and book titles.
   ```SQL
   SELECT `c`.`Name` AS `CustomerName`, `o`.`OrderDate`, `b`.`Title` AS `BookTitle`, `od`.`Quantity`
   FROM `Customers` `c`
   JOIN `Orders` `o` ON `c`.`CustomerID` = `o`.`CustomerID`
   JOIN `OrderDetails` `od` ON `o`.`OrderID` = `od`.`OrderID`
   JOIN `Books` `b` ON `od`.`ISBN` = `b`.`ISBN`;
   
   ```
   - Data Update: Write an UPDATE statement to change the price of one of the books. Then, write a SELECT statement to verify that the price has been updated.
   ```SQL
   UPDATE `Books` SET `Price` = 8.99 WHERE `ISBN` = '9781234567890';
   
   SELECT * FROM `Books` WHERE `ISBN` = '9781234567890';
   
   ```
   - Data Deletion: Write a DELETE statement to remove one of the order details. Then, write a SELECT statement to verify that the order detail has been deleted.
   ```SQL
   DELETE FROM `OrderDetails` WHERE `OrderID` = 1 AND `ISBN` = '9780321765723';
   
   SELECT * FROM `OrderDetails` WHERE `OrderID` = 1;
   
   ```
   - Books by Author: Write a query that joins Authors, BookAuthors, and Books to display a list of books and their authors.
   ```SQL
   SELECT `a`.`Name` AS `AuthorName`, `b`.`Title` AS `BookTitle`
   FROM `Authors` `a`
   JOIN `BookAuthors` `ba` ON `a`.`AuthorID` = `ba`.`AuthorID`
   JOIN `Books` `b` ON `ba`.`ISBN` = `b`.`ISBN`;
   
   ```
   - Complex Query: Write a more complex query that retrieves information based on multiple criteria. For example, find customers who have ordered books by a specific author.
   ```SQL
   SELECT `c`.`Name` AS `CustomerName`
   FROM `Customers` `c`
   JOIN `Orders` `o` ON `c`.`CustomerID` = `o`.`CustomerID`
   JOIN `OrderDetails` `od` ON `o`.`OrderID` = `od`.`OrderID`
   JOIN `Books` `b` ON `od`.`ISBN` = `b`.`ISBN`
   JOIN `BookAuthors` `ba` ON `b`.`ISBN` = `ba`.`ISBN`
   JOIN `Authors` `a` ON `ba`.`AuthorID` = `a`.`AuthorID`
   WHERE `a`.`Name` = 'Douglas Adams'; -- Change author name as needed
   
   ```
   - Save the `query_bookstore_data.sql` file.

   4. Execute the SQL Scripts
   - Open your SQL client (e.g., MySQL Workbench, pgAdmin, SQL Server Management Studio). Connect to your database server.
   - Execute the `create_bookstore_schema.sql` script. This will create the database and tables.
   - Execute the `insert_bookstore_data.sql` script. This will populate the tables with your sample data.
   - Execute the `query_bookstore_data.sql` script. Examine the results of your queries.
   
### **Step 4: Push Changes to GitHub**
Once you've completed your changes, follow these steps to upload your work to your GitHub repository.

1. Check the status of your changes:
   Open the terminal and run:
   
   ```bash
   git status
   ```
   This command shows any modified or new files.
   
2. Stage the changes:
   Add all modified files to staging:
   
   ```bash
   git add .
   ```
   
3. Commit your changes:
   Write a meaningful commit message:
   
   ```bash
   git commit -m "Submitting ADVDBMS Week 02 - Session 01 - Exercise 05"
   ```
   
4. Push your changes to GitHub:
   Upload your changes to your remote repository:
   
   ```bash
   git push origin main
   ```
