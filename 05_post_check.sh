#!/bin/bash

# Database credentials (environment variables are recommended)
DB_HOST="${DB_HOST:-127.0.0.1}"
DB_PORT="${DB_PORT:-4000}"
DB_USER="${DB_USER:-root}"
DB_NAME="${DB_NAME:-BookstoreDB}"

execute_sql() {
  mysql -h "$DB_HOST" -P "$DB_PORT" -u "$DB_USER" -D "$DB_NAME" -e "$1"
  if [[ $? -ne 0 ]]; then
    echo "Error executing SQL: $1"
    return 1
  fi
  return 0
}

# --- Validation ---

# 1. Check book counts
echo "Checking book counts..."
book_count=$(execute_sql "SELECT COUNT(*) FROM Books;" | tail -n 1)
if [[ "$book_count" -eq 3 ]]; then
  echo "Book count check: PASSED"
else
  echo "Book count check: FAILED. Expected 3, found $book_count"
  exit 1
fi

# 2. Check author counts
echo "Checking author counts..."
author_count=$(execute_sql "SELECT COUNT(*) FROM Authors;" | tail -n 1)
if [[ "$author_count" -eq 3 ]]; then
  echo "Author count check: PASSED"
else
  echo "Author count check: FAILED. Expected 3, found $author_count"
  exit 1
fi

# 3. Check customer counts
echo "Checking customer counts..."
customer_count=$(execute_sql "SELECT COUNT(*) FROM Customers;" | tail -n 1)
if [[ "$customer_count" -eq 3 ]]; then
  echo "Customer count check: PASSED"
else
  echo "Customer count check: FAILED. Expected 3, found $customer_count"
  exit 1
fi

# 4. Check order counts
echo "Checking order counts..."
order_count=$(execute_sql "SELECT COUNT(*) FROM Orders;" | tail -n 1)
if [[ "$order_count" -eq 3 ]]; then
  echo "Order count check: PASSED"
else
  echo "Order count check: FAILED. Expected 3, found $order_count"
  exit 1
fi

# 5. Check order detail counts
echo "Checking order detail counts..."
order_detail_count=$(execute_sql "SELECT COUNT(*) FROM OrderDetails;" | tail -n 1)
if [[ "$order_detail_count" -eq 2 ]]; then
  echo "Order detail count check: PASSED"
else
  echo "Order detail count check: FAILED. Expected 2, found $order_detail_count"
  exit 1
fi

# 6. Check updated book price
echo "Checking updated book price..."
book_price=$(execute_sql "SELECT Price FROM Books WHERE ISBN = '9781234567890';" | tail -n 1)
if [[ "$book_price" == "8.99" ]]; then
  echo "Book price check: PASSED"
else
  echo "Book price check: FAILED. Expected 8.99, found $book_price"
  exit 1
fi

# 7. Check deleted order detail (count)
echo "Checking deleted order detail..."
order_detail_count=$(execute_sql "SELECT COUNT(*) FROM OrderDetails WHERE OrderID = 1 AND ISBN = '9780321765723';" | tail -n 1)
if [[ "$order_detail_count" -eq 0 ]]; then
  echo "Order detail deletion check: PASSED"
else
  echo "Order detail deletion check: FAILED. Record still exists."
  exit 1
fi

# 8. Check query 1 output (partial content check)
echo "Checking query 1 output (partial content)..."
query1_count=$(execute_sql "SELECT COUNT(*) FROM Customers c JOIN Orders o ON c.CustomerID = o.CustomerID JOIN OrderDetails od ON o.OrderID = od.OrderID JOIN Books b ON od.ISBN = b.ISBN;" | tail -n 1)
if [[ "$query1_count" -eq 2 ]]; then
    echo "Query 1 count check: PASSED"
    #Checking presence of one specific record
    record_exists=$(execute_sql "SELECT 1 FROM Customers c JOIN Orders o ON c.CustomerID = o.CustomerID JOIN OrderDetails od ON o.OrderID = od.OrderID JOIN Books b ON od.ISBN = b.ISBN WHERE c.Name = 'John Doe' AND b.Title = 'The Hitchhiker''s Guide to the Galaxy';" | tail -n 1)
    if [[ "$record_exists" == 1 ]]; then
        echo "Query 1 content check: PASSED"
    else
        echo "Query 1 content check: FAILED"
        exit 1
    fi
else
    echo "Query 1 count check: FAILED. Expected 2, found $query1_count"
    exit 1
fi


# 9. Check query 4 output (partial content check)
echo "Checking query 4 output (partial content)..."
query4_count=$(execute_sql "SELECT COUNT(*) FROM Authors a JOIN BookAuthors ba ON a.AuthorID = ba.AuthorID JOIN Books b ON ba.ISBN = b.ISBN;" | tail -n 1)
if [[ "$query4_count" -eq 3 ]]; then
    echo "Query 4 count check: PASSED"
    #Checking presence of one specific record
    record_exists=$(execute_sql "SELECT 1 FROM Authors a JOIN BookAuthors ba ON a.AuthorID = ba.AuthorID JOIN Books b ON ba.ISBN = b.ISBN WHERE a.Name = 'Douglas Adams' AND b.Title = 'The Hitchhiker''s Guide to the Galaxy';" | tail -n 1)
    if [[ "$record_exists" == 1 ]]; then
        echo "Query 4 content check: PASSED"
    else
        echo "Query 4 content check: FAILED"
        exit 1
    fi
else
    echo "Query 4 count check: FAILED. Expected 3, found $query4_count"
    exit 1
fi


# 10. Check query 5 output (partial content check)
echo "Checking query 5 output (partial content)..."
query5_count=$(execute_sql "SELECT COUNT(*) FROM Customers c JOIN Orders o ON c.CustomerID = o.CustomerID JOIN OrderDetails od ON o.OrderID = od.OrderID JOIN Books b ON od.ISBN = b.ISBN JOIN BookAuthors ba ON b.ISBN = ba.ISBN JOIN Authors a ON ba.AuthorID = a.AuthorID WHERE a.Name = 'Douglas Adams';" | tail -n 1)

if [[ "$query5_count" -eq 1 ]]; then
  echo "Query 5 count check: PASSED"
  record_exists=$(execute_sql "SELECT 1 FROM Customers c JOIN Orders o ON c.CustomerID = o.CustomerID JOIN OrderDetails od ON o.OrderID = od.OrderID JOIN Books b ON od.ISBN = b.ISBN JOIN BookAuthors ba ON b.ISBN = ba.ISBN JOIN Authors a ON ba.AuthorID = a.AuthorID WHERE a.Name = 'Douglas Adams' AND c.Name = 'John Doe';" | tail -n 1)
  if [[ "$record_exists" == 1 ]]; then
        echo "Query 5 content check: PASSED"
    else
        echo "Query 5 content check: FAILED"
        exit 1
    fi

else
  echo "Query 5 count check: FAILED. Expected 1, found $query5_count"
  exit 1
fi

# 11. Check Primary Keys
echo "Checking Primary Keys..."

check_primary_key() {
  table="$1"
  expected_key="$2" # Can be a single column or comma-separated for composite keys
  actual_key=$(execute_sql "SHOW KEYS FROM $table WHERE Key_name = 'PRIMARY';" | awk '{print $5}' | tr -d '\n')
  if [[ "$actual_key" == "$expected_key" ]]; then
    echo "$table Primary Key check: PASSED"
  else
    echo "$table Primary Key check: FAILED. Expected: '$expected_key', Found: '$actual_key'"
    exit 1
  fi
}

check_primary_key "Books" "Column_nameISBN"
check_primary_key "Authors" "Column_nameAuthorID"
check_primary_key "BookAuthors" "Column_nameISBNAuthorID" # Composite key
check_primary_key "Customers" "Column_nameCustomerID"
check_primary_key "Orders" "Column_nameOrderID"
check_primary_key "OrderDetails" "Column_nameOrderIDISBN" # Composite key

# 12. Check Foreign Keys
echo "Checking Foreign Keys..."

check_foreign_key() {
  table="$1"
  referenced_table="$2"
  fk_exists=$(execute_sql "SELECT COUNT(*) FROM information_schema.REFERENTIAL_CONSTRAINTS WHERE TABLE_NAME = '$table' AND REFERENCED_TABLE_NAME = '$referenced_table';" | tail -n 1)
  if [[ "$fk_exists" -eq 1 ]]; then
    echo "Foreign Key in '$table' referencing '$referenced_table': PASSED"
  else
    echo "Foreign Key in '$table' referencing '$referenced_table': FAILED"
    exit 1
  fi
}


check_foreign_key "BookAuthors" "Books" # You'll need to name your FKs correctly
check_foreign_key "BookAuthors" "Authors"
check_foreign_key "Orders" "Customers"
check_foreign_key "OrderDetails" "Orders"
check_foreign_key "OrderDetails" "Books"



echo "All script validations passed!"

exit 0