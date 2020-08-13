package db

import (
	"database/sql"
	"fmt"
	"os"
	"time"

	_ "github.com/lib/pq"
)

var psqlInfo string

func init() {
	host := os.Getenv("POSTGRES_HOST")
	port := os.Getenv("POSTGRES_PORT")
	user := os.Getenv("POSTGRES_USER")
	password := os.Getenv("POSTGRES_PASSWORD")
	dbname := os.Getenv("POSTGRES_DB")

	fmt.Println("----------\n| Config |\n----------")
	fmt.Println("URL:", host)
	fmt.Println("PORT:", port)
	fmt.Println("DB:", dbname)
	fmt.Println("USER:", user)
	fmt.Println("PASWORD:", password)
	fmt.Println("----------")

	psqlInfo = fmt.Sprintf("host=%s port=%s user=%s password=%s dbname=%s sslmode=disable", host, port, user, password, dbname)

	initTodoTable()
}

func initTodoTable() {
	dbConnection := connect()
	defer dbConnection.Close()

	retries := 0
	for {
		err := dbConnection.Ping()
		if err != nil {
			retries++
			time.Sleep(time.Second)
		} else {
			break
		}
		maxRetries := 5
		if retries == maxRetries {
			panic("Not able to connect to database")
		}
	}

	createTableStatement := `
	CREATE TABLE IF NOT EXISTS TODOS (
	ID          SERIAL PRIMARY KEY,
	TITLE       TEXT NOT NULL,
	DESCRIPTION TEXT);`
	_, err := dbConnection.Exec(createTableStatement)
	if err != nil {
		panic(err)
	}
}

func connect() *sql.DB {
	dbConnection, err := sql.Open("postgres", psqlInfo)
	if err != nil {
		panic(err)
	}

	return dbConnection
}

// GetTodos returns all todos
func GetTodos() []Todo {
	var todos = []Todo{}

	dbConnection := connect()
	defer dbConnection.Close()

	getAllTodosSQLStatement := "SELECT id, title, description FROM todos;"

	rows, err := dbConnection.Query(getAllTodosSQLStatement)
	if err != nil {
		panic(err)
	}
	defer rows.Close()

	for rows.Next() {
		var id int
		var title string
		var description string
		err = rows.Scan(&id, &title, &description)
		if err != nil {
			panic(err)
		}
		todos = append(todos, Todo{ID: id, Title: title, Description: description})
	}

	err = rows.Err()
	if err != nil {
		panic(err)
	}

	return todos
}

// GetTodo returns a specific todo
func GetTodo(todoID int) (Todo, error) {
	dbConnection := connect()
	defer dbConnection.Close()

	getTodoSQLStatement := "SELECT id, title, description FROM todos WHERE id=$1;"

	row := dbConnection.QueryRow(getTodoSQLStatement, todoID)

	var id int
	var title string
	var description string
	switch err := row.Scan(&id, &title, &description); err {
	case nil:
		return Todo{ID: id, Title: title, Description: description}, nil
	case sql.ErrNoRows:
		return Todo{}, fmt.Errorf("Couldn't find todo")
	default:
		panic(err)
	}
}

// AddTodo adds a new todo
func AddTodo(newTodo Todo) error {
	dbConnection := connect()
	defer dbConnection.Close()

	addTodoStatement := "INSERT INTO todos (title, description) VALUES ($1, $2);"

	_, err := dbConnection.Exec(addTodoStatement, newTodo.Title, newTodo.Description)
	if err != nil {
		panic(err)
	}

	return nil
}

// UpdateTodo updates a specific todo identitfied by the id
func UpdateTodo(updatedTodo Todo) error {
	dbConnection := connect()
	defer dbConnection.Close()

	updateSQLStatement := "UPDATE todos SET title = $2, description = $3 WHERE id = $1;"

	_, err := dbConnection.Exec(updateSQLStatement, updatedTodo.ID, updatedTodo.Title, updatedTodo.Description)
	if err != nil {
		return fmt.Errorf("Couldn't find todo")
	}

	return nil
}

// DeleteTodo deletes a specific todo identitfied by the id
func DeleteTodo(todoID int) error {
	dbConnection := connect()
	defer dbConnection.Close()

	deleteSQLStatement := "DELETE FROM todos WHERE id = $1;"

	_, err := dbConnection.Exec(deleteSQLStatement, todoID)
	if err != nil {
		return fmt.Errorf("Couldn't find todo")
	}

	return nil
}
