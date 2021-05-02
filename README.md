# Symfony docker template with vitejs
## Setup process

- Verify settings in composer.json like the project name and description
- Move .env.example or .env.prod.example to .env and edit parameters to match your project
- Make sure permission are well-defined for 1000:1000 (`sudo chown 1000:1000 /path/ -R`)
- Execute `make build` to run installation
- Generate application secret key in .env at field `APP_SECRET`
- Enjoy :)

## Use vitejs

- Start container with `docker-compose up -d`
- Create a symbolic link in the public folder `ln -s ../assets/ assets`
