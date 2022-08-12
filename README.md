# libeufin-docker

Not official. See https://git.taler.net/libeufin.git/

````shell
docker compose up -d
````

Create nexus superuser `admin`

````shell
docker compose run --rm nexus superuser admin
````

Enable sandbox signup bonus

````shell
docker compose run --rm sandbox config --with-signup-bonus default
````

You can then access the demo bank at http://localhost:5002/demobanks/default

To change the sandbox admin password, create a file `compose.override.yaml` with the following contents

````yaml
services:
  sandbox:
    environment:
      LIBEUFIN_SANDBOX_ADMIN_PASSWORD: b4tterpassw0rd
````
