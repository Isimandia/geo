# Joffer

The application allows you to generate aggregative data based on input files with the following formats:
Job offers:
name - technical-test-jobs.csv
header - profession_id,contract_type,name,office_latitude,office_longitude
line (example)- 2,FULL_TIME,Dev Full Stack,48.8768868,2.3091203

Professions_id is an external key which is taken from the second file:
Professions:
name - technical-test-professions.csv
header - id,name,category_name
line (example) - 16,Développement Fullstack,Tech

The files should be stored in a directory that path is defined in config.exs (dev.exs)
The directory should be available for edit.

## Installation 

For the correct work of the application PostgreSQL is required, additionally the extension PostGIS should be installed on your machine as well.
The actual build might be found here https://postgis.net/install/.

In the config folder of the project dev configuration (dev.exs) must be added. 
The template of the file is the following:
```elixir
use Mix.Config
# Configure your database
config :joffer, Joffer.Repo,
  username: "test",
  password: "test",
  database: "test_db",
  hostname: "localhost",
  show_sensitive_data_on_connection_error: true,
  pool_size: 10,
  types: Joffer.PostgresTypes

config :joffer, :file_dir, "files"
```

After successful installation of the database and extension, the initial migration and module installation should be initiated with the command:
  
  mix setup

## 01 / 03 . Exercise: Continents grouping

In order to get the output file with the required format, the following command should be executed:

  mix run_script

The new file "aggregates.csv" will be created in the same folder where input files are stored.


## 02 / 03 . Question: Scaling ?
```
Now, let’s imagine we have 100 000 000 job offers in our database, and 1000 new job offers per second (yeah, it’s a lot coming in!). What do you implement if we want the same output than in the previous exercise in real-time?
```
In this case application supports chunking mechanism during the initial upload of the files.
However in order to reduce latency and get rid of validation checks a new table with raw string data shall be created.
All other manipulations with the data such as validations/type transformations or region determination shall be processed with separate background jobs executing in a separate GenServer. 
Considering that region determination is time consuming and a potential bottleneck it executes in own PIDs as well, the mechanism should be adapted for the chunking as well, each tact should process like 1000-10000 items at max otherwise it may lead to memory issues and potential process dumps.
Data aggregation for the report should be scheduled and executed periodically.

## 03 / 03 . Exercise: API implementation

The internal API is developed and might be executed in IEX console:

  iex -S mix

If the input parameters are:
  latitude (eg: 48.8659387)
  longitude (eg: 2.34532)
  radius (eg: 10 (km))

Then the following command should be executed:
```elixir
Joffer.Api.get_destinations(48.8659387, 2.34532, 10)
```



