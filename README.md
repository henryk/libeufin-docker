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
      LIBEUFIN_SANDBOX_PASSWORD: b4tterpassw0rd
````

To run `libeufin-cli` commands in the sandbox

````shell
docker compose run --rm sandbox libeufin-cli ...
````

To run a shell in the sandbox or nexus

````shell
docker compose run --rm sandbox sh
````

(`nexus` instead of `sandbox` works too, as does `bash` instead of `sh`)

