package api

import (
	"go-app/internal/db"
	"net/http"
	"strconv"

	"github.com/gin-gonic/gin"
)

// SetupAPI returns a gin engine with all necessary routes
func SetupAPI() *gin.Engine {
	router := gin.Default()

	router.GET("/", getTodos)
	router.GET("/todo/:id", getTodo)
	router.POST("/create", createTodo)
	router.POST("/update", updateTodo)
	router.GET("/delete/:id", deleteTodo)

	return router
}

func getTodos(c *gin.Context) {
	c.JSON(http.StatusOK, db.GetTodos())
}

func getTodo(c *gin.Context) {
	id, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusOK, gin.H{"error": "Invalid id param", "error-message": err.Error()})
	} else {
		todo, err := db.GetTodo(id)
		if err != nil {
			c.JSON(http.StatusOK, gin.H{"error": "Not found", "error-message": err.Error()})
		} else {
			c.JSON(http.StatusOK, todo)
		}
	}
}

func createTodo(c *gin.Context) {
	var newTodo db.Todo
	c.BindJSON(&newTodo)
	err := db.AddTodo(newTodo)
	if err != nil {
		c.JSON(http.StatusOK, gin.H{"error": "Couldn't add new todo", "error-message": err.Error()})
	} else {
		c.JSON(http.StatusOK, gin.H{"Success": "Added new todo"})
	}
}

func updateTodo(c *gin.Context) {
	var updatedTodo db.Todo
	c.BindJSON(&updatedTodo)
	err := db.UpdateTodo(updatedTodo)
	if err != nil {
		c.JSON(http.StatusOK, gin.H{"error": "Couldn't update todo", "error-message": err.Error()})
	} else {
		c.JSON(http.StatusOK, gin.H{"Success": "Updated todo"})
	}
}

func deleteTodo(c *gin.Context) {
	id, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusOK, gin.H{"error": "Invalid id param", "error-message": err.Error()})
	} else {
		err := db.DeleteTodo(id)
		if err != nil {
			c.JSON(http.StatusOK, gin.H{"error": "Not found", "error-message": err.Error()})
		} else {
			c.JSON(http.StatusOK, gin.H{"Success": "Deleted todo"})
		}
	}
}
