# Symfony docker template with vitejs
## Setup process

- Verify settings in composer.json like the project name and description
- Move .env.example or .env.prod.example to .env and edit parameters to match your project
- Make sure permission are well-defined for 1000:1000 (`sudo chown 1000:1000 /path/ -R`)
- make the order `make build` to create the docker service and the dev server
- Generate application secret key in .env at field `APP_SECRET`
- Enjoy :)

## Utilisation vitejs in symfony

- Start container dev `docker-compose up`
- check the variable `VITE_DEV` to 1 for the dev in .env
- For images creates a symbolic link in the public folder `ln -s ../assets/ assets`
- Dependency install `vitejs`, `react vanilla` and `sass`
- Enjoy :)
