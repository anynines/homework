package internal

import "go-app/internal/api"

func Run() {
	router := api.SetupAPI()
	router.Run(":8080")
}
