# libeufin-docker

````shell
docker compose up -d
````

Create nexus superuser `admin`

````shell
docker compose run nexus superuser admin
````

Enable sandbox signup bonus

````shell
docker compose run sandbox config --with-signup-bonus default
````

You can then access the demo bank at http://localhost:5002/demobanks/default
