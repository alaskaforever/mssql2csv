package main

import (
	"database/sql"
	"encoding/csv"
	"fmt"
	"log"
	"os"
	"path/filepath"
	"strings"

	"github.com/joho/godotenv"
	_ "github.com/denisenkom/go-mssqldb"
)

func main() {
	// Load .env file
	err := godotenv.Load()
	if err != nil {
		log.Fatalf("❌ Failed to load .env file: %v", err)
	}

	// Read DB config from environment
	server := os.Getenv("DB_SERVER")
	port := os.Getenv("DB_PORT")
	user := os.Getenv("DB_USER")
	password := os.Getenv("DB_PASSWORD")
	database := os.Getenv("DB_NAME")

	if server == "" || port == "" || user == "" || password == "" || database == "" {
		log.Fatal("❌ Incomplete DB configuration in .env")
	}

	connString := fmt.Sprintf("server=%s;user id=%s;password=%s;port=%s;database=%s",
		server, user, password, port, database)

	// Make sure at least one SQL file is provided
	if len(os.Args) < 2 {
		fmt.Println("Usage: mssql2csv <file1.sql> [file2.sql] ...")
		os.Exit(1)
	}

	// Open DB connection once
	db, err := sql.Open("sqlserver", connString)
	if err != nil {
		log.Fatalf("❌ Connection error: %v", err)
	}
	defer db.Close()

	// Process each .sql file
	for _, queryFile := range os.Args[1:] {
		processQueryFile(db, queryFile)
	}
}

func processQueryFile(db *sql.DB, queryFile string) {
	content, err := os.ReadFile(queryFile)
	if err != nil {
		log.Printf("❌ Skipping %s: can't read file (%v)\n", queryFile, err)
		return
	}
	query := string(content)

	// Derive CSV file name
	baseName := strings.TrimSuffix(queryFile, filepath.Ext(queryFile))
	outputFile := baseName + ".csv"

	rows, err := db.Query(query)
	if err != nil {
		log.Printf("❌ Skipping %s: query failed (%v)\n", queryFile, err)
		return
	}
	defer rows.Close()

	columns, err := rows.Columns()
	if err != nil {
		log.Printf("❌ Failed to get columns from %s: %v\n", queryFile, err)
		return
	}

	file, err := os.Create(outputFile)
	if err != nil {
		log.Printf("❌ Failed to create %s: %v\n", outputFile, err)
		return
	}
	defer file.Close()
	writer := csv.NewWriter(file)
	defer writer.Flush()

	writer.Write(columns)

	values := make([]interface{}, len(columns))
	valuePtrs := make([]interface{}, len(columns))

	for rows.Next() {
		for i := range values {
			valuePtrs[i] = &values[i]
		}
		if err := rows.Scan(valuePtrs...); err != nil {
			log.Printf("❌ Row scan error in %s: %v\n", queryFile, err)
			return
		}

		record := make([]string, len(values))
		for i, val := range values {
			if val != nil {
				record[i] = fmt.Sprintf("%v", val)
			} else {
				record[i] = ""
			}
		}
		writer.Write(record)
	}

	fmt.Printf("✅ %s -> %s\n", queryFile, outputFile)
}

